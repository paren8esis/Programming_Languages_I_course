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
 
#define MAX_N 500000
#define MAX_L 5000000

long double candidateInfo[MAX_N][4];
long double minVals[3];

long long int candidatesLeft;

/* candidateInfo array structure:
	N candidates x (position, speed, next to overtake, overtake time) */

/* minVals array structure:
	1 x (overtaker, overtaken, overtake time) */

void overtakeTime(long long int L, long long int curr, long long int N) {
/* Fills currentInfo with the length of time each candidate will need to overtake the next one and the index of the overtaken candidate. */

	long double dist, time = -1;
	long long int next = curr + 1;

	if (curr == N-1) // candidate is the last one
		next = 0;

	// find next candidate
	while ((candidateInfo[next][1] < 0) && (next != curr)) {
		if (next < N-1)
			next++;
		else
			next = 0;
	}
	
	if (next == curr) {
		candidateInfo[curr][2] = -1;
		candidateInfo[curr][3] = -1;
		return;
	}

	dist = (candidateInfo[next][0] - candidateInfo[curr][0]);
	if (dist < 0)
		dist += L; 

	time = dist / (candidateInfo[curr][1] - candidateInfo[next][1]);	

	candidateInfo[curr][3] = time;
	candidateInfo[curr][2] = next;
}

/* Goes through all candidates and finds minimum overtake time. */
long long int findMin(long long int N) {
	long long int i, min = -1;
	long double minTime = -1;

	int diff = 0, sec = 0;

	for (i = 0; i < N; i++) {
		if (candidateInfo[i][3] >= 0) {
			if (minTime == -1) {
				min = i;
				minTime = candidateInfo[i][3];
			} else {
				sec = 1;
				if (candidateInfo[i][3] != minTime) {
					diff = 1;
					if (candidateInfo[i][3] < minTime) {
						min = i;
						minTime = candidateInfo[i][3];
					}
				}
			}
		}
	}

	if ((!diff) && (sec))
		return -1;

	return  min;
}


int main(int argc, char *argv[]) {
	long long int N, L, i;
	long double speed, pos;

	FILE *file;
	file = fopen(argv[1], "r"); 

	/* Read first line of file: N L */
	if(fscanf(file, "%lld %lld", &N, &L) != 2) {
		printf("\nError while reading file.\n");
		exit(1);
	}
 
	candidatesLeft = N;

	/* Read the rest of the file */
	i = 0;
	while (fscanf(file, "%Lf %Lf", &pos, &speed) != EOF) {
		candidateInfo[i][0] = pos;
		candidateInfo[i][1] = speed;
		i++;
	}

	minVals[0] = -1;
	minVals[1] = -1;
	minVals[2] = -1;

	// Find overtake times for all candidates
	for (i = 0; i < N; i++) {
		// find overtake time and overtaken for i
		overtakeTime(L, i, N);
		
		// Keep overtakeTime if minimum
		if (candidateInfo[i][3] >= 0) {
			if ((candidateInfo[i][3] < minVals[2]) || (minVals[2] == -1)) {
				minVals[0] = i;
				minVals[1] = candidateInfo[i][2];
				minVals[2] = candidateInfo[i][3];
			}
		}
	}	

	long long int overtaker, overtaken;
	while ((minVals[0] != -1) && (candidatesLeft > 1)) {
		overtaker = (long long int)minVals[0];
		overtaken = (long long int)minVals[1];
		printf("%lld ", overtaken+1);
		candidateInfo[overtaken][1] = -1;  // update overtaken's speed
		candidateInfo[overtaken][3] = -1;  // update overtaken's time
		candidatesLeft--;
		overtakeTime(L, overtaker, N);
		
		if ((candidateInfo[overtaker][3] >= 0) && ((candidateInfo[overtaker][3] < minVals[2]) || (minVals[2] == -1))) {
			minVals[0] = overtaker;
			minVals[1] = candidateInfo[overtaker][2];
			minVals[2] = candidateInfo[overtaker][3];
		} else {
			overtaker = findMin(N);
			if (overtaker == -1)  // There is no other possible overtaking
				break;
			minVals[0] = overtaker;
			minVals[1] = candidateInfo[overtaker][2];
			minVals[2] = candidateInfo[overtaker][3];
		}
	}

	return 0;
}

