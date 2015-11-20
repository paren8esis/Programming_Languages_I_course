%	?- move10/4
%	
%	Returns the next 10-move from the given state and
%	updates the Checked associated list.
%
move10([_, Stack1, _]-_, Checked, Checked, B-B) :-
	dlist2list(Stack1, []).
move10([Stack2, [Stack1H|Stack1T]-Trail, []]-Moves, Checked, NewChecked, [[Stack2, Stack1T-Trail, [Stack1H]]-['10'|Moves]|B]-B) :-
	duplicate_term(Stack2, Stack2_Dup),
	duplicate_term(Stack1T-Trail, Stack1_Dup),
	dlist2list(Stack2_Dup, Stack2L),
	dlist2list(Stack1_Dup, Stack1L),
	not(get_assoc([Stack2L, Stack1L, [Stack1H]], Checked, _)),
	put_assoc([Stack2L, Stack1L, [Stack1H]], Checked, ['10'|Moves], NewChecked).
move10([_, _, _]-_, Checked, Checked, B-B).
	
%	?- move12/4
%	
%	Returns the next 12-move from the given state and
%	updates the Checked associated list.
%
move12([_, Stack1, _]-_, Checked, Checked, B-B) :-
	dlist2list(Stack1, []).
move12([Stack2, [Stack1H|Stack1T]-Trail, Buffer]-Moves, Checked, NewChecked, [[NewStack2, Stack1T-Trail, Buffer]-['12'|Moves]|B]-B) :-
	conc([Stack1H|A]-A, Stack2, NewStack2),
	duplicate_term(NewStack2, NewStack2_Dup),
	duplicate_term(Stack1T-Trail, Stack1_Dup),
	dlist2list(NewStack2_Dup, NewStack2L),
	dlist2list(Stack1_Dup, Stack1L),
	not(get_assoc([NewStack2L, Stack1L, Buffer], Checked, _)),
	put_assoc([NewStack2L, Stack1L, Buffer], Checked, ['12'|Moves], NewChecked).
move12([_,_,_]-_, Checked, Checked, B-B).

%	?- move01/4
%	
%	Returns the next 01-move from the given state and
%	updates the Checked associated list.
%
move01([_, _, []]-_, Checked, Checked, B-B).
move01([Stack2, Stack1-Trail, [Buffer]]-Moves, Checked, NewChecked, [[Stack2, [Buffer|Stack1]-Trail, []]-['01'|Moves]|B]-B) :-
	duplicate_term(Stack2, Stack2_Dup),
	duplicate_term(Stack1-Trail, Stack1_Dup),
	dlist2list(Stack2_Dup, Stack2L),
	dlist2list(Stack1_Dup, Stack1L),
	not(get_assoc([Stack2L, [Buffer|Stack1L], []], Checked, _)),
	put_assoc([Stack2L, [Buffer|Stack1L], []], Checked, ['01'|Moves], NewChecked).
move01([_,_,_]-_, Checked, Checked, B-B).

%	?- move02/4
%	
%	Returns the next 02-move from the given state and
%	updates the Checked associated list.
%
move02([_, _, []]-_, Checked, Checked, B-B).
move02([Stack2-Trail, Stack1, [Buffer]]-Moves, Checked, NewChecked, [[[Buffer|Stack2]-Trail, Stack1, []]-['02'|Moves]|B]-B) :-
	duplicate_term(Stack1, Stack1_Dup),
	duplicate_term(Stack2-Trail, Stack2_Dup),
	dlist2list(Stack1_Dup, Stack1L),
	dlist2list(Stack2_Dup, Stack2L),
	not(get_assoc([[Buffer|Stack2L], Stack1L, []], Checked, _)),
	put_assoc([[Buffer|Stack2L], Stack1L, []], Checked, ['02'|Moves], NewChecked).
move02([_,_,_]-_, Checked, Checked, B-B).

%	?- move21/4
%	
%	Returns the next 21-move from the given state and
%	updates the Checked associated list.
%
move21([Stack2, _, _]-_, Checked, Checked, B-B) :-
	dlist2list(Stack2, []).
move21([[Stack2H|Stack2T]-Trail, Stack1, Buffer]-Moves, Checked, NewChecked, [[Stack2T-Trail, NewStack1, Buffer]-['21'|Moves]|B]-B) :-
	conc([Stack2H|A]-A, Stack1, NewStack1),
	duplicate_term(NewStack1, NewStack1_Dup),
	duplicate_term(Stack2T-Trail, Stack2_Dup),
	dlist2list(NewStack1_Dup, NewStack1L),
	dlist2list(Stack2_Dup, Stack2L),
	not(get_assoc([Stack2L, NewStack1L, Buffer], Checked, _)),
	put_assoc([Stack2L, NewStack1L, Buffer], Checked, ['02'|Moves], NewChecked).
move21([_,_,_]-_, Checked, Checked, B-B).

%	?- move20/4
%	
%	Returns the next 20-move from the given state and
%	updates the Checked associated list.
%
move20([Stack2, _, _]-_, Checked, Checked, B-B) :-
	dlist2list(Stack2, []).
move20([[Stack2H|Stack2T]-Trail, Stack1, []]-Moves, Checked, NewChecked, [[Stack2T-Trail, Stack1, [Stack2H]]-['20'|Moves]|B]-B) :-
	duplicate_term(Stack1, Stack1_Dup),
	duplicate_term(Stack2T-Trail, Stack2_Dup),
	dlist2list(Stack1_Dup, Stack1L),
	dlist2list(Stack2_Dup, Stack2L),
	not(get_assoc([Stack2L, Stack1L, [Stack2H]], Checked, _)),
	put_assoc([Stack2L, Stack1L, [Stack2H]], Checked, ['20'|Moves], NewChecked).
move20([_, _, _]-_, Checked, Checked, B-B).

%	?- extend/4
%
% 	Returns a list of the next possible moves from the given state.
%
extend(Node, Checked, NewChecked, NewNodes) :-
	move10(Node, Checked, NewChecked1, Move10),
	move12(Node, NewChecked1, NewChecked2, Move12),
	move01(Node, NewChecked2, NewChecked3, Move01),
	move02(Node, NewChecked3, NewChecked4, Move02),
	move20(Node, NewChecked4, NewChecked5, Move20),
	move21(Node, NewChecked5, NewChecked, Move21), !,
	conc(Move10, Move12, M1),
	conc(M1, Move01, M2),
	conc(M2, Move02, M3),
	conc(M3, Move20, M4),
	conc(M4, Move21, NewNodes).
	

%	?- bfs/4
%
%	Performs a BFS algorithm on a given tree of states.

%	Use as bfs(Tree, Target, Checked, Moves), where:
%		Tree: a list representing the tree of states.
%			Its elements are of the form: [Stack2, Stack1, Buffer]-PathOfMovesToHere
%		Target: the string we are looking for	
%		Checked: an associated list of states that we have already been through (so we avoid making circles)
%		Moves: the (reversed) path of moves needed to get to the target string
%
bfs([[Stack2, _, _]-Moves|_]-_, Target, _, Moves) :-
	duplicate_term(Stack2, Stack2_Dup),
	dlist2list(Stack2_Dup, Stack2L),
	Stack2L \== [],
	Stack2 = Target.
bfs([[Stack2, Stack1, Buffer]-M|Rest]-Tail, Target, Checked, Moves) :-
	duplicate_term(Stack2, Stack2_Dup),
	duplicate_term(Target, Target_Dup),
	dlist2list(Stack2_Dup, Stack2List),
	dlist2list(Target_Dup, TargetList),
	Stack2List \== TargetList,
	extend([Stack2,Stack1,Buffer]-M, Checked, NewChecked, NewH),
	conc(Rest-Tail, NewH, NewList),
	bfs(NewList, Target, NewChecked, Moves).


%	?- getListRev/2
%
%	Use as getList(?Codes, ?List), where:
%		Codes: a list of codes representing characters
%		List: a (reversed) list of characters that correspond to the given codes
%
%	Uses the predicate getCharRev/2
%
getCharRev([X], [Character]) :-
	char_code(Character, X).
getCharRev([H|T], List) :-
	char_code(Character, H),
	getCharRev(T, Rest),
	append(Rest, [Character], List).

getListRev(Str, L-Tail) :-
	getCharRev(Str, List),
	append(List, Tail, L).

dlist2list(DiffList, List) :-
	convert2list(DiffList, List).

convert2list(L-[], L).

conc(A-B, B-C, A-C).

%	?- anagrams/3
%
%	anagrams(+Word, +Target, ?Moves)
%
anagrams(Word, Target, Moves) :-
	getListRev(Word, WordListDL),
	getListRev(Target, TargetListDL),
	list_to_assoc([], NewChecked),
	duplicate_term(WordListDL, WordListDL2),
	dlist2list(WordListDL2, WordList),
	put_assoc([[], WordList, []], NewChecked, [], Checked),
	bfs([[B-B, WordListDL, []]-[]|C]-C, TargetListDL, Checked, MovesRev),
	reverse(MovesRev, Moves).
