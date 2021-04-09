import os
import subprocess
import time


import pyperclip 
import win32con
import win32gui
import win32process
import pyautogui
import pygetwindow as gw

from win32gui import FindWindow, GetWindowRect
from ctypes import *

def remove_if_exists(filename):
    if os.path.exists(filename):
        os.remove(filename)


ROOT_DIR = os.path.dirname(os.path.realpath(__file__))
P95_EXE_PATH = os.path.join(ROOT_DIR, "p95v303b6.win32", "prime95.exe")
P95_RESULTS_TXT = os.path.join(ROOT_DIR, "p95v303b6.win32", "results.txt")

remove_if_exists(P95_RESULTS_TXT)

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

time.sleep(5)
ok = windll.user32.BlockInput(True) #enable block
win32gui.SetForegroundWindow(window_handle)
pyautogui.click(x=x+window_x, y=y+window_y)
pyautogui.click(x=x+edit_x, y=y+edit_y)
pyautogui.click(x=x+copy_x, y=y+copy_y)
ok = windll.user32.BlockInput(False) #disable block 

subprocess.Popen(f"taskkill /PID {p95_process.pid}")


p95_log_str = pyperclip.paste()
with open(os.path.join(os.getcwd(), "prime95.log"), "w") as p95_log:
  p95_log_str = p95_log_str.replace("\n", "")
  p95_log.write(p95_log_str)


print(ok)