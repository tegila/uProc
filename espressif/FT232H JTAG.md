sudo kextunload -b com.apple.driver.AppleUSBFTDI

| JTAG Signal | ESP8266 GPIO Pin | JTAG Signal |
|:-----------:|:----------------:|:-----------:|
| TMS         | GPIO14           | D3          |
| TDI         | GPIO12           | D1          |
| TCK         | GPIO13           | D0          |
| TDO         | GPIO15           | D2          |
| GND         | GND              | D2          |

openocd -s /Applications/OpenOCD/share/openocd/scripts/ -f interface/ftdi/flyswatter2.cfg -f target/esp8266.cfg

```
\#: export PATH=$PATH:/Volumes/case-sensitive/crosstool-NG/builds/xtensa-lx106-elf/bin/
\#: tegila@mbp:~$ xtensa-lx106-elf-gdb
```

### OpenOCD

```
**tegila@mbp:~$ ./openocd -s /Applications/OpenOCD/share/openocd/scripts/ -f interface/ftdi/flyswatter2.cfg -f target/esp8266.cfg**
Open On-Chip Debugger 0.9.0-rc1-dev-00457-g6a7dd37 (2015-07-21-00:19)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
srst_only separate srst_gates_jtag srst_open_drain connect_deassert_srst
adapter speed: 1000 kHz
stop_wdt
Info : clock speed 1000 kHz
Info : TAP esp8266.cpu does not have IDCODE
Warn : Warning: Target not halted, breakpoint/watchpoint state may be unpredictable.

Info : accepting 'gdb' connection on tcp/3333
undefined debug reason 7 - target needs reset
Info : TAP esp8266.cpu does not have IDCODE
Warn : xtensa_deassert_reset: 'reset halt' is not supported for Xtensa. Have halted some time after resetting (not the same thing!)
target state: halted
Info : halted: PC: 0x40003924
Info : debug cause: 0x20
Info : dropped 'gdb' connection
```

### GDB

```
**tegila@mbp:~$ xtensa-lx106-elf-gdb**
GNU gdb (crosstool-NG 1.20.0) 7.5.1
...
**(gdb) target remote localhost:3333**
Remote debugging using localhost:3333
0x40100004 in call_user_start ()
**(gdb) monitor reset halt**
TAP esp8266.cpu does not have IDCODE
xtensa_deassert_reset: 'reset halt' is not supported for Xtensa. Have halted some time after resetting (not the same thing!)
target state: halted
halted: PC: 0x40003924
debug cause: 0x20
**(gdb)**
```

[1] Tópico motivador http://www.esp8266.com/viewtopic.php?f=9&t=1871
[2] OpenOCD ESP8266 https://github.com/projectgus/openocd
[3] ST40 JTAG http://www.avi-plus.com/repair-tips-forum/miscellaneous-software/others/st40-stb71xx-jtag-interfacing
[4] FT232H.cfg https://digistump.com/board/index.php?topic=1275.0
[5] FT232H.cfg fix http://sourceforge.net/p/openocd/mailman/message/31920185/
[6] FT232H Datasheet http://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT232H.pdf
