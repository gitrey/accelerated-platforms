# Google I/O Tracker Storage Schema

This document describes the persistent storage schema used by the Google I/O Tracker Agent to store and retrieve announcements.

## Storage Type
The agent uses a **SQLite** database for persistent storage to allow for structured queries and efficient retrieval of historical announcements.

## Database Location
The database file is located at: `tools/io_tracker/announcements.db`

## Schema Definitions

### `announcements` Table
Stores individual announcements, sessions, or blog post updates.

| Column | Type | Description |
|--------|------|-------------|
| `id` | INTEGER | Primary key, auto-incrementing. |
| `title` | TEXT | Title of the announcement or session. |
| `date` | TEXT | Date of the announcement (ISO 8601 format: YYYY-MM-DD). |
| `category` | TEXT | Category (e.g., Android, AI, Cloud, Firebase). |
| `summary` | TEXT | Concise summary of the key takeaways. |
| `url` | TEXT | URL to the original source. |

## Tool Usage

The storage is managed via the following tools/functions:

### `save_announcement`
Saves a new announcement to the database.

**Arguments:**
- `title` (string): Title of the announcement.
- `date` (string): Date of the announcement.
- `category` (string): Category of the announcement.
- `summary` (string): Summary of the announcement.
- `url` (string): URL of the announcement.

### `get_announcements`
Retrieves announcements based on filters.

**Arguments:**
- `category` (string, optional): Filter by category.
- `date` (string, optional): Filter by date.
- `search_query` (string, optional): Search in title and summary.

### `list_categories`
Lists all unique categories in the database.
