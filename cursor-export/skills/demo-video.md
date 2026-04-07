---
name: demo-video
description: Capture screenshots, record demo videos, and create optimized GIFs of projects for GitHub READMEs and documentation.
triggers: When the user asks to take a screenshot, create a demo, make a GIF, record a demo video, screenshot a project, capture the app, or create visuals for a README.
---

# Demo Video Skill

Capture screenshots, record demo videos, and create optimized GIFs for GitHub project documentation.

## Quick Reference

| Task | Tool | Requires |
|------|------|----------|
| Check dependencies | `check-deps.js` | -- |
| Browser screenshot | `screenshot-web.js` | Playwright |
| Desktop/window screenshot | `screenshot-desktop.ps1` | PowerShell |
| Browser video recording | `record-web.js` | Playwright |
| MP4 to GIF | `to-gif.js` | ffmpeg |
| PNGs to GIF slideshow | `slideshow.js` | ffmpeg |

---

## Step 1: Check Dependencies

Ensure required tools are installed:

- **Playwright**: For web app capture. Install with `npx playwright install chromium`.
- **ffmpeg**: For GIF/video conversion. Install with `winget install Gyan.FFmpeg` (Windows) or `brew install ffmpeg` (macOS).

**Degradation strategy:**
- Playwright missing: Cannot capture web apps.
- ffmpeg missing: Can still take screenshots, but no GIF/video conversion.
- Both missing: Only desktop screenshots via PowerShell work.

Do NOT block on missing ffmpeg if the user only needs screenshots.

---

## Step 2: Detect Project Type

Examine the project to determine capture method:

| Signal | Project Type | Method |
|--------|-------------|--------|
| `package.json` with `start`/`dev` script, or `angular.json`, `next.config.*`, `vite.config.*` | Web app (local server) | Browser capture |
| `.html` files in root or `public/` | Static web | Browser capture (file://) |
| `.csproj` with `Microsoft.NET.Sdk.Web` | .NET web app | Browser capture |
| `.exe`, `.ps1`, or CLI tool | Desktop/CLI app | Desktop capture |
| No UI at all | Library/API | Screenshot of docs, tests, or terminal output |

Ask the user if detection is ambiguous.

---

## Step 3: Choose Capture Method

| Goal | Method |
|------|--------|
| Single web screenshot | Playwright screenshot |
| Full-page web screenshot | Playwright with `--full-page` |
| Desktop/window screenshot | PowerShell screen capture |
| Web interaction recording | Playwright video recording |
| MP4 to GIF | ffmpeg conversion |
| Multiple screenshots to GIF | ffmpeg slideshow |

---

## Step 4: Plan the Demo

Before capturing, confirm with the user:

1. **What to capture** -- Which screens, features, or interactions?
2. **Shot list** -- Ordered list of captures needed.
3. **Output format** -- Screenshot (PNG), GIF, or video (MP4)?
4. **Dark mode?** -- Dark backgrounds compress better in GIFs.

Present the plan and wait for confirmation before proceeding.

---

## Step 5: Capture

### Web Screenshots

```bash
# Basic screenshot
npx playwright screenshot "http://localhost:3000" --output "./output/screenshot.png"

# Full page
npx playwright screenshot "http://localhost:3000" --output "./output/screenshot.png" --full-page
```

Options: `--full-page`, `--wait-for <selector>`, `--dark-mode`

### Desktop Screenshots (Windows PowerShell)

```powershell
# Capture entire screen or specific window
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Screen]::PrimaryScreen | ForEach-Object {
    $bitmap = New-Object System.Drawing.Bitmap($_.Bounds.Width, $_.Bounds.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($_.Bounds.Location, [System.Drawing.Point]::Empty, $_.Bounds.Size)
    $bitmap.Save("./output/screenshot.png")
}
```

### Web Recording

Use Playwright to record browser interactions as MP4, then convert to GIF.

Supported actions: `click`, `type`, `wait`, `scroll`, `navigate`, `hover`.

---

## Step 6: Post-Process

### Convert MP4 to GIF

```bash
ffmpeg -i "./output/recording.mp4" -vf "fps=10,scale=640:-1" -gifflags +transdiff "./output/demo.gif"
```

Auto-retry with reduced settings if over size limit:
- Pass 1: 640w, 10fps
- Pass 2: 480w, 8fps
- Pass 3: 320w, 6fps

### Create Slideshow from Screenshots

```bash
ffmpeg -framerate 0.5 -pattern_type glob -i "./output/*.png" -vf "scale=640:-1" "./output/slideshow.gif"
```

---

## Step 7: Deliver

After capturing, provide the user with:

1. **File locations** -- List all generated files in `output/`.
2. **README snippet** -- Suggest markdown for their README:

```markdown
## Demo

![Demo](./output/demo.gif)

## Screenshots

| Feature | Preview |
|---------|---------|
| Dashboard | ![Dashboard](./output/screenshot-dashboard.png) |
| Settings | ![Settings](./output/screenshot-settings.png) |
```

3. **Gitignore reminder** -- If `output/` is not in `.gitignore`, suggest adding it (large binary files should not be committed). Recommend committing only the final optimized GIF/PNG.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Playwright not found | Run `npx playwright install chromium` |
| ffmpeg not found | Run `winget install Gyan.FFmpeg` then restart terminal |
| Screenshot is blank/white | Increase wait time or use a wait-for selector |
| GIF too large for GitHub | Reduce size or use lower fps/width |
| Dark mode not applying | Site must respect `prefers-color-scheme` media query |

---

## References

- GitHub GIF limits: <5MB for fast loading, <10MB max
- Recommended: 1280x720 for screenshots, 640px wide for GIFs, 10fps, 5-15s duration
