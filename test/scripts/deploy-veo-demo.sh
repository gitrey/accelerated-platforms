#!/bin/bash
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

export PROJECT_ID=$(gcloud config get-value project)
export REGION=${REGION:-us-central1}
export AR_REPO=${AR_REPO:-veo-demo}

echo "Deploying Veo Gen Media Demo App to Project: $PROJECT_ID"

# 1. Build and Push Images
echo "Building workflow-api..."
gcloud builds submit projects/workflow-api \
    --config projects/workflow-api/cloudbuild.yaml \
    --substitutions _DESTINATION="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/workflow-api:latest" \
    --quiet

echo "Building veo-frontend..."
gcloud builds submit projects/veo-demo-app/frontend \
    --config projects/veo-demo-app/frontend/cloudbuild.yaml \
    --substitutions _DESTINATION="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/veo-frontend:latest" \
    --quiet

# 2. Apply Kubernetes Manifests
echo "Applying Kubernetes manifests..."

cd k8s/veo-demo/overlays/dev

# Update project-specific values and images via a temporary Kustomize patch
cat <<EOF > patch-project.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: veo-demo-config
  namespace: veo-demo
data:
  VEO_ASSETS_BUCKET: "${PROJECT_ID}-veo-media"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: workflow-api-sa
  namespace: veo-demo
  annotations:
    iam.gke.io/gcp-service-account: workflow-api-sa@${PROJECT_ID}.iam.gserviceaccount.com
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: workflow-api
  namespace: veo-demo
spec:
  template:
    spec:
      containers:
      - name: workflow-api
        image: "${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/workflow-api:latest"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: veo-frontend
  namespace: veo-demo
spec:
  template:
    spec:
      containers:
      - name: veo-frontend
        image: "${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/veo-frontend:latest"
EOF

# Build and Apply
kubectl apply -k .

# Cleanup temporary patch
rm patch-project.yaml
cd -

echo "Deployment complete."
echo "Access the app via the Ingress IP (this may take a few minutes to provision)."
kubectl get ingress -n veo-demo veo-demo-ingress
