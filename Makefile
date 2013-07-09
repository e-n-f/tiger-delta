all: shpcat.class snap


shpcat.class: shpcat.java
	javac shpcat.java

snap: snap.c
	cc -g -Wall -O3 -o snap snap.c -lexpat
