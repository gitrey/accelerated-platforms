# Migration Guide: LangChain Tools to ADK 2.0 (Scion)

This guide documents the process of decoupling tools from the LangChain framework and redefining them as standalone Scion tools for use with the ADK 2.0 (Scion) architecture.

## 1. Overview
In LangChain, tools are often tightly coupled with the framework (e.g., `BaseTool` subclasses or `@tool` decorators). In Scion ADK 2.0, tools are decoupled, containerized, and defined declaratively via YAML. This allows for better isolation, easier testing, and cross-agent tool sharing via the Hub.

### Mapping Table
| LangChain Concept | ADK 2.0 (Scion) Equivalent |
| :--- | :--- |
| `@tool` function | Python Function Tool (Module-based) |
| `BaseTool` subclass | Standalone Script + YAML Definition |
| `args_schema` (Pydantic) | JSON Schema (auto-generated from docstrings/type hints) |
| `Toolkit` | Scion Skill |

---

## 2. Tool Extraction Process

### Step 1: Isolate Core Logic
Remove all LangChain-specific imports and decorators. Extract the execution logic into a pure Python function or a standalone script.

**Before (LangChain):**
```python
from langchain.tools import tool

@tool
def calculate_tax(amount: float, rate: float) -> float:
    """Calculates tax for a given amount and rate."""
    return amount * rate
```

**After (Pure Python):**
```python
# tools/calculator.py
def calculate_tax(amount: float, rate: float) -> float:
    """Calculates tax for a given amount and rate.
    
    Args:
        amount: The total amount to calculate tax on.
        rate: The tax rate as a decimal (e.g., 0.05 for 5%).
    
    Returns:
        The calculated tax amount.
    """
    return amount * rate
```

### Step 2: Define Dependencies
Ensure all required libraries are listed in your project's `requirements.txt` or the tool's environment configuration. Scion tools run in containerized environments, so explicit dependency management is critical.

---

## 3. YAML Definition Guide

Scion tools are defined in the agent's configuration file (e.g., `agent.yaml`) or as standalone registry entries.

### Inline Definition (Agent Config)
To use a Python function as a tool, reference its fully qualified name.

```yaml
# agent.yaml
name: tax_accountant
model: gemini-2.0-flash
tools:
  - name: tools.calculator.calculate_tax
```

### Standalone Tool Definition (Registry/Skill)
For tools that are not simple Python functions (e.g., Shell scripts, MCP servers), use a detailed YAML specification.

```yaml
# skills/finance/tools/tax_calc.yaml
name: calculate_tax
description: "Calculates tax for a given amount and rate."
parameters:
  type: object
  properties:
    amount:
      type: number
      description: "The total amount."
    rate:
      type: number
      description: "The tax rate (decimal)."
  required: ["amount", "rate"]
container:
  image: "python:3.11-slim"
  command: ["python", "scripts/tax_calc.py"]
```

---

## 4. Advanced Tool Types

### Model Context Protocol (MCP) Tools
If migrating a LangChain tool that interacts with complex local state or external hardware, consider using MCP.

```yaml
tools:
  - name: MCPToolset
    args:
      stdio_server_params:
        command: "python"
        args: ["-m", "mcp_filesystem_server", "/workspace/data"]
```

### OpenAPI Tools
For LangChain `APIChain` or `OpenAPITool`, use the native Scion OpenAPI support.

```yaml
tools:
  - name: OpenAPIToolset
    args:
      spec_path: "specs/inventory_api.yaml"
```

---

## 5. Skill Encapsulation

Group related tools into "Skills". A Scion Skill is a directory containing a `SKILL.md` file and bundled resources.

### Structure
```
skills/finance/
├── SKILL.md          # Metadata and instructions
├── scripts/          # Extracted tool logic
│   └── tax_calc.py
└── references/       # Supporting docs (e.g., tax tables)
    └── rates_2024.md
```

### SKILL.md Example
```markdown
---
name: finance-utils
description: Tools for financial calculations and tax estimation.
---
# Finance Utils
Use these tools when the user asks for tax calculations or financial projections.
```

---

## 6. Verification and Testing

1. **Local Test**: Use `scion run --local` to verify the tool executes correctly within the harness.
2. **Schema Check**: Ensure the auto-generated JSON schema correctly reflects the tool's input requirements.
3. **Hub Registry**: Push the tool or skill to the Hub registry to make it available to other agents.

```bash
scion templates sync --non-interactive
```

---
*Refer to `docs/LANGCHAIN_MIGRATION_PLAN.md` for the full migration roadmap.*
