## Adafruit Trinkey RP2040 InfoStealer
Building a simple, undetectable Info Stealer, physical edition.

## Undetectable?
Yeah. Complete stealth 9000 promax premium. Note that it's **not over 9000**. Tested only on non-AD Windows 10 clients, AD may or may not behave differently (default config, probably not). It could still leave some traces, depending on how the system is monitored, `sysmon`, `SIEM` or other advanced detection may catch it of course.

## Code
Working but not fully finished. We added a `Blink Debug` function, cause we often ran into the issue of "Safe Mode", when the Python script goes beyond software-fault and you cannot read it via REPL. Recommend to remove blinking on your release version.

Initially it seemed that you need to toggle between HID and storage mode, this may've been from a different bug we did mistaken at first. Long story short, we left the function to toggle to storage, but don't use it anymore, it works without. We also adjusted the delays, some shorter, some longer, to compensate for unforseen *Windows reactions* on pluggin the device in, like popup messages. 

## Blog
Article: https://blog.network-sec.de/post/physical_infostealer_without_malware/

## Licensing
lib-folder is 3rd party. 
