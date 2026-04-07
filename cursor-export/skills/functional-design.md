---
name: functional-design
description: End-to-end UI/UX creation -- from functional spec to visual design to working code. Discovers requirements, specs behavior (state machines, data flows, edge cases), generates a design system, produces an HTML preview, then builds actual project components with all states.
triggers: When planning and building new features, screens, or applications. When a UI feels "off" or when nobody has defined what a feature does or how it looks.
---

# Functional Design Skill

End-to-end UI/UX creation: **spec the function, design the visuals, build the code.**

This skill goes from requirements discovery through working components. It produces functional specifications (state machines, data flows, edge cases), generates a visual design system, creates an HTML preview for approval, then builds actual project files with every state implemented. No more happy-path-only UIs.

## When to Use This Skill

- Planning AND building a new feature, screen, or application
- A UI feels "off" but no one can articulate why (usually a functional gap, not a visual one)
- When the spec says "add a dashboard" but nobody has defined what it *does* or how it *looks*
- Refactoring a feature that has grown organically without a coherent interaction model
- When you want working UI code that handles every state -- not just the happy path

## When NOT to Use This Skill

- Conducting user research or creating personas (use a research skill)
- Performance optimization or backend architecture (use an architecture skill)
- Simple one-off component with clear requirements (just build it directly)

---

## Core Protocol: Eight Phases

**Phases 1-5**: Functional Spec (what it does, how it behaves)
**Phase 6**: Visual Design System (how it looks)
**Phase 7**: Preview (approve before building)
**Phase 8**: Component Implementation (working code)

**RULE: Never skip Phase 1. Never jump to component specs without completing Phase 2. Never write code without completing Phase 6.**

### Phase 1: Functional Discovery

Before any design work, answer these questions. If the user can't answer them, help them figure it out. Do NOT proceed until these are resolved.

#### Mandatory Questions

**Users & Roles**
1. Who uses this? List every distinct user role.
2. For each role: what are their top 3 tasks? (Not features -- tasks. "Find overdue invoices" not "Invoice page.")
3. What does each role NEVER need to see or do?

**Data & Domain**
4. What data flows through this interface? Name the core entities.
5. Where does the data come from? (API, local state, user input, real-time stream, file upload)
6. What are the business rules that constrain this data? (e.g., "An order can't be edited after shipping")
7. What's the data volume? (10 items vs. 10,000 vs. infinite scroll)

**Context & Constraints**
8. Where does the user arrive FROM? (Navigation context, deep link, notification, email link)
9. Where do they go AFTER? (Next step in workflow, back to list, external system)
10. What devices/viewport sizes must this work on? Any offline requirements?
11. What's the performance budget? (Time to interactive, acceptable loading time)

**Success Criteria**
12. How do we know this feature is working? (Not metrics -- observable user outcomes)
13. What's the worst thing that could go wrong? (Data loss, wrong action taken, confused user)

#### Output: Functional Requirements Brief

```markdown
## Functional Requirements Brief: [Feature Name]

### User Roles
| Role | Top Tasks | Excluded From |
|------|-----------|---------------|

### Core Entities
| Entity | Source | Volume | Business Rules |
|--------|--------|--------|----------------|

### Context
- Entry points: [how users arrive]
- Exit points: [where users go next]
- Device requirements: [viewport/offline needs]
- Performance budget: [time constraints]

### Success Criteria
- [Observable outcome 1]
- [Observable outcome 2]

### Risk: What Could Go Wrong
- [Risk 1 and mitigation]
- [Risk 2 and mitigation]
```

---

### Phase 2: Architecture Mapping

With requirements in hand, map the functional architecture.

#### 2A: Screen/View Inventory

List every distinct view the user will encounter. For each:

```markdown
### View: [Name]
- **Purpose**: [One sentence -- what the user accomplishes here]
- **Entry conditions**: [What must be true for the user to reach this view]
- **Primary action**: [The #1 thing the user does here]
- **Secondary actions**: [Other things available but not primary]
- **Data requirements**: [What data must be loaded to render this view]
- **Exit points**: [Where the user goes from here]
```

#### 2B: Navigation Architecture

```markdown
### Navigation Tree
- [Root]
  - [Section A]
    - [View A1] -- primary action: [...]
    - [View A2] -- primary action: [...]
  - [Section B]
    - [View B1] -- primary action: [...]

### Navigation Rules
- Deep link support: [which views are directly addressable]
- Back button behavior: [what "back" means in each context]
- Breadcrumb logic: [how the user knows where they are]
- Unsaved changes: [what happens if user navigates away with dirty state]
```

#### 2C: Data Flow Architecture

For each data concern, specify:

```markdown
### Data Architecture
| Data | Owner | Cache Strategy | Refresh Trigger | Survives Refresh? |
|------|-------|---------------|-----------------|-------------------|
| [Entity list] | Server | Stale-while-revalidate | Navigation, pull-to-refresh | Yes (cache) |
| [Form draft] | Client | Session storage | Manual save | Yes |
| [UI state] | Client | Memory only | -- | No |
```

#### 2D: State Management Strategy

Classify every piece of state:

| Category | Examples | Storage | Lifetime |
|----------|----------|---------|----------|
| **Server state** | Entity data, user profile | API + cache | Until invalidated |
| **Client state** | Form values, wizard step | Component/store | Until submitted or abandoned |
| **UI state** | Sidebar open, sort order | Memory/URL | Current session or persisted in URL |
| **Derived state** | Filtered list, computed totals | Computed | Recomputed on dependency change |

---

### Phase 3: Behavioral Specification

For each component or feature, produce a behavioral spec.

#### 3A: Component Behavior Specs

```markdown
### Component: [Name]

**States**: [List all possible states]
**Data In**: [What data this component receives]
**Data Out**: [What events/data this component emits]

| Current State | Event | Guard | Action | Next State |
|--------------|-------|-------|--------|------------|
| idle | user clicks edit | hasPermission | enable form fields | editing |
| editing | user clicks save | form.valid | submit to API | submitting |
| editing | user clicks cancel | -- | discard changes, confirm if dirty | idle |
| submitting | API success | -- | show success feedback | idle |
| submitting | API failure | -- | show error, preserve form data | editing |
```

#### 3B: User Flow Maps

For each primary task, map:
1. **Happy path**: The ideal journey from start to completion
2. **Error paths**: Every point where something can fail, and what happens
3. **Edge cases**: Empty states, large data sets, concurrent edits, expired sessions

#### 3C: Non-Happy State Specs

For every view, specify:

| State | What the User Sees | Available Actions | Tone |
|-------|--------------------|-------------------|------|
| Empty (first run) | [Guidance to get started] | [Primary CTA] | Welcoming, instructional |
| Empty (filtered) | [Explanation + clear filters] | [Clear filters, broaden search] | Helpful |
| Loading (initial) | [Skeleton/spinner spec] | [None or cancel] | -- |
| Loading (refresh) | [Preserve content + indicator] | [Continue interacting] | Non-blocking |
| Error (network) | [Offline message] | [Retry, work offline] | Reassuring |
| Error (server) | [Generic error] | [Retry, contact support] | Apologetic |
| Error (permission) | [Access denied] | [Request access, go back] | Factual |

#### 3D: Responsive Behavior Specs

Not layout breakpoints -- **functional** differences:

| Breakpoint | Functional Difference |
|-----------|----------------------|
| Mobile | Bulk actions hidden; swipe-to-action replaces hover menus; form fields stack |
| Tablet | Side panel replaces modal for detail views; touch targets enlarged |
| Desktop | Keyboard shortcuts active; hover previews enabled; multi-column layout |

---

### Phase 4: Interaction Design

#### 4A: Microinteraction Specs

Using Dan Saffer's framework (Trigger, Rules, Feedback, Loops & Modes):

```markdown
### Microinteraction: [Name]

**Trigger**: [What initiates this interaction -- user action or system event]
**Rules**: [What happens when triggered -- the logic]
**Feedback**: [How the user knows something happened -- visual, auditory, haptic]
**Loops & Modes**: [Does this repeat? Are there different modes?]
```

#### 4B: Error Flow Architecture

Map the complete error flow:

| Failure Point | Error Type | User Impact | Recovery Path | Fallback |
|--------------|------------|-------------|---------------|----------|
| API call | Network timeout | Can't load data | Auto-retry 3x, then manual retry | Show cached data if available |
| Form submit | Validation (client) | Can't proceed | Highlight fields, preserve input | -- |
| Form submit | Validation (server) | Can't proceed | Show server errors on fields | -- |
| Form submit | Conflict (409) | Stale data | Show diff, let user choose | -- |
| Auth | Token expired | Action rejected | Silent refresh, retry action | Redirect to login |

#### 4C: Complex Component State Machines

For components with rich interaction (modals, wizards, data tables, inline editors), define complete state machines with all transitions.

#### 4D: Transition Intent Specs

Specify what motion **communicates**, not the CSS:

| Transition | Intent | Duration Class |
|-----------|--------|---------------|
| View enters | "New content has arrived" | Standard (200-300ms) |
| Item deleted | "This is gone" with undo affordance | Quick (150ms) + undo window |
| Error appears | "Attention needed" | Immediate + subtle pulse |
| Loading to loaded | "Content is ready, here's what changed" | Staggered reveal |

---

### Phase 5: Validation & Handoff

#### 5A: Nielsen's Heuristics Audit

Check the spec against all 10:

| # | Heuristic | Status | Notes |
|---|-----------|--------|-------|
| 1 | Visibility of system status | | Loading states defined? Progress indicators? |
| 2 | Match between system and real world | | Domain language used? Familiar mental models? |
| 3 | User control and freedom | | Undo/redo? Cancel? Emergency exits? |
| 4 | Consistency and standards | | Same patterns for same actions? |
| 5 | Error prevention | | Confirmation for destructive actions? Constraints that prevent errors? |
| 6 | Recognition rather than recall | | Context visible? Options surfaced? |
| 7 | Flexibility and efficiency | | Power user shortcuts? Customization? |
| 8 | Aesthetic and minimalist design | | Every element serves a purpose? |
| 9 | Help users recognize, diagnose, recover from errors | | Error messages actionable? Recovery paths clear? |
| 10 | Help and documentation | | Contextual help? Onboarding? |

#### 5B: Norman's 7 Stages Check

For each primary task, verify the user can:
1. **Form the goal** -- Is the task discoverable?
2. **Form the intention** -- Is it clear HOW to start?
3. **Specify the action** -- Are the controls obvious?
4. **Execute the action** -- Can they physically do it?
5. **Perceive the result** -- Is feedback visible and immediate?
6. **Interpret the result** -- Does the feedback make sense?
7. **Evaluate the outcome** -- Does the user know they succeeded?

#### 5C: Developer Handoff Package

```markdown
## Handoff: [Feature Name]

### Behaviors (not obvious from visual design)
- [Behavior 1: e.g., "Table remembers sort order across sessions via URL params"]
- [Behavior 2: e.g., "Form auto-saves draft every 30s to session storage"]

### Edge Cases to Implement
- [ ] First-time user with no data
- [ ] User with 10,000+ items (pagination/virtualization required)
- [ ] Concurrent edit by another user
- [ ] Session expiry during multi-step flow
- [ ] Browser back button during unsaved changes

### Data Requirements
| Endpoint/Query | When Called | Cache Behavior | Error Handling |
|---------------|------------|----------------|----------------|

### QA Checklist
- [ ] All empty states render correctly
- [ ] All error states render correctly
- [ ] Loading states don't flash
- [ ] Keyboard navigation works for all primary actions
- [ ] Screen reader announces state changes
- [ ] Back button behavior matches spec
- [ ] Deep links resolve to correct view state
```

---

### Phase 6: Visual Design System

#### 6A: Detect Existing Project

Before generating anything visual, read the project:

1. **Package manager**: Read `package.json` for framework and styling dependencies
2. **Theme config**: Read `tailwind.config.ts/js`, `theme.ts`, CSS custom properties, or equivalent
3. **Global styles**: Read `index.css`, `global.css`, or equivalent base styles
4. **Existing components**: Scan shared/common component directory for established patterns

**If existing design system found**: ADOPT it. Only fill gaps.
**If no existing design system**: Generate opinionated defaults, then present for approval.

#### 6B: Generate Design Tokens

Produce a complete token set:

- **Colors**: Surface hierarchy (5 levels), accent + hover + muted, semantic (success/warning/error/info) + muted variants, border colors
- **Typography**: Font families (UI + mono), size scale, weight scale, line heights
- **Spacing**: Base unit (4px), scale, density mode (compact/comfortable/spacious)
- **Borders**: Radius scale, border colors, focus ring
- **Motion**: Duration scale, easing functions, animation definitions

#### 6C: Define Component Styles

For each component type needed by the spec:

- **Buttons**: Variants, sizes, all states (default/hover/active/focus/disabled/loading)
- **Cards**: Variants (KPI, content, status-decorated, clickable)
- **Badges**: Status color mapping, sizes, pulse for active states
- **Tables**: Header, row, hover, sort indicators, responsive behavior
- **Forms**: Input, label, help text, error text, disabled state
- **Navigation**: Active, hover, inactive, mobile collapse
- **Skeletons**: Match loaded content layout exactly
- **Empty states**: Centered layout with icon, heading, description, CTA
- **Error states**: Banner, inline, full-page variants with retry
- **Toasts**: Success/error/warning/info variants, positioning, auto-dismiss

---

### Phase 7: Preview Generation

#### 7A: Generate HTML Preview

Create a single self-contained HTML file that shows the entire UI:

1. **All views** from Phase 2A, rendered with the design system from Phase 6
2. **State switcher** -- tabs or toggles to view each screen in different states
3. **Responsive preview** -- viewport toggle for mobile/tablet/desktop
4. **Real-looking data** -- use realistic placeholder data, not "Lorem ipsum"
5. **All component variants** -- show buttons, cards, badges, tables in their various states

#### 7B: User Review

Save the preview to the project (e.g., `planning/ui-preview.html`). The user opens it in a browser and reviews.

- **Approved**: Proceed to Phase 8
- **Adjustments requested**: Loop back to Phase 6 or Phase 3 as needed

---

### Phase 8: Component Implementation

#### 8A: Detect Project Stack

Read project files to determine: Framework, Styling, File organization, Existing patterns. ALWAYS match existing conventions.

#### 8B: Generate Shared Components

Build the component library first:

1. Button -- all variants/sizes/states
2. Card -- KPI, content, status, clickable variants
3. Badge/Status -- status color mapping, pulse for active
4. DataTable -- sortable, filterable, URL-synced, with skeleton/empty/error states
5. Form elements -- input, select, checkbox, toggle with validation display
6. Skeleton -- variants matching each component's loaded layout
7. EmptyState -- configurable icon, title, description, CTA
8. ErrorState -- banner, inline, full-page variants with retry
9. Toast system -- queue-based, auto-dismiss, positioned
10. Layout shell -- sidebar, header, content area, mobile responsive

#### 8C: Generate Page Components

For each view: data fetching, state handling, all visual states, responsive behavior, microinteractions, accessibility.

#### 8D: Generate Hooks/Services

1. SWR polling hook -- with tab visibility pause, configurable interval
2. URL state hook -- sync filters/sort/pagination to URL params
3. Form state hook -- dirty tracking, validation, navigate-away warning
4. Toast hook -- add/remove/auto-dismiss

---

## Anti-Pattern Catalog

### Functional Anti-Patterns

| Anti-Pattern | Why It Fails | Do This Instead |
|-------------|-------------|-----------------|
| Skip Phase 1, jump to components | You'll build the wrong thing beautifully | Complete Functional Discovery first |
| Happy-path-only specs | 60% of user time is spent in non-happy states | Spec empty, loading, error, and edge states for EVERY view |
| Components without state machines | Leads to undiscovered states and broken transitions | Every interactive component gets a state table |
| "Show an error message" | Which error? What does it say? What can the user do? | Spec the error type, message content, recovery action, and fallback |
| Modal for everything | Modals block context | Use decision trees to pick the right pattern |
| "Responsive" means "stack columns" | Mobile users have different TASKS | Spec functional differences per breakpoint |

### Visual Design Anti-Patterns

| Anti-Pattern | Why It Fails | Do This Instead |
|-------------|-------------|-----------------|
| Rainbow syndrome | Too many colors overwhelms hierarchy | 1 accent + 4 semantic colors max |
| Font-size soup | 8 different sizes destroys hierarchy | Max 4 sizes per screen |
| Hardcoded colors in components | Changes require editing every file | Use design tokens everywhere |
| Skeleton that doesn't match content | Generic gray blocks confuse | Skeletons must match the EXACT layout of loaded content |
| Color as only indicator | Colorblind users can't distinguish states | Always pair color with icon, text, or shape |

---

## Authority Matrix

| Decision | Skill Decides | Ask the User |
|----------|:---:|:---:|
| Which questions to ask in Phase 1 | X | |
| What the user's requirements are | | X |
| Screen inventory structure | X | |
| Navigation architecture pattern | X | |
| Design token values | X | |
| Component styling patterns | X | |
| Business rules and domain constraints | | X |
| Priority of features / what's MVP | | X |
| Design system overrides | | X |
| Preview approval | | X |

---

## Output Modes

### Incremental Mode (Large Features -- recommended)
1. Phases 1-2: Discovery + Architecture. Get confirmation.
2. Phases 3-5: Behavioral Spec + Interaction Design + Validation. Get confirmation.
3. Phase 6: Design System. Get confirmation.
4. Phase 7: HTML Preview. Get approval.
5. Phase 8: Component Implementation.

### Combined Mode (Small Features)
Phases 1-5 as a single spec, then Phase 6-8 as design + build.

### Spec-Only Mode
Stop after Phase 5. The spec can be saved and built from later.
