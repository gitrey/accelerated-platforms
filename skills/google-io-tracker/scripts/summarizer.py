#!/usr/bin/env python3
import sys
import json
import argparse
import re

def extract_announcements(text):
    """Simple rule-based extraction of potential announcements."""
    announcements = []
    # Look for keywords that suggest announcements
    keywords = ["announced", "introduced", "released", "launching", "new", "updated", "preview"]
    
    lines = text.split('\n')
    for line in lines:
        line = line.strip()
        if any(keyword.lower() in line.lower() for keyword in keywords):
            if len(line) > 10 and len(line) < 300:
                announcements.append(line)
                
    return announcements[:10] # Return top 10 potential announcements

def summarize(text):
    """Generates a summary and extracts key announcements."""
    # In a production ADK 2.0 environment, this tool would ideally 
    # interface with a Large Language Model (LLM).
    
    potential_announcements = extract_announcements(text)
    
    # Basic summary: first few sentences
    sentences = re.split(r'(?<=[.!?]) +', text)
    basic_summary = " ".join(sentences[:3])
    
    return {
        "summary": basic_summary,
        "key_announcements": potential_announcements
    }

def main():
    parser = argparse.ArgumentParser(description="Summarize Google I/O content and extract announcements.")
    parser.add_argument("--text", help="Text to process")
    args = parser.parse_args()

    if not args.text:
        # Try reading from stdin
        if not sys.stdin.isatty():
            args.text = sys.stdin.read()
        else:
            print(json.dumps({"error": "No text provided to summarize."}))
            sys.exit(1)

    result = summarize(args.text)
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
