%	?- checkSolvable/3
%
%	Takes as arguments the capacities V1, V2 and the target Vg
%	and returns true if the given problem is solvable.
%
checkSolvable(V1, V2, Vg) :-
	GCD is gcd(V1, V2),
	MOD is mod(Vg, GCD),
	(Vg =< V1; Vg =< V2),
	(MOD == 0).

%	?- getChain012/6
%
%	Takes as arguments the capacities V1, V2, the target Vg, 
%	the current contains of bucket A, the current contains of bucket B
%	and returns the minimum chain of moves 0->1->2->0 needed to achieve the target.
%
getChain012(_, _, Vg, Vg, _, []).
getChain012(_,_, Vg, _, Vg, []).
getChain012(V1, V2, Vg, 0, WhatsInB, ['01'|ChainT]) :-
	getChain012(V1, V2, Vg, V1, WhatsInB, ChainT).
getChain012(V1, V2, Vg, WhatsInA, V2, ['20'|ChainT]):-
	getChain012(V1, V2, Vg, WhatsInA, 0, ChainT).
getChain012(V1, V2, Vg, WhatsInA, WhatsInB, ['12'|ChainT]):-
	CapacityB is V2 - WhatsInB - WhatsInA,
	((CapacityB >= 0, NewWhatsInB is WhatsInB + WhatsInA,
		NewWhatsInA is 0);
	(CapacityB < 0, NewWhatsInB is V2,
		NewWhatsInA is WhatsInA - V2 + WhatsInB)),
	getChain012(V1, V2, Vg, NewWhatsInA, NewWhatsInB, ChainT).

%	?- getChain021/6
%
%	Takes as arguments the capacities V1, V2, the target Vg, 
%	the current contains of bucket A, the current contains of bucket B
%	and returns the minimum chain of moves 0->2->1->0 needed to achieve the target.
%
getChain021(_, _, Vg, Vg, _, []).
getChain021(_,_, Vg, _, Vg, []).
getChain021(V1, V2, Vg, WhatsInA, 0, ['02'|ChainT]) :-
	getChain021(V1, V2, Vg, WhatsInA, V2, ChainT).
getChain021(V1, V2, Vg, V1, WhatsInB, ['10'|ChainT]):-
	getChain021(V1, V2, Vg, 0, WhatsInB, ChainT).
getChain021(V1, V2, Vg, WhatsInA, WhatsInB, ['21'|ChainT]):-
	CapacityA is V1 - WhatsInA - WhatsInB,
	((CapacityA >= 0, NewWhatsInA is WhatsInB + WhatsInA,
		NewWhatsInB is 0);
	(CapacityA < 0, NewWhatsInA is V1,
		NewWhatsInB is WhatsInB - V1 + WhatsInA)),
	getChain021(V1, V2, Vg, NewWhatsInA, NewWhatsInB, ChainT).

%	?- getShortestChain/3
%
%	Takes as arguments the chains 0->1->2->0 and 0->2->1->0
%	and returns the shortest one.
%
getShortestChain(Ch012, Ch021, Ch012) :-
	length(Ch012, L012),
	length(Ch021, L021),
	L012 < L021.

getShortestChain(Ch012, Ch021, Ch021) :-
	length(Ch012, L012),
	length(Ch021, L021),
	L012 >= L021.

%	?- kouvadakia/4
%	kouvadakia(+V1, +V2, +Vg, ?Plan)
%
%	Takes as arguments the capacities V1, V2 and the target Vg.
%	Returns the shortest chain of moves needed to achieve the target.
%
kouvadakia(V1, V2, Vg, Plan) :-
	checkSolvable(V1, V2, Vg),
	getChain012(V1, V2, Vg, 0, 0, Chain012),
	getChain021(V1, V2, Vg, 0, 0, Chain021), !,
	getShortestChain(Chain012, Chain021, Plan).

