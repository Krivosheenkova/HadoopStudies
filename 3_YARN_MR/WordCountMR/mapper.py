#!/usr/bin/env python
import sys
import re
for line in sys.stdin:
    # remove extra spaces
    line = line.strip().lower()
    # split strings to words
    words = line.split()
    # add counter
    for word in words:
	# remove punctuation
	word = re.sub(r'\W', '', word)
        # output key value
        print ('%s\t%s' % (word, 1))
