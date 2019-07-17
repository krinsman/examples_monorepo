After building the image as `tomopy:notebook` (or whatever you want to call it), run

`docker run  -p 8000:8000 tomopy:notebook jupyter notebook --ip=0.0.0.0 --port=8000 --allow-root`

Copy the URL it gives you into your browser to run Jupyter notebook.

