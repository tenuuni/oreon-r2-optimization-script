#!/bin/bash
echo Checking for an internet connection...
wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    echo "Online, proceeding..."
    echo "You will be asked for your password a few times during the process. If you do not feel safe entering your password, you can review the script."
    sleep 2
    echo "A beep will be played before asking for your password to indicate progress."
    sleep .3
    echo "Stage 1 - RPM Fusion Free and Nonfree"
    wget https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm
    wget https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm
    echo -e '\a'
    sudo dnf install rpmfusion-free-release-9.noarch.rpm
    echo -e '\a'
    sudo dnf install rpmfusion-nonfree-release-9.noarch.rpm
    echo "Stage 1 completed."
    sleep 1
    echo "Stage 2 - Multimedia codecs"
    echo -e '\a'
    sudo dnf swap ffmpeg-free ffmpeg --allowerasing
    echo -e '\a' 
    sudo dnf groupupdate multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    echo -e '\a'
    sudo dnf groupupdate sound-and-video
    echo -e '\a'
    echo "For the hardware-accelerated codecs you must choose what GPU you have. Input i for Intel, a for AMD, nv for Nvidia and none to not install a hardware-accelerated codec."
    read gputype
    if [ gputype == "i" ]; then
      echo -e '\a'
      sudo dnf install intel-media-driver
    fi
    if [ gputype == "a" ]; then
      sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
      sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
    fi
    if [ gputype == "nv" ]; then
      sudo dnf install nvidia-vaapi-driver
    fi
    if [ gputype == "n" ]; then
      echo "Skipping hardware codec"
    fi
    echo "Stage 2 completed."
    sleep 2
    echo "The script has finished running! Come back later for more features in the next update."
else
    echo "You need an internet connection to use this script! Connect to the Internet and re-run this script."
fi
