#!/bin/bash
printf "Shutting down the processes:\n"
ps afx | grep erlporter
pkill -f erlporter
