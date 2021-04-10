import os
import sys
import platform
import json

ROOT_DIR = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, ROOT_DIR)

from pyLib import psutil
from pyLib import cpuinfo

CPU_INFO_DICT = cpuinfo.get_cpu_info()

SYSTEM_CONFIG = {
    "CPU_NAME": CPU_INFO_DICT["brand_raw"],
    "CPU_ARCH": CPU_INFO_DICT["arch"],
    "CPU_FLAGS": CPU_INFO_DICT["flags"], # In list
    "NUMBER_OF_PHYSICAL_CORE": psutil.cpu_count(logical = False),
    "NUMBER_OF_LOGICAL_CORE": psutil.cpu_count(logical = True),
    "TOTAL_RAM": psutil.virtual_memory()[0] # Index 0: total memory includes virtual memory
    }

LOCAL_TXT_TEMPLATE = """OldCpuSpeed=2965
NewCpuSpeedCount=1
NewCpuSpeed=2592
RollingAverage=1000
RollingAverageIsFromV27=1
WorkerThreads=8
CoresPerTest=4
ComputerGUID=9c32b9c9d257e3082e344c2e7317fb1f
RollingStartTime=0
"""
