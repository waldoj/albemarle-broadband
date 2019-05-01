# WiGLE API Harvester

[WiGLE](https://wigle.net/) provides a rich API, with an endpoint for retrieving all records within arbitrary quadrangles. There are no bulk downloads. This API harvester pages through the records, 100 at a time, and saves them to files. It’s stateful, to permit running over the course of days, since WiGLE caps the number of daily queries at a relatively low number.

Register for a WiGLE API key, and then specify that in `wigle.sh`. Customize the value of `QUADRANGLE` to the range that you want to retrieve records for. Run `./wigle.sh`, which will retrieve a bunch of records, saving each of them in your working directory. It’ll tell you when you hit your API cap for the day. Run it again the next day. Repeat until it reports that you have all of the records. Then run `./generate-geojson > records.geojson` to concatenate all of the records finds into a single GeoJSON file.

## Requirements
* jq
* cURL
* json2csv
* csv2geojson
