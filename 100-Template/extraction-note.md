<%*
// 1. Prompt the user for the domain
const targetDomain = await tp.system.prompt("Target Domain");

// 2. Create a "slug" (lowercase, replaces spaces/special chars with underscores)
const targetDomainSlug = targetDomain
  .toLowerCase()
  .replace(/[^a-z0-9]+/g, '_')
  .replace(/^_+|_+$/g, '');

// 3. Rename the file
await tp.file.rename(`knowledge_extraction_${targetDomainSlug}`);
-%>
---
tags:
  - framework-extraction
domain: "<% targetDomain %>"
date-created: <% tp.date.now("YYYY-MM-DD") %>
related-domains: []
---

# 🧩 Knowledge Framework Extraction for domain: <% targetDomain %>

Area:
  - Pillars
  - Relationships
  - Principles
  - Boundaries
  - Mental Models
  - Failure Patterns
  - Synthesis

> **Execution Protocol** > 1. **Complete sequentially** > 2. Run LLM prompts via your AI plugin (Text Generator/Smart Connections)  
> 3. ✓ Check status areas above as completed  

## 🔷 1. Core Pillars
```prompt
Identify exactly 3-5 foundational pillars that form the irreducible framework of `<% targetDomain %>`. For each pillar: (a) Name it with a noun phrase, (b) Define its scope in ≤10 words, (c) State its primary function in the system.