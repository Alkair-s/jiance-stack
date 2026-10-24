# Incident & Postmortem Context

> Adapted from cursor/plugins `pstack/skills/why/references/sources/incident-postmortem.md` at `e73df47` by Lauren Tan, MIT License. See NOTICE and UPSTREAM.md.

- **Linear**: look for tickets labeled `incident`, `sev-*`, `postmortem-action-item`, `reliability`
- **Slack**: search `#sev-*` and `#incident-*` channels around the dates the target code was added
- **Git**: commits with messages like "fix for incident", "add defensive check", "revert" followed by "re-apply with..." are strong signals
