# Product Backlog

| ID | Priority | Status | Title | JIRA ID | Spec |
|----|----------|--------|-------|---------|------|
| F-0001 | P1 | Complete | H100 Gemma 3 27b Inference Expansion | TBD | [F-0001](specs/F-0001-h100-gemma-3-27b-inference-expansion.md) |

## Technical Tasks

| ID | Feature | Title | Assignee | Status |
|----|---------|-------|----------|--------|
| T-0001 | F-0001 | Create Async Inference manifests for H100 Gemma 3 27b | SWE-2 | Completed |
| T-0002 | F-0001 | Create Offline Batch Inference manifests for H100 Gemma 3 27b | SWE-2 | Completed |
| T-0003 | F-0001 | Update configuration scripts (configure_vllm.sh, configure_worker.sh) | SWE-2 | Completed |
| T-0004 | F-0001 | Update documentation for Async and Batch Inference | SWE-2 | Completed |
| T-0005 | F-0001 | Verify and Test the new inference patterns | SWE-Test | Completed |
| T-0006 | F-0001 | Fix Offline Batch Inference resource patch (limit to 1 GPU) | TPM | Completed |
