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

$tmp = "/tmp/$$";

# zoom 14: lines are about 25 feet thick

open(IN, "./render -l 2 -c 3333FF -B 14:.03:1.23 /data2/data/github/tiger-delta/preserved.shape $var{'z'} $var{'x'} $var{'y'} |");
open(TMP, ">$tmp.1");
while (<IN>) {
	print TMP;
}
close(IN);
close(TMP);

# buffer is exactly the same because all we want is to eliminate ones that were just split

open(IN, "./render -l 2 -c 3333FF -B 13:.06:1.23 /data2/data/github/tiger-delta/new.shape $var{'z'} $var{'x'} $var{'y'} |");
open(TMP, ">$tmp.2");
while (<IN>) {
	print TMP;
}
close(IN);
close(TMP);

system "../pngsubtract/subtract $tmp.1 $tmp.2";

unlink("$tmp.1");
unlink("$tmp.2");
