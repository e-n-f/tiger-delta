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
sub run {
	open(IN, @_[0]);
	open(TMP, @_[1]);
	while (<IN>) {
		print TMP;
	}
	close(IN);
	close(TMP);
}

# zoom 13: lines are about 50 feet thick

run("./render -l 2 -c 3333FF -B 13:.32:1.23 /data2/data/github/tiger-delta/preserved.shape $var{'z'} $var{'x'} $var{'y'} |", ">$tmp.1");

# buffer is exactly the same because all we want is to eliminate ones that were just split

run("./render -l 2 -c 3333FF -B 13:.32:1.23 /data2/data/github/tiger-delta/new.shape $var{'z'} $var{'x'} $var{'y'} |", ">$tmp.2");

# subtract new tiger from preserved tiger, leaving only should-be-relocated tiger

run("../pngsubtract/subtract $tmp.1 $tmp.2 |", ">$tmp.remove");

# zoom 16: lines are about 6 feet thick

run("./render -l 2 -c FFFF00 -B 16:.08:1.23 /data2/data/github/tiger-delta/new.shape $var{'z'} $var{'x'} $var{'y'} |", ">$tmp.3");

# zoom 14: lines are about 25 feet thick

run("./render -l 2 -c FFFF00 -B 14:.32:1.23 /data2/data/github/tiger-delta/northam.shape $var{'z'} $var{'x'} $var{'y'} |", ">$tmp.4");

run("../pngsubtract/subtract $tmp.3 $tmp.4 |", ">$tmp.add");

if (0 && $var{'z'} < 11) {
	system "../pngsubtract/subtract -a $tmp.1 $tmp.3";
} else {
	system "../pngsubtract/subtract -a $tmp.remove $tmp.add";
}

unlink("$tmp.1");
unlink("$tmp.2");
unlink("$tmp.remove");
unlink("$tmp.3");
unlink("$tmp.4");
unlink("$tmp.add");
