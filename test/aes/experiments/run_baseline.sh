#!/bin/bash

cd ../../tiny-AES-c
for inputSize in 1 4 16 128 1024 2048; do
    inputFileName="experiments/input$inputSize.mem"
    outputFileName="experiments/output$inputSize.txt"
    let "inputSizeBytes = $inputSize * 16"
    ./adhoc encrypt $inputSizeBytes ../final_proj/$inputFileName >> ../final_proj/$outputFileName
    ./adhoc decrypt $inputSizeBytes ../final_proj/$inputFileName >> ../final_proj/$outputFileName
done
