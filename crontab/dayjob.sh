#!/bin/bash

JOBS=("bowldacai_spider.py" "chairman_spider.py" "curryupnow_spider.py" "halalcart_spider.py" "japacurry_spider.py" "senorsisig_spider.py")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../bin/activate
cd $DIR/../scripts/schedules/schedules/spiders

for i in "${JOBS[@]}"
do
    scrapy runspider $i
done

python $DIR/../scripts/schedules/slidershack_spider.py
