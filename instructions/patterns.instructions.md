# Common Patterns

## Privacy Tags
Wrap sensitive content in `<private>` tags to exclude from session memory logs.
The observation hook only records file paths, not contents — use `<private>` for sensitive content in prompts.

## Skeleton Projects
When implementing new functionality: search for battle-tested skeleton projects, evaluate with parallel agents, clone best match as foundation.
