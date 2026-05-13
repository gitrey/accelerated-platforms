import argparse
import math
import sys
import re

HARDWARE_VRAM_GB = {
    "H100": 80.0,
    "A100": 80.0,
    "L4": 24.0
}

HARDWARE_MEM_UTIL = {
    "H100": 0.95,
    "A100": 0.92,
    "L4": 0.90
}

def parse_model_info(model_name: str) -> tuple[int, int]:
    # Parse string like gemma-2-27b
    match = re.match(r'gemma-(\d+)-(\d+)b', model_name.lower())
    if match:
        return int(match.group(1)), int(match.group(2))
    raise ValueError(f"Invalid model name format: {model_name}")

def calculate_memory_requirements(params_b: int, context_length: int) -> tuple[float, float]:
    weight_mem = params_b * 2.0
    kv_mem = (context_length / 8192) * (params_b / 9.0) * 2.0
    return weight_mem, kv_mem

def evaluate_deployment(model_name: str, hardware: str, gpu_count: int, context_length: int):
    if hardware not in HARDWARE_VRAM_GB:
        raise ValueError(f"Unsupported hardware: {hardware}")
    
    version, params_b = parse_model_info(model_name)
    weight_mem, kv_mem = calculate_memory_requirements(params_b, context_length)
    
    total_required_memory = weight_mem + kv_mem
    available_vram_per_gpu = HARDWARE_VRAM_GB[hardware] * HARDWARE_MEM_UTIL[hardware]
    total_available_vram = available_vram_per_gpu * gpu_count
    
    if total_required_memory > total_available_vram:
        print(f"ERROR: Deployment mathematically impossible.", file=sys.stderr)
        print(f"Total required memory ({total_required_memory:.2f} GB) exceeds "
              f"total available VRAM ({total_available_vram:.2f} GB).", file=sys.stderr)
        sys.exit(1)
        
    required_gpus = math.ceil(total_required_memory / available_vram_per_gpu)
    if required_gpus > gpu_count:
        print(f"ERROR: Insufficient GPUs.", file=sys.stderr)
        print(f"Required {required_gpus} GPUs, but only {gpu_count} provided.", file=sys.stderr)
        sys.exit(1)
        
    tp_size = required_gpus
    
    env_vars = {
        "TENSOR_PARALLEL_SIZE": str(tp_size),
        "GPU_MEMORY_UTILIZATION": str(HARDWARE_MEM_UTIL[hardware])
    }
    
    if hardware in ["H100", "A100"]:
        env_vars["VLLM_ATTENTION_BACKEND"] = "flashinfer"
        
    if context_length > 8192:
        env_vars["VLLM_ALLOW_LONG_MAX_MODEL_LEN"] = "1"
        
    for k, v in env_vars.items():
        print(f"{k}={v}")

def main():
    parser = argparse.ArgumentParser(description="Intelligent Model-Aware Deployment Framework")
    parser.add_argument("--model-name", required=True, help="Model name (e.g., gemma-2-27b)")
    parser.add_argument("--hardware", required=True, choices=HARDWARE_VRAM_GB.keys(), help="Target hardware accelerator")
    parser.add_argument("--gpu-count", required=True, type=int, help="Number of GPUs available")
    parser.add_argument("--context-length", required=False, type=int, default=8192, help="Requested context length")
    
    args = parser.parse_args()
    
    evaluate_deployment(args.model_name, args.hardware, args.gpu_count, args.context_length)

if __name__ == "__main__":
    main()
