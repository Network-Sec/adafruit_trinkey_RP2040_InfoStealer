## Adafruit Trinkey RP2040 InfoStealer
Building a simple, undetectable Info Stealer, physical edition

## Code
Working but not fully finished. We added a `Blink Debug` function, cause we often ran into the issue of "Safe Mode", when the Python script goes beyond software-fault and you cannot read it via REPL. Recommend to remove blinking on your release version.

Initially it seemed that you need to toggle between HID and storage mode, this may've been from a different bug we did mistaken at first. Long story short, we left the function to toggle to storage, but don't use it anymore, it works without. We also adjusted the delays, some shorter, some longer, to compensate for unforseen *Windows reactions* on pluggin the device in, like popup messages. 

## Blog
Article: https://blog.network-sec.de/post/physical_infostealer_without_malware/

## Licensing
lib-folder is 3rd party. 
