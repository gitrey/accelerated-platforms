# Copyright 2026 Google LLC
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

import unittest
from unittest.mock import MagicMock, patch
import os
import sys

# Add the src directory to the path so we can import the custom nodes
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'src'))

from custom_nodes.google_genmedia.veo3_nodes import Veo3TextToVideoNode
from custom_nodes.google_genmedia.constants import Veo3Model

class TestVeo3Nodes(unittest.TestCase):
    def setUp(self):
        self.node = Veo3TextToVideoNode()

    @patch('custom_nodes.google_genmedia.veo3_nodes.Veo3API')
    def test_veo3_text_to_video_node_execution(self, mock_api_class):
        # Mock API response
        mock_api_instance = mock_api_class.return_value
        mock_api_instance.generate_video_from_text.return_value = ["path/to/video.mp4"]
        
        # Test parameters
        prompt = "A beautiful sunset over the ocean"
        model = Veo3Model.VEO_3_1.name
        aspect_ratio = "16:9"
        duration_seconds = 5
        sample_count = 1
        fps = 24
        seed = 0
        enhance_prompt = True
        gcp_project_id = "test-project"
        gcp_region = "us-central1"

        # Execute node
        result = self.node.generate_video(
            prompt=prompt,
            model=model,
            aspect_ratio=aspect_ratio,
            duration_seconds=duration_seconds,
            sample_count=sample_count,
            fps=fps,
            seed=seed,
            enhance_prompt=enhance_prompt,
            gcp_project_id=gcp_project_id,
            gcp_region=gcp_region
        )

        # Verify API call
        mock_api_instance.generate_video_from_text.assert_called_once_with(
            prompt=prompt,
            model=model,
            aspect_ratio=aspect_ratio,
            duration_seconds=duration_seconds,
            sample_count=sample_count,
            fps=fps,
            seed=seed,
            enhance_prompt=enhance_prompt
        )
        
        # Verify result
        self.assertEqual(result, (["path/to/video.mp4"],))

if __name__ == '__main__':
    unittest.main()
