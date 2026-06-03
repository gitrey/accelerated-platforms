# Veo Demo GKE Manifests

This directory contains the Kubernetes manifests for the Veo Gen Media Demo App.

## Components

- **workflow-api**: Go-based API that interfaces with ComfyUI.
- **veo-frontend**: React-based frontend for the demo.
- **ingress**: GCE Ingress for routing traffic.

## Deployment

To deploy the application, you can use the provided script:

```bash
./test/scripts/deploy-veo-demo.sh
```

Ensure you have the following environment variables set if you want to override defaults:

- `PROJECT_ID`: Your GCP Project ID (auto-detected if not set).
- `REGION`: Target region (default: us-central1).

## Configuration

Update `01-configmap.yaml` with the correct `COMFYUI_BASE_URL` for your environment.

## Workload Identity

The `workflow-api` uses a Kubernetes ServiceAccount `workflow-api-sa` which is bound to a GCP ServiceAccount via Workload Identity. Ensure the GCP ServiceAccount exists and has the necessary permissions (e.g., `roles/storage.objectAdmin` on the media bucket).
The Terraform in `terraform/features/veo-demo/` handles this provisioning.
