#!/usr/bin/env bash

# Every time this exits, record the state
function finish {
    echo "TOTAL_RECORDS=$TOTAL_RECORDS
PER_PAGE=$PER_PAGE
TOTAL_PAGES=$TOTAL_PAGES
START=$START
CURRENT_PAGE=$i" > .state
}
trap finish EXIT

# Define our API key.
API_KEY=SPECIFY_API_KEY_HERE

# Define the quadrangle being retrieved.
QUADRANGLE="latrange1=37.72&latrange2=38.28&longrange1=-78.84&longrange2=-78.21"

# If a state file has been saved, get the state from that
if [ -f .state ]; then
    source .state
fi

# If we're lacking the basic variable about where to start, start at the beginning
if [ -z "$START" ]; then
    # Request the first 100 records, to get the scope of what we're doing here
    URL="https://api.wigle.net/api/v2/network/search?onlymine=false&$QUADRANGLE&lastupdt=20150101&freenet=false&paynet=false&resultsPerPage=100"
    curl -s -X GET "$URL" -H "accept: application/json" \
        -u "$API_KEY" --basic > wigle-0.json

    # Figure out how to do the paging
    TOTAL_RECORDS=$(jq ".totalResults" wigle-0.json)
    PER_PAGE=100
    ((TOTAL_PAGES="$TOTAL_RECORDS"/"$PER_PAGE"))
    # Round up
    TOTAL_PAGES=$(echo "$TOTAL_PAGES" | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}')
    START=$(jq ".search_after" wigle-0.json)
    CURRENT_PAGE=0
fi

# Figure out what page to start on
if [[ -v CURRENT_PAGE ]]; then
    START_PAGE="$CURRENT_PAGE"
else
    START_PAGE=1
fi

# Iterate through all of the records
for (( i="$START_PAGE"; i<="$TOTAL_PAGES"; i++ )); do

    # Get the record
    URL="https://api.wigle.net/api/v2/network/search?onlymine=false&$QUADRANGLE&lastupdt=20150101&freenet=false&paynet=false&resultsPerPage=100&searchAfter=$START"
    curl -s -X GET "$URL" -H "accept: application/json" -u "$API_KEY" --basic > wigle-"$i".json
    echo "$i" of "$TOTAL_PAGES"
    
    # Check for errors returned by the API
    SUCCESS=$(jq ".success" wigle-"$i".json)
    if [ "$SUCCESS" == "false" ]; then
        ERROR_MESSAGE=$(jq ".message" wigle-"$i".json)
        echo "The API returned the following error: $ERROR_MESSAGE"
        exit 1
    fi

    # Assign a new value to start at for the next query
    START=$(jq ".search_after" wigle-"$i".json)

done
