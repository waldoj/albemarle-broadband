#!/bin/bash

# Turn all of the results into a CSV file
jq '.results | .[]' *.json |json2csv > /tmp/places.csv

# Save the header row
HEADER=$(head -1 /tmp/places.csv)

# Start a new file, using the header
echo "$HEADER" > /tmp/places-filtered.csv

# Filter the list to include only non-Charlottesville ISP routers
grep -v "Charlottesville" /tmp/places.csv |egrep -i "(xfinity|centurylink)" >> /tmp/places-filtered.csv

# Generate GeoJSON, send it to STDOUT
csv2geojson /tmp/places-filtered.csv

# Remove our temporary files
rm /tmp/places.csv
rm /tmp/places-filtered.csv
