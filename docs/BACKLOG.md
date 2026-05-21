# Product Backlog

| ID | Priority | Status | Title | JIRA ID | Spec |
|----|----------|--------|-------|---------|------|
| F-0001 | P1 | Complete | H100 Gemma 3 27b Inference Expansion | TBD | [F-0001](specs/F-0001-h100-gemma-3-27b-inference-expansion.md) |
| F-0002 | P2 | Complete | Weather Monitoring in Top US Cities | TBD | [F-0002](specs/F-0002-weather-monitoring.md) |
| F-0003 | P3 | Complete | The Best Beachfront House in the World | TBD | [F-0003](specs/F-0003-best-house-in-the-world.md) |
| F-0004 | P1 | Complete | Detailed Documentation for CWS Image Pipeline (Milestone 7) | TBD | [F-0004](specs/F-0004-cws-image-pipeline-documentation.md) |
| F-0005 | P2 | Complete | Agentic Development and Operations with Scion Reference Guide | TBD | [F-0005](specs/F-0005-agentic-ops-reference-guide.md) |
| F-0006 | P1 | In Progress | Migration Framework: LangChain Agent to ADK 2.0 (Scion) | TBD | [F-0006](specs/F-0006-langchain-to-adk-migration.md) |
| F-0007 | P2 | Approved | Smart Ultrasonic Toothbrush for Dogs (CanineCare Pro) | TBD | [F-0007](specs/F-0007-smart-dog-toothbrush.md) |

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
| T-0018 | F-0006 | Create tool extraction and YAML definition guide | SWE-1 | In Progress |
| T-0019 | F-0006 | Implement PoC migration for Search agent | SWE-2 | In Progress |
| T-0020 | F-0007 | Create industrial design concepts for dog toothbrush | SWE-1 | Pending |
| T-0021 | F-0007 | Define hardware specs for ultrasonic motor and battery | SWE-2 | Pending |
| T-0022 | F-0007 | Draft initial schema for the companion mobile app | SWE-1 | Pending |
