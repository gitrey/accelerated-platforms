# F-0012: Veo 3.1 Latest Features Demo (Reference-to-Video)

- **Type:** Feature
- **Status:** Approved
- **Priority:** P1
- **JIRA ID:** LOCAL

## Problem
The current Veo Demo App only supports Text-to-Video and single Image-to-Video. Google Veo 3.1 introduces powerful new capabilities like **Reference-to-Video**, which allows generating videos based on one or more reference images (style, subject, etc.). Users need a way to demo and explore these latest features in the UI.

## Requirements
1. **Backend Support for Reference-to-Video:**
   - Implement `/api/v1/veo/veo3/reference-to-video` endpoint in `workflow-api`.
   - Update `APIHandler` to build the `Veo3ReferenceToVideo` ComfyUI workflow.
   - Handle multiple image GCS URIs in the request.
2. **Multi-Image Upload UI:**
   - Update the frontend to allow uploading and managing up to 3 reference images.
   - Provide visual feedback for each uploaded image.
3. **Reference-to-Video Mode:**
   - Add a new "Reference-to-Video" mode in the generation mode selector.
   - Ensure the UI correctly maps inputs to the new backend endpoint.
4. **Parameter Updates:**
   - Support new Veo 3.1 parameters if any (e.g., resolution, audio flags are already there, but ensure they work with Reference-to-Video).

## Acceptance Criteria
- [ ] Backend endpoint `/api/v1/veo/veo3/reference-to-video` is functional and correctly triggers the ComfyUI node.
- [ ] Frontend allows uploading 3 images and previewing them.
- [ ] Users can successfully generate a video using the Reference-to-Video mode.
- [ ] The visual progress stepper correctly tracks the Reference-to-Video pipeline.

## Out of Scope
- Support for Veo 3.1 Reference-to-Video for non-GCP projects.
- Video-to-Video features (this can be a future feature).

## Dependencies
- `workflow-api` updated with new handler.
- ComfyUI instance with `Veo3ReferenceToVideo` node available.
