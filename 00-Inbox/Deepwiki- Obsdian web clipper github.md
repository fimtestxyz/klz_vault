---
title: obsidianmd/obsidian-clipper
source: https://deepwiki.com/obsidianmd/obsidian-clipper
author:
  - "[[DeepWiki]]"
published: 2025-08-22
created: 2025-12-27
description: The Obsidian Web Clipper is an official cross-browser extension that captures and transforms web content into durable Markdown files stored in Obsidian vaults. Users can highlight text, extract clean
tags:
  - obsidian
  - deepwiki
---
Menu

## Overview

Relevant source files
- [README.md](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/README.md)
- [package-lock.json](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package-lock.json)
- [package.json](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package.json)
- [src/manifest.chrome.json](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.chrome.json)
- [src/manifest.firefox.json](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.firefox.json)
- [src/manifest.safari.json](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.safari.json)
- [src/utils/filters.ts](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/filters.ts)
- [src/utils/filters/reverse.ts](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/filters/reverse.ts)
- [src/utils/filters/safe\_name.ts](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/filters/safe_name.ts)
- [src/utils/string-utils.ts](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/string-utils.ts)
- [xcode/Obsidian Web Clipper/Obsidian Web Clipper.xcodeproj/project.pbxproj](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/xcode/Obsidian%20Web%20Clipper/Obsidian%20Web%20Clipper.xcodeproj/project.pbxproj)

The Obsidian Web Clipper is an official cross-browser extension that captures and transforms web content into durable Markdown files stored in Obsidian vaults. Users can highlight text, extract clean article content, and process web pages through customizable templates with AI-powered content interpretation.

The extension operates across Chrome, Firefox, Safari (including mobile), and other Chromium-based browsers, providing a consistent interface for web content capture while adapting to browser-specific capabilities and limitations.

## Installation

Install the Web Clipper from your browser's official extension store:

| Browser | Store | Compatibility |
| --- | --- | --- |
| Chrome, Brave, Arc, Orion | [Chrome Web Store](https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf) | All Chromium-based browsers |
| Firefox | [Firefox Add-Ons](https://addons.mozilla.org/en-US/firefox/addon/web-clipper-obsidian/) | Firefox Desktop & Mobile |
| Safari | [App Store](https://apps.apple.com/us/app/obsidian-web-clipper/id6720708363) | macOS, iOS, iPadOS |
| Microsoft Edge | [Edge Add-Ons](https://microsoftedge.microsoft.com/addons/detail/obsidian-web-clipper/eigdjhmgnaaeaonimdklocfekkaanfme) | Edge browser |

For development builds and local installation instructions, see the [Development Guide](https://deepwiki.com/obsidianmd/obsidian-clipper/10-development-guide).

**Sources:**[README.md 9-14](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/README.md#L9-L14)

## System Architecture

### High-Level Extension Components

The Web Clipper implements a Manifest V3 browser extension architecture with cross-browser compatibility layers:

```
Data & Storage LayerContent Processing PipelineBrowser Extension Infrastructuremanifest.chrome.json
Chrome/Edge configurationmanifest.firefox.json
Firefox configurationmanifest.safari.json
Safari configurationbackground.js
Service worker/background scriptcontent.js
DOM interaction & extractionpopup.js + popup.html
Main user interfacesettings.js + settings.html
Configuration interfaceside-panel.html
Chrome-only featuredefuddle library
Clean content extractionturndown library
HTML to Markdown conversionsrc/utils/filters.ts
applyFilters() function50+ FilterFunction implementations
blockquote, safe_name, markdown, etc.browser.storage API
Settings & template persistenceTemplate management
User-defined note structuresProperty type system
Metadata schema definitions
```

### Content Processing Flow

```
Web Page DOM
Current tab contentcontent.js
Content script injectiondefuddle.extract()
Clean content extractionhighlighter.css
Visual overlay systemturndown.turndown()
HTML to MarkdownapplyFilters()
src/utils/filters.ts:165Filter pipeline execution
markdown, safe_name, callout, etc.Variable substitution
{{content}}, {{title}}, {{url}}Template application
User-defined structureFinal Obsidian note
Markdown + YAML frontmatterHighlight extraction
Selected text ranges
```

**Sources:**[src/manifest.chrome.json 1-87](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.chrome.json#L1-L87) [src/manifest.firefox.json 1-89](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.firefox.json#L1-L89) [src/manifest.safari.json 1-86](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.safari.json#L1-L86) [src/utils/filters.ts 165-226](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/filters.ts#L165-L226) [package.json 41-52](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package.json#L41-L52)

## Core Components

## Cross-Browser Compatibility

The extension adapts to different browser capabilities through platform-specific manifest configurations:

### Browser-Specific Features

| Feature | Chrome/Edge | Firefox | Safari |
| --- | --- | --- | --- |
| Background Script | `service_worker` | `scripts` array | `service_worker` |
| Side Panel | ✓ (Chrome only) | ✗ | ✗ |
| Quick Clip Command | ✓ | ✗ | ✓ |
| Keyboard Shortcuts | Full support | Limited support | Full support |
| Mobile Support | ✗ | ✓ (Firefox Mobile) | ✓ (iOS/iPadOS) |

### Core Extension Components

| Component | File | Purpose |
| --- | --- | --- |
| Background Script | `background.js` | Extension lifecycle, message routing, storage management |
| Content Script | `content.js` | DOM interaction, content extraction, highlighter integration |
| Popup Interface | `popup.js`, `popup.html` | Main UI for content capture and template selection |
| Settings Page | `settings.js`, `settings.html` | Configuration, template management, AI provider setup |
| Side Panel | `side-panel.html` | Chrome-specific expanded interface |
| Highlighter Styles | `highlighter.css` | Visual overlay system for text selection |

### Manifest Configurations

Each browser requires specific manifest settings:

- **Chrome/Edge**: Uses `sidePanel` permission and `commands` for quick clip functionality
- **Firefox**: Requires `background.scripts` array instead of `service_worker`, different minimum version requirements
- **Safari**: Native app wrapper through Xcode project, platform-specific entitlements

**Sources:**[src/manifest.chrome.json 1-87](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.chrome.json#L1-L87) [src/manifest.firefox.json 1-89](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.firefox.json#L1-L89) [src/manifest.safari.json 1-86](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/manifest.safari.json#L1-L86)

## Key Dependencies and Third-Party Libraries

The extension integrates several specialized libraries for content processing and browser compatibility:

| Library | Version | Purpose | Key Functions |
| --- | --- | --- | --- |
| `webextension-polyfill` | ^0.12.0 | Cross-browser API compatibility | Unified browser API interface |
| `defuddle` | ^0.6.6 | Content extraction | Clean article content from web pages |
| `turndown` | ^7.2.0 | HTML to Markdown conversion | HTML element parsing and conversion |
| `dayjs` | ^1.11.13 | Date manipulation | Template date formatting and parsing |
| `lz-string` | ^1.5.0 | Data compression | Template storage optimization |
| `dompurify` | ^3.0.9 | HTML sanitization | Security filtering of extracted content |
| `mathml-to-latex` | ^1.4.1 | Math notation conversion | MathML to LaTeX transformation |
| `lucide` | ^0.359.0 | Icon system | UI iconography |

### Filter System Architecture

The filter system provides over 50 transformation functions accessible through the `applyFilters()` function:

```
Raw content stringapplyFilters()
src/utils/filters.ts:165splitFilterString()
Parse filter chainparseFilterString()
Extract parametersfilters object
src/utils/filters.ts:56Content Filters
markdown, remove_html, strip_mdFormat Filters
safe_name, title, capitalizeData Filters
date, calc, join, splitObsidian Filters
wikilink, callout, blockquoteProcessed string
```

**Sources:**[package.json 41-52](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package.json#L41-L52) [src/utils/filters.ts 56-108](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/filters.ts#L56-L108) [src/utils/filters.ts 165-226](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/src/utils/filters.ts#L165-L226)

## Build System and Development Architecture

The extension supports three browser targets through a unified Webpack-based build system:

### Build Configuration

```
Build OutputsWebpack Build ProcessSource CodeTypeScript sources
.ts filesSCSS stylesheets
.scss filesHTML templates
popup.html, settings.htmlLocalization files
src/_locales/*/messages.jsonwebpack.config.js
Multi-target configurationts-loader
TypeScript compilationsass-loader
SCSS processingcopy-webpack-plugin
Asset copyingdist/
Chrome/Chromium builddist_firefox/
Firefox builddist_safari/
Safari buildxcode/Obsidian Web Clipper/
Safari native app wrapper
```

### Build Commands

| Command | Target | Output Directory |
| --- | --- | --- |
| `npm run build:chrome` | Chrome, Edge, Brave, Arc | `dist/` |
| `npm run build:firefox` | Firefox Desktop & Mobile | `dist_firefox/` |
| `npm run build:safari` | Safari macOS/iOS/iPadOS | `dist_safari/` |
| `npm run build` | All browsers | All output directories |
| `npm run dev:chrome` | Development with watch mode | `dist/` |

### Safari Native Integration

Safari requires additional native app infrastructure through Xcode:

- **App Wrapper**: iOS and macOS applications that host the web extension
- **Entitlements**: Platform-specific security permissions
- **App Store Distribution**: Native app packaging for distribution

**Sources:**[package.json 5-19](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package.json#L5-L19) [xcode/Obsidian Web Clipper/Obsidian Web Clipper.xcodeproj/project.pbxproj 1-400](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/xcode/Obsidian%20Web%20Clipper/Obsidian%20Web%20Clipper.xcodeproj/project.pbxproj#L1-L400)

## Build System and Multi-Browser Support

```
Browser BuildsBuild ProcessSource CodeTypeScript Files
.ts sourcesSCSS Files
Styling systemHTML Templates
popup.html, settings.htmlwebpack.config.js
Build configurationts-loader
TypeScript compilationsass-loader
SCSS processingdist/
Chrome/Chromium builddist_firefox/
Firefox builddist_safari/
Safari + Xcode projectXcode Project
iOS/macOS Safari extension
```

The build system creates three distinct distributions:

- **Chrome/Chromium**: Standard extension format in `dist/`
- **Firefox**: Firefox-compatible build in `dist_firefox/` with background scripts array
- **Safari**: Native Safari extension in `dist_safari/` with accompanying Xcode project for iOS/macOS

Build commands from `package.json`:

- `npm run build:chrome` - Chrome/Edge/Brave build
- `npm run build:firefox` - Firefox build
- `npm run build:safari` - Safari build
- `npm run build` - All three builds

**Sources:**[package.json 5-19](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package.json#L5-L19) [xcode/Obsidian Web Clipper/Obsidian Web Clipper.xcodeproj/project.pbxproj 1-1060](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/xcode/Obsidian%20Web%20Clipper/Obsidian%20Web%20Clipper.xcodeproj/project.pbxproj#L1-L1060)

## Key Dependencies and Libraries

| Library | Purpose | Usage |
| --- | --- | --- |
| `defuddle` | Content extraction | Clean article content from web pages |
| `turndown` | HTML to Markdown | Convert extracted HTML to Markdown format |
| `dayjs` | Date handling | Date parsing and formatting in templates |
| `lz-string` | Compression | Compress templates to reduce storage space |
| `dompurify` | HTML sanitization | Sanitize HTML content for security |
| `mathml-to-latex` | Math conversion | Convert MathML to LaTeX notation |
| `webextension-polyfill` | Browser compatibility | Cross-browser API compatibility |

The extension leverages these libraries to create a robust content processing pipeline that handles diverse web content types while maintaining security and compatibility across browser platforms.

**Sources:**[package.json 41-52](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/package.json#L41-L52) [README.md 69-78](https://github.com/obsidianmd/obsidian-clipper/blob/b5388960/README.md#L69-L78)