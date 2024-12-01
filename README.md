## Adafruit Trinkey RP2040 InfoStealer
Building a simple, undetectable Info Stealer, physical edition.

## Undetectable?
Yeah. Complete stealth 9000 promax premium. Note that it's **not over 9000**. 

Tested only on non-AD Windows 10 clients, AD may or may not behave differently (default config, probably not). It could still leave some traces, depending on how the system is monitored, `sysmon`, `SIEM` or other advanced detection may catch it of course. It's not fileless and will touch disk. 

Commands like `whoami` can trigger suspicion, we put our focus rather on speed (< 45sec. on average, used system) and non-persistant properties (evade signature / antivirus and network detection, searching more or less the entire user space, "1TB C:-drive". 

## Code
- Working but not fully finished (when is it ever?)
- `Blink Debug` function, cause we often ran into the issue of "Safe Mode" with the Trinkey
- We left the function to toggle to storage mode, but don't use it anymore, it works without
- DE and US keyboard layout libraries included
- Batteries not included
- Adjusted the delays, some shorter, some longer, to compensate for unforseen *Windows reactions* when plugging, like popup messages
- Added a `boot.py` to prevent the device from rebooting after a certain timeout
- Finally we reworked the lite payload and a few more things

Should be fine to use. 

## How to customize
- Adjustment off the `typed-in` 1st stage (code.py) is mandatory, to make it look more like an official Windows update or whatever
- Uncomment / add code for Powershell history behaviour in 1st stage (examples in comments)
- Remove blinking

We will not provide further updates, if you cannot make the few **customizations** needed to actually use this, then consider not using it, please 

## Blog
Article: https://blog.network-sec.de/post/physical_infostealer_without_malware/

## Licensing
lib-folder is 3rd party. 

We release this cute demo project as-is `for legal purposes only` - gov surveillance of EU citizens excluded. 

Pentesting and Redteaming allowed & encouraged. 

