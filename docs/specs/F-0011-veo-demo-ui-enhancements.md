# F-0011: Veo Demo UI Enhancements for Backend Visibility

- **Type:** Enhancement
- **Status:** Approved
- **Priority:** P2
- **JIRA ID:** LOCAL

## Problem
While the Veo Demo App is functional, the integration with the backend is somewhat opaque to the user. The real-time progress is shown as a raw log, and there is no indication of backend health or connectivity before starting a generation. Providing more visibility into the "Pipeline" will improve user experience and debugging.

## Requirements
1. **Backend Health Indicator:** Add a status chip in the header that pings the backend `/health` endpoint (or a new `/api/v1/health` endpoint) to confirm connectivity.
2. **Visual Generation Pipeline:** Replace or augment the "Activity Log" with a visual stepper showing the high-level stages of generation:
   - **Step 1:** Uploading/Preparing (if Image-to-Video)
   - **Step 2:** Queued at Backend
   - **Step 3:** Processing (ComfyUI Workflow)
   - **Step 4:** Finalizing (GCS Storage & URL Generation)
3. **Swagger Integration:** Add a "Developer API" link in the footer or settings that points to the Swagger UI hosted on the backend.
4. **Error Traceability:** Ensure backend error codes or request IDs (if implemented) are visible in the UI for easier troubleshooting.

## Acceptance Criteria
- [ ] Header shows "Backend: Online" (green) or "Backend: Offline" (red) based on a periodic health check.
- [ ] A generation attempt triggers a visual progress stepper that updates based on SSE events.
- [ ] A link to `/api/swagger/index.html` is present in the UI.
- [ ] UI is responsive and maintains its modern aesthetic.

## Out of Scope
- Detailed logs of ComfyUI internal node execution (keep it high-level).
- Authentication logic changes (assume IAP is handled at Ingress).

## Dependencies
- `workflow-api` must expose a health check endpoint accessible via the Ingress.
- `workflow-api` SSE events should include enough metadata to drive the stepper.
