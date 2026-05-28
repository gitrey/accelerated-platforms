#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
import argparse
import json
import sys

def fetch_content(url):
    """Fetches content from a URL."""
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        response = requests.get(url, headers=headers, timeout=15)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(f"Error fetching {url}: {e}", file=sys.stderr)
        return None

def parse_io_website(html):
    """Parses the Google I/O website for key information."""
    if not html:
        return "Failed to fetch Google I/O website."
    soup = BeautifulSoup(html, 'html.parser')
    
    # Try to find meaningful sections
    content = []
    
    # Look for headlines or featured sections
    # Note: These selectors are based on common patterns and may need adjustment
    headlines = soup.find_all(['h1', 'h2', 'h3'])
    for h in headlines[:10]:
        text = h.get_text(strip=True)
        if text:
            content.append(text)
            
    # Also get some paragraphs
    paragraphs = soup.find_all('p')
    for p in paragraphs[:5]:
        text = p.get_text(strip=True)
        if text:
            content.append(text)
            
    return "\n".join(content)

def parse_keyword_blog(html):
    """Parses The Keyword blog for Google I/O related posts."""
    if not html:
        return "Failed to fetch The Keyword blog."
    soup = BeautifulSoup(html, 'html.parser')
    
    articles = []
    # The Keyword blog typically uses 'article' tags or specific classes
    # This is a generic approach to find potential article entries
    for entry in soup.find_all(['article', 'div'], class_=['feed-item', 'post-item']):
        title_tag = entry.find(['h2', 'h3', 'a'], class_=['title', 'post-title'])
        if title_tag:
            title = title_tag.get_text(strip=True)
            link = entry.find('a')['href'] if entry.find('a') else "No link"
            if not link.startswith('http'):
                link = "https://blog.google" + link
            articles.append(f"- {title}\n  URL: {link}")
            
    if not articles:
        # Fallback: search for any links containing 'google-io'
        for a in soup.find_all('a', href=True):
            if 'google-io' in a['href'].lower() and a.get_text(strip=True):
                articles.append(f"- {a.get_text(strip=True)}\n  URL: {a['href']}")

    return "\n".join(articles[:10])

def main():
    parser = argparse.ArgumentParser(description="Monitor Google I/O updates.")
    parser.add_argument("--source", choices=["io", "blog", "both"], default="both", help="Source to monitor")
    args = parser.parse_args()

    results = []
    if args.source in ["io", "both"]:
        html = fetch_content("https://events.google.com/io")
        content = parse_io_website(html)
        results.append({
            "source": "Google I/O Website",
            "url": "https://events.google.com/io",
            "content": content
        })
    
    if args.source in ["blog", "both"]:
        html = fetch_content("https://blog.google/products/google-io/")
        content = parse_keyword_blog(html)
        results.append({
            "source": "The Keyword Blog",
            "url": "https://blog.google/products/google-io/",
            "content": content
        })
    
    print(json.dumps(results, indent=2))

if __name__ == "__main__":
    main()
