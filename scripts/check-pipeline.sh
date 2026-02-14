#!/bin/bash

# Check full pipeline status
# Usage: ./scripts/check-pipeline.sh

set -e

echo ""
echo "🔍 Pipeline Status Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PASSED=0
FAILED=0

# Check 1: Local CMS
echo "1️⃣ Local CMS Status..."
if curl -s http://localhost:3000/api/health > /dev/null 2>&1; then
  echo "   ✅ Running at http://localhost:3000"
  ((PASSED++))
else
  echo "   ⚠️  Not running locally"
  echo "      (This is OK if using production CMS)"
fi
echo ""

# Check 2: Local CMS API - Blog Posts
echo "2️⃣ Local CMS Blog Posts..."
if curl -s http://localhost:3000/api/health > /dev/null 2>&1; then
  COUNT=$(curl -s "http://localhost:3000/api/blog-posts" | jq '.docs | length')
  echo "   ✅ Found $COUNT published blog posts"
  ((PASSED++))
else
  echo "   ⏭️  Skipped (CMS not running)"
fi
echo ""

# Check 3: Production CMS (if configured)
echo "3️⃣ Production CMS Status..."
if [ -z "$PAYLOAD_API_URL" ]; then
  echo "   ⚠️  PAYLOAD_API_URL not set"
  echo "      (Set after Vercel deployment)"
else
  if curl -s "$PAYLOAD_API_URL/health" > /dev/null 2>&1; then
    echo "   ✅ Reachable at $PAYLOAD_API_URL"
    ((PASSED++))
  else
    echo "   ❌ Not reachable at $PAYLOAD_API_URL"
    ((FAILED++))
  fi
fi
echo ""

# Check 4: GitHub Repository
echo "4️⃣ GitHub Repository..."
if git remote -v | grep -q "bowevil/ixtlandesigns"; then
  echo "   ✅ Connected to bowevil/ixtlandesigns"
  ((PASSED++))

  # Check if up to date
  if git diff --quiet && git diff --cached --quiet; then
    echo "   ✅ Working directory clean"
    ((PASSED++))
  else
    echo "   ⚠️  Uncommitted changes present"
  fi
else
  echo "   ❌ Not a valid repo"
  ((FAILED++))
fi
echo ""

# Check 5: Fetch Script
echo "5️⃣ Content Fetch Script..."
if [ -f "scripts/fetch-payload-content.js" ]; then
  echo "   ✅ Script exists"
  ((PASSED++))

  # Check if npm dependencies installed
  if [ -d "node_modules" ]; then
    echo "   ✅ Dependencies installed"
    ((PASSED++))
  else
    echo "   ⚠️  Dependencies not installed (npm install to fix)"
  fi
else
  echo "   ❌ Script not found"
  ((FAILED++))
fi
echo ""

# Check 6: Hugo Content
echo "6️⃣ Hugo Content Directories..."
DIRS=("content/blog" "content/resources" "content/hugo-migration")
for dir in "${DIRS[@]}"; do
  if [ -d "$dir" ]; then
    COUNT=$(find "$dir" -name "*.md" | wc -l)
    echo "   ✅ $dir ($COUNT files)"
  else
    echo "   ⚠️  $dir not found"
  fi
done
((PASSED += 3))
echo ""

# Check 7: GitHub Actions
echo "7️⃣ GitHub Actions Workflow..."
if [ -f ".github/workflows/hugo.yml" ]; then
  echo "   ✅ Hugo workflow configured"
  ((PASSED++))

  if grep -q "PAYLOAD_API_URL" .github/workflows/hugo.yml; then
    echo "   ✅ Uses PAYLOAD_API_URL secret"
    ((PASSED++))
  fi
else
  echo "   ⚠️  No Hugo workflow found"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASSED ✅  $FAILED ❌"
echo ""

if [ $FAILED -eq 0 ]; then
  echo "✨ Pipeline looks good!"
  exit 0
else
  echo "⚠️  Some checks failed. See above for details."
  exit 1
fi
