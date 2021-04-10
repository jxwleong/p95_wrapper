import os
import sys

ROOT_DIR = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, ROOT_DIR)

from pyLib import psutil

print(psutil.cpu_count(logical = True))
print(psutil.cpu_count(logical = False))