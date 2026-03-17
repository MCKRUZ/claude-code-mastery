
<!-- nexus:start -->
## Nexus Intelligence

*Auto-updated by Nexus — do not edit this section manually.*
*Last sync: 2026-03-17*

### Portfolio
| Project | Description | Tech |
|---------|------------|------|
| code | Pinokio plugin — a VS Code-like code editor plugin running inside the Pinokio A… | — |
| app | **Qwen3-TTS** — a Gradio web UI for Alibaba's Qwen3-TTS text-to-speech models, … | — |
| kohya_ss | **Kohya's GUI** — the standard GUI/CLI for training Stable Diffusion models inc… | — |
| ComfyUI | **ComfyUI** — the main local ComfyUI installation at E:/ComfyUI-Easy-Install/Co… | — |
| openclaw | **OpenClaw** — a personal AI assistant platform you run on your own devices, an… | — |
| eShopLite | **eShopLite** — Microsoft reference .NET application implementing an eCommerce … | — |
| agent-framework | **Microsoft Agent Framework** — comprehensive multi-language framework for buil… | — |
| Agent365-dotnet | **Microsoft Agent 365 SDK** — C#/.NET SDK that extends the Microsoft 365 Agents… | — |
| firecrawl | **Firecrawl** — a web scraper API that takes URLs, crawls them, and converts co… | — |
| ai-toolkit | **AI Toolkit by Ostris** — all-in-one training suite for diffusion models (imag… | — |
| musubi-tuner | **Musubi Tuner** — LoRA training scripts for modern video and image diffusion a… | — |
| ComfyUI-Qwen-TTS | **ComfyUI-Qwen-TTS** — ComfyUI custom nodes for speech synthesis using Alibaba'… | — |
| claude-code-langfuse-template | **Claude Code + Langfuse Template** — production-ready setup for observing Clau… | — |
| fluxgym | **Flux Gym** — simple web UI for training FLUX LoRAs with low VRAM support (12G… | — |
| everything-claude-code | **Everything Claude Code** — complete collection of Claude Code configs from an… | — |
| awesome-claude-skills | **Awesome Claude Skills** — curated list of practical Claude Skills for Claude.… | — |
| clawd | **clawd** — local installation of the Claude Code CLI tool at C:/Users/kruz7/cl… | — |
| sage-voice | **sage-voice** — MCKRUZ project for Sage's voice capabilities.

Sage is the AI … | — |
| sage-voice-bridge | **sage-voice-bridge** — bridge service connecting Sage's voice system to the br… | — |
| openclaw-voice | **OpenClaw Voice** — Discord voice bot enabling AI agents (Jarvis and Sage) to … | — |
| openclaw-realism | **OpenClaw Realism** — framework/blueprint for making OpenClaw agents feel like… | — |
| openclaw-langfuse | **openclaw-langfuse** — OpenClaw plugin for sending agent traces to Langfuse fo… | — |
| matthewkruczek-ai | **matthewkruczek.ai** — static personal brand website for Matthew Kruczek (EY M… | — |
| jarvis-voice-bridge | **jarvis-voice-bridge** — bridge service for Jarvis agent's voice integration.
… | — |
| github-agentic-workflows-poc | **GitHub Agentic Workflows POC** — proof-of-concept for GitHub's Agentic Workfl… | — |
| **claude-code-mastery** (this) | **Claude Code Mastery** — the definitive Claude Code setup and configuration sk… | — |
| TeamsBuddy | **TeamsBuddy** — real-time Microsoft Teams meeting transcript monitor with AI-p… | — |
| SocialMedia | **SocialMedia** — MCKRUZ social media project.

No documentation files found in… | — |
| ProjectPrism | **Prismcast / ProjectPrism** — autonomous AI news aggregation, synthesis, and v… | — |
| Microsoft-Agent-Skills-POC | **Microsoft Agent Skills POC** — proof-of-concept for building Agent Skills for… | — |
| DotNetSkills | **DotNetSkills / Skills Executor** — .NET orchestrator for executing Anthropic-… | — |
| ComfyUI Expert | **VideoAgent / ComfyUI Expert** — session-scoped Claude Code orchestrator that … | — |
| CodeReviewAssistant | **CodeReviewAssistant** — MCP server for capturing, analyzing, and documenting … | — |
| ArchitectureHelper | **AzureCraft / ArchitectureHelper** — AI-native Azure infrastructure designer f… | — |
| AI-SDLC | **AI-PDLC Platform** — multi-offering system for AI-assisted consulting and sof… | — |
| Nexus | Nexus is a local-first cross-project intelligence layer for Claude Code. | — |

### Recorded Decisions
- **[security]** Sanitize and rotate credentials after eval runs that may expose secrets
  > During test case TC-003, a real GitHub PAT was exposed in skill output. Established practice to rotate credentials and document secret exposure risks in eval framework.
- **[security]** Sanitize eval test harness to prevent credential leakage from settings files
  > Eval run exposed GitHub PAT token when skill accessed actual settings.json during MCP config test
- **[security]** Include platform-aware syntax validation in evaluations — specifically test Win…
  > TC-005 and TC-003 explicitly validate Windows-compatible output; 15% of benchmark criteria allocated to platform awareness
- **[architecture]** Add failure-mode test cases for adversarial input and edge cases before finaliz…
  > After initial 5 test cases passed at 100%, added TC-006, TC-007, TC-008 to test adversarial users, contradictory platform info, and cold-start scenarios. Discovered that robustness under adversarial conditions should be weighted (10%).
- **[architecture]** Use anchored, objective assertion types for eval scoring instead of subjective …
  > Initial eval used vague assertions like 'sequence_check' and subjective descriptions. Refactored to use concrete assertion types: contains, regex, question_before_code (line position), json_valid, token_limit to reduce scoring ambiguity.

> **Cross-project rule**: Before making decisions that affect shared concerns (APIs, auth, data formats, deployment), run `nexus_query` to check for existing decisions and conflicts across the portfolio.

*[Nexus: run `nexus query` to search full knowledge base]*
<!-- nexus:end -->
