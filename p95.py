import os
import subprocess
import time

import win32con
import win32gui
import win32process

ROOT_DIR = os.path.dirname(os.path.realpath(__file__))
P95_EXE_PATH = os.path.join(ROOT_DIR, 'p95v303b6.win32', 'prime95.exe')

p95_process = subprocess.Popen([P95_EXE_PATH, '-t'])




# http://timgolden.me.uk/python/win32_how_do_i/find-the-window-for-my-subprocess.html
def get_hwnds_for_pid(pid):
  def callback (hwnd, hwnds):
    if win32gui.IsWindowVisible (hwnd) and win32gui.IsWindowEnabled (hwnd):
      _, found_pid = win32process.GetWindowThreadProcessId (hwnd)
      if found_pid == pid:
        hwnds.append (hwnd)
    return True
    
  hwnds = []
  win32gui.EnumWindows (callback, hwnds)
  return hwnds

time.sleep(5)
hwnd = get_hwnds_for_pid(p95_process.pid)
print(hwnd)
time.sleep(5)
win32gui.ShowWindow(hwnd[0], win32con.SW_MAXIMIZE)
time.sleep(5)

time.sleep(5)
subprocess.Popen(f"taskkill /PID {p95_process.pid}")