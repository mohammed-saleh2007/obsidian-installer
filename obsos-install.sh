#!/bin/bash

# Functions

function askyn(){
  while [[ "$1" -ne "y" && "$1" -ne "n" ]]; do
    echo "wrone input, try again!"
    read $1
  done
}


echo "Welecome to Obsidian OS installer - alpha0.1"
echo "We will ask you some questions and let everything to us!"
echo "check if the script run with root privilage..."

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Exiting."
  exit 1
fi

echo "Running as root."

echo ""
echo "[-] How would you want to install Obsidian OS?"
echo "(_) online - soon"
echo "(1) offline"
echo "[?] type your answare: "

read WHERE

while [[ "$WHERE" -ne "1"]]; do
  echo "wrone input, try again!"
  read WHERE
done

if [[ "$WHERE" -eq "1" ]]; then
  echo "Starting offilne installation..."
fi

lsblk
echo "Do you want to change your disk? (y/n)"
read askdisk
askyn "$askdisk"

if [[ "$askdisk" -eq "y" ]]; then
  cfdisk
fi

echo "What disk you want to use? (/dev/sdX)"
read DISK

echo "Now! tell us where you want to mount every  partition?"
echo "root (/):"
read ROOT
echo "home (/home) -OPTIONAL-:"
read HOME

echo "reading partition table type of your disk $DISK"
PTT = $(fdisk -l $"DISK" | grep 'Disklabel type' | awk '{print $3}')

echo "Your disk partition table type is $PTT"
if [[ "$PTT" -eq "mbr" ]]; then
  echo "WE DO NOT NEED A PARTITION FOR BOOT!"
fi

echo "mounting partitions..."
# mount $ROOT /mnt
# mkdir -p /mnt/home
# mount $HOME /mnt/home
if [[ "$PTT" -eq "mbr" ]]; then
  echo "efi (/boot/efi)?"
  read EFI
  # mkdir -p /mnt/boot/efi
  # mount #EFI /mnt/boot/efi
fi

echo "Copying file system to your disk... please wait"
# rsync -aAXv --exclude={"/proc/*","/sys/*","/dev/*","/run/*", "/mnt/*", "/tmp/*", "/boot/*"} / /mnt

echo "Entering your new obsidian os"

echo "generating initramfs...."
# mkinitcpio -P

echo "installing grub"
# grub-install $DISK
# grub-mkconfig -o /boot/grub/grub.cfg

