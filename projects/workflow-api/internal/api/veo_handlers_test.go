// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package api

import (
	"testing"

	"comfyui-api-service/internal/config"
	"github.com/stretchr/testify/assert"
)

func TestBuildVeo2TextToVideoWorkflow(t *testing.T) {
	h := &APIHandler{
		Cfg: &config.Config{VeoAssetsBucket: "test-bucket"},
	}

	req := VeoGenerationRequest{
		Prompt:          "a test prompt",
		AspectRatio:     "16:9",
		DurationSeconds: 5,
		Seed:            12345,
	}

	workflow := h.buildVeo2TextToVideoWorkflow(req)

	assert.NotNil(t, workflow)
	assert.Contains(t, workflow, "5")
	node5 := workflow["5"].(map[string]interface{})
	assert.Equal(t, "Veo2TextToVideoNode", node5["class_type"])
	
	inputs := node5["inputs"].(map[string]interface{})
	assert.Equal(t, "a test prompt", inputs["prompt"])
	assert.Equal(t, 12345, inputs["seed"])
	assert.Equal(t, "gs://test-bucket/outputs/veo2", inputs["output_gcs_uri"])
}

func TestBuildVeo3TextToVideoWorkflow(t *testing.T) {
	h := &APIHandler{
		Cfg: &config.Config{VeoAssetsBucket: "test-bucket"},
	}

	req := Veo3GenerationRequest{
		VeoGenerationRequest: VeoGenerationRequest{
			Prompt: "veo3 test",
			Seed:   67890,
		},
		Model: "VEO_3_1",
	}

	workflow := h.buildVeo3TextToVideoWorkflow(req)

	assert.NotNil(t, workflow)
	assert.Contains(t, workflow, "6")
	node6 := workflow["6"].(map[string]interface{})
	assert.Equal(t, "Veo3TextToVideoNode", node6["class_type"])
	
	inputs := node6["inputs"].(map[string]interface{})
	assert.Equal(t, "veo3 test", inputs["prompt"])
	assert.Equal(t, "VEO_3_1", inputs["model"])
	assert.Equal(t, "gs://test-bucket/outputs/veo3", inputs["output_gcs_uri"])
}
