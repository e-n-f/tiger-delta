SHELL = /bin/bash

PBF = /data3/data/osm/geofabrik-20131028/north-america-latest.osm.pbf

all: preserved.shape/meta northam.shape/meta new.shape/meta


# Obsolete streets from old TIGER that are still preserved in OSM, as datamaps
preserved.shape/meta: preserved.sort ../datamaps/encode
	rm -rf preserved.shape; cat preserved.sort | sed 's/:/ /' | ../datamaps/encode -o preserved.shape -z20

# Obsolete streets from old TIGER that are still preserved in OSM
preserved.sort: old.sort northam.snap.sort
	LC_ALL=C join <(LC_ALL=C comm -12 <(awk '{print $$1}' old.sort) <(awk '{print $$1}' northam.snap.sort)) northam.snap.sort > preserved.sort


# Current OSM, as shape
northam.shape/meta: northam.snap.sort ../datamaps/encode
	rm -rf northam.shape; cat northam.snap.sort | sed 's/:/ /' | ../datamaps/encode -o northam.shape -z20

# Just the current OSM ways
northam.snap.sort: northam.snap
	cat northam.snap | sed 's/ /:/' | LC_ALL=C sort > northam.snap.sort

# Just the streets from old TIGER that aren't still in new TIGER
old.sort: county-delta/78010
	cat county-delta/* | grep 4:11 | sed 's/ /:/' | LC_ALL=C sort > old.sort

# New TIGER as datamaps
new.shape/meta: new.sort ../datamaps/encode
	rm -rf new.shape; cat new.sort | sed 's/:/ /' | ../datamaps/encode -o new.shape -z20

# Just the streets from new TIGER that weren't in old TIGER
new.sort: county-delta/78010
	cat county-delta/* | grep 4:2 | sed 's/ /:/' | LC_ALL=C sort > new.sort


# Current OSM ways, as flat text
northam.snap: $(PBF) osmconvert snap
	./osmconvert $(PBF) | ./snap > northam.snap

# Streets in new TIGER that aren't in old TIGER, and
# streets in old TIGER that aren't in new TIGER
county-delta/78010: shpcat.class dbfcat.class get-all2 get-county-delta2 get-county-delta-wrap2
	./get-all2


# Converts ESRI shapefiles to text
shpcat.class: shpcat.java
	javac shpcat.java

# Converts dBase III to text
dbfcat.class: dbfcat.java
	javac dbfcat.java

# Attaches the locations of OSM nodes to segments of the ways that include them
snap: snap.c
	cc -g -Wall -O3 -o snap snap.c -lexpat

# Converts OSM PBF to XML
osmconvert: osmconvert.c
	cc -g -Wall -O3 -o osmconvert osmconvert.c -lz
