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

PROJECT_ID=$(gcloud config get-value project)
REGION=${REGION:-us-central1}
AR_REPO=${AR_REPO:-veo-demo-repo}

echo "Deploying Veo Gen Media Demo App to Project: $PROJECT_ID"

# 1. Ensure Artifact Registry repository exists (optional step, usually done via Terraform)
# gcloud artifacts repositories create $AR_REPO --repository-format=docker --location=$REGION --quiet || true

# 2. Build and Push Images
echo "Building workflow-api..."
gcloud builds submit projects/workflow-api \
    --config projects/workflow-api/cloudbuild.yaml \
    --substitutions _DESTINATION="gcr.io/$PROJECT_ID/workflow-api:latest" \
    --quiet

echo "Building veo-frontend..."
gcloud builds submit projects/veo-frontend \
    --config projects/veo-frontend/cloudbuild.yaml \
    --substitutions _DESTINATION="gcr.io/$PROJECT_ID/veo-frontend:latest" \
    --quiet

# 3. Apply Kubernetes Manifests
echo "Applying Kubernetes manifests..."
# Note: Using sed to replace PROJECT_ID in manifests if necessary, 
# but manifests already use ${PROJECT_ID} which can be handled by envsubst if needed.
# For simplicity, we assume the user has envsubst or we use sed.

for f in k8s/veo-demo/*.yaml; do
    envsubst < "$f" | kubectl apply -f -
done

echo "Deployment complete."
echo "Access the app via the Ingress IP (this may take a few minutes to provision)."
kubectl get ingress -n veo-demo veo-demo-ingress
