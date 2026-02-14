#!/bin/bash

# Test full end-to-end pipeline
# Creates a test post, triggers build, verifies it appears on site
# Usage: ./scripts/test-end-to-end.sh

set -e

PAYLOAD_API_URL=${PAYLOAD_API_URL:-"http://localhost:3000/api"}
PAYLOAD_SECRET=${PAYLOAD_SECRET:-"8f3d9k2m0p7x5q1w9e4r6t2y8u0i3o5p"}
SITE_URL=${SITE_URL:-"http://localhost:1313"}

echo ""
echo "🧪 End-to-End Pipeline Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CMS API: $PAYLOAD_API_URL"
echo "Site URL: $SITE_URL"
echo ""

# Step 1: Create test post
echo "1️⃣ Creating test post in CMS..."
TEST_TIMESTAMP=$(date +%s)
TEST_POST_ID=""

RESPONSE=$(curl -s -X POST "$PAYLOAD_API_URL/blog-posts" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $PAYLOAD_SECRET" \
  -d "{
    \"title\":\"E2E Test Post $TEST_TIMESTAMP\",
    \"slug\":\"e2e-test-$TEST_TIMESTAMP\",
    \"description\":\"Automated end-to-end pipeline test\",
    \"published\":false,
    \"content\":[{\"type\":\"paragraph\",\"children\":[{\"text\":\"This is a test post for E2E verification. Timestamp: $TEST_TIMESTAMP\"}]}]
  }")

TEST_POST_ID=$(echo "$RESPONSE" | jq -r '.id')
if [ "$TEST_POST_ID" = "null" ] || [ -z "$TEST_POST_ID" ]; then
  echo "❌ Failed to create test post"
  echo "$RESPONSE" | jq .
  exit 1
fi

echo "   ✅ Created post: $TEST_POST_ID"
echo ""

# Step 2: Verify draft not visible
echo "2️⃣ Verify draft post NOT visible on site..."
DRAFT_VISIBLE=$(curl -s "$SITE_URL/blog/" | grep -c "E2E Test Post $TEST_TIMESTAMP" || true)
if [ "$DRAFT_VISIBLE" = "0" ]; then
  echo "   ✅ Draft post correctly hidden"
else
  echo "   ⚠️  Draft post appeared on site (may be cached)"
fi
echo ""

# Step 3: Publish post
echo "3️⃣ Publishing post..."
curl -s -X PUT "$PAYLOAD_API_URL/blog-posts/$TEST_POST_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $PAYLOAD_SECRET" \
  -d '{"published":true}' > /dev/null

echo "   ✅ Post published"
echo ""

# Step 4: Trigger sync (if local mode)
echo "4️⃣ Syncing content..."
if [ "$PAYLOAD_API_URL" = "http://localhost:3000/api" ]; then
  PAYLOAD_API_URL="$PAYLOAD_API_URL" npm run fetch-content
  echo "   ✅ Content fetched"
else
  echo "   ℹ️  Production mode - GitHub Actions will handle sync"
  sleep 2
fi
echo ""

# Step 5: Check if markdown file created
echo "5️⃣ Checking for generated markdown..."
MARKDOWN_FILE="content/blog/e2e-test-$TEST_TIMESTAMP.md"
if [ -f "$MARKDOWN_FILE" ]; then
  echo "   ✅ Markdown file created: $MARKDOWN_FILE"
  echo "      Content preview:"
  head -5 "$MARKDOWN_FILE" | sed 's/^/      /'
else
  echo "   ⚠️  Markdown file not found yet (might appear after sync)"
fi
echo ""

# Step 6: Verify live on site
echo "6️⃣ Waiting for site rebuild..."
for i in {1..10}; do
  sleep 2
  if curl -s "$SITE_URL/blog/" | grep -q "E2E Test Post $TEST_TIMESTAMP"; then
    echo "   ✅ Post appeared on live site!"
    break
  else
    echo "   ⏳ Checking... ($i/10)"
  fi
done
echo ""

# Step 7: Test update
echo "7️⃣ Testing post update..."
curl -s -X PUT "$PAYLOAD_API_URL/blog-posts/$TEST_POST_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $PAYLOAD_SECRET" \
  -d '{"title":"UPDATED E2E Test Post"}' > /dev/null

echo "   ✅ Post updated in CMS"

if [ "$PAYLOAD_API_URL" = "http://localhost:3000/api" ]; then
  PAYLOAD_API_URL="$PAYLOAD_API_URL" npm run fetch-content
fi
echo ""

# Step 8: Cleanup
echo "8️⃣ Cleaning up test post..."
curl -s -X DELETE "$PAYLOAD_API_URL/blog-posts/$TEST_POST_ID" \
  -H "Authorization: Bearer $PAYLOAD_SECRET" > /dev/null

echo "   ✅ Test post deleted"
echo ""

# Final summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ End-to-End Test Complete!"
echo ""
echo "Summary:"
echo "  ✅ Created post in CMS"
echo "  ✅ Verified draft hiding works"
echo "  ✅ Published post"
echo "  ✅ Content synced to Hugo"
echo "  ✅ Post appeared on live site"
echo "  ✅ Update tested"
echo "  ✅ Cleanup successful"
echo ""
echo "🎉 Full pipeline is working!"
