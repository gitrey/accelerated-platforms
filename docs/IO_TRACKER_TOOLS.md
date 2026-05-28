# Google I/O Tracker Tools

This document describes the tools implemented for the Google I/O Tracker Agent. These tools are bundled as part of the `google-io-tracker` skill.

## 1. Web Monitor Tool (`web_monitor.py`)

Fetches the latest updates from the official Google I/O website and The Keyword blog.

### Usage
```bash
python3 skills/google-io-tracker/scripts/web_monitor.py --source [io|blog|both]
```

### Parameters
- `--source`: Specifies which source to monitor. Options are `io` (Google I/O Website), `blog` (The Keyword Blog), or `both` (default).

### Output
Returns a JSON array of objects, each containing:
- `source`: The name of the source.
- `url`: The URL of the source.
- `content`: Extracted text content or article list.

---

## 2. Summarization Tool (`summarizer.py`)

Processes text content to generate a concise summary and extract key announcements.

### Usage
```bash
# Via argument
python3 skills/google-io-tracker/scripts/summarizer.py --text "Your content here"

# Via stdin
cat content.txt | python3 skills/google-io-tracker/scripts/summarizer.py
```

### Parameters
- `--text`: The text content to process. If omitted, the tool reads from standard input.

### Output
Returns a JSON object containing:
- `summary`: A concise summary of the content.
- `key_announcements`: A list of potential announcements extracted based on keyword matching.

---

## 3. Integration as a Scion Skill

The tools are defined within the `google-io-tracker` skill.

### Skill Definition (`skills/google-io-tracker/SKILL.md`)
```markdown
---
name: google-io-tracker
description: Tools for monitoring Google I/O announcements and summarizing key updates.
---
# Google I/O Tracker Skill
...
```

### Agent Configuration Example
To use these tools in an ADK 2.0 agent, add them to the agent's configuration:

```yaml
tools:
  - name: web_monitor
    description: "Fetches updates from Google I/O website and blog."
    container:
      image: "python:3.11-slim"
      command: ["python", "skills/google-io-tracker/scripts/web_monitor.py"]
  
  - name: summarizer
    description: "Summarizes content and extracts announcements."
    container:
      image: "python:3.11-slim"
      command: ["python", "skills/google-io-tracker/scripts/summarizer.py"]
```
