#!/bin/bash
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

# Smoke test script for Veo Demo App automated deployment.
# Usage: ./smoke-test.sh [frontend_url] [backend_url]

set -e

FRONTEND_URL=${1:-"http://localhost:3000"}
BACKEND_URL=${2:-"http://localhost:8080"}

echo "--------------------------------------------------"
echo "🚀 Starting Smoke Tests for Veo Demo App"
echo "Frontend: $FRONTEND_URL"
echo "Backend:  $BACKEND_URL"
echo "--------------------------------------------------"

# Function to check a URL
check_url() {
    local url=$1
    local name=$2
    echo "🔍 Checking $name..."
    if curl -s --head --fail "$url" > /dev/null; then
        echo "✅ $name is reachable"
    else
        echo "❌ $name is NOT reachable at $url"
        return 1
    fi
}

# 1. Check Frontend reachable
check_url "$FRONTEND_URL" "Frontend"

# 2. Check Backend Health Endpoint
echo "🔍 Checking Backend Health API..."
HEALTH_URL="$BACKEND_URL/health"
RESPONSE=$(curl -s -w "\n%{http_code}" "$HEALTH_URL")
HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
HTTP_STATUS=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_STATUS" -eq 200 ] && [[ "$HTTP_BODY" == *"UP"* ]]; then
    echo "✅ Backend Health: $HTTP_BODY"
else
    echo "❌ Backend Health Check failed!"
    echo "Status: $HTTP_STATUS"
    echo "Body:   $HTTP_BODY"
    exit 1
fi

# 3. Check specific API endpoint (Optional: /api/v1 group)
echo "🔍 Checking Backend API v1 availability..."
V1_URL="$BACKEND_URL/api/v1/queue_prompt"
# We expect 405 Method Not Allowed (since it's a POST) or 401 Unauthorized (if middleware active)
# but 404 would be bad.
V1_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$V1_URL")
if [ "$V1_STATUS" -ne 404 ]; then
    echo "✅ API v1 is mapped (Status: $V1_STATUS)"
else
    echo "❌ API v1 returned 404 Not Found"
    exit 1
fi

echo "--------------------------------------------------"
echo "✨ All Smoke Tests Passed Successfully!"
echo "--------------------------------------------------"
