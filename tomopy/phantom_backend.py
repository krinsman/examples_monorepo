import sys
import os
import argparse
import traceback
import tomopy
import dxchange
import tornado
import matplotlib
import timemory
import timemory.options as options
import signal
import numpy as np
import time as t
import pylab
from tomopy.misc.benchmark import *

def get_basepath(output_dir, algorithm, phantom):
    basepath = os.path.join(os.getcwd(), output_dir, phantom, algorithm)
    if not os.path.exists(basepath):
        os.makedirs(basepath)
    return basepath
    
@timemory.util.auto_timer()
def generate(phantom, size, partial, subset, no_center, angles):
    """Return the simulated data for the given phantom."""
    with timemory.util.auto_timer("[tomopy.misc.phantom.{}]".format(phantom)):
        obj = getattr(tomopy.misc.phantom, phantom)(size=size)
        obj = tomopy.misc.morph.pad(obj, axis=1, mode='constant')
        obj = tomopy.misc.morph.pad(obj, axis=2, mode='constant')

        if partial:
            data_size = obj.shape[0]
            subset = list(subset)
            subset.sort()
            nbeg, nend = subset[0], subset[1]
            if nbeg == nend:
                nend += 1
            if not no_center:
                ndiv = (nend - nbeg) // 2
                offset = data_size // 2
                nbeg = (offset - ndiv)
                nend = (offset + ndiv)
            print("[partial]> slices = {} ({}, {}) of {}".format(
                nend - nbeg, nbeg, nend, data_size))
            obj = obj[nbeg:nend,:,:]

    with timemory.util.auto_timer("[tomopy.angles]"):
        ang = tomopy.angles(angles)

    with timemory.util.auto_timer("[tomopy.project]"):
        prj = tomopy.project(obj, ang)

    print("[dims]> projection = {}, angles = {}, object = {}".format(
        prj.shape, ang.shape, obj.shape))
    return [prj, ang, obj]

@timemory.util.auto_timer()
def run(phantom, algorithm, output_dir, size, partial,
        subset, no_center, angles, ncores, num_iter,
        format, scale, ncol, get_recon=False):
    """Run reconstruction benchmarks for phantoms.

    Parameters
    ----------
    phantom : string
        The name of the phantom to use.
    algorithm : string
        The name of the algorithm to test.

    Returns
    -------
    Either rec or imgs
    rec : np.ndarray
        The reconstructed image.
    imgs : list
        A list of the original, reconstructed, and difference image
    """
    global image_quality

    imgs = []
    bname = get_basepath(output_dir=output_dir, algorithm=algorithm, phantom=phantom)
    pname = os.path.join(bname, "proj_{}_".format(algorithm))
    oname = os.path.join(bname, "orig_{}_".format(algorithm))
    fname = os.path.join(bname, "stack_{}_".format(algorithm))
    dname = os.path.join(bname, "diff_{}_".format(algorithm))

    prj, ang, obj = generate(phantom=phantom, size=size, partial=partial,
                             subset=subset, no_center=no_center, angles=angles)
    proj = np.zeros(shape=[prj.shape[1], prj.shape[0], prj.shape[2]], dtype=np.float)
    for i in range(0, prj.shape[1]):
        proj[i,:,:] = prj[:,i,:]

    # always add algorithm
    _kwargs = {"algorithm": algorithm}

    # assign number of cores
    _kwargs["ncore"] = ncores

    # don't assign "num_iter" if gridrec or fbp
    if algorithm not in ["fbp", "gridrec"]:
        _kwargs["num_iter"] = num_iter

    # use the accelerated version
    if algorithm in ["mlem", "sirt"]:
        _kwargs["accelerated"] = True

    print("kwargs: {}".format(_kwargs))
    with timemory.util.auto_timer("[tomopy.recon(algorithm='{}')]".format(
                                  algorithm)):
        rec = tomopy.recon(prj, ang, **_kwargs)
    print("completed reconstruction...")

    obj_min = np.amin(obj)
    rec_min = np.amin(rec)
    obj_max = np.amax(obj)
    rec_max = np.amax(rec)
    print("obj bounds = [{:8.3f}, {:8.3f}], rec bounds = [{:8.3f}, {:8.3f}]".format(obj_min, obj_max,
                                                              rec_min, rec_max))

    obj = normalize(obj)
    rec = normalize(rec)
    obj_max = np.amax(obj)
    rec_max = np.amax(rec)
    print("Max obj = {}, rec = {}".format(obj_max, rec_max))

    rec = trim_border(rec, rec.shape[0],
                      rec[0].shape[0] - obj[0].shape[0],
                      rec[0].shape[1] - obj[0].shape[1])

    label = "{} @ {}".format(algorithm.upper(), phantom.upper())

    quantify_difference(label + " (self)", rec, np.zeros(rec.shape, dtype=rec.dtype))
    quantify_difference(label, obj, rec)

    if "orig" not in image_quality:
        image_quality["orig"] = obj

    dif = obj - rec
    image_quality[algorithm] = dif

    if get_recon is True:
        return rec


    print("pname = {}, oname = {}, fname = {}, dname = {}".format(pname, oname, fname, dname))
    imgs.extend(output_images(proj, pname, format, scale, ncol))
    imgs.extend(output_images(obj, oname, format, scale, ncol))
    imgs.extend(output_images(rec, fname, format, scale, ncol))
    imgs.extend(output_images(dif, dname, format, scale, ncol))

    return imgs

def main(phantom, algorithm, output_dir, angles, size, ncores, format,
        scale, ncol, compare, num_iter, subset, preserve_output_dir,
        partial, no_center):
    """
    Parameters
    ----------
    phantom : string
        The name of the phantom to use.
        default = "shepp2d"
        choices = ["baboon", "cameraman", "barbara", "checkerboard",
                    "lena", "peppers", "shepp2d", "shepp3d"]
    algorithm : string
        The name of the algorithm to test. Select the algorithm.
        default="sirt"
        choices = ['gridrec', 'art', 'fbp', 'bart', 'mlem', 'osem',
                    'sirt', 'ospml_hybrid', 'ospml_quad', 'pml_hybrid',
                    'pml_quad', 'tv', 'grad']
    output_dir : string
        The location of the output directory.
        default = "."
    angles : integer
        number of angles
        default = 1501
    size : integer
        size of image
        default = 512
    ncores : integer
        number of cores
    format : string
        output image format
        default = "png"
    scale : integer
        scale image by a positive factor
        default = 1
    ncol : integer
        Number of images per row
        default = 1
    compare: list of strings (arbitrary length)
        Generate comparison
        default = ["none"]
    num_iter : integer
        Number of iterations
        default = 50
    subset : tuple of integers of length 2
        Select subset (range) of slices (center enabled by default)
        default = (0, 48)
    preserve_output_dir : Boolean
        Do not clean up output directory
        default = False
    partial : Boolean
        Enable partial reconstruction of 3D data
        default = False
    no_center : Boolean
        When used with 'subset', do no center subset
        default = False
    Returns
    -------
    Either rec or imgs
    rec : np.ndarray
        The reconstructed image.
    imgs : list
        A list of the original, reconstructed, and difference image
    """

    print("using tomopy: {}".format(tomopy.__file__))

    global image_quality

    manager = timemory.manager()

    algorithms = ['gridrec', 'art', 'fbp', 'bart', 'mlem', 'osem',
                    'sirt', 'ospml_hybrid', 'ospml_quad', 'pml_hybrid',
                    'pml_quad', 'tv', 'grad']
    
    if len(compare) == 1 and compare[0].lower() == "all":
        compare = list(algorithms)
    elif len(compare) == 1:
        compare = []
    
    if len(compare) > 0:
        algorithm = "comparison"

    if output_dir is None:
        output_dir = "."

    # unique output directory w.r.t. phantom
    adir = os.path.join(os.getcwd(), output_dir, phantom)
    # unique output directory w.r.t. phantom and extension
    if len(compare) > 0:
        adir = os.path.join(adir, "comparison")
    else:
        adir = os.path.join(adir, algorithm)
    
    if not preserve_output_dir:
        try:
            print("removing output from '{}' (if not '{}')...".format(adir, os.getcwd()))
            import shutil
            if os.path.exists(adir) and adir != os.getcwd():
                shutil.rmtree(adir)
                os.makedirs(adir)
        except:
            pass
    else:
        os.makedirs(adir)
    
    output_dir = os.path.abspath(output_dir)
        
    print(("\nArguments:\n{} = {}\n{} = {}\n{} = {}\n{} = {}\n{} = {}\n"
          "{} = {}\n{} = {}\n{} = {}\n{} = {}\n{} = {}\n").format(
          "\tPhantom", phantom,
          "\tAlgorithm", algorithm,
          "\tSize", size,
          "\tAngles", angles,
          "\tFormat", format,
          "\tScale", scale,
          "\tcomparison", compare,
          "\tnumber of cores", ncores,
          "\tnumber of columns", ncol,
          "\tnumber iterations", num_iter))

    if len(compare) > 0:
        ncol = 1
        scale = 1
        nitr = 1
        comparison = None
        for alg in compare:
            print("Reconstructing {} with {}...".format(phantom, alg))
            tmp = run(phantom=phantom, algorithm=alg,
                      output_dir=output_dir,
                      size=size, partial=partial,
                      subset=subset, no_center=no_center,
                      angles=angles, ncores=ncores,
                      num_iter=num_iter, format=format, 
                      scale=scale, ncol=ncol, get_recon=True)
            tmp = rescale_image(tmp, size, scale, transform=False)
            if comparison is None:
                comparison = image_comparison(
                    len(compare), tmp.shape[0], tmp[0].shape[0],
                    tmp[0].shape[1], image_quality["orig"]
                    )
            comparison.assign(alg, nitr, tmp)
            nitr += 1
        bname = get_basepath(output_dir=output_dir, algorithm=algorithm, phantom=phantom)
        fname = os.path.join(bname, "stack_{}_".format(comparison.tagname()))
        dname = os.path.join(bname, "diff_{}_".format(comparison.tagname()))
        imgs = []
        imgs.extend(
            output_images(comparison.array, fname,
                          format, scale, ncol))
        imgs.extend(
            output_images(comparison.delta, dname,
                          format, scale, ncol))
    else:
        print("Reconstructing with {}...".format(algorithm))
        imgs = run(phantom=phantom, algorithm=algorithm, 
                   output_dir=output_dir, size=size, partial=partial, 
                   subset=subset, no_center=no_center, angles=angles,
                  ncores=ncores, num_iter=num_iter, format=format,
                  scale=scale, ncol=ncol)

    # timing report to stdout
    print('{}\n'.format(manager))

    _dir = os.path.abspath(output_dir)
    timemory.options.output_dir = "{}/{}/{}".format(
        _dir, phantom, algorithm)
    timemory.options.set_report("run_tomopy.out")
    timemory.options.set_serial("run_tomopy.json")
    manager.report()

    # provide timing plots
    try:
        timemory.plotting.plot(files=[timemory.options.serial_filename],
                               echo_dart=True,
                               output_dir=timemory.options.output_dir)
    except Exception as e:
        print("Exception - {}".format(e))

    # provide results to dashboard
    try:
        for i in range(0, len(imgs)):
            img_base = "{}_{}_stack_{}".format(phantom, algorithm, i)
            img_name = os.path.basename(imgs[i]).replace(
                ".{}".format(format), "").replace(
                "stack_{}_".format(algorithm), img_base)
            img_type = format
            img_path = imgs[i]
            img_path = os.path.abspath(img_path)
            timemory.plotting.echo_dart_tag(img_name, img_path, img_type)
    except Exception as e:
        print("Exception - {}".format(e))

    # provide ASCII results
    try:
        notes = manager.write_ctest_notes(
            directory="{}/{}/{}".format(output_dir, phantom,
                                        algorithm))
        print('"{}" wrote CTest notes file : {}'.format(tomopy.__file__, notes))
    except Exception as e:
        print("Exception - {}".format(e))