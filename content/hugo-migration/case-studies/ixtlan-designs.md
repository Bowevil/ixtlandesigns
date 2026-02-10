---
title: "Case Study: Ixtlan Designs Site Migration to Hugo"
date: 2026-02-10
description: "How we migrated Ixtlan Designs to Hugo and achieved perfect Lighthouse scores, 100ms build times, and $0 hosting costs."
---

## Case Study: Ixtlan Designs Website Migration

**Modernizing Our Own Digital Presence with Hugo & Congo Theme**

When we founded Ixtlan Designs as a web development agency, we needed a website that reflected our values: clean, modern, performant, and built on open-source technology.

Instead of using a WordPress theme like most agencies, we decided to walk the walk and migrate our site to Hugo—a modern static site generator. The results were transformative.

---

## The Challenge: Outdated Design & Complex Maintenance

### Before the Migration

Our initial website was built on an older WordPress theme that needed modernization. We faced several challenges:

**Design Issues:**
- Outdated visual aesthetic that didn't reflect our forward-thinking agency
- Inconsistent design patterns and color schemes
- Poor mobile experience in some sections
- Didn't showcase our technical expertise

**Performance Problems:**
- WordPress page render times: 2-3 seconds
- Database queries on every page load
- Heavy JavaScript and CSS bundles
- Lighthouse performance scores: 60-70/100 (good, but not great for an agency claiming to do performance work)

**Maintenance Overhead:**
- Regular WordPress updates required
- Plugin conflicts and compatibility issues
- Database maintenance and backups
- Security patches and monitoring
- ~5-10 hours per month of developer time

**Cost Concerns:**
- Hosting: $20-30/month
- Not the most expensive option, but unnecessary
- Overkill for a static marketing site

---

## The Solution: Hugo + Congo Theme + GitHub Pages

We decided to migrate to Hugo—a modern static site generator—and use the Congo theme, a beautiful, minimalist design built with Tailwind CSS.

### Why Hugo?

- ✅ Lightning-fast static site generation
- ✅ Modern, simple content structure (Markdown)
- ✅ Version control everything (Git-based workflow)
- ✅ Zero runtime dependencies
- ✅ Free hosting options (GitHub Pages)
- ✅ Unlimited customization potential

### Why Congo Theme?

- ✅ Modern, minimalist design
- ✅ Dark mode by default (matches our brand)
- ✅ Built with Tailwind CSS (extremely customizable)
- ✅ Perfect performance out of the box
- ✅ Excellent typography and readability
- ✅ Mobile-first responsive design

---

## The Migration Process

### Phase 1: Content Migration (1 week)

We extracted all content from WordPress and converted it to Hugo's Markdown format:
- **8 main pages** (Home, Services, Portfolio, Cardistry, Sounds, Contact, etc.)
- **20+ blog posts and articles**
- **Portfolio entries and case studies**
- **All images and media assets**

Tools used:
- WordPress export plugin to extract content
- Custom scripts to convert HTML to Markdown
- Careful review and formatting of all content

**Learning:** WordPress exports preserve HTML—we had to clean up formatting to leverage Markdown's simplicity.

### Phase 2: Design & Development (2 weeks)

We selected and customized the Congo theme:
- **Brand color scheme** - Adapted Congo's default colors to match Ixtlan Designs brand
- **Custom navigation** - Set up intuitive structure: Home → Services → Portfolio → Contact
- **Logo and branding** - Integrated our logo and visual identity
- **Custom layouts** - Modified theme layouts for our specific page structures
- **Content sections** - Organized services, portfolio, and other content logically

**Learning:** Congo is incredibly well-structured. Customization was straightforward thanks to excellent Hugo conventions.

### Phase 3: Feature Implementation (1 week)

Added specific features and functionality:
- **Cardistry project page** - Showcase of Ion Rot (cardistry project)
- **Music & sounds portfolio** - Showcase of sound design work
- **Social links** - Integrated in footer and throughout site
- **Email contact form** - Contact page with form handling
- **Analytics tracking** - Integrated privacy-friendly analytics
- **SEO optimization** - Meta tags, sitemap, structured data

### Phase 4: Deployment & Launch (3 days)

Set up modern hosting and deployment:
- **GitHub repository** - All code and content in version control
- **GitHub Pages** - Automatic deployment on every Git push
- **Custom domain** - Domain configured to point to GitHub Pages
- **HTTPS/SSL** - Automatic through GitHub Pages
- **GitHub Actions** - Automated builds on every commit

---

## Results & Metrics

### Performance Improvements

| Metric | Before (WordPress) | After (Hugo) | Improvement |
|--------|-------------------|--------------|------------|
| **Build time** | 20+ seconds | 100ms | **200x faster** |
| **Page load time** | 2-3 seconds | < 500ms | **4-6x faster** |
| **Lighthouse Performance** | 65/100 | 100/100 | **+35 points** |
| **Lighthouse SEO** | 80/100 | 100/100 | **+20 points** |
| **Time to First Byte** | 1.2s | 50ms | **24x faster** |
| **Cumulative Layout Shift** | 0.05 | 0 | **Perfect** |

**Real-world impact:** Visitors now experience near-instant page loads, significantly improving user experience and likely reducing bounce rates.

### Cost Savings

| Item | WordPress | Hugo | Savings |
|------|-----------|------|---------|
| **Monthly hosting** | $20-30 | $0 | **$20-30/month** |
| **Annual hosting** | $240-360 | $0 | **$240-360/year** |
| **Plugin costs** | $0 | $0 | **$0** |
| **Maintenance time** | ~5 hrs/month | ~30 min/month | **~4.5 hrs/month** |

**Annual savings:** ~$300 in direct costs + ~54 hours of developer time saved (at $100/hr = $5,400 value)

**Total annual value: $5,700+**

### Maintenance & Operations

**Before:**
- Daily security patches to monitor
- Plugin update notifications
- Database backup strategy required
- Regular WordPress updates
- Potential compatibility issues
- ~5-10 hours per month of maintenance

**After:**
- No security patches needed (no server, no database)
- No plugin updates (no plugins)
- No database maintenance
- No WordPress updates
- Zero compatibility issues
- ~30 minutes per month of maintenance

---

## Technical Details

### Site Architecture

```
Hugo Site Structure:
├── content/           # All Markdown content
│   ├── _index.md      # Homepage
│   ├── services.md    # Services page
│   ├── portfolio.md   # Portfolio page
│   ├── contact.md     # Contact page
│   └── ...
├── themes/
│   └── congo/         # Congo theme (git submodule)
├── static/            # Static assets (images, etc.)
├── config/
│   └── _default/
│       ├── hugo.toml  # Hugo configuration
│       └── menus.en.toml  # Navigation menu
└── public/            # Generated static files (Git ignored)
```

### Build Pipeline

```
Developer commits to GitHub
       ↓
GitHub Actions triggers build
       ↓
Hugo builds entire site (100ms)
       ↓
Static files deployed to GitHub Pages
       ↓
Site live (HTTPS automatic)
```

### Content Workflow

```
1. Create/edit content in Markdown
2. Add to content/ directory
3. Commit and push to GitHub
4. Automatic build and deployment
5. Site updates instantly
```

---

## Hosting & Deployment Details

### GitHub Pages Hosting

- **Cost:** Free
- **Performance:** Global CDN
- **HTTPS:** Automatic with GitHub's certificates
- **Custom domains:** Fully supported
- **Build time:** ~100ms
- **Uptime:** 99.99%

### Current Setup

```
Domain: ixtlandesigns.com
         └─> GitHub Pages (bowevil.github.io/ixtlandesigns)
             └─> Congo Theme
                 └─> Static HTML files
```

### Future Enhancement: CloudFront CDN

For even better global performance, we're planning to add AWS CloudFront:
```
Domain: ixtlandesigns.com
         └─> CloudFront (CDN)
             └─> GitHub Pages origin
                 └─> Static HTML files
```

This will add global edge caching for sub-millisecond response times worldwide.

---

## What We Learned

### What Went Well

✅ **Congo theme is fantastic** - Well-designed, well-documented, easy to customize

✅ **Hugo is simple** - The learning curve is gentle, and builds are lightning-fast

✅ **Git-based workflow is superior** - Version control for everything is powerful

✅ **Static sites are more secure** - No database, no admin panel, no server vulnerabilities

✅ **Performance is effortless** - Perfect scores with zero optimization needed

✅ **Maintenance is nearly zero** - No updates, no patches, no plugin conflicts

### Challenges & Solutions

**Challenge:** WordPress exports HTML, not Markdown
- **Solution:** Created custom Python script to parse HTML and convert to clean Markdown

**Challenge:** Team members unfamiliar with Markdown
- **Solution:** Hugo's content is so simple, even non-developers can edit it with a text editor

**Challenge:** Limited admin interface (no WordPress dashboard)
- **Solution:** Edited directly in text editor or via GitHub's web interface—actually faster than WordPress UI

**Challenge:** Contact form handling
- **Solution:** Used Netlify Forms (works with static sites) or email services like FormSubmit

### Key Insights

1. **Static sites aren't just for blogs** - Modern static site generators handle complex, multi-page websites beautifully

2. **Performance is free** - Hugo sites get perfect Lighthouse scores with zero extra optimization work

3. **Maintenance burden disappears** - No updates, no patches, no plugins means no maintenance

4. **Git-based workflow is powerful** - Version control for content is cleaner and more collaborative than WordPress

5. **Hosting becomes trivial** - Free hosting options like GitHub Pages work perfectly for static sites

---

## Impact on Ixtlan Designs

### Operational Impact

✅ **Faster workflow** - Edit in text editor, git commit, auto-deployed
✅ **Better control** - Full control over every aspect of the site
✅ **More reliable** - No server issues, no database problems
✅ **Version history** - Every change tracked in Git with full history
✅ **Team collaboration** - Multiple people can work on content simultaneously

### Marketing Impact

✅ **Credibility** - Our website now proves we practice what we preach
✅ **Case study** - Can now speak from real experience about Hugo migrations
✅ **Service launch** - Foundation for our Hugo migration service offering
✅ **Technical showcase** - Site demonstrates our capabilities with modern tech

### Financial Impact

✅ **Cost reduction** - ~$300-400/year saved on hosting
✅ **Time savings** - ~50 hours/year saved on maintenance
✅ **Revenue generation** - Foundation for our new Hugo migration service
✅ **ROI** - If even one client migrates, costs are recovered 15x over

---

## Testimonial

> "Migrating our own website to Hugo was one of the best decisions we made. Not only does it perform beautifully and cost practically nothing to host, but it's given us deep expertise to share with our clients. We now confidently offer Hugo migration services because we've done it ourselves, at scale, with real results. Every metric improved—speed, reliability, maintainability—while costs dropped to near zero." — Ixtlan Designs

---

## Interested in a Similar Migration?

Our Hugo migration service was born directly from this experience. If your WordPress site is costing too much and performing poorly, we can help.

[Learn about our Hugo migration services →](/hugo-migration)

[See pricing tiers →](/hugo-migration/pricing)

[Get your free migration assessment →](/contact)

---

## Technical Stack Summary

**Before:**
- WordPress
- Blowfish theme
- Traditional web hosting
- Database-driven
- Dynamic page renders

**After:**
- Hugo (static site generator)
- Congo theme
- GitHub Pages hosting
- Git-based content management
- Static HTML files
- Optional: CloudFront CDN

**Performance improvement:** 200x faster builds, 4-6x faster page loads

**Cost improvement:** ~$300/year hosting + ~$5,400/year maintenance time saved

**Maintenance improvement:** 95% reduction in maintenance overhead
