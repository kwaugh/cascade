#!/bin/bash

cp ./sbox.mem /tmp/init.mem
~/cascade/bin/cascade -e decrypt_debug.v
