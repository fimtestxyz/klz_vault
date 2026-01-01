<%*
// Prompt user for target domain and store it
const targetDomain = await tp.system.prompt("Target Domain");
-%>
---
tags:
  - framework-extraction
domain: "<%= targetDomain %>"
date-created: <% tp.date.now("YYYY-MM-DD") %>
related-domains: []
---

# 🧩 Framework Extraction: <%= targetDomain %>

status: 
  - [ ] Pillars
  - [ ] Relationships
  - [ ] Principles
  - [ ] Boundaries
  - [ ] Mental Models
  - [ ] Failure Patterns
  - [ ] Synthesis

> **Execution Protocol**  
> 1. **Complete sequentially** (≈20 mins total)  
> 2. Run LLM prompts via your AI plugin (Text Generator/Smart Connections)  
> 3. ✓ Check status boxes as completed  
> 4. *Pro tip: Paste all prompts at once to LLM with "Answer in this exact order"*

## 🔷 1. Core Pillars
```prompt
Identify exactly 3-5 foundational pillars that form the irreducible framework of `<%= targetDomain %>`. For each pillar: (a) Name it with a noun phrase, (b) Define its scope in ≤10 words, (c) State its primary function in the system.