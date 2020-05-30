#!/bin/bash

for i in $(cut -d ' ' -f 1 list.txt)
do
	wget http://169.44.201.108:7002/imagenet/val/$i
done
