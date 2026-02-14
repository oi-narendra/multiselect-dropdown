---
description: Triage and respond to a new GitHub issue.
---

# Workflow: Triage Issue

Help triage an incoming GitHub issue.

## Step 1: Read the Issue

```bash
gh issue view <ISSUE_NUMBER>
```

## Step 2: Classify

Determine the issue type and priority:

| Label              | Criteria                                   |
| ------------------ | ------------------------------------------ |
| `bug`              | Something that worked before is broken     |
| `enhancement`      | New feature or improvement request         |
| `question`         | Usage question (redirect to Discussions)   |
| `duplicate`        | Already reported (link to original)        |
| `invalid`          | Not a real issue / misuse                  |
| `good first issue` | Simple, well-scoped, good for contributors |
| `help wanted`      | We want external contributions             |
| `breaking-change`  | Would require a major version bump         |

## Step 3: Assess

For **bugs**:

- Can we reproduce it from the description?
- Which version/platform is affected?
- Is it a regression or a long-standing issue?
- What's the severity? (crash / wrong behavior / cosmetic)

For **features**:

- Does it fit the package's scope?
- Would it benefit a broad set of users?
- Does it conflict with existing API design?
- How complex is the implementation?

## Step 4: Respond

Apply appropriate labels:

```bash
gh issue edit <ISSUE_NUMBER> --add-label "<label>"
```

If more info is needed, comment:

```bash
gh issue comment <ISSUE_NUMBER> --body "Thanks for reporting! Could you provide:
- Your Flutter version (\`flutter --version\`)
- A minimal code sample to reproduce
- The platform you're testing on"
```

If it's a question, redirect:

```bash
gh issue comment <ISSUE_NUMBER> --body "This looks like a usage question. Please post it in [Discussions](https://github.com/oi-narendra/multiselect-dropdown/discussions) instead."
gh issue close <ISSUE_NUMBER> --reason "not planned"
```

## Output

Summarize:

- Issue classification
- Labels applied
- Response sent (if any)
- Recommended next steps
