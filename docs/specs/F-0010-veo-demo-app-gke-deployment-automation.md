# F-0010: Veo Demo App GKE Deployment Automation

- **Type:** Enhancement
- **Status:** Approved
- **Priority:** P1
- **JIRA ID:** TBD

## Problem
The Veo Gen Media Demo App (F-0009) currently requires manual steps for building container images and deploying Kubernetes manifests. To ensure consistency, scalability, and faster iteration, this process must be automated using CI/CD pipelines.

## Requirements
1. **Automated Builds:** Create Cloud Build triggers for both the React frontend and the Go workflow-api.
2. **Infrastructure as Code:** Utilize Terraform to manage necessary GKE node pools, GCS buckets, and Artifact Registry repositories.
3. **Configuration Management:** Refactor existing Kubernetes manifests to use Kustomize or Helm for environment-specific configurations (e.g., dev, staging, prod).
4. **Automated Deployment:** Set up a CD pipeline that automatically deploys the latest images to GKE upon successful completion of the CI build.
5. **Security & Access:** Automate the configuration of GCE Ingress and Identity-Aware Proxy (IAP) to ensure secure access to the demo application.
6. **Health Monitoring:** Implement automated health checks and smoke tests to verify the deployment.

## Acceptance Criteria
- [ ] Cloud Build triggers are active and successfully build/push images to Artifact Registry.
- [ ] Terraform plan/apply successfully provisions all required infrastructure.
- [ ] Automated deployment pipeline successfully updates GKE workloads without manual intervention.
- [ ] IAP is correctly configured and enforced via automated manifests.
- [ ] Smoke tests pass after an automated deployment.

## Out of Scope
- Support for non-GKE deployment targets.
- Multi-region deployment automation (initially single-region).

## Dependencies
- Existing F-0009 application code (frontend and workflow-api).
- GCP project with billing enabled and necessary APIs active.
- Access to GitHub repository for Cloud Build integration.
