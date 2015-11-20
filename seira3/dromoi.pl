%	?- read_and_return/4
%
%	Reads the information of an input file and returns
%	it in the next three arguments: two integers and a list with seg/2
%	structures with the start and end of a segment.
%
%	To read the information of each of the segments, it uses the auxiliary
%	predicate read_segs/3.
%
read_and_return(File, L, X, Segs) :-
    open(File, read, Stream),
    read_line(Stream, [N, L, X]),
    read_segs(Stream, N, Segs),
    close(Stream).

read_segs(Stream, N, Segs) :-
    ( N > 0 ->
	Segs = [Seg|Rest],
        read_line(Stream, [S, E]),
	Seg = seg(S, E),
        N1 is N - 1,
        read_segs(Stream, N1, Rest)
    ; N =:= 0 ->
	Segs = []
    ).

%	?- read_line/2
%
%	Reads a line and returns the list of integers that
%	the line contains.
%
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

%	?- makePairs/3
%
%	Takes as arguments the segments as returned by the 
%	read_and_return/4 predicate and returns them as a list
%	of key-value pairs.
%	The key is Sk, and the value is [day, Ek].
%
makePairs([], [], _).
makePairs([seg(S,E)|T], [S-[N, E]|ST], N) :-
	NewN is N+1,
	makePairs(T, ST, NewN).

%	?- isRoadFixed/4
%
%	Returns true if the length of the biggest unfinished part of the road
%	is less than or equal to X on a specific day.
%
isRoadFixed([], _, _, _).
isRoadFixed([SegsH|SegsT], X, Day, T) :-
	pairs_values([SegsH], [[CurrentDay, CurrentEnd]]),
	pairs_keys([SegsH], [CurrentStart]),
	CurrentDay =< Day,
	T < CurrentStart,
	CurrentStart - T =< X,
	isRoadFixed(SegsT, X, Day, CurrentEnd).
isRoadFixed([SegsH|SegsT], X, Day, T) :-
	pairs_values([SegsH], [[CurrentDay, CurrentEnd]]),
	pairs_keys([SegsH], [CurrentStart]),
	CurrentDay =< Day,
	T >= CurrentStart,
	T < CurrentEnd,
	isRoadFixed(SegsT, X, Day, CurrentEnd).
isRoadFixed([SegsH|SegsT], X, Day, T) :-
	pairs_values([SegsH], [[CurrentDay, CurrentEnd]]),
	pairs_keys([SegsH], [CurrentStart]),
	CurrentDay =< Day,
	T >= CurrentStart,
	T >= CurrentEnd,
	isRoadFixed(SegsT, X, Day, T).
isRoadFixed([SegsH|SegsT], X, Day, T) :-
	pairs_values([SegsH], [[CurrentDay, CurrentEnd]]),
	pairs_keys([SegsH], [CurrentStart]),
	CurrentDay > Day,
	isRoadFixed(SegsT, X, Day, T).

%	?- binSearch/7
%
%	Performs binary search on the given segments.
%	The segments are sorted by starting point Sk, and this
%	predicate performs binary search on them by checking
%	if the length of the biggest unfinished part of the road
%	is less than or equal to X on the day examined.
%
%	Returns the smallest day on which the above restriction holds.
%
binSearch(_, _, _, Start, End, PrevDay, PrevDay) :-
	Start > End,
	PrevDay \== 0.
binSearch(Segs, X, _, Start, End, PrevDay, PrevDay) :-
	Start =< End,
	Day is floor(((End-Start)/2) + Start),
	PrevDay \== 0,
	PrevDay == Day,
	isRoadFixed(Segs, X, Day, 0), !.
binSearch(Segs, X, L, Start, End, PrevDay, Days) :-
	Start =< End,
	Day is floor(((End-Start)/2) + Start),
	PrevDay =\= Day,
	NewEnd is Day - 1,
	isRoadFixed(Segs, X, Day, 0), !,
	binSearch(Segs, X, L, Start, NewEnd, Day, Days).
binSearch(Segs, X, L, Start, End, PrevDay, Days) :-
	Start =< End,
	Day is floor(((End-Start)/2) + Start),
	not(isRoadFixed(Segs, X, Day, 0)), !,
	NewStart is Day + 1,
	binSearch(Segs, X, L, NewStart, End, PrevDay, Days).

%	?- dromoi/2
%	dromoi(+File, ?Days)
%
%	Takes as argument the input file and returns
%	the smallest day on which the length of the biggest 
%	unfinished part of the road is less than or equal to X.
%
dromoi(File, Days) :-
	read_and_return(File, L, X, S),
	makePairs(S, Segs, 1),
	length(S, N),
	append([L-[0, L]], Segs, AllS),
	keysort(AllS, SortedS),
	binSearch(SortedS, X, L, 1, N, 0, Days).
