import axios from 'axios';

const api = axios.create({
  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
});

export interface VeoGenerationRequest {
  prompt: string;
  aspect_ratio?: string;
  duration_seconds?: number;
  compression_quality?: string;
  person_generation?: string;
  enhance_prompt?: boolean;
  sample_count?: number;
  negative_prompt?: string;
  seed?: number;
}

export interface Veo3GenerationRequest extends VeoGenerationRequest {
  model?: string;
  output_resolution?: string;
  generate_audio?: boolean;
}

export interface VeoImageToVideoRequest extends VeoGenerationRequest {
  image_gcs_uri?: string;
  last_frame_gcs_uri?: string;
}

export interface Veo3ImageToVideoRequest extends Veo3GenerationRequest {
  image_gcs_uri?: string;
  last_frame_gcs_uri?: string;
}

export const triggerVeo2TextToVideo = (data: VeoGenerationRequest) => {
  return fetch('/api/v1/veo/veo2/text-to-video', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
};

export const triggerVeo2ImageToVideo = (data: VeoImageToVideoRequest) => {
  return fetch('/api/v1/veo/veo2/image-to-video', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
};

export const triggerVeo3TextToVideo = (data: Veo3GenerationRequest) => {
  return fetch('/api/v1/veo/veo3/text-to-video', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
};

export const triggerVeo3ImageToVideo = (data: Veo3ImageToVideoRequest) => {
  return fetch('/api/v1/veo/veo3/image-to-video', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
};

export const uploadImage = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  const response = await api.post('/veo/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
  return response.data;
};

export const checkHealth = async () => {
  const response = await api.get('/health');
  return response.data;
};

export default api;
