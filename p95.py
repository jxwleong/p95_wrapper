import argparse
import os
import subprocess
import sys
import time
import shutil

import ctypes


ROOT_DIR = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, ROOT_DIR)

PYLIB_PATH = os.path.join(ROOT_DIR, "pyLib")
sys.path.append(PYLIB_PATH)

from pyLib import pyperclip
from pyLib import win32
from pyLib.tqdm import tqdm
#import pyLib.win32.win32gui
from pyLib import pyautogui
from pyLib import pygetwindow as gw
#from win32.win32gui import FindWindow, GetWindowRect


P95_EXE_PATH = os.path.join(ROOT_DIR, "p95v303b6.win32", "prime95.exe")
P95_RESULTS_TXT_PATH = os.path.join(ROOT_DIR, "p95v303b6.win32", "results.txt")
P95_LOCAL_TXT_PATH = os.path.join(ROOT_DIR, "p95v303b6.win32", "local.txt")
P95_PRIME_TXT_PATH = os.path.join(ROOT_DIR, "p95v303b6.win32", "prime.txt")
P95_PRIME_WINDOW_NAME = "Prime95"
P95_TIMEOUT = 60

pyautogui.FAILSAFE = False

def remove_if_exists(filename):
    if os.path.exists(filename):
        os.remove(filename)

def GetWindowRectFromName(name:str)-> tuple:
    hwnd = ctypes.windll.user32.FindWindowW(0, name)
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.pointer(rect))
    # print(hwnd)
    # print(rect)
    return (rect.left, rect.top, rect.right, rect.bottom)
remove_if_exists(P95_RESULTS_TXT_PATH)

parser = argparse.ArgumentParser()
parser.add_argument('-t', '--time', type=int)


args = parser.parse_args()
if args.time is not None:
      P95_TIMEOUT = args.time

print("Killing prime95.exe")
kill_p95 = subprocess.Popen("taskkill /F /IM \"prime95.exe\"")
time.sleep(3)
p95_process = subprocess.Popen([P95_EXE_PATH, '-t'])
print("Waiting up to 5 seconds for prime95.exe GUI")
time.sleep(5)
print(f"prime95.exe spawned with PID: {p95_process.pid}")

edit_x = 60
edit_y = 45

copy_x = 60
copy_y = 65

window_x = 30
window_y = 280

test_x = 20
test_y = 45

stop_x = 30
stop_y = 150

START_TIME = time.time()
END_TIME = START_TIME + P95_TIMEOUT

print(f"\nSTART TIME: {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(START_TIME))}")
print(f"ESTIMATED END TIME: {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(END_TIME))}")

for _ in tqdm(range(P95_TIMEOUT), desc="Progress", dynamic_ncols =True):
    time.sleep(1)

# FindWindow takes the Window Class name (can be None if unknown), and the window's display text. 
p95 =  gw.getWindowsWithTitle(P95_PRIME_WINDOW_NAME)[0]
##window_rect   = GetWindowRect(window_handle)
##print(window_handle)
##print(window_rect)
x, y, win_x, win_y = p95.left, p95.top, p95.width, p95.height
size = f"x1: {x}, y1: {y}, win_x1: {win_x}, win_y1: {win_y}"
#print(GetWindowRectFromName("Prime95"))
#print(size)
pyperclip.copy("")
print("Locking mouse and keyboard...")
ok = ctypes.windll.user32.BlockInput(True) #enable block
#time.sleep(1)
p95.activate()
time.sleep(2)
pyautogui.click(x=x+test_x, y=y+test_y) 
pyautogui.press('down')
pyautogui.press('down')
pyautogui.press('down')
pyautogui.press('down')
pyautogui.press('down')
pyautogui.press('enter')
pyautogui.press('enter')
#pyautogui.moveTo(x=x+test_x, y=y+test_y, duration = 1) 
time.sleep(2)
#pyautogui.click(y)
#print("click1")
#pyautogui.moveTo(x=x+window_x, y=y+win_y*0.7, duration=1)
pyautogui.click(x=x+window_x, y=y+win_y*0.7)
time.sleep(2)
pyautogui.click(x=x+edit_x, y=y+edit_y)
#pyautogui.moveTo(x=x+edit_x, y=y+edit_y, duration=0.5)
pyautogui.press('down')
pyautogui.press('enter')
time.sleep(2)
#print("click2")
#time.sleep(1)
#pyautogui.press('enter')
#pyautogui.click(x=x+window_x, y=y+win_y/2.5)
#pyautogui.click(x=x+edit_x, y=y+edit_y)
#pyautogui.click(x=x+copy_x, y=y+copy_y)
ok = ctypes.windll.user32.BlockInput(False) #disable block 
print("Release mouse and keyboard...")

subprocess.Popen(f"taskkill /F /PID {p95_process.pid}")

time.sleep(1)
p95_log_str = pyperclip.paste()

print(f"Generating prime95.log at {os.path.join(os.getcwd(), 'prime95.log')}")
with open(os.path.join(os.getcwd(), "prime95.log"), "w") as p95_log:
  p95_log_str = p95_log_str.replace("\n", "")
  p95_log.write(p95_log_str)


if os.path.exists(P95_RESULTS_TXT_PATH):
    print(f"Copying results.txt => os.getcwd() IF prime95.exe generates it.")  
    shutil.move(P95_RESULTS_TXT_PATH, os.path.join(os.getcwd(), "results.txt"))
