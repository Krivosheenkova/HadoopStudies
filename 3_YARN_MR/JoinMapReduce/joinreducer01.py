# reducer
#!/usr/bin/env python
import sys
import string

last_country = None
cur_index = "-"

for line in sys.stdin:
    line = line.strip()
    country, corruption_perceptions_index, score = line.split("\t")

    if not last_country or last_country != country:
        last_country = country
        cur_index = corruption_perceptions_index
    elif country == last_country:
        index = cur_index
    print('%s\t%s' % (corruption_perceptions_index, score))
