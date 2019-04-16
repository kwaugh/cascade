#!/bin/bash

cd ../
for inputSize in 1 4 16 128 1024 2048; do
    inputFileName="experiments/input$inputSize.mem"
    for i in $(seq 1 $inputSize); do
        echo "0 1 2 3 4 5 6 7 8 9 a b c d e f" >> $inputFileName
    done
    let "inputSizeBytes = $inputSize*16"
    # ENCRYPT
    echo "include sim_run.v; RUN_ENCRYPT#($inputSizeBytes) enc(clock.val);" >> "experiments/runEncrypt$inputSize.v"
    # DECRYPT
    echo "include sim_run.v; RUN_DECRYPT#($inputSizeBytes) dec(clock.val);" >> "experiments/runDecrypt$inputSize.v"
done
