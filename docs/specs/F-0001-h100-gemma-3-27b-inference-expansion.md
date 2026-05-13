# F-0001: H100 Gemma 3 27b Inference Expansion

- **Type:** Enhancement
- **Status:** Complete
- **Priority:** P1
- **JIRA ID:** TBD (Pending PO creation)

## Problem
Gemma 3 27b support on H100 is currently only available for Online Inference and Speculative Decoding in the reference architecture. Users need consistent support across other inference patterns, specifically Async Inference and Offline Batch Inference, to leverage H100 GPUs effectively for all use cases.

## Requirements
1. **Async Inference Support:**
   - Create Kubernetes manifests for Async Inference using vLLM on H100 for Gemma 3 27b.
   - Configuration should use 1 x H100 GPU (80GB).
2. **Offline Batch Inference Support:**
   - Create Kubernetes manifests for Offline Batch Inference (batch worker) on H100 for Gemma 3 27b.
   - Configuration should use 1 x H100 GPU (80GB).
3. **Consistency:**
   - Ensure runtime.env and resource patches are consistent with the existing Online Inference configuration.
4. **Documentation:**
   - Update docs/platforms/gke/base/use-cases/inference-ref-arch/async-inference/README.md to include H100 + Gemma 3 27b.
   - Update docs/platforms/gke/base/use-cases/inference-ref-arch/batch-inference/README.md to include H100 + Gemma 3 27b.

## Acceptance Criteria
- [x] Directory platforms/gke/base/use-cases/inference-ref-arch/kubernetes-manifests/async-inference-gpu/vllm/h100-gemma-3-27b-it exists with valid manifests.
- [x] Directory platforms/gke/base/use-cases/inference-ref-arch/offline-batch-inference-gpu/offline-batch-worker/h100-gemma-3-27b-it exists with valid manifests.
- [x] configure_vllm.sh and configure_worker.sh correctly handle the new configurations.
- [x] Documentation updated and accurately reflects the new supported accelerator/model combinations.


## Out of Scope
- Support for other models (e.g., Llama) in this specific task.
- Multi-GPU configurations (Tensor Parallelism > 1).

## Dependencies
- Existing H100 node pool configuration in Terraform.
- Existing vLLM base manifests.
