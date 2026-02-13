const fetch = require('node-fetch');
const fs = require('fs');
const path = require('path');

const PAYLOAD_API_URL = process.env.PAYLOAD_API_URL || 'http://localhost:3000/api';

async function fetchFromPayload(collection) {
  try {
    console.log(`Fetching ${collection} from ${PAYLOAD_API_URL}/${collection}...`);
    const response = await fetch(`${PAYLOAD_API_URL}/${collection}?where[published][equals]=true&limit=100`);

    if (!response.ok) {
      console.warn(`⚠️  Could not fetch ${collection} (${response.status}). Payload CMS may not be running.`);
      return [];
    }

    const data = await response.json();
    console.log(`✓ Found ${data.docs?.length || 0} published ${collection}`);
    return data.docs || [];
  } catch (error) {
    console.warn(`⚠️  Error fetching ${collection}:`, error.message);
    return [];
  }
}

function ensureDir(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

function convertRichTextToMarkdown(richText) {
  // Convert rich text JSON to markdown
  // This is a simple implementation - can be enhanced
  if (typeof richText === 'string') {
    return richText;
  }

  if (!richText) return '';

  // If it's an array of blocks, convert each
  if (Array.isArray(richText)) {
    return richText.map(block => {
      if (block.type === 'paragraph') {
        return block.children?.map(child => child.text || '').join('') || '';
      }
      if (block.type === 'heading') {
        const level = block.level || 2;
        const text = block.children?.map(child => child.text || '').join('') || '';
        return '#'.repeat(level) + ' ' + text;
      }
      if (block.type === 'list') {
        return block.children?.map(item => '- ' + (item.children?.[0]?.text || '')).join('\n') || '';
      }
      return '';
    }).join('\n\n');
  }

  return '';
}

async function convertToMarkdown(post, type) {
  const frontmatter = `---
title: "${post.title.replace(/"/g, '\\"')}"
date: ${new Date(post.date).toISOString().split('T')[0]}
description: "${(post.description || '').replace(/"/g, '\\"')}"
slug: "${post.slug}"
source: payload
${post.tags && post.tags.length > 0 ? `tags: [${post.tags.map(t => `"${t.tag || t}"`).join(', ')}]` : ''}
${post.category ? `category: "${post.category}"` : ''}
---

${convertRichTextToMarkdown(post.content)}
`;

  const fileName = `${post.slug}.md`;
  const filePath = path.join(__dirname, `../content/${type}/${fileName}`);

  ensureDir(path.dirname(filePath));
  fs.writeFileSync(filePath, frontmatter);
  console.log(`  ✓ Created: ${type}/${fileName}`);
}

function cleanupOrphanedFiles(contentDir, keepSlugs) {
  // Delete markdown files that are no longer in CMS
  // Keep: _index.md and files that match CMS slugs
  const fullPath = path.join(__dirname, `../content/${contentDir}`);

  if (!fs.existsSync(fullPath)) return;

  const files = fs.readdirSync(fullPath);
  files.forEach(file => {
    if (file === '_index.md') return; // Always keep section index
    if (!file.endsWith('.md')) return; // Only check markdown files

    const slug = file.replace('.md', '');
    if (!keepSlugs.includes(slug)) {
      const filePath = path.join(fullPath, file);
      fs.unlinkSync(filePath);
      console.log(`  ✗ Deleted: ${contentDir}/${file} (no longer in CMS)`);
    }
  });
}

async function main() {
  console.log('\n🚀 Fetching content from Payload CMS...\n');

  // Fetch blog posts
  console.log('📝 Blog Posts:');
  const blogPosts = await fetchFromPayload('blog-posts');
  const blogSlugs = [];
  for (const post of blogPosts) {
    await convertToMarkdown(post, 'blog');
    blogSlugs.push(post.slug);
  }
  cleanupOrphanedFiles('blog', blogSlugs);

  // Fetch case studies
  console.log('\n📊 Case Studies:');
  const caseStudies = await fetchFromPayload('case-studies');
  const caseSlugs = [];
  for (const study of caseStudies) {
    await convertToMarkdown(study, 'hugo-migration/case-studies');
    caseSlugs.push(study.slug);
  }
  cleanupOrphanedFiles('hugo-migration/case-studies', caseSlugs);

  // Fetch resources
  console.log('\n📚 Resources:');
  const resources = await fetchFromPayload('resources');
  const resourceSlugs = [];
  for (const resource of resources) {
    await convertToMarkdown(resource, 'resources');
    resourceSlugs.push(resource.slug);
  }
  cleanupOrphanedFiles('resources', resourceSlugs);

  console.log('\n✅ Content fetch complete!\n');
}

main().catch(error => {
  console.error('❌ Error:', error);
  process.exit(1);
});
