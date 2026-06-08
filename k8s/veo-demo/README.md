# Veo Demo GKE Manifests

This directory contains the Kubernetes manifests for the Veo Gen Media Demo App.

## Components

- **workflow-api**: Go-based API that interfaces with ComfyUI.
- **veo-frontend**: React-based frontend for the demo.
- **ingress**: GCE Ingress for routing traffic.

## Structure

- **base/**: Contains the core Kubernetes manifests with placeholder values.
- **overlays/dev/**: Contains development-specific overrides and patches.

## Deployment

To deploy the application, you can use the provided script which uses Kustomize:

```bash
./test/scripts/deploy-veo-demo.sh
```

Alternatively, you can manually build and apply using Kustomize:

```bash
kubectl apply -k k8s/veo-demo/overlays/dev
```

## Configuration

Update `base/configmap.yaml` or use an overlay to set the correct `COMFYUI_BASE_URL` for your environment.

## Workload Identity

The `workflow-api` uses a Kubernetes ServiceAccount `workflow-api-sa` which is bound to a GCP ServiceAccount via Workload Identity. Ensure the GCP ServiceAccount exists and has the necessary permissions (e.g., `roles/storage.objectAdmin` on the media bucket).
The Terraform in `terraform/features/veo-demo/` handles this provisioning.
