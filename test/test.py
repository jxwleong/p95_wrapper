import os
import sys
import re

ROOT_DIR = os.path.join(os.path.dirname(__file__), "..")
sys.path.insert(0, ROOT_DIR)

import config

LOCAL_TXT = config.LOCAL_TXT_TEMPLATE
LOCAL_TXT = """
MinTortureFFT=4
MaxTortureFFT=8192
TortureMem=2000
TortureTime=6
"""
# Attempt to change the worker threads



r1 = re.findall("MaxTortureFFT=\\d*", LOCAL_TXT)
print(r1)
if len(r1) == 0:
    print("NOOOO")
    LOCAL_TXT = LOCAL_TXT + "".join(["MaxTortureFFT=4444"])
    print(LOCAL_TXT)
else:
    LOCAL_TXT = re.sub("MaxTortureFFT=\\d*", "MaxTortureFFT=123",LOCAL_TXT)
    print(LOCAL_TXT)