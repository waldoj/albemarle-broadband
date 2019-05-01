# Albemarle Broadband Maps

Using [WiGLE data for Albemarle County](../wigle/) and [CAF-II records](https://data.usac.org/publicreports/caf-map/), plus some Census boundary data, I’ve built some maps, in an effort to figure out where broadband is and is not available in Albemarle County. These maps are based on incomplete information, and must be understood to be a proof of concept.

Using [QGIS](https://www.qgis.org/), I ginned up the following maps.

## WiGLE Records
Every WiGLE datapoint in Albemarle County.

![WiGLE Map](map-wigle.pdf)

## WiGLE Records of ISPs
Every WiGLE datapoint in Albemarle County with `xfinity` or `centurylink` in the SSID. This is basically a map of the most-driven roads in Albemarle County, which shows a weakness of WiGLE's data collection methods (volunteers who leave the software running on their Android phones).

![WiGLE Map of ISPs](map-wigle-isps.pdf)

## WiGLE Records of ISPs + CAF-II Records
Every WiGLE datapoint in Albemarle County with `xfinity` or `centurylink` in the SSID _plus_ all CAF-II records (that is, deployments of broadband funded by the Connect America Fund, which concentrates on rural areas).

![WiGLE Map of ISPs and CAF-II](map-wigle-caf-ii.pdf)

## Wardriving

I experimentally drove around a single census block group and collected SSIDs. In doing so, I identified 235 that contained the strings `centurylink` or `xfinity`, compared to 156 such records via WiGLE and 132 via CAF-II.
