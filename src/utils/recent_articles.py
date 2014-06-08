#!/usr/bin/env python
from __future__ import print_function
from stat import S_ISREG, ST_CTIME, ST_MODE
import os, sys, time

# path to the directory (relative or absolute)
dirpath = sys.argv[1] if len(sys.argv) == 2 else r'src'

# get all entries in the directory w/ stats
#entries = (os.path.join(dirpath, fn) for fn in [os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser(dirpath)) for f in fn if f.endswith(".md")])
entries = ((os.stat(path), path) for path in [os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser(dirpath)) for f in fn if f.endswith(".md")])

# leave only regular files, insert creation date
entries = ((stat[ST_CTIME], path)
           for stat, path in entries if S_ISREG(stat[ST_MODE]))
#NOTE: on Windows `ST_CTIME` is a creation date
#  but on Unix it could be something else
#NOTE: use `ST_MTIME` to sort by a modification date

import re
from dateutil import parser

articles = []
for cdate, path in reversed(sorted(entries)):
   with open(path, 'r') as f:
      article = f.read()
      title = re.search(r'title:\s*"(.*)"', article).group(1)
      url = re.search(r'urls:\s*\-(.*)', article).group(1)
      date = re.search(r'date:\s*"(.*)"', article).group(1)
      articles.append('<li><a href="%s">%s</a><span>%s</span></li>' % (url, title, parser.parse(date).strftime("%B %d, %Y")))

print("Adding recent articles...")
os.system("sed -i '' -e 's:<ul></ul>:<ul>%s</ul>:g' out/index.html" % "".join(articles))
