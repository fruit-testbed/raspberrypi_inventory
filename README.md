# Inventory scripts

For automated inventorying of many Raspberry Pi boards.

 1. Get a recent Raspbian image.
 2. Put it on your SD card.
 3. Mount the boot partition of the SD card on your PC.
 4. Edit `config.txt`, adding `enable_uart=1` at the bottom, to enable the serial console.
 5. `git clone https://github.com/fruit-testbed/raspberrypi_inventory` into the boot partition
 6. Create a file `raspberrypi_inventory/server.txt` containing the
    URL of your server. For example, `http://YOUR.SERVER.NAME:5998`.
 7. Mount the root partition of the SD card on your PC.
 8. Edit `etc/rc.local`, adding a line `/boot/raspberrypi_inventory/bootscript.sh` before the `exit 0` at the end.
 9. Start the server on your host: `python3 -m http.server 5998 --cgi`

Collects:
  - `/proc/cpuinfo` - serial and hardware variant
  - `free` output - memory info
  - `ifconfig` output - ethernet stuff incl MAC
  - `iwconfig` output - wireless stuff

Could perhaps collect:
  - bluetooth info??

## Notes

DNS is super slow by default in some environments -
[This page](https://serverfault.com/questions/858649/slow-responses-with-curl-and-wget-on-centos-7)
recommends adding a line `options single-request-reopen` to
`/etc/resolv.conf`. Our `bootscript.sh` does this.
