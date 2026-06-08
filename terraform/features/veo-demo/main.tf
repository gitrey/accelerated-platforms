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

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The GKE cluster name"
  type        = string
  default     = "main-cluster"
}

variable "cluster_location" {
  description = "The GKE cluster location"
  type        = string
  default     = "us-central1"
}

variable "github_owner" {
  description = "The GitHub owner of the repository"
  type        = string
  default     = "GoogleCloudPlatform"
}

variable "github_repo_name" {
  description = "The GitHub repository name"
  type        = string
  default     = "accelerated-platforms"
}

resource "google_storage_bucket" "veo_media" {
  name                        = "${var.project_id}-veo-media"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_artifact_registry_repository" "veo_demo" {
  location      = var.region
  repository_id = "veo-demo"
  description   = "Docker repository for Veo Gen Media Demo App"
  format        = "DOCKER"
}

resource "google_service_account" "workflow_api" {
  account_id   = "workflow-api-sa"
  display_name = "Workflow API Service Account"
}

resource "google_storage_bucket_iam_member" "workflow_api_gcs_admin" {
  bucket = google_storage_bucket.veo_media.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.workflow_api.email}"
}

# Workload Identity binding
resource "google_service_account_iam_member" "workflow_api_workload_identity" {
  service_account_id = google_service_account.workflow_api.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[veo-demo/workflow-api-sa]"
}

resource "google_project_service" "cloudbuild" {
  project                    = var.project_id
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = true
}

resource "google_cloudbuild_trigger" "workflow_api" {
  project  = var.project_id
  name     = "veo-workflow-api-trigger"
  location = var.region

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = "^main$"
    }
  }

  included_files = ["projects/workflow-api/**", "k8s/veo-demo/**"]
  filename       = "projects/workflow-api/cloudbuild.yaml"

  substitutions = {
    _REGION           = var.region
    _AR_REPO          = google_artifact_registry_repository.veo_demo.name
    _CLUSTER_NAME     = var.cluster_name
    _CLUSTER_LOCATION = var.cluster_location
  }

  depends_on = [google_project_service.cloudbuild]
}

resource "google_cloudbuild_trigger" "veo_frontend" {
  project  = var.project_id
  name     = "veo-frontend-trigger"
  location = var.region

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = "^main$"
    }
  }

  included_files = ["projects/veo-demo-app/frontend/**", "k8s/veo-demo/**"]
  filename       = "projects/veo-demo-app/frontend/cloudbuild.yaml"

  substitutions = {
    _REGION           = var.region
    _AR_REPO          = google_artifact_registry_repository.veo_demo.name
    _CLUSTER_NAME     = var.cluster_name
    _CLUSTER_LOCATION = var.cluster_location
  }

  depends_on = [google_project_service.cloudbuild]
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_iam_member" "cloudbuild_gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

output "veo_media_bucket" {
  value = google_storage_bucket.veo_media.name
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.veo_demo.name
}

# IAP IAM policy for access
resource "google_iap_web_iam_member" "iap_access" {
  project = var.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member  = "group:accelerated-platforms-users@google.com" # Example group
}
