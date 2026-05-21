# Migration Plan: LangChain to ADK 2.0 (Scion)

This plan outlines the strategic approach for porting agents from the LangChain framework to the Scion-based ADK 2.0 architecture.

## Phase 1: Analysis & Mapping
The goal is to identify all LangChain components and map them to their ADK 2.0 equivalents.

| LangChain Concept | ADK 2.0 (Scion) Equivalent | Notes |
| :--- | :--- | :--- |
| **Agent / Executor** | **Scion Agent (Harness + Prompt)** | The Scion harness manages the loop and tool calls. |
| **Tool (Function/Class)** | **Scion Tool (YAML + Script)** | Tools become standalone, containerized scripts. |
| **Toolkit** | **Scion Skill** | Groups of tools that can be activated dynamically. |
| **Memory (Buffer/Summary)** | **Scion Hub / Local State** | Persistent, structured state managed by the Hub. |
| **Chain** | **Agent-to-Agent Messaging** | Complex workflows are broken into multi-agent coordination. |
| **Prompts / Templates** | **System Instructions (prompt.md)** | Core persona and behavioral logic. |

## Phase 2: Tool & Skill Development
1. **Extract Logic:** Isolate the core execution logic from the LangChain tool definitions.
2. **Containerize:** Package each tool into its own container-ready environment (typically part of the agent's `/workspace`).
3. **YAML Definition:** Define the tool interface (inputs, outputs, description) in a YAML file for the Scion registry.
4. **Skill Creation:** Use the `skill-creator` or manual configuration to bundle related tools into logical skills.

## Phase 3: Agent Configuration
1. **Harness Selection:** Choose the appropriate harness (e.g., `gemini`, `vertex-ai`).
2. **Persona Porting:** Port the LangChain `SystemMessage` or prompt template to the Scion `prompt.md` or system instruction block.
3. **Authentication:** Map LangChain environment-based secrets (like `OPENAI_API_KEY`) to Scion's secure Hub secrets or harness-auth configurations.

## Phase 4: Integration & Testing
1. **Local Validation:** Use `scion run --local` to test tool execution without Hub dependency.
2. **Messaging Integration:** If the agent was part of a larger chain, implement Scion's `SendMessage` protocol to coordinate with other agents.
3. **State Verification:** Ensure memory persists correctly via Hub heartbeats and state updates.

## Phase 5: Operationalization
1. **Monitoring:** Configure standard Scion status signals (`thinking`, `executing`, `blocked`).
2. **CI/CD:** Integrate the agent template into an automated deployment pipeline (e.g., GitHub Actions building the container and updating the Hub registry).
3. **Logging:** Leverage `scion logs` for centralized operational visibility.
