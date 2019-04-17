#!/bin/env bash
cd ~
gpsd /dev/ttyUSB0
kismet_server --daemonize
