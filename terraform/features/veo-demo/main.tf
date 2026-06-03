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

output "veo_media_bucket" {
  value = google_storage_bucket.veo_media.name
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.veo_demo.name
}
