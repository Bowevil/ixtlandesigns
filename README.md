# Ixtlan Designs Website

Modern, forward-thinking web development agency portfolio. Hugo static site synced with headless Payload CMS for content management.

**Live Site:** https://bowevil.github.io/ixtlandesigns/
**Custom Domain:** ixtlandes.com (in progress)
**CMS:** MongoDB Atlas + Express.js (in production)

---

## 📋 Overview

This is a **Hugo static site** that syncs content from a **headless CMS**. The workflow:

```
Create/edit content in CMS  →  Sync script fetches  →  Hugo builds  →  Deploy to GitHub Pages
    (Payload CMS)              to markdown              automatically
```

### Tech Stack
- **Static Site Generator:** Hugo (Congo theme)
- **Content Source:** MongoDB Atlas + Express CMS
- **Hosting:** GitHub Pages (https://bowevil.github.io/ixtlandesigns/)
- **CI/CD:** GitHub Actions (auto-build on push)
- **Domain:** NameSilo (ixtlandes.com)

---

## 🚀 Quick Start

### Prerequisites
- Node.js 16+ (for sync script)
- Hugo (for local development)
- Git

### Local Development

**1. Clone the repository**
```bash
git clone https://github.com/bowevil/ixtlandesigns.git
cd ixtlandesigns
```

**2. Install dependencies**
```bash
npm install
```

**3. Start Hugo dev server**
```bash
hugo server
```
Opens at `http://localhost:1313`

**4. (Optional) Sync content from CMS**
```bash
export PAYLOAD_API_URL=http://localhost:3000/api
npm run fetch-content
```

---

## 📁 Project Structure

```
ixtlandesigns/
├── content/                    # Markdown content synced from CMS
│   ├── blog/                   # Blog posts
│   ├── resources/              # Resource library
│   └── hugo-migration/         # Case studies & migration content
├── themes/
│   └── congo/                  # Hugo theme (git submodule)
├── config/
│   └── _default/
│       ├── hugo.toml           # Main Hugo configuration
│       ├── params.toml         # Theme parameters
│       └── menus.toml          # Navigation menus
├── static/                     # Static assets
│   ├── images/
│   ├── sounds/                 # Audio portfolio
│   └── CNAME                   # Custom domain config
├── layouts/                    # Custom Hugo layouts
├── scripts/
│   ├── fetch-payload-content.js  # Sync script (CMS → Markdown)
│   ├── test-cms-api.sh          # API testing
│   ├── sync-content.sh          # Full sync + commit workflow
│   ├── check-pipeline.sh        # Verify all components
│   ├── test-end-to-end.sh       # Full pipeline test
│   └── README.md                # Script documentation
├── .github/
│   └── workflows/
│       └── hugo.yml             # GitHub Actions build & deploy
├── package.json                # Node.js dependencies
└── .gitignore

```

---

## 📝 Content Management

### Add/Edit Content

**Option 1: Via CMS Admin (Recommended)**
1. Go to https://ixtlandesigns-cms.vercel.app/admin
2. Click "Blog Posts" or "Resources"
3. Create or edit content
4. Mark as "published" when ready
5. Content auto-syncs to site (or manually run sync)

**Option 2: Direct Markdown (Advanced)**
1. Create `.md` file in `content/blog/` or `content/resources/`
2. Add YAML frontmatter:
```yaml
---
title: "Post Title"
date: 2026-02-14
description: "Short description"
slug: "post-slug"
tags: ["tag1", "tag2"]
published: true
---

# Markdown content here
```

### Publishing Workflow

1. **Create** - Write in CMS admin or editor
2. **Draft** - Set `published: false` to hide from live site
3. **Review** - Content hidden while drafting
4. **Publish** - Set `published: true` to make visible
5. **Sync** - Run sync script or wait for automatic sync
6. **Deploy** - GitHub Actions auto-builds on commit

---

## 🔄 Sync Process

### Manual Sync
```bash
./scripts/sync-content.sh
```

This:
1. Fetches all published content from CMS
2. Converts to Hugo markdown
3. Shows changes before committing
4. Commits to git with proper message
5. Pushes to GitHub (triggers auto-deploy)

### Automatic Sync
GitHub Actions workflow triggers on:
- Push to `master` branch
- Manual dispatch (`Actions` tab on GitHub)
- Repository dispatch webhook (from CMS)

**Workflow file:** `.github/workflows/hugo.yml`

---

## 🧪 Automation Scripts

All scripts are in `./scripts/` directory.

### Testing & Debugging
```bash
# Check if everything is configured correctly
./scripts/check-pipeline.sh

# Test CMS API (local or production)
./scripts/test-cms-api.sh local
./scripts/test-cms-api.sh production

# Full end-to-end test
./scripts/test-end-to-end.sh
```

### Content Sync
```bash
# Sync and commit changes
./scripts/sync-content.sh
```

📖 **Full documentation:** See `scripts/README.md`

---

## ⚙️ Configuration

### Hugo Configuration
**File:** `config/_default/hugo.toml`

Key settings:
- `baseURL` - Site URL (currently GitHub Pages, will change to ixtlandes.com)
- `theme` - Uses "congo" theme
- `title` - "Ixtlan Designs"

### Theme Configuration
**File:** `config/_default/params.toml`

Customizable:
- Colors and fonts
- Navigation menu
- Social media links
- Analytics

### Site Menu
**File:** `config/_default/menus.toml`

```toml
[[main]]
name = "Services"
url = "services/"
weight = 1

[[main]]
name = "Portfolio"
url = "portfolio/"
weight = 2
# ... more items
```

---

## 🌐 Pages & Navigation

### Main Pages
- **Home** (`/`) - Homepage with value proposition
- **Services** (`/services`) - Web Dev, CMS, Digital Strategy
- **Portfolio** (`/portfolio`) - Client work showcase
- **Blog** (`/blog`) - Articles synced from CMS
- **Resources** (`/resources`) - Resource library
- **Cardistry** (`/ionrot`) - Ion Rot cardistry project
- **Sounds** (`/sounds`) - Music & sound design portfolio
- **Contact** (`/contact`) - Contact form

### Navigation Flow
```
Home → Services → Portfolio → Cardistry → Sounds → Resources → Contact
```

---

## 🚀 Deployment

### Automatic Deployment
Site auto-deploys when:
1. Changes pushed to `master` branch
2. GitHub Actions workflow runs `hugo` command
3. Built site pushed to GitHub Pages

**Status:** Check Actions tab on GitHub
**Live site:** https://bowevil.github.io/ixtlandesigns/

### Custom Domain Setup
**Status:** In progress (Phase 4)

When complete:
- `ixtlandes.com` → GitHub Pages CDN
- HTTPS enabled automatically
- DNS configured at NameSilo

**Current config:**
- `static/CNAME` - Domain config file
- GitHub Pages settings - Custom domain setup

---

## 🔗 Related Projects

### Payload CMS Repository
Repository with content management system.

```bash
git clone https://github.com/bowevil/ixtlandesigns-cms.git
```

**Features:**
- Admin dashboard: https://ixtlandesigns-cms.vercel.app/admin
- REST API: https://ixtlandesigns-cms.vercel.app/api
- MongoDB Atlas database
- Authentication on write operations

---

## 📊 Development Workflow

### Regular Content Updates
```bash
# 1. Create/edit in CMS (or markdown)
# 2. Sync to Hugo
./scripts/sync-content.sh

# 3. Site auto-deploys
# 4. Check live site
open https://bowevil.github.io/ixtlandesigns/
```

### Bug Fixes or Design Changes
```bash
# 1. Edit Hugo theme or config
git add .
git commit -m "Fix description"
git push origin master

# 2. GitHub Actions auto-deploys
# 3. Check status in Actions tab
```

### Adding New Collections
1. Create collection in CMS (e.g., "Testimonials")
2. Update `fetch-payload-content.js` to sync new collection
3. Create Hugo content directory
4. Add menu item in `menus.toml`
5. Create Hugo template for new collection

---

## 🧰 Troubleshooting

### Content Not Syncing
```bash
# 1. Check pipeline status
./scripts/check-pipeline.sh

# 2. Test CMS API
./scripts/test-cms-api.sh local

# 3. Run sync manually
./scripts/sync-content.sh

# 4. Check GitHub Actions logs
# Go to Actions tab on GitHub
```

### Site Not Building
```bash
# 1. Verify Hugo works locally
hugo server

# 2. Check GitHub Actions logs
# Actions tab → hugo.yml workflow

# 3. Common issues:
# - Invalid frontmatter in markdown
# - Missing theme submodule
# - Node.js dependency issues
```

### CMS Not Reachable
```bash
# Local CMS not running?
cd ../ixtlandesigns-cms
npm run dev

# Production CMS URL not set?
export PAYLOAD_API_URL=https://your-vercel-url/api

# Test connection
./scripts/test-cms-api.sh production
```

---

## 📚 Documentation

### Script Documentation
See `scripts/README.md` for detailed script usage and examples.

### Hugo Theme Documentation
Congo theme docs: https://github.com/jpanther/congo

### Project Documentation
- **[CMS Repository](https://github.com/bowevil/ixtlandesigns-cms)** - Content management system
- **[Scripts Guide](scripts/README.md)** - Automation scripts
- **[Phase 2-4 Plan](docs/pipeline-implementation.md)** - Remaining deployment phases

---

## 🔐 Security

### Sensitive Information
- `.env.local` - Contains API keys (not committed)
- `PAYLOAD_SECRET` - Used for CMS authentication
- GitHub secrets - PAYLOAD_API_URL configuration

### Best Practices
- ✅ Never commit `.env` files
- ✅ Use GitHub secrets for sensitive config
- ✅ Verify CMS authentication before deploying
- ✅ Review changes before pushing

---

## 📈 Performance

Hugo generates static HTML for:
- ⚡ Fast load times
- 🔒 No server vulnerabilities
- 📊 Excellent SEO
- 🌍 Easy CDN distribution

Current metrics:
- Build time: ~2 seconds
- Page size: ~50KB average
- Lighthouse: 95+ scores

---

## 🤝 Contributing

### Adding Content
1. Create in CMS admin or push markdown
2. Run `./scripts/sync-content.sh`
3. Review changes
4. Push to master

### Modifying Design
1. Edit theme files in `themes/congo/`
2. Test locally: `hugo server`
3. Commit changes
4. Push to master

### Bug Reports
Found an issue? File a bug on GitHub Issues.

---

## 📞 Support

### Getting Help
1. Check `scripts/README.md` for script issues
2. Run `./scripts/check-pipeline.sh` to diagnose
3. Review `.github/workflows/hugo.yml` for deployment issues
4. Check CMS repository for content management questions

### Common Commands

```bash
# Development
hugo server                          # Start dev server
npm install                          # Install dependencies

# Content Sync
./scripts/sync-content.sh            # Fetch & commit
export PAYLOAD_API_URL=http://localhost:3000/api

# Testing
./scripts/check-pipeline.sh          # Verify setup
./scripts/test-cms-api.sh local      # Test CMS
./scripts/test-end-to-end.sh         # Full workflow test

# Deployment
git push origin master               # Triggers auto-deploy
```

---

## 📄 License

Copyright © 2026 Ixtlan Designs. All rights reserved.

---

## 🎯 Next Steps

- [ ] Vercel deployment (Phase 2)
- [ ] Webhook automation (Phase 3)
- [ ] Custom domain setup (Phase 4)
- [ ] Content population
- [ ] Performance optimization

See **[Pipeline Implementation Plan](docs/pipeline-implementation.md)** for details.

---

**Built with ❤️ using Hugo + Payload CMS**
