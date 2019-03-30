#!/usr/bin/env bash

# Define our API key.
API_KEY=SPECIFY_API_KEY_HERE

# Define the quadrangle being retrieved.
QUADRANGLE="latrange1=37.72&latrange2=38.28&longrange1=-78.84&longrange2=-78.21"

# Request the first 100 records, to get the scope of what we're doing here
URL="https://api.wigle.net/api/v2/network/search?onlymine=false&$QUADRANGLE&lastupdt=20150101&freenet=false&paynet=false&resultsPerPage=100"
curl -s -X GET "$URL" -H "accept: application/json" \
    -u "$API_KEY" --basic > wigle.json

# Figure out how to do the paging
TOTAL_RECORDS=$(jq ".totalResults" wigle.json)
PER_PAGE=100
((TOTAL_PAGES="$TOTAL_RECORDS"/"$PER_PAGE"))
START=$(jq ".search_after" wigle.json)

# Remove this starter file.
rm wigle.json

# Iterate through all of the records
for (( i=0; i<="$TOTAL_PAGES"; i++ )); do

    # Get the record
    URL="https://api.wigle.net/api/v2/network/search?onlymine=false&$QUADRANGLE&lastupdt=20150101&freenet=false&paynet=false&resultsPerPage=100&searchAfter=$START"
    curl -s -X GET "$URL" -H "accept: application/json" -u "$API_KEY" --basic > wigle-"$i".json
    echo "$i" of "$TOTAL_PAGES"
    
    # Assign a new value to start at for the next query
    START=$(jq ".search_after" wigle-"$i".json)

done
