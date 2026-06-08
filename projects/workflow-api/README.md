# Workflow API

This service provides a REST API to interface with ComfyUI workflows, specifically optimized for generative media models like Google Veo.

## Features

- **Queue Prompts:** Submit arbitrary ComfyUI workflows.
- **History & Results:** Retrieve execution status and generated assets.
- **Veo Support:** Dedicated endpoints for Veo 2.0 and Veo 3.1 text-to-video and image-to-video.
- **Progress Tracking:** Stream real-time generation progress via Server-Sent Events (SSE). Supports concurrent requests with unique ClientIDs.
- **GCS Integration:** Upload media to GCS and trigger workflows that use GCS URIs.
- **Health Check:** Standardized health check endpoint at `/api/v1/health`.

## Veo Endpoints

### Upload Media
- **POST** `/api/v1/veo/upload`
  - Uploads an image/video to GCS.
  - Returns the `gcs_uri` for use in subsequent generation requests.

### Veo 2.0 Generation
- **POST** `/api/v1/veo/veo2/text-to-video`
- **POST** `/api/v1/veo/veo2/image-to-video`

### Veo 3.1 Generation
- **POST** `/api/v1/veo/veo3/text-to-video`
- **POST** `/api/v1/veo/veo3/image-to-video`

All Veo generation endpoints support streaming progress via SSE.

## Configuration

The service is configured via environment variables:

- `COMFYUI_BASE_URL`: URL of the ComfyUI backend (default: `http://127.0.0.1:8188`).
- `VEO_ASSETS_BUCKET`: GCS bucket for uploading/storing Veo media assets.
- `SERVER_PORT`: Port the API server listens on (default: `8080`).
- `GIN_MODE`: `debug` or `release`.

## Getting Started

1. Install dependencies: `go mod download`
2. Run the server: `go run cmd/server/main.go`
3. Access Swagger UI: `http://localhost:8080/swagger/index.html`

## Monitoring

- **Health Check:** `GET /api/v1/health` - Returns `{"status": "UP"}` if the service is running.
