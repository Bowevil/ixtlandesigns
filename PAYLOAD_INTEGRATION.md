# Payload CMS Integration Guide

This Hugo site is now integrated with Payload CMS for managing dynamic content like blog posts, case studies, and resources.

## How It Works

```
1. Create/edit content in Payload CMS admin UI
         ↓
2. Publish content (sets published: true)
         ↓
3. GitHub webhook triggers automatic rebuild
         ↓
4. fetch-payload-content.js fetches from Payload API
         ↓
5. Content converted to Markdown files
         ↓
6. Hugo builds site with content
         ↓
7. Deploy to GitHub Pages
```

## Local Development

### Start Payload CMS

```bash
# In ixtlandesigns-cms directory
cd ../ixtlandesigns-cms
npm install
npm run dev
# Visit http://localhost:3000/admin
```

### Fetch Content from Payload

```bash
# In ixtlandesigns directory
npm install
npm run fetch-content
```

This fetches all published content and generates Markdown files:
- `content/blog/*.md` - Blog posts
- `content/hugo-migration/case-studies/*.md` - Case studies
- `content/resources/*.md` - Resources

### Start Hugo Server

```bash
npm run dev
# OR
hugo server -D
```

## Creating Content

### In Payload CMS

1. Visit http://localhost:3000/admin
2. Click collection (Blog Posts, Case Studies, or Resources)
3. Click "Create New"
4. Fill in fields:
   - **Title:** Your content title
   - **Slug:** URL-friendly identifier (auto-generated or custom)
   - **Date:** Publication date
   - **Description:** Short summary
   - **Content:** Full content using rich text editor
5. Add tags/categories as needed
6. Click "Save"
7. Click "Publish" to make it public

### In Payload API Format

The fetched content looks like this:

```json
{
  "id": "...",
  "title": "How to Build Great Websites",
  "slug": "how-to-build-great-websites",
  "date": "2024-02-12",
  "description": "Best practices...",
  "content": [...],
  "tags": ["web design", "tips"],
  "published": true
}
```

### Generated Markdown

After fetching, you get Markdown like this:

```markdown
---
title: "How to Build Great Websites"
date: 2024-02-12
description: "Best practices..."
slug: "how-to-build-great-websites"
source: payload
tags: ["web design", "tips"]
---

Content goes here...
```

## File Locations

**Payload-generated content:**
- Blog: `content/blog/` (from CMS)
- Case Studies: `content/hugo-migration/case-studies/` (from CMS)
- Resources: `content/resources/` (from CMS)

**Manual content (untouched):**
- Services: `content/services/`
- Portfolio: `content/portfolio/`
- Other existing pages

**Note:** Both sources are built together into the final site.

## Workflow

### For New Blog Posts
1. Create in Payload CMS
2. Write using rich text editor
3. Add tags and featured image
4. Publish when ready
5. GitHub Actions automatically rebuilds site

### For Existing Content
- Keep editing Markdown directly in Git
- No need to migrate to Payload
- Hugo builds both sources seamlessly

### Hybrid Approach
- New content → Payload CMS (easier for non-technical writers)
- Existing content → Keep as Markdown (no migration needed)
- Both automatically combined in final build

## Build Pipeline

### Local Build
```bash
npm run build
# 1. Fetches content from Payload (or uses local if offline)
# 2. Runs Hugo build
# 3. Outputs to public/
```

### Production Build (GitHub Actions)
```yaml
# .github/workflows/hugo.yml
1. Checkout code
2. Setup Node.js
3. Install dependencies
4. Fetch from Payload API (using PAYLOAD_API_URL secret)
5. Build with Hugo
6. Deploy to GitHub Pages
```

## Environment Variables

### Local Development
```bash
# .env (in Hugo site directory)
# No special vars needed - uses localhost:3000
```

### Production (GitHub)
In repository settings → Secrets and variables → Actions:

```
PAYLOAD_API_URL=https://your-cms-url.com/api
```

This tells GitHub Actions where to fetch content during builds.

### Production (Payload Server)
```
DATABASE_URI=mongodb+srv://user:pass@cluster.mongodb.net/db
PAYLOAD_SECRET=random-secret-key-min-32-chars
GITHUB_TOKEN=your-github-token
SERVER_URL=https://your-cms-url.com
```

## Troubleshooting

### Content Not Fetching?
- Is Payload CMS running? Check http://localhost:3000
- Are articles published (published: true)?
- Run with: `PAYLOAD_API_URL=http://localhost:3000/api npm run fetch-content`

### Hugo Can't Find Content?
- Did you run `npm run fetch-content` first?
- Check `content/blog/`, `content/hugo-migration/case-studies/`, `content/resources/`
- Verify frontmatter format in generated `.md` files

### GitHub Actions Failing?
- Check `PAYLOAD_API_URL` secret is set correctly
- Verify Payload server is accessible (not localhost)
- Check GitHub Actions logs for error details

### Duplicate Content?
- Old Markdown files stay in place
- If same slug appears in both, Payload takes precedence
- Delete old files if migrating to Payload

## Next Steps

1. **Set up MongoDB Atlas** for production database
2. **Deploy Payload** to Vercel or similar
3. **Add GitHub secrets** (`PAYLOAD_API_URL`)
4. **Test full pipeline:**
   - Create content in Payload
   - Push to GitHub → triggers build
   - Verify on GitHub Pages

## Additional Resources

- **Payload Docs:** https://payloadcms.com/docs
- **Hugo Docs:** https://gohugo.io/documentation/
- **GitHub Actions:** https://docs.github.com/en/actions
- **MongoDB Atlas:** https://www.mongodb.com/cloud/atlas

## Content Management Best Practices

- ✅ Use descriptive slugs (matches URL)
- ✅ Add alt text to all images
- ✅ Use formatting for readability
- ✅ Publish only when ready
- ✅ Keep descriptions under 160 characters (SEO)
- ❌ Don't delete published content unless necessary
- ❌ Don't publish duplicate content with same slug
- ❌ Don't commit auto-generated files to Git

## File Ignore

Generated content is included in Git for version control:
```
content/blog/
content/hugo-migration/case-studies/
content/resources/
```

These are updated automatically and tracked for history.
