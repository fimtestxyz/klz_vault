#!/usr/bin/env bash
# ------------------------------------------------------------
# create_obsidian_templates.sh
# ------------------------------------------------------------
# Purpose:  Build a starter set of Obsidian template files
#           under ~/Documents/klz_vault/90-Template/
# ------------------------------------------------------------

# ---- 1. Define the target directory ---------------------------------
TEMPLATE_DIR="${HOME}/Documents/klz_vault/90-Template"

# ---- 2. Create the directory (including any missing parents) -------
mkdir -p "${TEMPLATE_DIR}" || {
    echo "❌  Could not create directory ${TEMPLATE_DIR}"
    exit 1
}
echo "📁  Created/verified template folder: ${TEMPLATE_DIR}"

# ---- 3. Helper: write a file only if it does NOT already exist -----
write_if_missing() {
    local filepath="$1"
    local content="$2"

    if [[ -e "${filepath}" ]]; then
        echo "⚠️  ${filepath} already exists – skipping"
    else
        cat > "${filepath}" <<< "${content}"
        echo "✅  Created ${filepath}"
    fi
}

# ---- 4. Template contents -------------------------------------------

# 4.1 Daily Note (core placeholders)
read -r -d '' DAILY_NOTE <<'EOF'
---
date: {{date}}
tags: daily
---

# {{title}}

## 🌞 Morning

- Mood:
- Top 3 priorities:

## 📋 Tasks

- [ ] Task 1
- [ ] Task 2

## 🗒️ Notes

{{cursor}}
EOF

# 4.2 Weekly Review (core placeholders)
read -r -d '' WEEKLY_REVIEW <<'EOF'
---
date: {{date}}
tags: weekly-review
---

# Weekly Review – Week {{date:WW}}

## ✅ Wins
- 

## ❌ Challenges
- 

## 📈 Metrics
- Hours worked: 
- Completed tasks: 

## 🎯 Goals for next week
- 

## 📚 Learning
- 
EOF

# 4.3 Project Brief (Templater syntax)
read -r -d '' PROJECT_BRIEF <<'EOF'
---
title: <% tp.file.title %>
date: <% tp.date.now("YYYY-MM-DD") %>
tags: project
---

# <% tp.file.title %> – Project Brief

**Owner:** <% tp.prompt("Project owner") %>  
**Start date:** <% tp.date.now("YYYY-MM-DD") %>  
**Target finish:** <% tp.prompt("Target finish date (YYYY-MM-DD)") %>  

## Objective
<% tp.prompt("One‑sentence objective") %>

## Scope
- 

## Stakeholders
- <% tp.prompt("Stakeholder 1") %>
- <% tp.prompt("Stakeholder 2") %>

## Milestones
| Milestone | Due |
|-----------|-----|
| <% tp.prompt("Milestone 1") %> | <% tp.prompt("Due date") %> |
| <% tp.prompt("Milestone 2") %> | <% tp.prompt("Due date") %> |

## Risks & Mitigations
- 

## Next steps
- <% tp.cursor %>
EOF

# 4.4 Meeting Note (Templater syntax)
read -r -d '' MEETING_NOTE <<'EOF'
---
date: <% tp.date.now("YYYY-MM-DD") %>
title: <% tp.file.title %>
tags: meeting
---

# Meeting: <% tp.file.title %>

**Date:** <% tp.date.now("dddd, MMMM Do YYYY") %>  
**Time:** <% tp.date.now("HH:mm") %>  
**Location:** <% tp.prompt("Where?") %>

## Attendees
<% tp.prompt("List attendees (comma‑separated)").split(",").map(a => "- " + a.trim()).join("\n") %>

## Agenda
- <% tp.prompt("First agenda item") %>
- <% tp.prompt("Second agenda item") %>

## Notes
<% tp.cursor %>

## Action Items
- [ ] <% tp.prompt("First action item") %>
- [ ] <% tp.prompt("Second action item") %>
EOF

# 4.5 Book Summary (core placeholders)
read -r -d '' BOOK_SUMMARY <<'EOF'
---
date: {{date}}
tags: book-summary
---

# {{title}} – Book Summary

**Author:**  
**Finished on:** {{date}}

## TL;DR
> 

## Key Take‑aways
- 

## Quotes
> 

## Personal reflections
- 
EOF

# ---- 5. Write the files ---------------------------------------------
write_if_missing "${TEMPLATE_DIR}/Daily Note.md"          "${DAILY_NOTE}"
write_if_missing "${TEMPLATE_DIR}/Weekly Review.md"      "${WEEKLY_REVIEW}"
write_if_missing "${TEMPLATE_DIR}/Project Brief.md"      "${PROJECT_BRIEF}"
write_if_missing "${TEMPLATE_DIR}/Meeting Note.md"       "${MEETING_NOTE}"
write_if_missing "${TEMPLATE_DIR}/Book Summary.md"       "${BOOK_SUMMARY}"

# ---- 6. Final message ------------------------------------------------
echo "🎉  All done! Your templates live in ${TEMPLATE_DIR}"
echo "   • Open Obsidian → Settings → Core Plugins → Template"
echo "   • Point the plugin to the same folder."
echo "   • Use your hot‑key (default Ctrl+T / ⌘+T) to insert any of them."
