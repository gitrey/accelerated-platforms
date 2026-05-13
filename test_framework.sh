#!/bin/bash

# Test Framework for Intelligent Model-Aware Deployment Framework

PYTHON_CMD="python3 /app/tools/gemma_deploy.py"

echo "Running tests..."

# Test 1: Gemma 2 27B on single H100 with fitting context (e.g., 30k)
echo "Test 1: Gemma 2 27B on single H100 with fitting context (30k)"
OUTPUT=$($PYTHON_CMD --model-name gemma-2-27b --hardware H100 --gpu-count 1 --context-length 30000)
if [ $? -ne 0 ]; then
    echo "Test 1 Failed: Command exited with non-zero status"
    exit 1
fi
if [[ ! "$OUTPUT" == *"VLLM_ALLOW_LONG_MAX_MODEL_LEN=1"* ]]; then
    echo "Test 1 Failed: VLLM_ALLOW_LONG_MAX_MODEL_LEN=1 missing"
    exit 1
fi
if [[ ! "$OUTPUT" == *"TENSOR_PARALLEL_SIZE=1"* ]]; then
    echo "Test 1 Failed: TENSOR_PARALLEL_SIZE=1 missing"
    exit 1
fi
if [[ ! "$OUTPUT" == *"GPU_MEMORY_UTILIZATION=0.95"* ]]; then
    echo "Test 1 Failed: GPU_MEMORY_UTILIZATION=0.95 missing"
    exit 1
fi
echo "Test 1 Passed"
echo "-----------------------------------"

# Test 2: Gemma 2 27B on single H100 with impossible context (e.g., 128k)
echo "Test 2: Gemma 2 27B on single H100 with impossible context (128k)"
OUTPUT=$($PYTHON_CMD --model-name gemma-2-27b --hardware H100 --gpu-count 1 --context-length 128000 2>&1)
if [ $? -eq 0 ]; then
    echo "Test 2 Failed: Command should have exited with non-zero status"
    exit 1
fi
if [[ ! "$OUTPUT" == *"ERROR"* ]]; then
    echo "Test 2 Failed: Output missing ERROR message"
    exit 1
fi
if [[ ! "$OUTPUT" == *"impossible"* ]] && [[ ! "$OUTPUT" == *"exceeds"* ]]; then
    echo "Test 2 Failed: Output missing descriptive error message"
    exit 1
fi
echo "Test 2 Passed"
echo "-----------------------------------"

# Test 3: Gemma 2 27B on L4 hardware (Requires TP scaling)
echo "Test 3: Gemma 2 27B on L4 hardware"
OUTPUT=$($PYTHON_CMD --model-name gemma-2-27b --hardware L4 --gpu-count 4)
if [ $? -ne 0 ]; then
    echo "Test 3 Failed: Command exited with non-zero status"
    exit 1
fi
if [[ ! "$OUTPUT" == *"TENSOR_PARALLEL_SIZE=3"* ]] && [[ ! "$OUTPUT" == *"TENSOR_PARALLEL_SIZE=4"* ]]; then
    echo "Test 3 Failed: TENSOR_PARALLEL_SIZE missing or incorrect (should be 3 or 4)"
    exit 1
fi
if [[ ! "$OUTPUT" == *"GPU_MEMORY_UTILIZATION=0.9"* ]]; then
    echo "Test 3 Failed: GPU_MEMORY_UTILIZATION=0.9 missing"
    exit 1
fi
echo "Test 3 Passed"
echo "-----------------------------------"

# Test 4: Long context injection check
echo "Test 4: Long context injection check"
OUTPUT=$($PYTHON_CMD --model-name gemma-3-8b --hardware L4 --gpu-count 1 --context-length 16000)
if [ $? -ne 0 ]; then
    echo "Test 4 Failed: Command exited with non-zero status"
    exit 1
fi
if [[ ! "$OUTPUT" == *"VLLM_ALLOW_LONG_MAX_MODEL_LEN=1"* ]]; then
    echo "Test 4 Failed: VLLM_ALLOW_LONG_MAX_MODEL_LEN=1 missing"
    exit 1
fi
echo "Test 4 Passed"
echo "-----------------------------------"

echo "All tests passed successfully!"
exit 0
