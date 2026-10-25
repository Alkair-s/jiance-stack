# Eval cases: how to write and run them

Behaviour checks for skills use `claude plugin eval` (Claude Code 2.1.310). Each run executes the case twice:
with the plugin and without it (the baseline). A skill is shown to work when the plugin arm passes and the
baseline does not. Found while building stage 1; keep this file current.

## Layout of a case

```
evals/<case>/
  prompt.md          the prompt; frontmatter: max_turns, allowed_tools (see below)
  case.yaml          only for what prompt.md cannot hold: the scaffold
  scaffold.sh        builds the tiny repo the agent works in (relative paths, quoted heredocs)
  graders/*.md       one file per grader
```

`case.yaml`:

```yaml
schema_version: "1.1"
name: <case>              # must match the directory name
context:
  scaffold_script: scaffold.sh
```

prompt.md frontmatter accepts only known keys (`max_turns`, `allowed_tools`, `timeout_seconds`, `model`, `env`
and a few more); anything else is a hard error. There is no scaffold key in prompt.md.

## Graders

- `type: llm` with `focus: trace`: a judge reads the trace. Put the plan's one-line criterion first, then the
  exact pass and fail conditions. The judge sees a trace with its middle cut on long runs, so skills should
  restate key evidence in their final reply.
- `type: tool_used` with `tool`, `input_match` (regex), `min`, `max`: counts tool calls. Use
  `tool: Skill, input_match: <skill-name>` as the "skill fired" indicator (it is with-only, not scored).
- `type: tool_order` with `before` / `after` (each `{tool, input_match}`): proves order, for example the test
  edit before the fix edit. Deterministic, so prefer it over asking the judge.
- The subagent tool is named `Task` in `allowed_tools` but `Agent` in traces and in `tool_used` graders.

## Running

```bash
claude plugin eval . --case <case> --runs 1 --scaffold --allow-tools Write Edit Task \
  --trust-plugin --no-publish --threshold 0 --json evals/results/<case>.json
```

- `--scaffold` is required, or the agent sees an empty directory.
- Give `Write` and `Edit` (and `Task` when the skill spawns subagents) in both `allowed_tools` and
  `--allow-tools`. Without Write/Edit a "changes no file" check passes trivially.
- One `--case` flag per invocation: with several, only the last one runs. Loop in the shell instead.
- Results go to `evals/results/` (git-ignored). Traces in the temp folder are deleted after the run; the
  grader `evidence` field in the JSON keeps the judged trace, and its last `"result":"` holds the final reply.

## Windows: no shell tool

The eval children have no Bash or PowerShell tool (the Windows sandbox is off). The agent cannot run tests or
commit. Graders must accept: "could not run, here is the exact command", never a success claim without quoted
output from a real run. Real test runs are only proven by using the plugin in a real session.

## Rules learned the hard way

- Write the case before the skill and run it: that is the failing-before run. A case that passes without the
  plugin is only a regression guard; say so, and add a case that does separate the arms.
- Never use the eval scenario as the skill's own example. That teaches to the test.
- Never edit a grader to make a run pass. If a grader is wrong (wrong tool name, impossible condition), fix it
  before re-measuring, then re-run both arms and report it.
- Single runs are noisy (one judge vote can flip a case). Confirm important results with `--runs 3`.
- Cost and limits: a full suite at `--runs 3` is about 110 agent runs and about 25 USD, and it can exhaust the
  owner's 5-hour usage limit. Runs that hit the limit score 0 with an error: re-run them, do not count them.
- A skill that should run in any situation (verification before claiming success) needs its core rule in the
  router, which is always in context. A skill text alone may never load.
