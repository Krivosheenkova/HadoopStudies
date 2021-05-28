# mapper
#!/usr/bin/env python

import sys
for line in sys.stdin:
	# Setting some defaults
	country, corruption_perceptions, score = '-', '-', '-'
	# social_support, freedom_to_make_choices, gdp = '-', '-', '-'

	line = line.replace('\n', '')
	splits = line.split(',')

	if len(splits) == 6: 
		country = splits[1]
		# gdp = splits[2]
		corruption_perceptions = splits[3]
		# social_support = splits[4]
		# freedom_to_make_choices = splits[5]
	else:
		country = splits[1]
		score = splits[2]                   
	# print(f'{country}\t{gdp}\t{corruption_perceptions}\t{social_support}\t{freedom_to_make_choices}\t{score}')
	print(f'{country}\t{corruption_perceptions}\t{score}')