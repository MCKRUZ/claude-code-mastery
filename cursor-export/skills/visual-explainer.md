---
name: visual-explainer
description: Generate beautiful, self-contained HTML pages that visually explain systems, code changes, plans, and data. Also use proactively when rendering complex tables (4+ rows or 3+ columns).
triggers: When the user asks for a diagram, architecture overview, diff review, plan review, project recap, comparison table, or any visual explanation of technical concepts.
---

# Visual Explainer

Generate self-contained HTML files for technical diagrams, visualizations, and data tables. Always open the result in the browser. Never fall back to ASCII art when this skill is loaded.

**Proactive table rendering.** When you're about to present tabular data as an ASCII box-drawing table in the terminal (comparisons, audits, feature matrices, status reports, any structured rows/columns), generate an HTML page instead. The threshold: if the table has 4+ rows or 3+ columns, it belongs in the browser. Don't wait for the user to ask -- render it as HTML automatically and tell them the file path.

## Workflow

### 1. Think (5 seconds, not 5 minutes)

Before writing HTML, commit to a direction.

**Who is looking?** A developer understanding a system? A PM seeing the big picture? A team reviewing a proposal? This shapes information density and visual complexity.

**What type of diagram?** Architecture, flowchart, sequence, data flow, schema/ER, state machine, mind map, data table, timeline, or dashboard. Each has distinct layout needs.

**What aesthetic?** Pick one and commit:
- Monochrome terminal (green/amber on black, monospace everything)
- Editorial (serif headlines, generous whitespace, muted palette)
- Blueprint (technical drawing feel, grid lines, precise)
- Neon dashboard (saturated accents on deep dark, glowing edges)
- Paper/ink (warm cream background, hand-drawn feel, sketchy borders)
- Hand-drawn / sketch (wiggly lines, informal whiteboard feel)
- IDE-inspired (borrow a real color scheme: Dracula, Nord, Catppuccin, Solarized, Gruvbox, One Dark)
- Data-dense (small type, tight spacing, maximum information)
- Gradient mesh (bold gradients, glassmorphism, modern SaaS feel)

Vary the choice each time. If the last diagram was dark and technical, make the next one light and editorial.

### 2. Structure

**Choosing a rendering approach:**

| Diagram type | Approach | Why |
|---|---|---|
| Architecture (text-heavy) | CSS Grid cards + flow arrows | Rich card content needs CSS control |
| Architecture (topology-focused) | **Mermaid** | Connections need automatic edge routing |
| Flowchart / pipeline | **Mermaid** | Automatic node positioning and edge routing |
| Sequence diagram | **Mermaid** | Lifelines, messages, and activation boxes need automatic layout |
| Data flow | **Mermaid** with edge labels | Connections need automatic edge routing |
| ER / schema diagram | **Mermaid** | Relationship lines need auto-routing |
| State machine | **Mermaid** | State transitions with labeled edges need automatic layout |
| Mind map | **Mermaid** | Hierarchical branching needs automatic positioning |
| Data table | HTML `<table>` | Semantic markup, accessibility, copy-paste behavior |
| Timeline | CSS (central line + cards) | Simple linear layout doesn't need a layout engine |
| Dashboard | CSS Grid + Chart.js | Card grid with embedded charts |

**Mermaid theming:** Always use `theme: 'base'` with custom `themeVariables` so colors match your page palette. Use `look: 'handDrawn'` for sketch aesthetic or `look: 'classic'` for clean lines.

**Mermaid zoom controls:** Always add zoom controls (+/-/reset buttons) to every Mermaid container. Complex diagrams render at small sizes and need zoom to be readable. Include Ctrl/Cmd+scroll zoom on the container.

### 3. Style

Apply these principles to every diagram:

**Typography is the diagram.** Pick a distinctive font pairing from Google Fonts. A display/heading font with character, plus a mono font for technical labels. Never use Inter, Roboto, Arial, or system-ui as the primary font.

**Color tells a story.** Use CSS custom properties for the full palette. Define at minimum: `--bg`, `--surface`, `--border`, `--text`, `--text-dim`, and 3-5 accent colors. Each accent should have a full and a dim variant. Support both light and dark themes:

```css
/* Light-first (editorial, paper/ink, blueprint): */
:root { /* light values */ }
@media (prefers-color-scheme: dark) { :root { /* dark values */ } }

/* Dark-first (neon, IDE-inspired, terminal): */
:root { /* dark values */ }
@media (prefers-color-scheme: light) { :root { /* light values */ } }
```

**Surfaces whisper, they don't shout.** Build depth through subtle lightness shifts (2-4% between levels), not dramatic color changes.

**Backgrounds create atmosphere.** Don't use flat solid colors for the page background. Subtle gradients, faint grid patterns via CSS, or gentle radial glows behind focal areas.

**Visual weight signals importance.** Executive summaries and key metrics should dominate the viewport on load. Reference sections should be compact. Use `<details>/<summary>` for sections that are useful but not primary.

**Surface depth creates hierarchy.** Vary card depth to signal what matters. Hero sections get elevated shadows. Body content stays flat. Code blocks feel recessed.

**Animation earns its place.** Staggered fade-ins on page load guide the eye. Mix animation types by role: `fadeUp` for cards, `fadeScale` for KPIs and badges, `drawIn` for SVG connectors, `countUp` for hero numbers. Always respect `prefers-reduced-motion`.

### 4. Deliver

**Output location:** Write to a descriptive filename based on content: `modem-architecture.html`, `pipeline-flow.html`, `schema-overview.html`.

**Open in browser** and tell the user the file path so they can re-open or share it.

## Diagram Types

### Architecture / System Diagrams
**Text-heavy overviews** (card content matters more than connections): CSS Grid with explicit row/column placement. Cards with colored borders and monospace labels.

**Topology-focused diagrams** (connections matter more than card content): Use Mermaid with custom `themeVariables`.

### Flowcharts / Pipelines
Use Mermaid. `graph TD` for top-down or `graph LR` for left-right. Color-code node types.

### Sequence Diagrams
Use Mermaid. Style actors and messages via CSS overrides.

### Data Flow Diagrams
Use Mermaid with edge labels. Thicker, colored edges for primary flows.

### Schema / ER Diagrams
Use Mermaid's `erDiagram` syntax with entity attributes.

### State Machines / Decision Trees
Use Mermaid's `stateDiagram-v2` for states with labeled transitions. **Caveat:** If labels need colons, parentheses, or HTML entities, use `flowchart LR` instead (stateDiagram-v2 has a strict label parser).

### Mind Maps
Use Mermaid's `mindmap` syntax for hierarchical branching.

### Data Tables / Comparisons / Audits
Use a real `<table>` element. Layout patterns:
- Sticky `<thead>` for long tables
- Alternating row backgrounds
- First column optionally sticky for wide tables
- Responsive wrapper with `overflow-x: auto`
- Row hover highlight

Status indicators (use styled `<span>` elements, never emoji):
- Match/pass/yes: green indicator
- Gap/fail/no: red indicator
- Partial/warning: amber indicator
- Neutral/info: muted badge

### Timeline / Roadmap Views
Vertical or horizontal timeline with a central line. Phase markers as circles. Content cards branching alternately. Color progression from past (muted) to future (vivid).

### Dashboard / Metrics Overview
Card grid layout. Hero numbers large and prominent. Sparklines via inline SVG. Progress bars via CSS. For charts, use Chart.js via CDN. KPI cards with trend indicators.

## File Structure

Every diagram is a single self-contained `.html` file. No external assets except CDN links (fonts, optional libraries).

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Descriptive Title</title>
  <link href="https://fonts.googleapis.com/css2?family=...&display=swap" rel="stylesheet">
  <style>
    /* CSS custom properties, theme, layout, components -- all inline */
  </style>
</head>
<body>
  <!-- Semantic HTML: sections, headings, lists, tables, inline SVG -->
</body>
</html>
```

## Quality Checks

Before delivering, verify:
- **The squint test**: Can you still perceive hierarchy when blurred?
- **The swap test**: Would generic dark theme make this indistinguishable from a template?
- **Both themes**: Toggle between light and dark. Both should look intentional.
- **Information completeness**: Does the diagram actually convey what was asked for?
- **No overflow**: No content should clip or escape its container at any width.
- **Mermaid zoom controls**: Every Mermaid container must have zoom controls.
- **File opens cleanly**: No console errors, no broken font loads, no layout shifts.
