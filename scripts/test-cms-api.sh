#!/bin/bash

# Test CMS API endpoints with authentication
# Usage: ./scripts/test-cms-api.sh [local|production]

set -e

MODE=${1:-local}
PAYLOAD_SECRET=${PAYLOAD_SECRET:-"8f3d9k2m0p7x5q1w9e4r6t2y8u0i3o5p"}

if [ "$MODE" = "local" ]; then
  BASE_URL="http://localhost:3000/api"
  echo "🧪 Testing LOCAL CMS API..."
elif [ "$MODE" = "production" ]; then
  if [ -z "$PAYLOAD_API_URL" ]; then
    echo "❌ Error: PAYLOAD_API_URL not set"
    echo "Set it with: export PAYLOAD_API_URL=https://your-vercel-url/api"
    exit 1
  fi
  BASE_URL="$PAYLOAD_API_URL"
  echo "🧪 Testing PRODUCTION CMS API..."
else
  echo "Usage: ./scripts/test-cms-api.sh [local|production]"
  exit 1
fi

echo ""
echo "API Base URL: $BASE_URL"
echo ""

# Test 1: Health check
echo "1️⃣ Health Check..."
curl -s "$BASE_URL/health" | jq . || echo "❌ Failed"
echo ""

# Test 2: GET blog posts (public read)
echo "2️⃣ Get Published Blog Posts (no auth needed)..."
curl -s "$BASE_URL/blog-posts" | jq '.docs | length' | xargs echo "   Found" "posts"
echo ""

# Test 3: POST without auth (should fail)
echo "3️⃣ Test POST without auth (should be 401)..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/blog-posts" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test"}')
STATUS=$(echo "$RESPONSE" | tail -1)
if [ "$STATUS" = "401" ]; then
  echo "   ✅ Correctly rejected (401)"
else
  echo "   ❌ Expected 401, got $STATUS"
fi
echo ""

# Test 4: POST with auth (should work)
echo "4️⃣ Test POST with auth..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/blog-posts" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $PAYLOAD_SECRET" \
  -d '{
    "title":"Auth Test Post",
    "slug":"auth-test",
    "description":"Testing authentication",
    "published":false,
    "content":[{"type":"paragraph","children":[{"text":"Test content"}]}]
  }')
STATUS=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$STATUS" = "200" ]; then
  echo "   ✅ Successfully created test post (200)"
  POST_ID=$(echo "$BODY" | jq -r '.id')
  echo "   Post ID: $POST_ID"

  # Clean up: delete the test post
  echo ""
  echo "5️⃣ Cleaning up (delete test post)..."
  curl -s -X DELETE "$BASE_URL/blog-posts/$POST_ID" \
    -H "Authorization: Bearer $PAYLOAD_SECRET" | jq . || echo "❌ Failed to delete"
else
  echo "   ❌ Failed with status $STATUS"
  echo "$BODY" | jq .
fi
echo ""

echo "✅ CMS API Tests Complete"
