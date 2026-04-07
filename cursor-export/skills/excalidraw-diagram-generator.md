---
name: excalidraw-diagram-generator
description: Generate Excalidraw diagrams from natural language descriptions. Supports flowcharts, relationship diagrams, mind maps, system architecture, data flow, swimlane, class, sequence, and ER diagrams.
triggers: When asked to create a diagram, make a flowchart, visualize a process, draw a system architecture, create a mind map, or generate an Excalidraw file.
---

# Excalidraw Diagram Generator

Generate Excalidraw-format diagrams from natural language descriptions. Creates visual representations of processes, systems, relationships, and ideas without manual drawing.

## When to Use This Skill

Use when users request:

- "Create a diagram showing..."
- "Make a flowchart for..."
- "Visualize the process of..."
- "Draw the system architecture of..."
- "Generate a mind map about..."
- "Create an Excalidraw file for..."
- "Show the relationship between..."
- "Diagram the workflow of..."

**Supported diagram types:**
- **Flowcharts**: Sequential processes, workflows, decision trees
- **Relationship Diagrams**: Entity relationships, system components, dependencies
- **Mind Maps**: Concept hierarchies, brainstorming results, topic organization
- **Architecture Diagrams**: System design, module interactions, data flow
- **Data Flow Diagrams (DFD)**: Data flow visualization, data transformation processes
- **Business Flow (Swimlane)**: Cross-functional workflows, actor-based process flows
- **Class Diagrams**: Object-oriented design, class structures and relationships
- **Sequence Diagrams**: Object interactions over time, message flows
- **ER Diagrams**: Database entity relationships, data models

## Prerequisites

- Clear description of what should be visualized
- Identification of key entities, steps, or concepts
- Understanding of relationships or flow between elements

## Step-by-Step Workflow

### Step 1: Understand the Request

Analyze the user's description to determine:
1. **Diagram type** (flowchart, relationship, mind map, architecture)
2. **Key elements** (entities, steps, concepts)
3. **Relationships** (flow, connections, hierarchy)
4. **Complexity** (number of elements)

### Step 2: Choose the Appropriate Diagram Type

| User Intent | Diagram Type | Example Keywords |
|-------------|--------------|------------------|
| Process flow, steps, procedures | **Flowchart** | "workflow", "process", "steps", "procedure" |
| Connections, dependencies | **Relationship Diagram** | "relationship", "connections", "dependencies" |
| Concept hierarchy, brainstorming | **Mind Map** | "mind map", "concepts", "ideas", "breakdown" |
| System design, components | **Architecture Diagram** | "architecture", "system", "components", "modules" |
| Data flow, transformation | **Data Flow Diagram (DFD)** | "data flow", "data processing" |
| Cross-functional processes | **Business Flow (Swimlane)** | "business process", "swimlane", "actors" |
| Object-oriented design | **Class Diagram** | "class", "inheritance", "OOP" |
| Interaction sequences | **Sequence Diagram** | "sequence", "interaction", "messages" |
| Database design | **ER Diagram** | "database", "entity", "relationship", "data model" |

### Step 3: Extract Structured Information

**For Flowcharts:**
- List of sequential steps
- Decision points (if any)
- Start and end points

**For Relationship Diagrams:**
- Entities/nodes (name + optional description)
- Relationships between entities (from -> to, with label)

**For Mind Maps:**
- Central topic
- Main branches (3-6 recommended)
- Sub-topics for each branch (optional)

**For Data Flow Diagrams (DFD):**
- Data sources and destinations (external entities)
- Processes (data transformations)
- Data stores (databases, files)
- Data flows (arrows showing data movement)
- Important: Do not represent process order, only data flow

**For Business Flow (Swimlane):**
- Actors/roles (departments, systems, people) as header columns
- Process lanes (vertical lanes under each actor)
- Process boxes (activities within each lane)
- Flow arrows (connecting process boxes, including cross-lane handoffs)

**For Class Diagrams:**
- Classes with names
- Attributes with visibility (+, -, #)
- Methods with visibility and parameters
- Relationships: inheritance, implementation, association, dependency, aggregation, composition
- Multiplicity notations (1, 0..1, 1..*, *)

**For Sequence Diagrams:**
- Objects/actors (arranged horizontally at top)
- Lifelines (vertical lines from each object)
- Messages (horizontal arrows between lifelines)
- Synchronous/asynchronous messages
- Return values (dashed arrows)
- Activation boxes

**For ER Diagrams:**
- Entities (rectangles with entity names)
- Attributes (listed inside entities)
- Primary keys (underlined or marked with PK)
- Foreign keys (marked with FK)
- Relationships and cardinality (1:1, 1:N, N:M)

### Step 4: Generate the Excalidraw JSON

Create the `.excalidraw` file with appropriate elements:

**Available element types:**
- `rectangle`: Boxes for entities, steps, concepts
- `ellipse`: Alternative shapes for emphasis
- `diamond`: Decision points
- `arrow`: Directional connections
- `text`: Labels and annotations

**Key properties to set:**
- **Position**: `x`, `y` coordinates
- **Size**: `width`, `height`
- **Style**: `strokeColor`, `backgroundColor`, `fillStyle`
- **Font**: `fontFamily: 5` (Excalifont -- required for all text elements)
- **Text**: Embedded text for labels
- **Connections**: `points` array for arrows

### Step 5: Format the Output

Structure the complete Excalidraw file:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [
    // Array of diagram elements
  ],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 20
  },
  "files": {}
}
```

### Step 6: Save and Provide Instructions

1. Save as `<descriptive-name>.excalidraw`
2. Inform user how to open:
   - Visit https://excalidraw.com
   - Click "Open" or drag-and-drop the file
   - Or use Excalidraw VS Code extension

## Best Practices

### Element Count Guidelines

| Diagram Type | Recommended Count | Maximum |
|--------------|-------------------|---------|
| Flowchart steps | 3-10 | 15 |
| Relationship entities | 3-8 | 12 |
| Mind map branches | 4-6 | 8 |
| Mind map sub-topics per branch | 2-4 | 6 |

### Layout Tips

1. **Start positions**: Center important elements, use consistent spacing
2. **Spacing**:
   - Horizontal gap: 200-300px between elements
   - Vertical gap: 100-150px between rows
3. **Colors**: Use consistent color scheme
   - Primary elements: Light blue (`#a5d8ff`)
   - Secondary elements: Light green (`#b2f2bb`)
   - Important/Central: Yellow (`#ffd43b`)
   - Alerts/Warnings: Light red (`#ffc9c9`)
4. **Text sizing**: 16-24px for readability
5. **Font**: Always use `fontFamily: 5` (Excalifont)
6. **Arrow style**: Straight arrows for simple flows, curved for complex relationships

### Complexity Management

If user request has too many elements:
- Suggest breaking into multiple diagrams
- Focus on main elements first
- Offer to create detailed sub-diagrams

## Icon Libraries (Optional Enhancement)

For specialized diagrams (e.g., AWS/GCP/Azure architecture), you can use pre-made icon libraries from Excalidraw.

**Setup instructions:**
1. Visit https://libraries.excalidraw.com/
2. Search for the desired icon set and download the .excalidrawlib file
3. Place in a `libraries/<icon-set-name>/` directory
4. Use a splitter script to extract individual icons

**Using icons with Python scripts:**
```bash
# Add icon to diagram at position with label
python scripts/add-icon-to-diagram.py diagram.excalidraw EC2 400 300 --label "Web Server"

# Add connecting arrows
python scripts/add-arrow.py diagram.excalidraw 300 250 500 300 --label "HTTPS"
```

**Fallback when no icons available:**
- Use basic shapes (rectangles, ellipses, arrows)
- Apply color coding and text labels
- The diagram will still be functional and clear

## Validation Checklist

Before delivering the diagram:
- [ ] All elements have unique IDs
- [ ] Coordinates prevent overlapping
- [ ] Text is readable (font size 16+)
- [ ] All text elements use `fontFamily: 5` (Excalifont)
- [ ] Arrows connect logically
- [ ] Colors follow consistent scheme
- [ ] File is valid JSON
- [ ] Element count is reasonable (<20 for clarity)

## Output Summary Format

Always provide:
1. Complete `.excalidraw` JSON file
2. Summary of what was created
3. Element count
4. Instructions for opening/editing

Example:
```
Created: user-workflow.excalidraw
Type: Flowchart
Elements: 7 rectangles, 6 arrows, 1 title text
Total: 14 elements

To view:
1. Visit https://excalidraw.com
2. Drag and drop user-workflow.excalidraw
3. Or use File -> Open in Excalidraw VS Code extension
```

## Limitations

- Complex curves are simplified to straight/basic curved lines
- Hand-drawn roughness is set to default (1)
- No embedded images support in auto-generation
- Maximum recommended elements: 20 per diagram
- No automatic collision detection (use spacing guidelines)
