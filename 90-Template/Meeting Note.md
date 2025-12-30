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
