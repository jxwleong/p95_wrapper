import argparse
import os
import subprocess
import sys
import time

from ctypes import *

def remove_if_exists(filename):
    if os.path.exists(filename):
        os.remove(filename)


ROOT_DIR = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, ROOT_DIR)

from pyLib import pyperclip
from pyLib.win32 import win32gui
from pyLib import pyautogui
from pyLib import pygetwindow as gw

from win32gui import FindWindow, GetWindowRect


P95_EXE_PATH = os.path.join(ROOT_DIR, "p95v303b6.win32", "prime95.exe")
P95_RESULTS_TXT = os.path.join(ROOT_DIR, "p95v303b6.win32", "results.txt")
P95_TIMEOUT = 60

remove_if_exists(P95_RESULTS_TXT)


parser = argparse.ArgumentParser()
parser.add_argument('-t', '--time', type=int)


args = parser.parse_args()
if args.time is not None:
      P95_TIMEOUT = args.time

kill_p95 = subprocess.Popen("taskkill /IM \"prime95.exe\" /F")
print(kill_p95)
time.sleep(1)
p95_process = subprocess.Popen([P95_EXE_PATH, '-t'])
time.sleep(1)

edit_x = 60
edit_y = 40

copy_x = 60
copy_y = 65

window_x = 30
window_y = 280


# FindWindow takes the Window Class name (can be None if unknown), and the window's display text. 
window_handle = FindWindow(None, "Prime95")
window_rect   = GetWindowRect(window_handle)
print(window_handle)
print(window_rect)
x, y, _, _ = window_rect

time.sleep(P95_TIMEOUT)
pyperclip.copy("")
ok = windll.user32.BlockInput(True) #enable block
time.sleep(1)
win32gui.SetForegroundWindow(window_handle)
time.sleep(2)
pyautogui.click(x=x+window_x, y=y+window_y)
time.sleep(1)
pyautogui.click(x=x+edit_x, y=y+edit_y)
pyautogui.click(x=x+copy_x, y=y+copy_y)
ok = windll.user32.BlockInput(False) #disable block 

subprocess.Popen(f"taskkill /PID {p95_process.pid}")

time.sleep(1)
p95_log_str = pyperclip.paste()
with open(os.path.join(os.getcwd(), "prime95.log"), "w") as p95_log:
  p95_log_str = p95_log_str.replace("\n", "")
  p95_log.write(p95_log_str)


print(ok)