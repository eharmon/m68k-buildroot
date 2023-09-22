#!/bin/bash

git submodule update --init
make -C buildroot O=../ outputmakefile
