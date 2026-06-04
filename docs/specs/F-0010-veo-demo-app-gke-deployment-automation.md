# F-0010: Veo Demo App GKE Deployment Automation

- **Type:** Feature
- **Status:** Approved
- **Priority:** P1
- **JIRA ID:** TBD

## Problem
Currently, the Veo Gen Media Demo App is deployed manually using scripts. To ensure consistency, speed, and reliability, we need to automate the build and deployment process using Cloud Build triggers (CI/CD).

## Requirements
1. **CI/CD Triggers:**
   - Create a Cloud Build trigger for the `workflow-api` backend.
   - Create a Cloud Build trigger for the `veo-frontend` frontend.
   - Triggers should be activated on pushes to the `main` branch.
2. **Automated Build:**
   - Build Docker images using Kaniko and push them to Artifact Registry.
   - Use the `veo-demo` repository in Artifact Registry.
3. **Automated Deployment:**
   - Deploy the new images to the GKE cluster in the `veo-demo` namespace.
   - Use `kubectl apply` or `gcloud deploy` (Cloud Deploy) if applicable. For this task, we will use `kubectl` within Cloud Build.
   - Ensure environment variables are correctly substituted.
4. **Environment Handling:**
   - Use project-level substitutions for `_REGION`, `_CLUSTER_NAME`, and `_CLUSTER_LOCATION`.

## Technical Tasks
- **T-0034:** Create Cloud Build triggers for frontend and backend via Terraform.
- **T-0036:** Implement automated deployment CD pipeline steps in `cloudbuild.yaml`.

## Acceptance Criteria
- [ ] Cloud Build triggers are provisioned in the GCP project.
- [ ] Pushing to `main` automatically triggers a build and deployment.
- [ ] Successfully deployed app is accessible after an automated run.
