Buildroot Linux for 68k Macs [Debian packaging branch]
======================================================

Pre-configured [Buildroot Linux](https://buildroot.org) for 68040-based Macintosh.

*This branch enables installing packages directly from the m68k Debian port: https://www.debian.org/ports/m68k/*
*See below for more details*

To setup the Buildroot environment, run:

	./setup.sh

Now you can configure further using the standard Buildroot methods, please see the Buildroot documentation.

As an example, to build images simply run make:

	make

The first build will take quite some time.

By default, a kernel, ramdisk, and ext2 volume will be built into the `images` directory.

The images are configured to DHCP using onboard ethernet and start an SSH server. There is only a `root` user with no password. Additional packages can be installed by configuring Buildroot.

For machines with smaller memory configurations, you can switch the kernel to build for size (-Os), disable kernel features (additional filesystems, IPv6, etc), and disable software packages. The default configuration will run well on systems with 64MiB, but may work on smaller systems.

First boot will be very, very slow as the SSH host keys will be generated. Let it sit, it is not frozen.

Debian
------

This branch enables direct installation of Debian packages from the Debian m68k port. This is a dirty hack. You should never trust an old system like this to do anything important (even with a modern kernel), and this further reduces security and increases instability. While these mix-and-match configurations are possible, they're not designed to work and can break at any time. I tried this only because it was there, though it is handy to have a large corpus of binary packages to work with.

This is accomplished with a few tricks:
- apt and dpkg are provided as external Buildroot packages. On first `make` Buildroot will automatically be configured to find this external tree.
- A root FS is included which installs the correct sources for Debian to find `sid`.
- The root FS additionally contains manually unpacked keyring data to authenticate packages.
- Unlike the main branch, this uses glibc instead of uclibc for compatibility.

This is sufficient to convince apt to install packages, which works for simple things like command-line tools. It's unlikely to work with anything complex, like daemons, etc.

To install packages, use `apt` normally. `apt update` must be run first to populate the package list. You can also use `dpkg` to manually install packages.

The first package you install will cause apt to replace Buildroot's copy of glibc with Debian's libc6 package. This is a result of the dirty hacks above. While not strictly desirable, at the moment (June 2025), they are compatible "enough" and this works without problems.

Usage
-----

To boot these in Qemu, run:

	$ qemu-system-m68k -boot d \
	    -M q800 -m 256M -rtc base=localtime \
	    -net nic,model=dp83932 -net user \
	    -append "root=/dev/sda rw console=ttyS0" \
	    -kernel images/vmlinux \
	    -drive file=images/rootfs.ext2,format=raw \
	    -nographic

To boot on a real computer, use [Penguin](https://sourceforge.net/projects/linux-mac68k/files/Penguin%20Booter/Penguin-19/). The Linux/mac68k Project has a [useful FAQ](http://www.mac.linux-m68k.org/docs/penguin.php).

Roughly, you can do the following to boot Linux from memory as a test. This will require a large amount of memory (64MiB+):

1) Copy `vmlinux` and `rootfs.cpio.lz4` to your Mac.
2) By default, Penguin is not configured to use as much memory as we need to load modern, larger Linux kernels and ramdisks.
	- On your 68k Mac, select the Penguin app and do File -> Get Info.
	- Set the Minimum and Preferred memory to something large, like 50000. This ensures the app can allocate enough memory to load the entire kernel and ramdisk.
	- Close the Info window.
3) Open Penguin and select File -> Settings…. Select the Kernel tab.
4) Choose a kernel file and select `vmlinux`.
5) Check the RAM Disk box and select `rootfs.cpio.lz4`.
6) Select the Options tab.
7) In the command line, put `root=/dev/ram`.
8) Click OK, save the settings if you like.
9) Select File -> Boot Now

If you'd like to install to disk, you'll need to copy the `rootfs.ext2` to a new ext2 partition on a SCSI disk. You can select this as the boot device by modifying the command line to put `root=/dev/sda2 rw`, where "sda" is mapped to the SCSI ID (a=1, b=2, etc) and the digit is the partition number.
