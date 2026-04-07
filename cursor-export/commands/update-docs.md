---
name: /update-docs
description: Sync documentation from source-of-truth files (package.json, .env.example). Generate CONTRIB.md and RUNBOOK.md.
---

# Update Documentation

Sync documentation from source-of-truth files to keep docs accurate and current.

## Workflow

1. **Read package.json scripts section**
   - Generate scripts reference table
   - Include descriptions from comments

2. **Read .env.example**
   - Extract all environment variables
   - Document purpose and format

3. **Generate docs/CONTRIB.md** with:
   - Development workflow
   - Available scripts
   - Environment setup
   - Testing procedures

4. **Generate docs/RUNBOOK.md** with:
   - Deployment procedures
   - Monitoring and alerts
   - Common issues and fixes
   - Rollback procedures

5. **Identify obsolete documentation**:
   - Find docs not modified in 90+ days
   - List for manual review

6. **Show diff summary**

## Source of Truth

Single source of truth: `package.json` and `.env.example`. All generated documentation derives from these files.
