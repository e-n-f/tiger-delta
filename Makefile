PBF = /data3/data/osm/geofabrik-20130701/north-america-latest.osm.pbf

all: northam.snap


northam.snap: $(PBF) osmconvert snap
	./osmconvert $(PBF) | ./snap > northam.snap


shpcat.class: shpcat.java
	javac shpcat.java

snap: snap.c
	cc -g -Wall -O3 -o snap snap.c -lexpat

osmconvert: osmconvert.c
	cc -g -Wall -O3 -o osmconvert osmconvert.c -lz
