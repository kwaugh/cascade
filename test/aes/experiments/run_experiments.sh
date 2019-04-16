#!/bin/bash

cd ../
for inputSize in 1 4 16 128 1024 2048; do
    inputFileName="experiments/input$inputSize.mem"
    runFileName="experiments/run$inputSize.v"
    outputFileName="experiments/output$inputSize.txt"
    cp $inputFileName "input.mem"
    runFileName="experiments/runEncrypt$inputSize.v"
    ~/cascade/bin/cascade --march sw --batch -e $runFileName >> $outputFileName
    runFileName="experiments/runDecrypt$inputSize.v"
    ~/cascade/bin/cascade --march sw --batch -e $runFileName >> $outputFileName
done

