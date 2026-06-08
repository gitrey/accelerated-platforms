# F-0010: Veo Demo App GKE Deployment Automation

- **Type:** Enhancement
- **Status:** Approved
- **Priority:** P1
- **JIRA ID:** LOCAL

## Problem
Currently, the Veo Gen Media Demo App is deployed manually using scripts. To ensure consistency, speed, and reliability, we need to automate the build and deployment process using Cloud Build triggers (CI/CD).

## Requirements
1. **CI/CD Triggers:**
   - Create a Cloud Build trigger for the `workflow-api` backend.
   - Create a Cloud Build trigger for the `veo-frontend` frontend.
   - Triggers should be activated on pushes to the `scion/pm-agent` branch (or `main`).
2. **Automated Build:**
   - Build Docker images using Kaniko and push them to Artifact Registry.
   - Use the `veo-demo` repository in Artifact Registry.
3. **Automated Deployment:**
   - Deploy the new images to the GKE cluster in the `veo-demo` namespace.
   - Refactor existing Kubernetes manifests to use Kustomize or environment-specific handling.
   - Ensure environment variables are correctly substituted (e.g., `_REGION`, `_PROJECT_ID`).
4. **Security & Access:**
   - Automate the configuration of GCE Ingress and Identity-Aware Proxy (IAP) to ensure secure access.
5. **Health Monitoring:**
   - Implement automated health checks and smoke tests to verify the deployment.

## Technical Tasks
- **T-0034:** Create Cloud Build triggers for frontend and backend via Terraform.
- **T-0035:** Refactor GKE manifests to use Kustomize/Env Handling.
- **T-0036:** Implement automated deployment CD pipeline steps in `cloudbuild.yaml`.
- **T-0037:** Implement health check and smoke test script.
- **T-0038:** Configure IAP and Ingress automation via Terraform.

## Acceptance Criteria
- [x] Cloud Build triggers are provisioned in the GCP project.
- [x] Pushing to the branch automatically triggers a build and deployment.
- [x] Refactored manifests are used for deployment.
- [ ] Successfully deployed app is accessible and verified by smoke tests.
- [ ] IAP is correctly configured and enforced.
