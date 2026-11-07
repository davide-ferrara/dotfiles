#!/usr/bin/env python3
"""Fetch small, public news feeds for the dashboard."""
import json
import sys
import urllib.request
import xml.etree.ElementTree as ET
from urllib.parse import urlparse

SOURCES = {
    'hacker': 'https://hn.algolia.com/api/v1/search?tags=front_page&hitsPerPage=8',
    'omarchy': 'https://omarchy.org/news/rss.xml',
}

def safe_url(url):
    parsed = urlparse(url)
    return len(url) <= 2048 and parsed.scheme in ('http', 'https') and bool(parsed.hostname) and not parsed.username and not parsed.password

def main():
    source = sys.argv[1]
    request = urllib.request.Request(SOURCES[source], headers={'User-Agent': 'OmarchyDashboard/1.0'})
    with urllib.request.urlopen(request, timeout=10) as response:
        data = response.read(2097153)
    if len(data) > 2097152:
        raise ValueError('feed too large')
    entries = []
    if source == 'hacker':
        for item in json.loads(data).get('hits', [])[:8]:
            ident = str(item.get('objectID', ''))
            if not ident.isdigit():
                continue
            url = item.get('url') or ('https://news.ycombinator.com/item?id=' + ident)
            if safe_url(url):
                entries.append({'title': str(item.get('title') or 'Untitled')[:180], 'url': url})
    else:
        tree = ET.fromstring(data)
        for item in tree.findall('./channel/item')[:8]:
            url = item.findtext('link', default='').strip()
            if safe_url(url) and urlparse(url).hostname == 'omarchy.org':
                entries.append({'title': (item.findtext('title', default='Untitled') or 'Untitled')[:180], 'url': url})
    print(json.dumps(entries, ensure_ascii=False))

if __name__ == '__main__':
    try:
        main()
    except Exception:
        print('[]')
        sys.exit(1)
