# PoC Migration: LangChain Search & Calculate Agent to ADK 2.0 (Scion)

This document describes the proof-of-concept migration of a standard LangChain "Search & Calculate" agent to the ADK 2.0 (Scion) architecture.

## 1. Original LangChain Logic
The original agent was built using LangChain's `initialize_agent` with the `ZERO_SHOT_REACT_DESCRIPTION` agent type.

### Tools:
- `serpapi`: For Google Search.
- `llm-math`: For numerical calculations.

### Prompt:
"Answer the following questions as best you can. You have access to the following tools..."

## 2. ADK 2.0 (Scion) Translation

### Agent Structure
The agent is now defined as a Scion Project with the following components:
- `prompt.md`: The translated system instructions.
- `tools/`: Independent, containerized tool definitions and scripts.
- `harness.yaml`: Execution context configuration.

### Mapping Table
| LangChain Component | Scion Component |
| :--- | :--- |
| `AgentExecutor` | Scion Harness |
| `serpapi` Tool | `google_search` Tool (YAML + Script) |
| `llm-math` Tool | `calculator` Tool (YAML + Script) |
| System Prompt | `prompt.md` |
| `Memory` | Hub State Management |

## 3. Implementation Details

### Tools
#### google_search
- **YAML:** `projects/search-calculate-agent/tools/google_search.yaml`
- **Script:** `projects/search-calculate-agent/tools/google_search.py`

#### calculator
- **YAML:** `projects/search-calculate-agent/tools/calculator.yaml`
- **Script:** `projects/search-calculate-agent/tools/calculator.py`

### System Instructions (`prompt.md`)
The ReAct logic is now handled by the Scion harness, allowing the prompt to focus on persona and goal.

## 4. Verification Plan
- [x] Local execution of `google_search` tool.
- [x] Local execution of `calculator` tool.
- [ ] Full agent loop verification via `scion run --local`.
