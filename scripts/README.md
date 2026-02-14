# Ixtlan Designs - Pipeline Automation Scripts

Automated scripts for managing the CMS-to-Live publishing pipeline.

## Quick Start

### 1. Check Pipeline Status
```bash
./scripts/check-pipeline.sh
```
Verifies all components are properly configured and running.

**Checks:**
- ✅ Local CMS status
- ✅ Production CMS configuration
- ✅ GitHub repository setup
- ✅ Content sync script
- ✅ Hugo content directories
- ✅ GitHub Actions workflow

**Output:** Status report showing what's ready and what needs attention.

---

### 2. Test CMS API

#### Local CMS
```bash
./scripts/test-cms-api.sh local
```

#### Production CMS
```bash
export PAYLOAD_API_URL=https://your-vercel-url.vercel.app/api
./scripts/test-cms-api.sh production
```

**Tests:**
- Health check
- Public read access (no auth)
- Authentication verification
- POST/PUT/DELETE with token
- Auto-cleanup of test data

**Output:** Detailed test results with ✅/❌ status.

---

### 3. Sync Content from CMS

```bash
export PAYLOAD_API_URL=http://localhost:3000/api
./scripts/sync-content.sh
```

**What it does:**
1. Verifies CMS is reachable
2. Fetches all published content
3. Converts to Hugo markdown
4. Stages changed files
5. Commits with proper message
6. Asks if you want to push

**Output:**
- Shows what's being synced
- Lets you review before committing
- Confirms push to GitHub

**Triggers:** GitHub Actions build & deploy on push.

---

### 4. End-to-End Pipeline Test

```bash
export PAYLOAD_API_URL=http://localhost:3000/api
./scripts/test-end-to-end.sh
```

**Test workflow:**
1. Create a test post in CMS (unpublished)
2. Verify it doesn't appear on site
3. Publish the post
4. Sync content to Hugo
5. Verify post appears on live site
6. Test updating the post
7. Clean up test post

**Output:** ✅ confirmation of each step or errors.

---

## Script Details

### test-cms-api.sh
- **Requires:** curl, jq
- **Time:** ~5 seconds
- **Modes:** local, production
- **Exit code:** 0 on success, 1 on failure

### sync-content.sh
- **Requires:** npm, git
- **Time:** 10-30 seconds
- **Interactive:** Yes (asks for commit message & push confirmation)
- **Affects:** Git repository, working directory

### check-pipeline.sh
- **Requires:** curl, git, npm
- **Time:** 5-10 seconds
- **Interactive:** No
- **Read-only:** Yes (no changes made)

### test-end-to-end.sh
- **Requires:** npm, curl
- **Time:** 1-2 minutes
- **Interactive:** No
- **Modifies:** CMS data (creates & deletes test post)

---

## Environment Variables

### Required
```bash
PAYLOAD_API_URL    # CMS API endpoint (e.g., http://localhost:3000/api)
PAYLOAD_SECRET     # Bearer token for auth (from .env.local)
```

### Optional
```bash
SITE_URL          # Hugo dev site (default: http://localhost:1313)
```

### Set Defaults
```bash
# In your ~/.bashrc or ~/.zshrc
export PAYLOAD_API_URL="http://localhost:3000/api"
export PAYLOAD_SECRET="your-secret-key"
```

---

## Common Workflows

### Daily Content Sync
```bash
./scripts/check-pipeline.sh   # Verify everything works
./scripts/sync-content.sh     # Fetch and commit new content
```

### Testing a New Post
```bash
# 1. Create in CMS admin
# 2. Run sync
./scripts/sync-content.sh

# 3. Verify on live site
open http://localhost:1313/blog/
```

### Deploying to Production
```bash
# 1. Verify everything works locally
./scripts/test-end-to-end.sh

# 2. Push to master (auto-deploys via GitHub Actions)
git push origin master

# 3. Monitor live site
open https://bowevil.github.io/ixtlandesigns/
```

### Debugging Pipeline Issues
```bash
# 1. Check overall status
./scripts/check-pipeline.sh

# 2. Test CMS API directly
./scripts/test-cms-api.sh local

# 3. Verify content sync works
./scripts/sync-content.sh

# 4. Run full test
./scripts/test-end-to-end.sh
```

---

## Troubleshooting

### "Cannot reach CMS API"
```bash
# Make sure CMS is running
cd ../ixtlandesigns-cms
npm run dev
# Should see: Server running on port 3000
```

### "curl: command not found"
```bash
# Install curl
brew install curl    # macOS
apt install curl     # Linux
```

### "jq: command not found"
```bash
# Install jq
brew install jq      # macOS
apt install jq       # Linux
```

### "npm: command not found"
```bash
# Install Node.js with npm
https://nodejs.org/
```

### Test Post Not Appearing on Site
```bash
# 1. Make sure post is published (not draft)
# 2. Run sync again
./scripts/sync-content.sh

# 3. Rebuild Hugo locally
hugo server

# 4. Check that markdown file was created
ls content/blog/
```

---

## Adding More Scripts

Template for new automation scripts:

```bash
#!/bin/bash
set -e  # Exit on error

echo "🔍 Starting task..."

# Verify prerequisites
if ! command -v tool &> /dev/null; then
  echo "❌ Error: 'tool' not found"
  exit 1
fi

# Do the thing
# ...

echo "✅ Done!"
```

---

## Tips

- 💾 **Save results:** Pipe output to file with `script.sh | tee output.log`
- 🐛 **Debug mode:** Run with `bash -x script.sh` for detailed execution
- 📅 **Schedule syncs:** Use cron: `0 9 * * * /path/to/scripts/sync-content.sh`
- 🔒 **Secure secrets:** Don't commit `.env.local` or paste secrets in code
- 📝 **Dry run:** Many scripts let you review changes before applying

---

## Support

For issues with scripts:
1. Check troubleshooting section above
2. Run `check-pipeline.sh` to diagnose
3. Test individual endpoints with `test-cms-api.sh`
4. Review script comments for more details
