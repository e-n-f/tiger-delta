PBF = /data3/data/osm/geofabrik-20130701/north-america-latest.osm.pbf

all: northam.snap county-delta/78010


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
