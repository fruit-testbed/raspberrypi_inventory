#!/usr/bin/env python3
#
# Run: python3 -m http.server 5998 --cgi
#
import os
import cgitb
import sys

os.makedirs('./logs', exist_ok=True)
os.makedirs('./data', exist_ok=True)

cgitb.enable(display=0, logdir="./logs")

content_length = int(os.environ.get('CONTENT_LENGTH', '0'))
data = sys.stdin.buffer.read(content_length)

path_info = os.environ.get('PATH_INFO', None)
if not path_info:
    raise Exception('No PATH_INFO given')

path = os.path.normpath('./data/' + path_info)
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, 'wb') as f:
    f.write(data)

print()
print(path)
