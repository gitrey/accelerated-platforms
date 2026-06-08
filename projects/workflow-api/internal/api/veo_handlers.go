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
	"context"
	"fmt"
	"io"
	"net/http"
	"time"

	"cloud.google.com/go/storage"
	"comfyui-api-service/comfyui"
	"github.com/gin-gonic/gin"
)

// VeoGenerationRequest represents the base parameters for Veo generation.
type VeoGenerationRequest struct {
	Prompt             string `json:"prompt" binding:"required"`
	AspectRatio        string `json:"aspect_ratio" default:"16:9"`
	DurationSeconds    int    `json:"duration_seconds" default:"8"`
	CompressionQuality string `json:"compression_quality" default:"optimized"`
	PersonGeneration   string `json:"person_generation" default:"allow_adult"`
	EnhancePrompt      bool   `json:"enhance_prompt" default:"true"`
	SampleCount        int    `json:"sample_count" default:"1"`
	NegativePrompt     string `json:"negative_prompt"`
	Seed               int    `json:"seed" default:"0"`
}

// Veo3GenerationRequest includes Veo 3.1 specific fields.
type Veo3GenerationRequest struct {
	VeoGenerationRequest
	Model            string `json:"model" default:"VEO_3_1"`
	OutputResolution string `json:"output_resolution" default:"720p"`
	GenerateAudio    bool   `json:"generate_audio" default:"true"`
}

// VeoImageToVideoRequest includes parameters for image-to-video generation.
type VeoImageToVideoRequest struct {
	VeoGenerationRequest
	ImageGcsURI     string `json:"image_gcs_uri"`
	LastFrameGcsURI string `json:"last_frame_gcs_uri"`
}

// Veo3ImageToVideoRequest includes parameters for Veo 3.1 image-to-video generation.
type Veo3ImageToVideoRequest struct {
	Veo3GenerationRequest
	ImageGcsURI     string `json:"image_gcs_uri"`
	LastFrameGcsURI string `json:"last_frame_gcs_uri"`
}

// TriggerVeo2TextToVideo godoc
// @Summary      Trigger Veo 2.0 Text-to-Video
// @Description  Starts a Veo 2.0 text-to-video generation workflow.
// @Tags         Veo
// @Accept       json
// @Produce      text/event-stream
// @Param        request body VeoGenerationRequest true "Generation parameters"
// @Success      200 {string} string "SSE stream with progress and results"
// @Router       /veo2/text-to-video [post]
func (h *APIHandler) TriggerVeo2TextToVideo(c *gin.Context) {
	var req VeoGenerationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid request body", Details: err.Error()})
		return
	}

	workflow := h.buildVeo2TextToVideoWorkflow(req)
	h.streamProgress(c, workflow)
}

// TriggerVeo3TextToVideo godoc
// @Summary      Trigger Veo 3.1 Text-to-Video
// @Description  Starts a Veo 3.1 text-to-video generation workflow.
// @Tags         Veo
// @Accept       json
// @Produce      text/event-stream
// @Param        request body Veo3GenerationRequest true "Generation parameters"
// @Success      200 {string} string "SSE stream with progress and results"
// @Router       /veo3/text-to-video [post]
func (h *APIHandler) TriggerVeo3TextToVideo(c *gin.Context) {
	var req Veo3GenerationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid request body", Details: err.Error()})
		return
	}

	workflow := h.buildVeo3TextToVideoWorkflow(req)
	h.streamProgress(c, workflow)
}

// buildVeo2TextToVideoWorkflow constructs the ComfyUI workflow for Veo 2.0 Text-to-Video.
func (h *APIHandler) buildVeo2TextToVideoWorkflow(req VeoGenerationRequest) map[string]interface{} {
	outputGcsURI := ""
	if h.Cfg.VeoAssetsBucket != "" {
		outputGcsURI = fmt.Sprintf("gs://%s/outputs/veo2", h.Cfg.VeoAssetsBucket)
	}
	return map[string]interface{}{
		"3": map[string]interface{}{
			"inputs": map[string]interface{}{
				"autoplay":               true,
				"mute":                   true,
				"loop":                   true,
				"save_video":             true,
				"save_video_file_prefix": "veo_video",
				"video_paths":            []interface{}{"5", 0},
			},
			"class_type": "VeoVideoSaveAndPreview",
		},
		"5": map[string]interface{}{
			"inputs": map[string]interface{}{
				"prompt":              req.Prompt,
				"aspect_ratio":        req.AspectRatio,
				"compression_quality": req.CompressionQuality,
				"person_generation":   req.PersonGeneration,
				"duration_seconds":    req.DurationSeconds,
				"enhance_prompt":      req.EnhancePrompt,
				"sample_count":        req.SampleCount,
				"negative_prompt":     req.NegativePrompt,
				"seed":                req.Seed,
				"output_gcs_uri":      outputGcsURI,
			},
			"class_type": "Veo2TextToVideoNode",
		},
	}
}

// buildVeo3TextToVideoWorkflow constructs the ComfyUI workflow for Veo 3.1 Text-to-Video.
func (h *APIHandler) buildVeo3TextToVideoWorkflow(req Veo3GenerationRequest) map[string]interface{} {
	outputGcsURI := ""
	if h.Cfg.VeoAssetsBucket != "" {
		outputGcsURI = fmt.Sprintf("gs://%s/outputs/veo3", h.Cfg.VeoAssetsBucket)
	}
	return map[string]interface{}{
		"3": map[string]interface{}{
			"inputs": map[string]interface{}{
				"autoplay":               true,
				"mute":                   true,
				"loop":                   true,
				"save_video":             true,
				"save_video_file_prefix": "veo_video",
				"video_paths":            []interface{}{"6", 0},
			},
			"class_type": "VeoVideoSaveAndPreview",
		},
		"6": map[string]interface{}{
			"inputs": map[string]interface{}{
				"model":               req.Model,
				"prompt":              req.Prompt,
				"aspect_ratio":        req.AspectRatio,
				"output_resolution":   req.OutputResolution,
				"compression_quality": req.CompressionQuality,
				"person_generation":   req.PersonGeneration,
				"duration_seconds":    req.DurationSeconds,
				"generate_audio":      req.GenerateAudio,
				"sample_count":        req.SampleCount,
				"negative_prompt":     req.NegativePrompt,
				"seed":                req.Seed,
				"output_gcs_uri":      outputGcsURI,
			},
			"class_type": "Veo3TextToVideoNode",
		},
	}
}

// streamProgress queues the prompt and streams progress via SSE.
func (h *APIHandler) streamProgress(c *gin.Context, workflow map[string]interface{}) {
	resp, err := h.ComfyClient.QueuePrompt(workflow)
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Failed to queue prompt", Details: err.Error()})
		return
	}

	promptID := resp.PromptID
	progressChan := make(chan comfyui.ProgressData)
	errChan := make(chan error)

	go func() {
		errChan <- h.ComfyClient.TrackProgress(promptID, progressChan)
	}()

	c.Header("Content-Type", "text/event-stream")
	c.Header("Cache-Control", "no-cache")
	c.Header("Connection", "keep-alive")
	c.Header("Transfer-Encoding", "chunked")

	c.Stream(func(w io.Writer) bool {
		select {
		case progress := <-progressChan:
			c.SSEvent("progress", progress)
			return true
		case err := <-errChan:
			if err != nil {
				c.SSEvent("error", err.Error())
			} else {
				// Success! Get results
				history, err := h.ComfyClient.GetHistory(promptID)
				if err != nil {
					c.SSEvent("error", "Failed to retrieve results: "+err.Error())
				} else {
					c.SSEvent("result", history[promptID])
				}
			}
			return false
		case <-c.Request.Context().Done():
			return false
		}
	})
}

// UploadToGCS uploads a file to GCS and returns the URI.
func (h *APIHandler) UploadToGCS(ctx context.Context, bucketName, objectName string, content io.Reader) (string, error) {
	client, err := storage.NewClient(ctx)
	if err != nil {
		return "", fmt.Errorf("failed to create GCS client: %w", err)
	}
	defer client.Close()

	bucket := client.Bucket(bucketName)
	obj := bucket.Object(objectName)
	wc := obj.NewWriter(ctx)
	if _, err := io.Copy(wc, content); err != nil {
		return "", fmt.Errorf("failed to upload to GCS: %w", err)
	}
	if err := wc.Close(); err != nil {
		return "", fmt.Errorf("failed to close GCS writer: %w", err)
	}

	return fmt.Sprintf("gs://%s/%s", bucketName, objectName), nil
}

// TriggerVeo2ImageToVideo godoc
// @Summary      Trigger Veo 2.0 Image-to-Video
// @Description  Starts a Veo 2.0 image-to-video generation workflow.
// @Tags         Veo
// @Accept       json
// @Produce      text/event-stream
// @Param        request body VeoImageToVideoRequest true "Generation parameters"
// @Success      200 {string} string "SSE stream with progress and results"
// @Router       /veo2/image-to-video [post]
func (h *APIHandler) TriggerVeo2ImageToVideo(c *gin.Context) {
	var req VeoImageToVideoRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid request body", Details: err.Error()})
		return
	}

	workflow := h.buildVeo2ImageToVideoWorkflow(req)
	h.streamProgress(c, workflow)
}

// TriggerVeo3ImageToVideo godoc
// @Summary      Trigger Veo 3.1 Image-to-Video
// @Description  Starts a Veo 3.1 image-to-video generation workflow.
// @Tags         Veo
// @Accept       json
// @Produce      text/event-stream
// @Param        request body Veo3ImageToVideoRequest true "Generation parameters"
// @Success      200 {string} string "SSE stream with progress and results"
// @Router       /veo3/image-to-video [post]
func (h *APIHandler) TriggerVeo3ImageToVideo(c *gin.Context) {
	var req Veo3ImageToVideoRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid request body", Details: err.Error()})
		return
	}

	workflow := h.buildVeo3ImageToVideoWorkflow(req)
	h.streamProgress(c, workflow)
}

// buildVeo2ImageToVideoWorkflow constructs the ComfyUI workflow for Veo 2.0 Image-to-Video.
func (h *APIHandler) buildVeo2ImageToVideoWorkflow(req VeoImageToVideoRequest) map[string]interface{} {
	outputGcsURI := ""
	if h.Cfg.VeoAssetsBucket != "" {
		outputGcsURI = fmt.Sprintf("gs://%s/outputs/veo2", h.Cfg.VeoAssetsBucket)
	}
	return map[string]interface{}{
		"3": map[string]interface{}{
			"inputs": map[string]interface{}{
				"autoplay":               true,
				"mute":                   true,
				"loop":                   true,
				"save_video":             true,
				"save_video_file_prefix": "veo_video",
				"video_paths":            []interface{}{"5", 0},
			},
			"class_type": "VeoVideoSaveAndPreview",
		},
		"5": map[string]interface{}{
			"inputs": map[string]interface{}{
				"gcsuri":              req.ImageGcsURI,
				"prompt":              req.Prompt,
				"aspect_ratio":        req.AspectRatio,
				"compression_quality": req.CompressionQuality,
				"person_generation":   req.PersonGeneration,
				"duration_seconds":    req.DurationSeconds,
				"enhance_prompt":      req.EnhancePrompt,
				"sample_count":        req.SampleCount,
				"last_frame_gcsuri":   req.LastFrameGcsURI,
				"negative_prompt":     req.NegativePrompt,
				"seed":                req.Seed,
				"output_gcs_uri":      outputGcsURI,
			},
			"class_type": "Veo2GcsUriImageToVideoNode",
		},
	}
}

// buildVeo3ImageToVideoWorkflow constructs the ComfyUI workflow for Veo 3.1 Image-to-Video.
func (h *APIHandler) buildVeo3ImageToVideoWorkflow(req Veo3ImageToVideoRequest) map[string]interface{} {
	outputGcsURI := ""
	if h.Cfg.VeoAssetsBucket != "" {
		outputGcsURI = fmt.Sprintf("gs://%s/outputs/veo3", h.Cfg.VeoAssetsBucket)
	}
	return map[string]interface{}{
		"4": map[string]interface{}{
			"inputs": map[string]interface{}{
				"autoplay":               true,
				"mute":                   true,
				"loop":                   true,
				"save_video":             true,
				"save_video_file_prefix": "veo_video",
				"video_paths":            []interface{}{"3", 0},
			},
			"class_type": "VeoVideoSaveAndPreview",
		},
		"3": map[string]interface{}{
			"inputs": map[string]interface{}{
				"model":               req.Model,
				"gcsuri":              req.ImageGcsURI,
				"prompt":              req.Prompt,
				"aspect_ratio":        req.AspectRatio,
				"output_resolution":   req.OutputResolution,
				"compression_quality": req.CompressionQuality,
				"person_generation":   req.PersonGeneration,
				"duration_seconds":    req.DurationSeconds,
				"generate_audio":      req.GenerateAudio,
				"sample_count":        req.SampleCount,
				"last_frame_gcsuri":   req.LastFrameGcsURI,
				"negative_prompt":     req.NegativePrompt,
				"seed":                req.Seed,
				"output_gcs_uri":      outputGcsURI,
			},
			"class_type": "Veo3GcsUriImageToVideoNode",
		},
	}
}

// VeoUploadResponse represents the response after uploading to GCS.
type VeoUploadResponse struct {
	GcsURI string `json:"gcs_uri"`
}

// TriggerVeoUpload godoc
// @Summary      Upload media for Veo
// @Description  Uploads an image or video to GCS for use with Veo.
// @Tags         Veo
// @Accept       multipart/form-data
// @Produce      json
// @Param        file formData file true "Media file to upload"
// @Success      200 {object} VeoUploadResponse
// @Router       /veo/upload [post]
func (h *APIHandler) TriggerVeoUpload(c *gin.Context) {
	file, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "No file uploaded"})
		return
	}

	f, err := file.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Failed to open file", Details: err.Error()})
		return
	}
	defer f.Close()

	// Assuming a bucket name is provided via environment or config.
	bucketName := h.Cfg.VeoAssetsBucket

	objectName := fmt.Sprintf("uploads/%d_%s", time.Now().Unix(), file.Filename)
	uri, err := h.UploadToGCS(c.Request.Context(), bucketName, objectName, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Failed to upload to GCS", Details: err.Error()})
		return
	}

	c.JSON(http.StatusOK, VeoUploadResponse{GcsURI: uri})
}
