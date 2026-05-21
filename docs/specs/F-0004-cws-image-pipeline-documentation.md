# F-0004: Detailed Documentation for CWS Image Pipeline (Milestone 7)

- **Type:** Enhancement
- **Status:** Approved
- **Priority:** P1
- **JIRA ID:** TBD (Pending PO creation)

## Problem
The Cloud Workstations (CWS) Image Pipeline is a critical component of the platform but currently lacks detailed documentation. To support Milestone 7 and ensure maintainability, we need comprehensive guides covering its architecture, usage, and extension points.

## Requirements
1. **Architecture Overview:** Create a dedicated document `docs/platforms/cws/image-pipeline.md` detailing how the pipeline uses Cloud Build, Artifact Registry, and Cloud Scheduler.
2. **Image Template Documentation:** Document the purpose and configuration of existing image templates:
   - `antigravity-crd`
   - `code-oss`
   - `comfyui` (CPU, Models, NVIDIA)
3. **Usage Guides:** Provide step-by-step instructions for:
   - Applying and destroying the pipeline using the provided scripts.
   - Configuring Git tokens and repository settings.
4. **Extension Guide:** Document the process for adding a new custom image to the pipeline.
5. **Update Reference Implementation:** Link the new documentation from `docs/platforms/cws/reference-implementation.md`.

## Acceptance Criteria
- [ ] New file `docs/platforms/cws/image-pipeline.md` created with architectural details.
- [ ] Existing image templates documented with their respective Dockerfiles and configuration.
- [ ] Guide for adding new images completed.
- [ ] Integration with `reference-implementation.md` verified.

## Out of Scope
- Documentation for the GKE platforms (unless directly impacting CWS).
- Literal implementation changes to the pipeline code.

## Dependencies
- Completion of the current Image Pipeline implementation.
