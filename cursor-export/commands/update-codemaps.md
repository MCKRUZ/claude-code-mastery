---
name: /update-codemaps
description: Analyze codebase structure and update architecture documentation (codemaps) with freshness timestamps.
---

# Update Codemaps

Analyze the codebase structure and update architecture documentation.

## Workflow

1. **Scan all source files** for imports, exports, and dependencies

2. **Generate token-lean codemaps** in the following format:
   - `codemaps/architecture.md` — Overall architecture
   - `codemaps/backend.md` — Backend structure
   - `codemaps/frontend.md` — Frontend structure
   - `codemaps/data.md` — Data models and schemas

3. **Calculate diff percentage** from previous version

4. **If changes > 30%**, request user approval before updating

5. **Add freshness timestamp** to each codemap

6. **Save reports** to `.reports/codemap-diff.txt`

## Focus

Use TypeScript/Node.js for analysis. Focus on high-level structure, not implementation details. Keep codemaps token-lean so they can be included in AI context without consuming excessive tokens.
