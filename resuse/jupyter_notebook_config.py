def mem_limit_calculator(rss, used_mem, total_mem, num_users, cpu_percent):
    targetPctFraction = 1/num_users
    return targetPctFraction * total_mem

c.ResourceUseDisplay.mem_limit_calculator = mem_limit_calculator
