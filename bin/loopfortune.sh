#!/bin/bash

while true; do
	if [ "$l" == "quit" ]; then
		exit
	fi
	fortune
	read l
done
