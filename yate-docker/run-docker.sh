#!/bin/sh

docker run --name=yate --privileged -p 80:80 -p 5038:5038 -v /dev/bus/usb:/dev/bus/usb yate-container
