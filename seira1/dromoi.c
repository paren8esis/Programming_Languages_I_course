/* Copyright 2015 paren8esis*/

/* This program is free software: you can redistribute it and/or modify*/
/*    it under the terms of the GNU General Public License as published by*/
/*    the Free Software Foundation, either version 3 of the License, or*/
/*    (at your option) any later version.*/

/*    This program is distributed in the hope that it will be useful,*/
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of*/
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the*/
/*    GNU General Public License for more details.*/

/*    You should have received a copy of the GNU General Public License*/
/*    along with this program.  If not, see <http://www.gnu.org/licenses/>.*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
 
#define MAX_N 1000000
#define MAX_L 1000000000
#define MAX_X 1000000000

long int parts[(2*MAX_N)+1][3];
//long int days[MAX_N];

/* 'parts' array structure: 
	(2*N + 1) x (S or E point, day, 1 for S or 0 for E) */


int compare(void *a, void *b) {
/* Function to be used in qsort().
	Takes two rows 'a' and 'b' of the 'parts' array as input and compares
	their first element.
	Returns: 
	0 if a[0] == b[0]  
	1 if a[0] > b[0]
	-1 if a[0] < b[0] */
	long int (*n1)[3] = a;
	long int (*n2)[3] = b;
	if ((*n1)[0] == (*n2)[0]) 
		return  0; 
	else if ((*n1)[0] <  (*n2)[0])
		return -1;
	else
		return  1;;
}

int isRoadFixed(long int day, long int N, long int X) {
/* Checks if the maximun unfixed part of the road is <= X on a given day.
	If it is, returns 1. Otherwise returns 0. */
	long int start, counter, i;

	start = 0;
	counter = 0;
	for (i = 0; i <= (2*N); i++) {
		if (parts[i][1] > day)
			continue;
		else {
			if ((counter == 0) && (parts[i][2] == 1)) {
				if (parts[i][0] - start > X)
					return 0;
				else
					counter++;
			} else if (parts[i][2] == 1) {
				counter++;		
			} else {
				counter--;
				if (counter == 0)
					start = parts[i][0];
			}	
		}
	}
	
	return 1;
}

int main(int argc, char *argv[]) {
	long int N, L, X, i, S, E, day, lastDay, start, end;
	int roadFixed;

	FILE *file;
	file = fopen(argv[1], "r"); 

	/* Read first line of file: N L X */
	if(fscanf(file, "%ld %ld %ld", &N, &L, &X) != 3) {
		printf("\nError while reading file.\n");
		exit(1);
	}
 
	/* Read the rest of the file */
	day = 1;
	i = 0;
	while (fscanf(file, "%ld %ld", &S, &E) != EOF) {
		parts[i][0] = S;
		parts[i][1] = day;
		parts[i][2] = 1;
		i++;
		parts[i][0] = E;
		parts[i][1] = day;
		parts[i][2] = 0;
		i++;
		day++;
	}
	parts[i][0] = L;
	parts[i][1] = 0;
	parts[i][2] = 1;

	// Sort 'parts' array based on position (first column)
	qsort(parts, (2*N)+1, sizeof(parts[0]), (void *)compare );

	// Binary search for the suitable day
	lastDay = 0; 
	start = 1;
	end = N;
	while (end >= start) {
		day = floor(((end - start)/2) + start);
		roadFixed = isRoadFixed(day, N, X);
		if (roadFixed) {
			if (lastDay == day) 
				break;
			end = day - 1;
			lastDay = day;
		} else {
			start = day + 1;
		}
	}

	if (lastDay == 0)
		printf("-1");
	else
		printf("%d", (int)lastDay);

	return 0;

}
