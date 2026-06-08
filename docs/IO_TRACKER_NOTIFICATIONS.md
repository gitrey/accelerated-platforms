# Google I/O Tracker: Notification and Broadcast Logic

This document defines how the Google I/O Tracker Agent (F-0008) communicates updates to users and other agents within the Scion orchestration system.

## 1. Trigger Conditions
The agent should trigger a notification/broadcast when:
-   A new blog post is detected on "The Keyword" under the Google I/O category.
-   A new technical session transcript is processed and summarized.
-   A significant announcement is detected (e.g., major version release of a tool).

## 2. Notification Protocols

### 2.1 User Notifications
-   **Method:** Scion Hub Messaging.
-   **Format:**
    ```text
    🔔 Google I/O Update: [Title of Announcement]
    Category: [Android/AI/Cloud/etc.]
    Summary: [Concise summary from Task T-0027]
    Source: [URL]
    ```

### 2.2 Agent Broadcasts
-   **Method:** Hub-wide broadcast to agents subscribed to the `google-io-updates` topic.
-   **Payload:** Structured JSON containing the full summary and metadata.
-   **Target Agents:**
    -   `pm-agent`: For automated backlog suggestions based on new releases.
    -   `swe-*` agents: For technical awareness of new library versions.

## 3. Configuration Settings

| Setting | Value | Description |
| :--- | :--- | :--- |
| `CHECK_INTERVAL` | 3600s | Poll sources every hour. |
| `BROADCAST_ENABLED` | true | Enable agent-to-agent updates. |
| `NOTIFY_ON_KEYWORD` | ["Gemini", "ADK", "GKE"] | Immediate high-priority alerts for these terms. |

## 4. Operational Commands
-   `scion message google-io-tracker "What's new with Gemini?"`: On-demand retrieval.
-   `scion message google-io-tracker "Summarize today's highlights"`: Daily summary request.
