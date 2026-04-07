---
name: docx
description: Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction.
triggers: When users need to create, modify, edit, or analyze .docx files, work with tracked changes, add comments, or perform any Word document tasks.
---

# DOCX Creation, Editing, and Analysis

## Overview

Work with .docx files for creation, editing, and analysis. A .docx file is essentially a ZIP archive containing XML files and other resources that you can read or edit.

## Workflow Decision Tree

### Reading/Analyzing Content
Use "Text extraction" or "Raw XML access" sections below

### Creating New Document
Use "Creating a new Word document" workflow

### Editing Existing Document
- **Your own document + simple changes**: Use "Basic OOXML editing" workflow
- **Someone else's document**: Use **"Redlining workflow"** (recommended default)
- **Legal, academic, business, or government docs**: Use **"Redlining workflow"** (required)

## Reading and Analyzing Content

### Text Extraction
Convert the document to markdown using pandoc for excellent structure preservation:

```bash
# Convert document to markdown with tracked changes
pandoc --track-changes=all path-to-file.docx -o output.md
# Options: --track-changes=accept/reject/all
```

### Raw XML Access
Needed for: comments, complex formatting, document structure, embedded media, and metadata.

#### Unpacking a file
```bash
python ooxml/scripts/unpack.py <office_file> <output_directory>
```

#### Key file structures
* `word/document.xml` - Main document contents
* `word/comments.xml` - Comments referenced in document.xml
* `word/media/` - Embedded images and media files
* Tracked changes use `<w:ins>` (insertions) and `<w:del>` (deletions) tags

## Creating a New Word Document

Use **docx-js** to create Word documents using JavaScript/TypeScript.

### Workflow
1. Read the docx-js documentation for detailed syntax, critical formatting rules, and best practices
2. Create a JavaScript/TypeScript file using Document, Paragraph, TextRun components
3. Export as .docx using Packer.toBuffer()

## Editing an Existing Word Document

Use the **Document library** (a Python library for OOXML manipulation).

### Workflow
1. Read the ooxml documentation for the Document library API and XML patterns
2. Unpack the document: `python ooxml/scripts/unpack.py <office_file> <output_directory>`
3. Create and run a Python script using the Document library
4. Pack the final document: `python ooxml/scripts/pack.py <input_directory> <office_file>`

## Redlining Workflow for Document Review

This workflow allows you to plan comprehensive tracked changes using markdown before implementing them in OOXML.

**Batching Strategy**: Group related changes into batches of 3-10 changes. Test each batch before moving to the next.

**Principle: Minimal, Precise Edits**
Only mark text that actually changes. Repeating unchanged text makes edits harder to review. Break replacements into: [unchanged text] + [deletion] + [insertion] + [unchanged text].

Example - Changing "30 days" to "60 days" in a sentence:
```python
# BAD - Replaces entire sentence
'<w:del><w:r><w:delText>The term is 30 days.</w:delText></w:r></w:del><w:ins><w:r><w:t>The term is 60 days.</w:t></w:r></w:ins>'

# GOOD - Only marks what changed
'<w:r w:rsidR="00AB12CD"><w:t>The term is </w:t></w:r><w:del><w:r><w:delText>30</w:delText></w:r></w:del><w:ins><w:r><w:t>60</w:t></w:r></w:ins><w:r w:rsidR="00AB12CD"><w:t> days.</w:t></w:r>'
```

### Tracked Changes Workflow

1. **Get markdown representation**: Convert document to markdown with tracked changes preserved:
   ```bash
   pandoc --track-changes=all path-to-file.docx -o current.md
   ```

2. **Identify and group changes**: Review the document and identify ALL changes needed, organizing them into logical batches.

   **Location methods** (for finding changes in XML):
   - Section/heading numbers
   - Paragraph identifiers if numbered
   - Grep patterns with unique surrounding text
   - Document structure (e.g., "first paragraph", "signature block")
   - **DO NOT use markdown line numbers** -- they don't map to XML structure

3. **Read documentation and unpack**:
   - Read the ooxml documentation, especially "Document Library" and "Tracked Change Patterns" sections.
   - Unpack the document: `python ooxml/scripts/unpack.py <file.docx> <dir>`

4. **Implement changes in batches**: For each batch:
   - **Map text to XML**: Grep for text in `word/document.xml` to verify how text is split across `<w:r>` elements.
   - **Create and run script**: Use `get_node` to find nodes, implement changes, then `doc.save()`.
   - Always grep `word/document.xml` immediately before writing a script to get current line numbers.

5. **Pack the document**: `python ooxml/scripts/pack.py unpacked reviewed-document.docx`

6. **Final verification**:
   ```bash
   pandoc --track-changes=all reviewed-document.docx -o verification.md
   grep "original phrase" verification.md   # Should NOT find it
   grep "replacement phrase" verification.md # Should find it
   ```

## Converting Documents to Images

```bash
# Convert DOCX to PDF
soffice --headless --convert-to pdf document.docx

# Convert PDF pages to JPEG images
pdftoppm -jpeg -r 150 document.pdf page
# Creates page-1.jpg, page-2.jpg, etc.
```

## Code Style Guidelines
When generating code for DOCX operations: write concise code, avoid verbose variable names and redundant operations, avoid unnecessary print statements.

## Dependencies

- **pandoc**: For text extraction
- **docx**: `npm install -g docx` (for creating new documents)
- **LibreOffice**: For PDF conversion
- **Poppler**: For pdftoppm (PDF to images)
- **defusedxml**: `pip install defusedxml` (for secure XML parsing)
