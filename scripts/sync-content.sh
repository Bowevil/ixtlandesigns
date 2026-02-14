#!/bin/bash

# Fetch content from CMS and commit changes
# Usage: PAYLOAD_API_URL=http://localhost:3000/api ./scripts/sync-content.sh

set -e

PAYLOAD_API_URL=${PAYLOAD_API_URL:-"http://localhost:3000/api"}

echo ""
echo "🔄 Content Sync Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Source: $PAYLOAD_API_URL"
echo ""

# Check if API is reachable
echo "📡 Checking API connection..."
if ! curl -s "$PAYLOAD_API_URL/health" > /dev/null; then
  echo "❌ Error: Cannot reach CMS API at $PAYLOAD_API_URL"
  echo ""
  echo "💡 Make sure:"
  echo "   - CMS is running (local: npm run dev in ixtlandesigns-cms)"
  echo "   - PAYLOAD_API_URL is set correctly"
  echo "   - URL includes /api suffix"
  exit 1
fi
echo "✅ API is reachable"
echo ""

# Run fetch script
echo "📥 Fetching content from CMS..."
PAYLOAD_API_URL="$PAYLOAD_API_URL" npm run fetch-content

# Check for changes
echo ""
echo "📊 Checking for changes..."
if git diff --quiet; then
  echo "✅ No changes to commit"
  exit 0
fi

echo "📝 Changes detected. Staging files..."
git add content/

# Show what will be committed
echo ""
echo "Changes to commit:"
git diff --cached --stat
echo ""

# Create commit
read -p "📋 Commit message (default: 'Sync content from Payload CMS'): " COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-"Sync content from Payload CMS"}

git commit -m "$(cat <<EOF
$COMMIT_MSG

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
EOF
)"

echo ""
echo "✅ Content synced and committed"
echo ""

# Ask about pushing
read -p "🚀 Push to remote master? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git push origin master
  echo "✅ Pushed to GitHub"
else
  echo "⏸️  Not pushing. Run 'git push origin master' when ready"
fi

echo ""
echo "✨ Sync complete!"
