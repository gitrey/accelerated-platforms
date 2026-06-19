# F-0009: Veo Gen Media Demo App

- **Type:** Feature
- **Status:** Approved
- **Priority:** P1
- **JIRA ID:** TBD

## Problem
Users need a user-friendly way to explore and demonstrate the capabilities of Google's Veo generative media models (Veo 2.0 and Veo 3.1) within the Accelerated Platforms environment. While the backend workflows exist in ComfyUI, there is no unified demo application that non-technical users can interact with to generate video from text or images.

## Requirements
1. **Model Support:** Support generation using both Veo 2.0 and Veo 3.1.
2. **Generation Modes:**
   - **Text-to-Video:** User enters a prompt, selects a model, and receives a generated video.
   - **Image-to-Video:** User uploads an image and an optional prompt to generate a video.
3. **Unified Interface:** A web-based frontend that allows users to:
   - Select the generation mode.
   - Configure model parameters (e.g., aspect ratio, duration for Veo 3.1).
   - View generation progress.
   - Play and download the resulting videos.
4. **Backend Integration:** Leverage the existing `workflow-api` (Go/Gin) to trigger ComfyUI workflows.
5. **Deployment:** Containerize the demo app and provide Kubernetes manifests for deployment on GKE.

## Acceptance Criteria
- [ ] React-based (or similar) frontend implemented with mode selection and media previews.
- [ ] `workflow-api` updated (if needed) to handle the specific Veo workflows.
- [ ] Integration with GCS for persistent video storage and retrieval.
- [ ] Demo app successfully deployed on GKE and accessible via a public/IAP-protected URL.
- [ ] Successfully generates a 6-second Veo 3.1 video from a text prompt via the UI.

## Out of Scope
- Real-time video editing or post-processing.
- Support for non-Google generative models in this specific app.

## Dependencies
- Running ComfyUI instance with `google_genmedia` custom nodes.
- `workflow-api` service configured to communicate with ComfyUI.
- GCS bucket for media assets.
