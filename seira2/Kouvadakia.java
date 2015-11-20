// Copyright 2015 paren8esis

// This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.

//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

import java.io.*;
import java.math.BigInteger;

public class Kouvadakia {
	public static String checkChain(int a, int b, int target, int[] order) {
	/* Returns the possible chain of moves 0->a->b->0 */
		int whatsInA = 0;
		int whatsInB = 0;
		String sol = "";

		while ((whatsInA != target) && (whatsInB != target)) {
			if (whatsInA == 0) {
				// a is empty; fill a.
				whatsInA = a;
				if (sol.equals("")) 
					sol = "0" + Integer.toString(order[0]);
				else
					sol += "-0" + Integer.toString(order[0]);	
			} else if (whatsInB == b) {
				// b is full; empty b.
				whatsInB = 0;
				if (sol.equals("")) 
					sol = Integer.toString(order[1]) + "0";
				else
					sol += "-" + Integer.toString(order[1]) + "0";
			} else {
				// neither a is empty, nor b is full; empty a into b.
				if (b - whatsInB - whatsInA >= 0) {
					// a's contents fit into b
					whatsInB = whatsInB + whatsInA;
					whatsInA = 0;
				} else {
					// a's contents do not fit into b
					whatsInA = whatsInA - (b - whatsInB);
					whatsInB = b;	// b gets full
				}
				if (sol.equals("")) 
					sol = Integer.toString(order[0]) + Integer.toString(order[1]);
				else
					sol += "-" + Integer.toString(order[0]) + Integer.toString(order[1]);
			}
		}

		return sol;
	}

	public static void main(String[] args) {
		// Read input
		if (args.length == 0) {
			System.out.println("Error: Not enough input arguments\n");
			System.exit(1);
		}


		int V1 = Integer.parseInt(args[0].trim());
		int V2 = Integer.parseInt(args[1].trim());
		int Vg = Integer.parseInt(args[2].trim());

		// Check if this is a solvable problem
		int gcd = BigInteger.valueOf(V1).gcd(BigInteger.valueOf(V2)).intValue();
		if ((Vg % gcd != 0) || ((Vg > V1) && (Vg > V2))) {
			System.out.println("impossible");
			System.exit(1);
		}

		int[] order = new int[2];
		order[0] = 1;
		order[1] = 2;
		String chain0120 = checkChain(V1, V2, Vg, order);
		order[0] = 2;
		order[1] = 1;
		String chain0210 = checkChain(V2, V1, Vg, order);
		
		if (chain0120.length() < chain0210.length()) 
			System.out.println(chain0120);
		else
			System.out.println(chain0210);
	}

}
