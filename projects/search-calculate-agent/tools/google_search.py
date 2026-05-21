import sys
import json
import os

def search(query):
    # In a real implementation, this would call SerpAPI or Google Search API
    # For this PoC, we return a mock result
    print(f"DEBUG: Searching for '{query}'", file=sys.stderr)
    
    mock_results = {
        "current weather in san francisco": "San Francisco weather: 65°F, Sunny.",
        "capital of france": "The capital of France is Paris.",
        "who is the ceo of google": "Sundar Pichai is the CEO of Google.",
        "population of tokyo": "Tokyo's population is approximately 14 million."
    }
    
    return mock_results.get(query.lower(), f"No results found for '{query}'. (Mock Search)")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No query provided"}))
        sys.exit(1)
    
    query = sys.argv[1]
    result = search(query)
    print(json.dumps({"result": result}))
