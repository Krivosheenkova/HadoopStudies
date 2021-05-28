test:
cat ./country_* | python joinmapper01.py | sort | python joinreducer01.py >> test_result.txt 
