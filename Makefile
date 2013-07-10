SHELL = /bin/bash

PBF = /data3/data/osm/geofabrik-20130701/north-america-latest.osm.pbf

all: preserved.shape/meta northam.snap.sort old.sort new.sort


preserved.shape/meta: preserved.sort ../datamaps/encode
	cat preserved.sort | ../datamaps/encode -o preserved.shape -z20 -m4

preserved.sort: old.sort northam.snap.sort
	LC_ALL=C comm -12 <(awk '{print $$1}' old.sort) <(awk '{print $$1}' northam.snap.sort) > preserved.sort

northam.snap.sort: northam.snap
	cat northam.snap | sed 's/ /:/' | LC_ALL=C sort > northam.snap.sort

old.sort: county-delta/78010
	cat county-delta/* | grep 4:11 | sed 's/ /:/' | LC_ALL=C sort > old.sort

new.sort: county-delta/78010
	cat county-delta/* | grep 4:2 | sed 's/ /:/' | LC_ALL=C sort > new.sort


northam.snap: $(PBF) osmconvert snap
	./osmconvert $(PBF) | ./snap > northam.snap

county-delta/78010: shpcat.class get-all get-county-delta get-county-delta-wrap
	./get-all


shpcat.class: shpcat.java
	javac shpcat.java

snap: snap.c
	cc -g -Wall -O3 -o snap snap.c -lexpat

osmconvert: osmconvert.c
	cc -g -Wall -O3 -o osmconvert osmconvert.c -lz
