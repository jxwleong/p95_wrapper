import os
import sys
import re

ROOT_DIR = os.path.join(os.path.dirname(__file__), "..")
sys.path.insert(0, ROOT_DIR)

import config

LOCAL_TXT = config.LOCAL_TXT_TEMPLATE
LOCAL_TXT = """
OldCpuSpeed=2965
NewCpuSpeedCount=1
NewCpuSpeed=2592
RollingAverage=1000
RollingAverageIsFromV27=1
CoresPerTest=4
ComputerGUID=9c32b9c9d257e3082e344c2e7317fb1f
RollingStartTime=0

"""
# Attempt to change the worker threads

worker_threads = "".join(["WorkerThreads=", 
                        str(config.SYSTEM_CONFIG["NUMBER_OF_LOGICAL_CORE"])])
print(worker_threads)
r1 = re.findall("WorkerThreads=\\s*", LOCAL_TXT)
if len(r1) == 0:
    print("NOOOO")
    LOCAL_TXT = LOCAL_TXT + worker_threads
    print(LOCAL_TXT)
print(r1)