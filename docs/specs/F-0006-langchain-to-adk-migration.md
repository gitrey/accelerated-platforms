# F-0006: Migration Framework: LangChain Agent to ADK 2.0 (Scion)

- **Type:** Enhancement
- **Status:** Complete
- **Priority:** P1
- **JIRA ID:** TBD

## Problem
Currently, several legacy agents are built using the LangChain framework. To leverage the full benefits of the Scion orchestration system—including containerized tool execution, cross-agent messaging via the Hub, and standardized operational monitoring—these agents need to be migrated to the ADK 2.0 (Scion) architecture.

## Requirements
1. **Tool Decoupling:** Extract LangChain tools and redefine them as independent Scion tools (YAML + Scripts).
2. **Skill Encapsulation:** Group related tools into Scion "Skills" for dynamic activation.
3. **State Migration:** Port LangChain memory logic to use the Scion Hub for persistent cross-session state.
4. **Agent Logic Porting:** Translate LangChain agent prompts and reasoning loops into Scion system instructions and harness configurations.
5. **Orchestration Update:** Replace LangChain's internal orchestration with Scion agent-to-agent messaging.

## Acceptance Criteria
<<<<<<< HEAD
- [ ] Comprehensive Migration Guide produced.
- [ ] Mapping table (LangChain vs. ADK 2.0) completed.
=======
- [x] Comprehensive Migration Guide produced (see [docs/LANGCHAIN_TOOL_MIGRATION.md](../LANGCHAIN_TOOL_MIGRATION.md)).
- [x] Mapping table (LangChain vs. ADK 2.0) completed (see [docs/LANGCHAIN_MIGRATION_PLAN.md](../LANGCHAIN_MIGRATION_PLAN.md)).
>>>>>>> feature/langchain-tool-migration-guide-v2
- [ ] Proof-of-concept (PoC) migration of a standard "Search & Calculate" agent.

## Out of Scope
- Migrating LangChain logic that relies on proprietary closed-source libraries.
- Physical infrastructure changes.

## Dependencies
- ADK 2.0 (Scion) core libraries and CLI access.
- Existing LangChain agent source code for analysis.
