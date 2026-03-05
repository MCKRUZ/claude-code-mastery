
<!-- nexus:start -->
## Nexus Intelligence

*Auto-updated by Nexus — do not edit this section manually.*
*Last sync: 2026-03-05*

### Project Context
#### Project Overview
**Claude Code Mastery** — the definitive Claude Code setup and configuration skill for Windows/PowerShell.

**Stack:** Markdown-based skill system. Self-updating knowledge base. Install by copying to `~/.claude/skills/claude-code-mastery/`.

**Seven pillars:**
1. CLAUDE.md Engineering — hierarchy, golden rules, templates
2. Context Management — token budgeting, compaction, subagents
3. MCP Server Stack — tiered recommendations, project configs
4. Settings/Permissions/Hooks — production-ready templates
5. Agent Teams — orchestration, cost management, patterns
6. Skills & Plugins — ecosystem, community plugins
7. CI/CD & Automation — headless mode, GitHub Actions, worktrees

**Patterns (from Nexus):** Self-updating skill pattern (SKILL.md + web research + changelog), session lifecycle automation via hooks (SessionStart, Stop, PostToolUse).

**Update:** Say "update knowledge" or "research latest" to trigger web research for updates.
*Tags: overview, claude*

### Context from code
#### Project Overview
Pinokio plugin — a VS Code-like code editor plugin running inside the Pinokio AI app launcher (E:/pinokio). Pinokio is a desktop application for one-click installation and running of AI tools/models. This plugin provides an IDE-style code editing interface within that environment.

**Path context:** E:/pinokio/plugin/code — lives inside the Pinokio installation on the E: drive alongside other Pinokio apps and plugins.
*Tags: overview, image-gen*

### Context from app
#### Project Overview
**Qwen3-TTS** — a Gradio web UI for Alibaba's Qwen3-TTS text-to-speech models, running as a Pinokio app.

**Stack:** Python 3.10+, Gradio UI at localhost:7860, PyTorch with CUDA 12.8, uv package manager.

**Capabilities:**
- Voice Design — create voices from natural language descriptions
- Voice Cloning — zero-shot cloning from reference audio
- Custom Voice — predefined speakers with style instructions
- Long text auto-chunking at sentence/word boundaries
- Whisper auto-transcription for reference audio
- Model management UI (download, load, unload)

**Hardware:** NVIDIA GPU with CUDA 12.8. ~8GB VRAM for 0.6B models, ~16GB for 1.7B models.

**Run:** `python app.py`
*Tags: overview, voice, python*

### Context from kohya_ss
#### Project Overview
**Kohya's GUI** — the standard GUI/CLI for training Stable Diffusion models including LoRA, Dreambooth, and fine-tuning.

**Stack:** Python, Gradio UI, uv or pip for install. Supports Linux, Mac, Windows.

**Training methods:** LoRA (Low-Rank Adaptation), Dreambooth, fine-tuning, SDXL training.

**Key feature:** Generates the CLI commands needed to run Kohya's training scripts automatically from UI parameters.

**Install:** `uv pip install -r requirements.txt` then launch with `python kohya_gui.py`

**License:** Apache 2.0. This is the canonical local installation of the tool at E:/kohya_ss.
*Tags: overview, ml-training, python*

### Context from ComfyUI
#### Project Overview
**ComfyUI** — the main local ComfyUI installation at E:/ComfyUI-Easy-Install/ComfyUI. The most powerful modular visual AI engine for Stable Diffusion and related models.

**Stack:** Python, node-based graph/flowchart UI, runs at localhost:8188 (referred to as FURIOUS:8188 in some project configs).

**Supported models:** SD1.x, SD2.x, SDXL, FLUX (all variants), Wan 2.1/2.2, HunyuanVideo, LTX-Video, Mochi, Z Image, Qwen Image, and many more.

**Hardware:** RTX 5090 (32GB VRAM) — can run all models at full precision with `--highvram --fp8_e4m3fn-unet` flags.

**Key usage in portfolio:** This installation is used for Sage character generation (identity-preserving LoRA workflows), apartment skill image generation, and ProjectPrism video production. API workflows (JSON) are used programmatically via POST to /prompt and polling /history.

**Run:** `python main.py --highvram`
*Tags: overview, image-gen, python*

### Context from openclaw
#### OpenClaw Ollama Integration & Stop Hook Architecture
(1) OpenClaw uses agent model fallback chains requiring tool-capable models (Claude Opus/Sonnet, llama3.1:8b); (2) Two separate Ollama patterns: OpenClaw agent fallback (requires tools) vs Sage direct NSFW routing via curl (any model); (3) OpenClaw auth-profiles.json has three critical sections (version, profiles, lastGood) - missing lastGood entries cause No API key found errors even when profile exists; (4) Claude Code Stop hooks: prompt-type hooks are single-turn evaluators that cannot call MCP tools - use {ok: false, reason: call mcp__tool} pattern to instruct main Claude instead; (5) llama3.1:8b (4.9GB) downloaded on Furious and configured as Ollama fallback in openclaw.json.

#### Project Overview
**OpenClaw** — a personal AI assistant platform you run on your own devices, answering across channels you already use.

**Stack:** Node.js 22+, npm global install (`npm install -g openclaw@latest`).

**Supported channels:** WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, WebChat, BlueBubbles, Matrix, Zalo. Voice on macOS/iOS/Android. Live Canvas UI.

**Recommended model:** Anthropic Pro/Max with Claude Opus 4.6 for long-context strength and prompt-injection resistance.

**Key commands:**
- `openclaw onboard --install-daemon` — initial setup
- `openclaw gateway --port 18789 --verbose` — start gateway
- `openclaw agent --message "..." --thinking high` — run agent

**Architecture note:** Personal, single-user assistant. The openclaw directory under openclaw/openclaw is the main repo. Related projects in this portfolio: openclaw-voice (Discord voice bot), openclaw-realism (personhood framework), openclaw-langfuse (observability plugin).
*Tags: overview, typescript, claude, mckruz-project*

### Context from eShopLite
#### Project Overview
**eShopLite** — Microsoft reference .NET application implementing an eCommerce site demonstrating AI, MCP, and search scenarios.

**Stack:** .NET 9, .NET Aspire (orchestration), Docker/Podman, Azure Developer CLI (azd).

**Scenarios covered (12+):**
- Semantic search with OpenAI embeddings
- Azure AI Search + vector databases (In Memory, Chroma DB, Azure AI Search)
- Realtime audio with GPT-4o
- Model Context Protocol (MCP) server/client
- Multi-agent concurrent systems
- SQL Server 2025 vector search
- DeepSeek-R1, GitHub Models, Azure Functions

**Purpose:** Reference/learning project from Microsoft showing modern .NET AI integration patterns. Not a production MCKRUZ project — used for studying patterns.
*Tags: overview, dotnet, microsoft*

### Context from agent-framework
#### Project Overview
**Microsoft Agent Framework** — comprehensive multi-language framework for building, orchestrating, and deploying AI agents.

**Stack:** .NET (Microsoft.Agents.AI NuGet) + Python (pip install agent-framework).

**Key capabilities:**
- Graph-based workflows connecting agents and deterministic functions
- Streaming, checkpointing, human-in-the-loop, time-travel
- AF Labs: benchmarking, reinforcement learning, research
- DevUI for development, testing, debugging

**Install:**
- Python: `pip install agent-framework --pre`
- .NET: `dotnet add package Microsoft.Agents.AI`

**Purpose:** Microsoft open-source framework, used as reference/integration point for building agent systems. Related: Agent365-dotnet extends this for Microsoft 365 enterprise contexts.
*Tags: overview, dotnet, microsoft, python*

### Context from Agent365-dotnet
#### Project Overview
**Microsoft Agent 365 SDK** — C#/.NET SDK that extends the Microsoft 365 Agents SDK with enterprise-grade capabilities.

**Stack:** .NET 8.0+, C#. Build: `dotnet build src/Microsoft.Agents.A365.Sdk.sln`

**Four core areas:**
- **Observability:** Comprehensive tracing, caching, monitoring
- **Notifications:** Agent notification services and models
- **Runtime:** Core utilities and extensions for agent runtime
- **Tooling:** Developer tools and utilities

**Purpose:** Microsoft open-source project. Reference implementation for extending M365 agent capabilities. Used for studying enterprise agent patterns. Related to agent-framework (parent framework).
*Tags: overview, dotnet, microsoft*

### Context from firecrawl
#### Project Overview
**Firecrawl** — a web scraper API that takes URLs, crawls them, and converts content to LLM-ready markdown or structured data.

**Stack:** Monorepo — apps/api (Node.js/TypeScript API + worker), apps/js-sdk, apps/python-sdk, apps/rust-sdk. pnpm.

**Capabilities:** Scrape, Crawl, Map (all URLs of a site), Search, Extract (structured data with AI).

**Development workflow (from CLAUDE.md):**
1. Write E2E tests first (called "snips") — always preferred over unit tests
2. Use `scrapeTimeout` from `./lib` for all scrape timeouts
3. Run tests: `pnpm harness jest ...`
4. Tests run on multiple configs: fire-engine tests gate on `!TEST_SUITE_SELF_HOSTED`; AI tests gate on OPENAI_API_KEY/OLLAMA_BASE_URL

**Integrations:** Langchain, Llama Index, Crew.ai, Composio, Dify, Langflow, Zapier.
*Tags: overview, typescript, python*

### Context from ai-toolkit
#### Project Overview
**AI Toolkit by Ostris** — all-in-one training suite for diffusion models (image and video) on consumer hardware.

**Stack:** Python, supports both GUI and CLI operation.

**Purpose:** Train LoRA and fine-tune image/video diffusion models. Designed for consumer-grade hardware (lower VRAM requirements than some alternatives like Kohya for certain model types).

**Note:** Complementary to kohya_ss in this portfolio — covers different model architectures and has an easier setup for certain workflows. Also related to fluxgym (which uses AI-Toolkit's Gradio UI frontend with Kohya backend).
*Tags: overview, ml-training, python*

### Context from musubi-tuner
#### Project Overview
**Musubi Tuner** — LoRA training scripts for modern video and image diffusion architectures.

**Stack:** Python. Unofficial/community implementation. Under active development.

**Supported architectures:**
- HunyuanVideo
- Wan 2.1 / 2.2
- FramePack
- FLUX.1 Kontext
- Qwen-Image / Qwen-Image-Edit
- Kandinsky 5
- Z-Image-Turbo

**Features:** LoRA training + fine-tuning; simple GUI for Z-Image-Turbo and Qwen-Image training.

**Use case:** Training custom video/image LoRAs for characters and styles — complements the ComfyUI installation for inference.
*Tags: overview, ml-training, python*

### Context from ComfyUI-Qwen-TTS
#### Project Overview
**ComfyUI-Qwen-TTS** — ComfyUI custom nodes for speech synthesis using Alibaba's Qwen3-TTS models.

**Stack:** Python, ComfyUI custom nodes. No separate loader nodes required — integrated loading.

**Nodes:**
- `VoiceDesignNode` — generate unique voices from text descriptions
- `VoiceCloneNode` — zero-shot voice cloning from reference audio
- `CustomVoiceNode` — standard TTS with preset speakers
- `RoleBankNode` — manage and reuse voice profiles

**Capabilities:** 10 languages, sage_attn/flash_attn/sdpa/eager attention backends, optional model unloading.

**Relationship:** Extends the main ComfyUI installation (E:/ComfyUI-Easy-Install/ComfyUI). Related to the Qwen3-TTS standalone app (app project in this portfolio).
*Tags: overview, voice, python, image-gen*

### Context from claude-code-langfuse-template
#### Project Overview
**Claude Code + Langfuse Template** — production-ready setup for observing Claude Code sessions using self-hosted Langfuse.

**Stack:** Docker + Docker Compose (Langfuse at localhost:3050), Python 3.11+, Claude Code CLI hooks.

**What it captures:** Every Claude Code conversation — prompts, responses, tool calls, session grouping, incremental state management.

**Setup:** `docker compose up -d` → install hook via `./scripts/install-hook.sh` → sessions appear in Langfuse dashboard.

**Requirements:** Docker, Python 3.11+, Claude Code CLI, 4-6GB RAM.

**Note:** Template/reference project. The portfolio also has openclaw-langfuse (for OpenClaw observability) and the Nexus project itself integrates with Langfuse via ~/.nexus/config.json.
*Tags: overview, claude, typescript*

### Context from fluxgym
#### Project Overview
**Flux Gym** — simple web UI for training FLUX LoRAs with low VRAM support (12GB/16GB/20GB).

**Stack:** Python, Gradio UI (forked from AI-Toolkit), Kohya Scripts backend.

**Supported models:** Flux1-dev, Flux1-dev2pro, Flux1-schnell (auto-downloaded on first training run).

**Key advantage:** Works on 12GB VRAM where AI-Toolkit requires 24GB. Supports 100% of Kohya sd-scripts features via an Advanced tab.

**Use case:** Training FLUX LoRAs for character/style consistency. Complements AI-Toolkit and kohya_ss in this portfolio.
*Tags: overview, ml-training, python, image-gen*

### Context from everything-claude-code
#### Project Overview
**Everything Claude Code** — complete collection of Claude Code configs from an Anthropic hackathon winner (10+ months of production use).

**Contents:**
- `agents/` — specialized subagents: planner, architect, tdd-guide, code-reviewer, security-reviewer, build-error-resolver, e2e-runner, refactor-cleaner, doc-updater
- `skills/` — workflow definitions: coding-standards, backend-patterns, frontend-patterns, tdd-workflow, security-review, clickhouse-io
- `commands/` — slash commands: /tdd, /plan, /e2e, /code-review

**Purpose:** Reference repository for Claude Code best practices. The portfolio's own claude-code-mastery project and Nexus are inspired by / complement this kind of systematic Claude Code configuration.
*Tags: overview, claude*

### Context from awesome-claude-skills
#### Project Overview
**Awesome Claude Skills** — curated list of practical Claude Skills for Claude.ai, Claude Code, and Claude API.

**Categories:** Document Processing, Development & Code Tools, Data & Analysis, Business & Marketing, Communication & Writing, Creative & Media, Productivity & Organization, Collaboration & Project Management, Security & Systems.

**Key integration:** Composio wiring for 500+ app actions.

**Purpose:** Reference/discovery repository. Used to find existing skills before building new ones. Complements everything-claude-code and claude-code-mastery in this portfolio.
*Tags: overview, claude*

### Context from clawd
#### Project Overview
**clawd** — local installation of the Claude Code CLI tool at C:/Users/kruz7/clawd.

Based on the path structure and relationship to openclaw (which references clawd as an agent engine), this is likely a custom or development build of the `clawd` CLI — the underlying runtime that powers OpenClaw agents.

**Relationship to portfolio:** OpenClaw agents run via clawd. This directory likely contains the CLI binary or source for running Claude-based agents locally outside of the full OpenClaw gateway setup.
*Tags: overview, claude, typescript, mckruz-project*

### Context from sage-voice
#### Project Overview
**sage-voice** — MCKRUZ project for Sage's voice capabilities.

Sage is the AI companion character in this portfolio (appears in openclaw-voice, openclaw-realism, ComfyUI/sage generation workflows). sage-voice handles the TTS/voice synthesis component for Sage specifically — distinct from the general openclaw-voice Discord bot.

**Related projects:**
- openclaw-voice — Discord voice bot (Sage + Jarvis participate in voice channels)
- sage-voice-bridge — bridge layer connecting Sage voice to other systems
- ComfyUI Expert — visual generation for Sage character
- openclaw-realism — Sage personhood/autonomy framework
*Tags: overview, voice, mckruz-project*

### Context from sage-voice-bridge
#### Project Overview
**sage-voice-bridge** — bridge service connecting Sage's voice system to the broader agent infrastructure.

Part of the Sage AI companion ecosystem in this portfolio. Acts as a bridge/adapter between the voice synthesis layer (sage-voice) and consuming services (OpenClaw gateway, Discord bot, etc.).

**Portfolio context:** The MCKRUZ projects form a layered voice AI stack:
- sage-voice → TTS/voice generation for Sage character
- sage-voice-bridge → routing/bridging layer
- openclaw-voice → Discord integration (Sage + Jarvis)
- jarvis-voice-bridge → parallel bridge for Jarvis agent
*Tags: overview, voice, mckruz-project*

### Context from openclaw-voice
#### Project Overview
**OpenClaw Voice** — Discord voice bot enabling AI agents (Jarvis and Sage) to participate naturally in Discord voice channels.

**Stack:** Python 3.12+, NVIDIA CUDA 12.x, Windows 10/11. Requires RTX 3060+ (min 8GB VRAM).

**Architecture pipeline:**
```
Discord Voice Channel → Per-user opus→PCM streams
→ Silero VAD → Pipecat Smart Turn v3 → faster-whisper STT
→ Relevance Filter → OpenClaw API → Chatterbox TTS → Discord TX
```

**Key features:**
- Passive listening (no wake word or push-to-talk)
- Smart Turn v3 for natural conversation turn-taking
- Relevance filter — only speaks when valuable
- OpenAI-compatible HTTP API for TTS and STT
- Emotion control and paralinguistic TTS support
*Tags: overview, voice, python, mckruz-project*

### Context from openclaw-realism
#### Project Overview
**OpenClaw Realism** — framework/blueprint for making OpenClaw agents feel like autonomous people, not assistants.

**Core problem it solves:** OpenClaw's identity system (SOUL.md, USER.md) creates a character with personality, but not a *person* with ongoing life. This framework adds:
- Life between conversations (scheduled events, things that happen during the day)
- Proactive outreach (agent initiates, doesn't just respond)
- Persistent emotional state and mood carry-over
- A social circle with ongoing situations
- Specific, arguable opinions
- Time-of-day personality variation (sharper morning, looser at night)

**Target agents:** Sage and Jarvis in the MCKRUZ portfolio.

**Relationship:** Configures the OpenClaw platform (openclaw project) — not a standalone app but a set of patterns/configs applied to an OpenClaw instance.
*Tags: overview, mckruz-project, claude*

### Context from openclaw-langfuse
#### Project Overview
**openclaw-langfuse** — OpenClaw plugin for sending agent traces to Langfuse for LLM observability.

**Stack:** Node.js, no npm packages — uses Langfuse REST API directly via native `fetch`. No Docker rebuild needed — drop into workspace volume and restart.

**What it records per turn:**
- Trace name: `openclaw-turn`
- Session ID, User ID (agent ID), Tags, Input/Output, Token usage, Duration

**Install:** Copy plugin to `.openclaw/extensions/` in workspace volume and restart.

**Compatibility:** Works with self-hosted Langfuse (bablyon NAS: langfuse.bablyon.synology.me) and Langfuse Cloud.

**Note:** Nexus also integrates Langfuse via config.json for cross-project intelligence tracing.
*Tags: overview, mckruz-project, typescript*

### Context from matthewkruczek-ai
#### Project Overview
**matthewkruczek.ai** — static personal brand website for Matthew Kruczek (EY Managing Director), focused on AI/enterprise thought leadership.

**Stack:** Pure HTML5, CSS3, Vanilla JS. No build step. Dark theme with amber/gold accents (#d4a853). Fonts: Playfair Display, Source Sans 3, JetBrains Mono. Hosting: Netlify/Vercel/GitHub Pages.

**Structure:** index.html, blog.html, blog/ directory, css/styles.css, assets/webmcp.js, CV PDF.

**AI-Agent Ready features:**
- **WebMCP** (implemented): 5 structured tools exposed to Chrome 146+ AI agents — getProfile, getExpertise, getSpeakingTopics, getArticles, getContactInfo
- **Cloudflare Markdown for Agents** (pending): 80% token reduction for AI crawlers

**Conventions:** Semantic HTML5, .component-element CSS class naming pattern.
*Tags: overview, typescript*

### Context from jarvis-voice-bridge
#### Project Overview
**jarvis-voice-bridge** — bridge service for Jarvis agent's voice integration.

Part of the MCKRUZ voice AI stack alongside sage-voice-bridge. Jarvis is a second AI agent persona (alongside Sage) that participates in Discord voice channels via openclaw-voice.

**Portfolio voice stack:**
- openclaw-voice — Discord voice bot (both Sage and Jarvis)
- jarvis-voice-bridge — voice routing/bridging for Jarvis
- sage-voice-bridge — voice routing/bridging for Sage
- openclaw (main) — agent gateway that both connect to
*Tags: overview, voice, mckruz-project*

### Context from github-agentic-workflows-poc
#### Project Overview
**GitHub Agentic Workflows POC** — proof-of-concept for GitHub's Agentic Workflows tech preview: Markdown-driven AI agent workflows in GitHub Actions with Claude Code as the agent engine.

**Stack:** Claude Code (agent engine), GitHub Actions (CI), C# .NET 9 minimal API (sample app), `gh aw` CLI extension.

**Workflow authoring (from CLAUDE.md):**
- Workflows live in `.github/workflows/*.md` with YAML frontmatter
- `gh aw compile` → produces `.lock.yml` files GitHub Actions executes
- Rules: triggers in frontmatter, least-privilege permissions, explicit safe outputs, no secrets in .md files

**Included workflows:** PR code review, issue triage, weekly status report, test coverage analysis, CI failure investigation.

**Commands:** `gh extension install github/gh-aw` → `gh aw compile` → `gh aw run <name>`
*Tags: overview, claude, dotnet*

### Context from TeamsBuddy
#### Project Overview
**TeamsBuddy** — real-time Microsoft Teams meeting transcript monitor with AI-powered question suggestions.

**Stack:** .NET 9.0 (API/Services), .NET 8.0 (Core/Infrastructure), ASP.NET Core Web API, Blazor Server, Microsoft Graph SDK 5.x, Azure SignalR, Azure OpenAI (GPT-4), Bicep IaC.

**Architecture (from CLAUDE.md):**
- Background service polls Graph API every 5s for active sessions (max 5 concurrent)
- VTT transcript parsing via `VttTranscriptParser.Parse()`
- Question generation triggers at 30+ sec since last + 3+ new segments
- Question categories: Clarification, Deep-dive, Follow-up, Summary
- SignalR hub: `SendTranscriptUpdateAsync`, `SendQuestionSuggestionsAsync`

**Graph API scopes required:** OnlineMeetings.Read.All, User.Read.All, Calls.AccessMedia.All

**Solution structure:** Core, Api, Web, Services, Infrastructure layers.
*Tags: overview, dotnet, microsoft*

### Context from SocialMedia
#### Project Overview
**SocialMedia** — MCKRUZ social media project.

No documentation files found in the repository. Based on portfolio context, this likely handles social media content creation, scheduling, or distribution — possibly related to ProjectPrism's content distribution pipeline (YouTube, TikTok, Instagram, X) or a standalone social media management tool.
*Tags: overview, mckruz-project*

### Context from ProjectPrism
#### Project Overview
**Prismcast / ProjectPrism** — autonomous AI news aggregation, synthesis, and video production network.

**Stack:** .NET 10, C# 13, Clean Architecture (Domain → Application → Infrastructure → Presentation), CQRS via MediatR, EF Core + SQLite (MVP, migration path to PostgreSQL), Spectre.Console CLI, xUnit + Moq + Shouldly (80%+ coverage target).

**AI integrations:** Microsoft.Extensions.AI, Semantic Kernel, Microsoft Agent Framework, ComfyUI (FURIOUS:8188), Chatterbox TTS (FURIOUS:5000), FFMpegCore.

**Pipeline:**
1. Ingest from 100+ RSS feeds and APIs
2. Cluster articles into story threads via AI
3. Verify factual claims across sources
4. Generate 4 perspectives: Neutral, Left, Right, Video Script
5. Render 30-60s AI anchor video clips
6. Distribute to YouTube, TikTok, Instagram, X, web, email digest

**Commands:** `dotnet build Prismcast.sln` | `dotnet test` | `dotnet run --project Content/Presentation/Presentation.CLI`
*Tags: overview, dotnet, python, image-gen*

### Context from Microsoft-Agent-Skills-POC
#### Project Overview
**Microsoft Agent Skills POC** — proof-of-concept for building Agent Skills for Microsoft Foundry and Azure AI Agent Service.

**Stack:** C# / .NET 9, Azure AI Foundry, Azure AI Agent Service. Services: Azure Container Apps, Cosmos DB, Azure AI Search, Azure OpenAI. Tooling: azd, MCP servers.

**What it demonstrates:**
1. Agent Skills — Markdown-based SKILL.md files in `.github/skills/<skill-name>/` encoding Azure dev patterns
2. A working Azure AI Agent — C# console app using Azure AI Foundry Persistent Agents SDK with function calling to read its own skill library

**Key principle (from README):** "Load only what you need. Overloading context causes *context rot*."

**Security constraints (from CLAUDE.md):** All Azure clients use `DefaultAzureCredential` — never hardcode keys. Record types + immutable patterns for DTOs.

**Commands:** `dotnet build` | `dotnet test` | `azd up`
*Tags: overview, dotnet, microsoft, claude*

### Context from DotNetSkills
#### Project Overview
**DotNetSkills / Skills Executor** — .NET orchestrator for executing Anthropic-style SKILL.md files with Azure OpenAI and MCP tool support.

**Stack:** C#/.NET, Azure OpenAI (function calling), MCP client.

**What it does:**
1. Parses SKILL.md files (YAML frontmatter + Markdown body)
2. Connects to MCP servers as a client to discover and execute tools
3. Orchestrates Azure OpenAI calls in an agentic loop
4. Bridges Azure OpenAI tool calls → MCP server execution

**Project structure:** SkillsCore (shared: ISkillLoader, SkillLoaderService), SkillsQuickstart (main orchestrator with skills/ directory).

**Included skills:** code-explainer, project-analyzer, github-assistant.

**Relationship to portfolio:** Demonstrates the same skills-first pattern used in AI-SDLC and Microsoft-Agent-Skills-POC but in a minimal, standalone .NET form.
*Tags: overview, dotnet, claude*

### Context from ComfyUI Expert
#### Project Overview
**VideoAgent / ComfyUI Expert** — session-scoped Claude Code orchestrator that routes natural language video production requests to 12 specialized skill modules.

**Launched via:** `video-agent.bat` → writes state/session.json → `cd` to repo → launches Claude Code (which auto-loads CLAUDE.md)

**Hardware context (from CLAUDE.md):**
- GPU: RTX 5090 (32GB VRAM)
- Launch flags: `--highvram --fp8_e4m3fn-unet`
- Can run ALL models natively (Wan 14B, FLUX FP16, PuLID Flux II)

**Request routing (12 skills):**
| Request | Skill |
|---------|-------|
| Image generation | comfyui-workflow-builder |
| Video/animation | comfyui-video-pipeline |
| Voice/TTS | comfyui-voice-pipeline |
| LoRA training | comfyui-lora-training |
| Research models | comfyui-research |
| Debugging | comfyui-troubleshooter |
| Prompt interview | comfyui-prompt-interview |

**Relationship:** Wraps the main ComfyUI installation (E:/ComfyUI-Easy-Install/ComfyUI) with structured orchestration.
*Tags: overview, image-gen, voice, claude*

### Context from CodeReviewAssistant
#### Project Overview
**CodeReviewAssistant** — MCP server for capturing, analyzing, and documenting code review sessions with AI-powered reasoning reconstruction.

**Stack:** TypeScript (MCP server), serves MCP tools to Claude Code and other MCP clients.

**MCP Tools:**
- `capture_session` — start a new code review session
- `add_change` — add file change with reasoning
- `finalize_review` — finalize + generate dashboard
- `replay_from_diff` — analyze git diffs, reconstruct reasoning with AI
- `query_reasoning` — ask questions about changes in a session
- `export_review` — export to Markdown/HTML/PDF/JSON

**Capabilities:** Risk analysis, VS Code extension integration (hooks on port 51372), interactive HTML dashboards.

**Note:** The VS Code extension hooks in the global Claude settings (claude-hooks.ps1) send events to port 51372 — that's this project's extension side.
*Tags: overview, typescript, claude*

### Context from ArchitectureHelper
#### Project Overview
**AzureCraft / ArchitectureHelper** — AI-native Azure infrastructure designer for visual drag-and-drop architecture diagrams with real-time cost estimation.

**Stack:**
- Frontend: Next.js 15 (App Router), React 19, React Flow (@xyflow/react v12), CopilotKit, Tailwind CSS + shadcn/ui, Framer Motion, TypeScript strict — in `apps/web/`
- Backend: .NET 9, ASP.NET Core, Clean Architecture (CQRS via MediatR), EF Core, FluentValidation — in `backend/`
- Protocol: AG-UI (SSE) connecting frontend shared state to backend agents

**Features:** 26 Azure service types, 705 official Azure SVG icons, real-time cost estimates (Azure Retail Prices API, 15-min cache), WAF review (15 automated rules), orthogonal routing, export PNG/JSON, AI diagram generation from natural language (CopilotKit).

**Commands:**
- Frontend: `cd apps/web && npm run dev` (port 3000)
- Backend: `cd backend && dotnet run --project src/AzureCraft.Api` (port 7001)

**Custom agents:** nexus-architect, security-guardian (in .claude/agents/)
*Tags: overview, typescript, dotnet, microsoft*

### Context from AI-SDLC
#### Project Overview
**AI-PDLC Platform** — multi-offering system for AI-assisted consulting and software development (v4.0).

**Core philosophy:** Skills-first design. Agent-as-orchestrator (agents compose skills, don't contain business logic). Human-in-the-loop (AI proposes, humans validate). Tool-agnostic (methodology in portable Markdown).

**Architecture:**
```
AI-PDLC/
├── core/            — primitives, meta-skills, references, templates (SHARED)
├── offerings/
│   ├── sdlc-framework/          — AI-SDLC v3.8 (4 phase agents, 26 skills)
│   └── agentic-transformation/  — Enterprise AI readiness assessment (in dev)
└── .claude/commands/
```

**Meta-skills (shared):** context-operations, narrative-enhancer, html-report-generator, docx-artifact-generator.

**SDLC Framework phases:** 4 phase agents covering full software development lifecycle.

**Offerings:**
- sdlc-framework: Active, software development lifecycle
- agentic-transformation: In Development, enterprise AI agent readiness
*Tags: overview, claude*

### Context from Nexus
#### OpenClaw Ollama Fallback & Stop Hook JSON Validation Fix
(1) OpenClaw agent fallback chain requires tool-capable models; dolphin-llama3 doesn't support tools so was removed; llama3.1:8b being pulled as Ollama fallback replacement. (2) Stop hook JSON validation error caused by prompt hooks trying to call MCP tools directly instead of returning evaluator format {ok: true/false, reason: string}. (3) All 7 Stop hooks tested—the two prompt hooks now properly instruct main Claude via reason field instead of attempting MCP calls.
*Tags: openclaw, ollama, hooks, bug-fix*

#### Project Overview
Nexus is a local-first cross-project intelligence layer for Claude Code.
*Tags: context, overview*

### Recorded Decisions
- **[pattern]** Self-updating skill pattern: SKILL.md defines update protocol, web research checks GitHub releases + Anthropic announcements, changelog tracks versions
  > Skill stays current by running periodic self-update that fetches latest Claude Code release notes and patches the knowledge-base.md and changelog.md reference files

### Established Patterns
- **Claude hooks for session lifecycle automation**: Use ~/.claude/settings.json hooks (SessionStart, Stop, PostToolUse) to automate memory persistence, formatting, and knowledge extraction at session boundaries.

<!-- nexus:end -->
