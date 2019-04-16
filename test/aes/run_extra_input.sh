#!/bin/bash

inputSize=2048
inputFileName="experiments/input$inputSize.mem"
runFileName="experiments/runEncrypt$inputSize.v"
outputFileName="experiments/output$inputSize.txt"
cd ../
cp $inputFileName "input.mem"
~/cascade/bin/cascade --march sw --batch -e $runFileName >> $outputFileName
