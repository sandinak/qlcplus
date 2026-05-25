#!/bin/bash
set -e

echo "Setting up QLC+ build environment..."

# Update package lists
sudo apt-get update

# Install Qt5 and essential build tools (qt5-default is not available in Ubuntu 22.04+)
sudo apt-get install -y \
    build-essential \
    qt5-qmake \
    qtbase5-dev \
    qtbase5-dev-tools \
    qttools5-dev \
    qttools5-dev-tools \
    qtscript5-dev \
    qtmultimedia5-dev \
    libqt5multimedia5-plugins \
    libqt5multimediawidgets5 \
    libqt5svg5-dev \
    libqt5serialport5-dev \
    libqt5test5

# Install QLC+ specific dependencies
sudo apt-get install -y \
    libasound2-dev \
    libusb-1.0-0-dev \
    libftdi1-dev \
    shared-mime-info \
    libudev-dev \
    libmad0-dev \
    libsndfile1-dev \
    liblo-dev \
    libfftw3-dev \
    libgl1-mesa-dev \
    libxml2-utils \
    xvfb \
    ccache \
    wget \
    libpulse-dev \
    pkg-config

# Install Python dependencies for fixture validation
sudo apt-get install -y python3-pip python3-lxml

# Set up environment variables for headless Qt testing
echo 'export PATH=/usr/lib/qt5/bin:$PATH' >> $HOME/.profile
echo 'export QT_SELECT=qt5' >> $HOME/.profile
echo 'export QT_QPA_PLATFORM=minimal' >> $HOME/.profile
echo 'export QT_LOGGING_RULES="qt.qpa.xcb.warning=false"' >> $HOME/.profile

# Source the profile to make variables available immediately
source $HOME/.profile

# Navigate to workspace
cd /mnt/persist/workspace

# Clean any previous builds
make distclean 2>/dev/null || true

# Fix Qt 5.15 compatibility issue with QColor::fromString
# This method was added in Qt 6, so we need to replace it with setNamedColor for Qt 5
echo "Fixing Qt 5.15 compatibility issues..."
sed -i 's/QColor::fromString(/QColor().setNamedColor(/g' ui/src/consolechannel.cpp
sed -i 's/color = QColor().setNamedColor(/color.setNamedColor(/g' ui/src/consolechannel.cpp

# Generate translation files
./translate.sh ui

# Configure the build with qmake
qmake QMAKE_CXX="g++" QMAKE_CC="gcc" QMAKE_LINK="g++" QMAKE_LINK_SHLIB="g++"

# Build the project using all available CPU cores
NUM_CPUS=$(nproc)
make -j${NUM_CPUS}

echo "Build completed successfully!"
echo "QLC+ build environment is ready for testing."