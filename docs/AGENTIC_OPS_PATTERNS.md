# Agentic Operational Monitoring and Security Patterns

This document outlines the standard operational patterns for agents operating within the Scion orchestration system.

## 1. Monitoring Agent Health and Activity

### 1.1 Activity Logs
- Agents MUST emit structured logs for all tool calls and significant state transitions.
- The `scion logs <agent>` command is the primary interface for retrieving activity history.
- **Heartbeats:** Agents automatically send heartbeats to the Hub. A missing heartbeat for > 5 minutes indicates an `unresponsive` or `crashed` state.

### 1.2 Activity States
- **thinking:** Agent is processing information or calling an LLM.
- **executing:** Agent is running a local tool or shell command.
- **idle:** Agent is awaiting the next step in its internal loop.
- **blocked:** Agent is intentionally waiting for an external event (e.g., child agent completion, user input).
- **stalled:** Agent has not made forward progress for a significant period without being "blocked".

## 2. Error Handling and State Management

### 2.1 Stalled vs. Blocked
- **Blocked State:** MUST be explicitly signaled using `sciontool status blocked "<reason>"`. This prevents the system from misidentifying a legitimate wait as a failure.
- **Stalled Detection:** If an agent remains in `thinking` or `executing` for > 10 minutes without state change or tool output, it is marked as `stalled`.
- **Remediation:** Stalled agents should be inspected via `scion look` and restarted if necessary.

### 2.2 Terminal States
- **completed:** Task successfully finished.
- **failed:** Unrecoverable error encountered.
- **crashed:** Process terminated unexpectedly.

## 3. Security Protocols

### 3.1 Agent-to-Agent Communication
- All communication between agents MUST go through the Scion Hub via the `scion message` command.
- **Identity Propagation:** Agents inherit the identity and permissions of their owner/creator, restricted by the scope of the grove.
- **Encryption:** All message payloads are encrypted in transit via TLS 1.3.

### 3.2 Harness and Authentication
- Agents use named harness configurations (e.g., `gemini`, `vertex-ai`).
- API keys and OAuth tokens MUST be managed via the Hub's secure secret store and never committed to the repository.
- Use `scion start --harness-auth api-key` to propagate credentials securely.

### 3.3 Workspace Isolation
- Each agent runs in a containerized sandbox.
- Access to the host filesystem is restricted to the `/workspace` mount.
- Sensitive environment variables (e.g., `SCION_HUB_TOKEN`) are isolated per agent.
