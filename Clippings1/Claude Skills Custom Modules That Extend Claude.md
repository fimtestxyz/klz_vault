---
title: "Claude Skills: Custom Modules That Extend Claude"
source: "https://www.datacamp.com/tutorial/claude-skills"
author:
  - "[[Aashi Dutt]]"
published: 2025-11-10
created: 2025-12-28
description: "Claude Skills are modular, reusable task modules that extend Claude’s abilities across apps and API, enabling consistent, code-driven automation."
tags:
  - "clippings"
---
Whether you’re chatting in [Claude apps](https://www.claude.com/download), coding in [Claude Code](https://www.claude.com/product/claude-code), or automating workflows via the [Developer API](https://www.claude.com/platform/api), the same Skill can be versioned once, centrally managed, and auto-invoked when the task matches its purpose. This leads to consistent quality and faster turnarounds. Thus, one Skill to reusable everywhere.

In this tutorial, we’ll apply an “Auto-Invoice Generator” Skill across the Claude app and the API to parse an Excel file and output a ready-to-send invoice.

### Claude App

Claude Skills live in your Claude App and auto-activate when a request matches their purpose. You enable them once in Settings, then just describe the outcome you want. Claude loads the right Skill and shows it in the reasoning view.

Note: This feature is only available for the Pro, Max, Team, and Enterprise users.

You can also find a list of Skills like algorithmic-art, artifacts-builder, brand-guidelines, canvas-design, internal-comms, mcp-builder, slack-gif-creator, etc, to add in your conversations with Claude.

Click on upload skill and upload a zip file containing the SKILL.md file. Here are the file requirements.

- ZIP file that includes exactly one SKILL.md file at the root level
    
- `SKILL.md` contains a skill name and description formatted in YAML
    

The `SKILL.md` file used in this tutorial looks like this:

`name: "auto-invoice-generator-monthly-articles" description: "Generate monthly invoices for written content from simple line items. Produces a branded PDF or editable DOCX/RTF invoice and, optionally, a one-page timesheet if article titles/links are provided."`

[Powered By](https://www.datacamp.com/datalab) 

![Uploading skills](https://media.datacamp.com/cms/2e6ef7411fd6b347f80f8618f1ac587c.png)

Once you upload the Skill, Claude automatically recognizes it and opens a new chat where it’s ready to use.

![New chat with skill enabled](https://media.datacamp.com/cms/a2f19278729bfbe5949789f442768cce.png)

How does this affect usage in chats?

- You don’t have to “turn on” a Skill inside each conversation. When relevant, Claude auto invokes enabled Skills and shows them in the reasoning view for transparency.
- Disabling a Skill prevents it from being considered in any chat until you re-enable it.
- If your organization pins a canonical set of Skills like brand templates, reporting, etc, keeping them enabled ensures consistent outputs every time.

![](https://media.datacamp.com/cms/7dfbdbca119b6883b2b15e605c2c7157.png)

![](https://media.datacamp.com/cms/34470162d8593808ce5577d19f513fa9.png)

Next, I passed my own timesheet and asked Claude to build an editable invoice.

![](https://media.datacamp.com/cms/3c4dec02921ccc261e0a34c1a57c67a4.png)

Claude spotted the Skill on its own, read the Excel file, and returned an editable Word invoice, which can also be exported to PDF or Word. The invoice layout looks clean, and the subtotal and total are also on point. It adhered to the prompt, and both editable DOCX and formatted PDF files styling matched the Skill’s brand settings.

Now let’s run the same example using the API.

### Claude Developer Platform (API)

Claude skills can also be accessed via the Claude API. In this section, we’ll explore how we can mimic the Claude app interface via the Claude API.

#### Step 1: Prerequisites

Start by installing all the runtime dependencies:

- `Anthropic` for the Claude Messages API
    
- `pandas` and `openpyxl` to read timesheets from Excel
    
- `reportlab` to generate a fallback PDF invoice locally 
    

`!pip -q install anthropic pandas openpyxl reportlab`

[Powered By](https://www.datacamp.com/datalab) 

Now we have all the dependencies installed.  Next, we can configure our API key.

#### Step 2: Configure your API key

Before we can call the Messages API, we need to authenticate. This step creates a single, reusable `anthropic.Client` with the API key. 

`import os, json, sys, re import anthropic from datetime import datetime, timedelta API_KEY = "YOUR_ANTHROPIC_API_KEY" client = anthropic.Client(api_key=API_KEY)`

[Powered By](https://www.datacamp.com/datalab) 

Log in to Anthropic Console and locate the API keys tab under Settings. Click on Create Key and copy your Anthropic API key.