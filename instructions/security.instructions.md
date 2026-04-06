# Security

## Pre-Commit Checklist
- No hardcoded secrets — User Secrets (dev), Azure Key Vault (prod)
- All user inputs validated (FluentValidation / Angular reactive forms)
- SQL: EF Core only (auto-parameterized). Raw SQL: `FromSqlInterpolated` only.
- XSS: Angular auto-escapes. Use `DomSanitizer` only when unavoidable.
- CSRF protection enabled. Auth on all endpoints. Rate limiting on public endpoints.
- Error messages don't leak sensitive data.
- JWT: ValidateLifetime=true, ClockSkew=Zero, validate issuer+audience+signing key.
- Headers: X-Frame-Options:DENY, X-Content-Type-Options:nosniff, CSP, HSTS 365d.
- Frontend: never put secrets in Angular — backend proxies external API calls.

## If Security Issue Found
1. STOP — use security-reviewer agent
2. Fix CRITICAL issues before other work
3. Rotate exposed secrets, check Application Insights for exploitation
