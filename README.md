Buildroot Linux for 68k Macs
============================

Pre-configured Buildroot Linux for 68040 Macintosh.

To setup the Buildroot environment, run:

	./setup.sh

Now you can configure further using the standard Buildroot methods. For instance, to build images:

	make

The first build will take quite some time.

By default, a kernel, ramdisk, and ext2 volume will be built into the `images` directory.

The images are configured to DHCP using onboard ethernet and start an SSH server. There is only a `root` user with no password. Additional packages can be installed by configuring Buildroot.

First boot will be very, very slow as the SSH host keys will be generated. Let it sit, it is not frozen.

To boot these in Qemu, run:

	$ qemu-system-m68k -boot d \
	    -M q800 -m 256M -rtc base=localtime \
	    -net nic,model=dp83932 -net user \
	    -append "root=/dev/sda rw console=ttyS0" \
	    -kernel images/vmlinux \
	    -drive file=images/rootfs.ext2,format=raw \
	    -nographic
