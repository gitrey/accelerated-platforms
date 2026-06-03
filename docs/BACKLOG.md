# Product Backlog

| ID | Priority | Status | Title | JIRA ID | Spec |
|----|----------|--------|-------|---------|------|
| F-0001 | P1 | Complete | H100 Gemma 3 27b Inference Expansion | TBD | [F-0001](specs/F-0001-h100-gemma-3-27b-inference-expansion.md) |
| F-0002 | P2 | Complete | Weather Monitoring in Top US Cities | TBD | [F-0002](specs/F-0002-weather-monitoring.md) |
| F-0003 | P3 | Complete | The Best Beachfront House in the World | TBD | [F-0003](specs/F-0003-best-house-in-the-world.md) |
| F-0004 | P1 | Complete | Detailed Documentation for CWS Image Pipeline (Milestone 7) | TBD | [F-0004](specs/F-0004-cws-image-pipeline-documentation.md) |
| F-0005 | P2 | Complete | Agentic Development and Operations with Scion Reference Guide | TBD | [F-0005](specs/F-0005-agentic-ops-reference-guide.md) |
| F-0006 | P1 | Complete | Migration Framework: LangChain Agent to ADK 2.0 (Scion) | TBD | [F-0006](specs/F-0006-langchain-to-adk-migration.md) |
| F-0007 | P2 | Complete | Smart Ultrasonic Toothbrush for Dogs (CanineCare Pro) | TBD | [F-0007](specs/F-0007-smart-dog-toothbrush.md) |
| F-0008 | P2 | Complete | Google I/O Tracker Agent (ADK 2.0) | TBD | [F-0008](specs/F-0008-google-io-tracker-agent.md) |
| F-0009 | P1 | Approved | Veo Gen Media Demo App | TBD | [F-0009](specs/F-0009-veo-gen-media-demo-app.md) |

## Technical Tasks

| ID | Feature | Title | Assignee | Status |
|----|---------|-------|----------|--------|
| T-0001 | F-0001 | Create Async Inference manifests for H100 Gemma 3 27b | SWE-2 | Completed |
| T-0002 | F-0001 | Create Offline Batch Inference manifests for H100 Gemma 3 27b | SWE-2 | Completed |
| T-0003 | F-0001 | Update configuration scripts (configure_vllm.sh, configure_worker.sh) | SWE-2 | Completed |
| T-0004 | F-0001 | Update documentation for Async and Batch Inference | SWE-2 | Completed |
| T-0005 | F-0001 | Verify and Test the new inference patterns | SWE-Test | Completed |
| T-0006 | F-0001 | Fix Offline Batch Inference resource patch (limit to 1 GPU) | TPM | Completed |
| T-0007 | F-0002 | Retrieve weather for top 5 US cities | PM-Agent | Completed |
| T-0008 | F-0002 | Document results in PROGRESS_WEATHER.md | PM-Agent | Completed |
| T-0009 | F-0003 | Create conceptual architectural design doc for the Beach House | SWE-1 | Completed |
| T-0010 | F-0004 | Create docs/platforms/cws/image-pipeline.md with architecture overview | DOC-Agent | Completed |
| T-0011 | F-0004 | Document existing CWS image templates (Dockerfiles/Config) | DOC-Agent | Completed |
| T-0012 | F-0004 | Create extension guide for custom CWS images | DOC-Agent | Completed |
| T-0013 | F-0004 | Integrate new docs with reference-implementation.md | DOC-Agent | Completed |
| T-0014 | F-0005 | Create initial outline for the Agentic Ops Reference Guide | DOC-Agent | Completed |
| T-0015 | F-0005 | Draft content for "Agent Development Lifecycle" section | DOC-Agent | Completed |
| T-0016 | F-0005 | Define operational monitoring and security patterns | TPM | Completed |
| T-0017 | F-0006 | Produce LangChain to ADK 2.0 Mapping Table | PM-Agent | Completed |
| T-0018 | F-0006 | Create tool extraction and YAML definition guide | SWE-1 | Completed |
| T-0019 | F-0006 | Implement PoC migration for Search agent | SWE-2 | Completed |
| T-0020 | F-0007 | Create industrial design concepts for dog toothbrush | SWE-1 | Completed |
| T-0021 | F-0007 | Define hardware specs for ultrasonic motor and battery | SWE-2 | Completed |
| T-0022 | F-0007 | Draft initial schema for the companion mobile app | SWE-1 | Completed |
| T-0023 | F-0007 | Perform BOM sourcing research and cost estimation | TPM | Completed |
| T-0024 | F-0007 | Shortlist contract manufacturing partners for waterproof electronics | TPM | Completed |
| T-0025 | F-0007 | Define DFM requirements for silicone overmolding | SWE-2 | Completed |
| T-0026 | F-0008 | Define Google I/O Tracker Agent persona and instructions | PM-Agent | Completed |
| T-0027 | F-0008 | Implement web-monitoring and summarization tools | SWE-1 | Completed |
| T-0028 | F-0008 | Set up persistent local storage for announcements | SWE-2 | Completed |
| T-0029 | F-0008 | Configure notification logic and broadcast settings | TPM | Completed |
| T-0030 | F-0009 | Design and implement React frontend for Veo Demo App | SWE-1 | Completed |
| T-0031 | F-0009 | Update workflow-api to support Veo generation endpoints | SWE-2 | Completed |
| T-0032 | F-0009 | Containerize demo app and create Kubernetes manifests | DevOps | Completed |

| T-0033 | F-0009 | Perform end-to-end testing of generation workflows | SWE-Test | In Progress |
