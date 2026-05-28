import sqlite3
import os
from typing import List, Optional, Dict

DB_PATH = os.path.join(os.path.dirname(__file__), "announcements.db")

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    """Initializes the database schema."""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS announcements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            date TEXT NOT NULL,
            category TEXT NOT NULL,
            summary TEXT NOT NULL,
            url TEXT NOT NULL UNIQUE
        )
    ''')
    conn.commit()
    conn.close()

def save_announcement(title: str, date: str, category: str, summary: str, url: str) -> bool:
    """Saves a new announcement to the database. Returns True if successful."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('''
            INSERT OR IGNORE INTO announcements (title, date, category, summary, url)
            VALUES (?, ?, ?, ?, ?)
        ''', (title, date, category, summary, url))
        conn.commit()
        success = cursor.rowcount > 0
        conn.close()
        return success
    except sqlite3.Error as e:
        print(f"Database error: {e}")
        return False

def get_announcements(category: Optional[str] = None, date: Optional[str] = None, search_query: Optional[str] = None) -> List[Dict]:
    """Retrieves announcements based on optional filters."""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = "SELECT * FROM announcements WHERE 1=1"
    params = []
    
    if category:
        query += " AND category = ?"
        params.append(category)
    
    if date:
        query += " AND date = ?"
        params.append(date)
        
    if search_query:
        query += " AND (title LIKE ? OR summary LIKE ?)"
        params.extend([f"%{search_query}%", f"%{search_query}%"])
        
    query += " ORDER BY date DESC"
    
    cursor.execute(query, params)
    rows = cursor.fetchall()
    conn.close()
    
    return [dict(row) for row in rows]

def list_categories() -> List[str]:
    """Lists all unique categories."""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT DISTINCT category FROM announcements ORDER BY category")
    categories = [row['category'] for row in cursor.fetchall()]
    conn.close()
    return categories

if __name__ == "__main__":
    init_db()
    print(f"Database initialized at {DB_PATH}")
