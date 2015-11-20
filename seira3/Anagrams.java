import java.io.*;
import java.util.*;

/* The objects of this class describe the state of the system 
	on a given time. */
class State {
	String Stack1;		// Contents of stack 1
	String Stack2;		// Contents of stack 2
	String Buffer;		// Contents of buffer

	/* Constructor */
	State(String newStack1, String newStack2, String newBuffer) {
		this.Stack1 = newStack1;
		this.Stack2 = newStack2;
		this.Buffer = newBuffer;
	}

	/* Returns the contents of stack 1 */
	String getStack1() {
		return this.Stack1;
	}
		
	/* Returns the contents of stack 2 */
	String getStack2() {
		return this.Stack2;
	}

	/* Returns the contents of the buffer */
	String getBuffer() {
		return this.Buffer;
	}

	/* Overriding the hashCode() and equals() methods
		so that the operations on the hashmap 'checked' work properly */
	@Override
	public int hashCode() {
		return Stack1.hashCode() ^ Stack2.hashCode() ^ Buffer.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null)
			return false;
		if (!(obj instanceof State))
			return false;
		
		State other = (State) obj;

		if (!this.Stack1.equals(other.Stack1))
			return false;
		if (!this.Stack2.equals(other.Stack2))
			return false;
		if (!this.Buffer.equals(other.Buffer))
			return false;

		return true;
	}
}

public class Anagrams {
	static HashMap<State, String> checked = new HashMap<State, String>();
	/* Keeps the states that we've already been through, so that
		we avoid making circles.
		Structure:  {[Stack1, Stack2, Buffer] -> [Moves]} */

	static ArrayList<String[]> tree = new ArrayList<String[]>();
	/* Keeps the states opened by the BFS algorithm.
		Structure: ArrayList of [Stack1, Stack2, Buffer, Moves] */

	static String target = new String();
	/* The second string given */

	static boolean found = false;

	/* Performs a 10-move from the given state and returns the 
		new state */
	public static State move10(String st1, String st2, String buff) {
		if ((st1.equals("")) || (!buff.equals(""))) {
			return null;
		} else {
			buff = Character.toString(st1.charAt(st1.length()-1));
			if (st1.length() == 1)
				st1 = "";
			else
				st1 = st1.substring(0, st1.length()-1);

			State nextState = new State(st1, st2, buff);

			if (!checked.containsKey(nextState))
				return nextState;
			else
				return null;
		}
	}

	/* Performs a 12-move from the given state and returns the 
		new state */
	public static State move12(String st1, String st2, String buff) {
		if (st1.equals(""))
			return null;
		else {
			st2 = st2.concat(Character.toString(st1.charAt(st1.length()-1)));

			if (st2.equals(target))
				found = true;

			if (st1.length() == 1)
				st1 = "";
			else
				st1 = st1.substring(0, st1.length()-1);

			State nextState = new State(st1, st2, buff);

			if (!checked.containsKey(nextState))
				return nextState;
			else
				return null;
		}
	}

	/* Performs a 01-move from the given state and returns the 
		new state */
	public static State move01(String st1, String st2, String buff) {
		if (buff.equals(""))
			return null;
		else {
			State nextState = new State(st1.concat(buff), st2, "");

			if (!checked.containsKey(nextState))
				return nextState;
			else
				return null;
		}			
	}

	/* Performs a 02-move from the given state and returns the 
		new state */
	public static State move02(String st1, String st2, String buff) {
		if (buff.equals(""))
			return null;
		else {
			st2 = st2.concat(buff);
			State nextState = new State(st1, st2, "");

			if (st2.equals(target))
				found = true;

			if (!checked.containsKey(nextState)) 
				return nextState;
			else
				return null;
		}
	}

	/* Performs a 20-move from the given state and returns the 
		new state */
	public static State move20(String st1, String st2, String buff) {
		if (st2.equals("") || !buff.equals("")) 
			return null;
		else {
			buff = Character.toString(st2.charAt(st2.length()-1));
			if (st2.length() == 1)
				st2 = "";
			else
				st2 = st2.substring(0, st2.length()-1);

			if (st2.equals(target))
				found = true;

			State nextState = new State(st1, st2, buff);

			if (!checked.containsKey(nextState))
				return nextState;
			else
				return null;
		}
	}

	/* Performs a 21-move from the given state and returns the 
		new state */
	public static State move21(String st1, String st2, String buff) {
		if (st2.equals(""))
			return null;
		else {
			st1 = st1.concat(Character.toString(st2.charAt(st2.length()-1)));
			if (st2.length() == 1)
				st2 = "";
			else
				st2 = st2.substring(0, st2.length()-1);
			
			if (st2.equals(target))
				found = true;

			State nextState = new State(st1, st2, buff);

			if (!checked.containsKey(nextState))
				return nextState;
			else
				return null;
		}
	}

	/* The main method */
	public static void main(String[] args) {
		// Check input
		if (args.length == 0) {		
			System.out.println("Error: Not enough input arguments\n");
			System.exit(1);
		}

		State root = new State(args[0], "", "");
		target = args[1];

		String[] initial = new String[4];
		initial[0] = args[0];
		initial[1] = "";
		initial[2] = "";
		initial[3] = "";

		// Add initial state to tree
		tree.add(initial);

		// Perform BFS looking for the target string
		String st1 = args[0];
		String st2 = "";
		String buff = "";
		String moves = "";

		while (!st2.equals(target)) {
			st1 = tree.get(0)[0];
			st2 = tree.get(0)[1];
			buff = tree.get(0)[2];
			moves = tree.get(0)[3];

			tree.remove(0);

			if (st2.equals(target)) { 	// Stop search - target reached
				System.out.println(moves);
				break;
			} else {		// Keep searching
				State move10 = move10(st1, st2, buff);
				if (move10 instanceof State) {
					String newMoves;
					if (moves.equals(""))
						newMoves = "10";
					else
						newMoves = moves.concat("-10");

					String[] newState = new String[4];
					newState[0] = move10.getStack1();
					newState[1] = move10.getStack2();
					newState[2] = move10.getBuffer();
					newState[3] = newMoves;
					tree.add(newState);
					checked.put(move10, newMoves);
				}

				State move12 = move12(st1, st2, buff);
				if (move12 instanceof State) {
					String newMoves;
					if (moves.equals(""))
						newMoves = "12";
					else
						newMoves = moves.concat("-12");

					if (found) {
						System.out.println(newMoves);
						break;
					}

					String[] newState = new String[4];
					newState[0] = move12.getStack1();
					newState[1] = move12.getStack2();
					newState[2] = move12.getBuffer();
					newState[3] = newMoves;
					tree.add(newState);
					checked.put(move12, newMoves);
				}

				State move01 = move01(st1, st2, buff);
				if (move01 instanceof State) {
					String newMoves;
					if (moves.equals(""))
						newMoves = "01";
					else
						newMoves = moves.concat("-01");
					String[] newState = new String[4];
					newState[0] = move01.getStack1();
					newState[1] = move01.getStack2();
					newState[2] = move01.getBuffer();
					newState[3] = newMoves;
					tree.add(newState);
					checked.put(move01, newMoves);
				}

				State move02 = move02(st1, st2, buff);
				if (move02 instanceof State) {
					String newMoves;
					if (moves.equals(""))
						newMoves = "02";
					else
						newMoves = moves.concat("-02");
				
					if (found) {
						System.out.println(newMoves);
						break;
					}

					String[] newState = new String[4];
					newState[0] = move02.getStack1();
					newState[1] = move02.getStack2();
					newState[2] = move02.getBuffer();
					newState[3] = newMoves;
					tree.add(newState);
					checked.put(move02, newMoves);
				}

				State move20 = move20(st1, st2, buff);
				if (move20 instanceof State) {
					String newMoves;
					if (moves.equals(""))
						newMoves = "20";
					else
						newMoves = moves.concat("-20");

					if (found) {
						System.out.println(newMoves);
						break;
					}

					String[] newState = new String[4];
					newState[0] = move20.getStack1();
					newState[1] = move20.getStack2();
					newState[2] = move20.getBuffer();
					newState[3] = newMoves;
					tree.add(newState);
					checked.put(move20, newMoves);
				}

				State move21 = move21(st1, st2, buff);
				if (move21 instanceof State) {
					String newMoves;
					if (moves.equals(""))
						newMoves = "21";
					else
						newMoves = moves.concat("-21");

					if (found) {
						System.out.println(newMoves);
						break;
					}

					String[] newState = new String[4];
					newState[0] = move21.getStack1();
					newState[1] = move21.getStack2();
					newState[2] = move21.getBuffer();
					newState[3] = newMoves;
					tree.add(newState);
					checked.put(move21, newMoves);
				}
			}
		}
	}
	
}
