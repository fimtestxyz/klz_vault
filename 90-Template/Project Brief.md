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
