#!/usr/bin/perl

print "Content-type: image/png\n\n";

@vars = split(/&/, $ENV{'QUERY_STRING'});

for $v (@vars) {
	($key, $val) = split(/=/, $v, 2);

        $val =~ s/%20/ /g;
        $val =~ s/[^A-Za-z0-9._: -]//g;

	$var{$key} = $val;
}

# Works out to about z12 (~100ft/pixel)
# Beyond that, alleys start to run into streets

chdir("/data2/data/github/datamaps");

# zoom 14: lines are about 25 feet thick

open(IN1, "./render -l 2 -c FFFF00 -B 14:.03:1.23 /data2/data/github/tiger-delta/county-delta-4-2.shape $var{'z'} $var{'x'} $var{'y'} |");
open(TMP1, ">/tmp/$$.1");
while (<IN1>) {
	print TMP1;
}
close(IN1);
close(TMP1);

# zoom 13: buffer is about 50 feet thick

open(IN2, "./render -l 2 -c FFFF00 -B 13:.06:1.23 /data3/data/osm/geofabrik-20130701/north-america-highway.shape $var{'z'} $var{'x'} $var{'y'} |");
open(TMP2, ">/tmp/$$.2");
while (<IN2>) {
	print TMP2;
}
close(IN2);
close(TMP2);

system "../pngsubtract/subtract /tmp/$$.1 /tmp/$$.2";

unlink("/tmp/$$.1");
unlink("/tmp/$$.2");