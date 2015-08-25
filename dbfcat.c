#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int read32le(unsigned char *ba) {
	return ((ba[0] & 0xFF)) |
		((ba[1] & 0xFF) << 8) |
		((ba[2] & 0xFF) << 16) |
		((ba[3] & 0xFF) << 24);
}

int read16le(unsigned char *ba) {
	return ((ba[0] & 0xFF)) |
		((ba[1] & 0xFF) << 8);
}

void decode(FILE *f) {
	unsigned char dbfheader[32];
	if (fread(dbfheader, 32, sizeof(char), f) != 1) {
		perror("read header");
		exit(EXIT_FAILURE);
	}

	int flen = read32le(dbfheader + 4);
	int dbheaderlen = read16le(dbfheader + 8);
	int dbreclen = read16le(dbfheader + 10);

	int cols = dbheaderlen - 32;
	unsigned char dbcolumns[cols];
	if (fread(dbcolumns, cols, sizeof(char), f) != 1) {
		perror("read columns");
		exit(EXIT_FAILURE);
	}

	int dbflen[cols / 32];
	int i;
	for (i = 0; i < cols / 32; i++) {
		if (i != 0) {
			putchar('|');
		}
		int start = i * 32;
		int end;
		for (end = start; end < start + 10 && dbcolumns[end] != '\0'; end++) {
			if (dbcolumns[end] != '|') {
				putchar(dbcolumns[end]);
			}
		}
		dbflen[i] = dbcolumns[32 * i + 16] & 0xff;
	}
	putchar('\n');

	unsigned char db[dbreclen];

	while (flen > 0) {
		if (fread(db, dbreclen, sizeof(char), f) != 1) {
			perror("read record");
			exit(EXIT_FAILURE);
		}

		int here = 1;
		for (i = 0; i < cols / 32; i++) {
			unsigned char *cp;
			unsigned char *end = cp;

			if (i != 0) {
				putchar('|');
			}

			for (cp = db + here; cp < db + here + dbflen[i]; cp++) {
				if (*cp != ' ') {
					end = cp + 1;
				}
			}

			for (cp = db + here; cp < end; cp++) {
				if (*cp == '|') {
					printf("\\u002c");
				} else {
					putchar(*cp);
				}
			}

			here += dbflen[i];
		}
		putchar('\n');
		flen--;
	}
}

int main(int argc, char **argv) {
	decode(stdin);
}
