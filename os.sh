#!/bin/sh

OS="$(uname -s)"

case "$OS" in
  Linux)
    OS_TYPE="Linux"
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      DISTRO="$ID"
      VERSION="$VERSION_ID"
    else
      DISTRO="unknown"
      VERSION="unknown"
    fi
    CMD="sudo"
    ;;
  Darwin)
    OS_TYPE="macOS"
    DISTRO="macOS"
    VERSION="$(sw_vers -productVersion)"
    CMD="sudo"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    OS_TYPE="Windows"
    DISTRO="Windows"
    VERSION="unknown"
    CMD="curl -sSL"
    ;;
esac

echo "$OS_TYPE $DISTRO $VERSION $CMD"

