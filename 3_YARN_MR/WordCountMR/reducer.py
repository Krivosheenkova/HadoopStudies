#!/usr/bin/env python
import sys

current_word = None
current_count = 0
word = None

# read strings from stdin
for line in sys.stdin:
    # remove spaces at hte begining and at the end
    line = line.strip()

    # split key value
    word, count = line.split('\t', 1)

    # convert value to int
    try:
        count = int(count)
    except ValueError:
        # ignore errors
        continue

    #Reduce get data after sort
    if current_word == word:
        current_count += count
    else:
        if current_word:
            # write result to STDOUT
            print ('%s\t%s' % (current_word, current_count))
        current_count = count
        current_word = word

# Don't forget last word
if current_word == word:
    print ('%s\t%s' % (current_word, current_count))
