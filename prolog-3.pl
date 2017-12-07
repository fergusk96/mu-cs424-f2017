%% -*- prolog -*-

%% member(-,-).
%% append(-,-,-).

%% can define member in terms of append:
mem(X,Ys) :- append(_,[X|_],Ys).

%% arithmetic with, e.g., is(X,1+2)
%% is(-,+).

%% "cut", denoted by !
%% belongs where subgoal (on RHS of rule) goes.

%%% Cut terminates (prunes) alternatives in search tree.
%% foo(...) :- ...
%% foo(...) :- bar(...), !, baz(...).
%% foo(...) :- ...
%% foo(...) :- ...

%%% cut is used to define not, in a HORRIBLE WAY.
%% not(G) :- G, !, false.
%% not(_).

%% one-dimensional board, represented as a list,
%% each spot is either empty (-) or occupied by peg (x).
%% can jump peg over adjacent peg into hole, removing peg in middle.
%% sample board: [-,x,-,-,-,x,x,-,x]

%% move(+,-).
move(B1,B2) :- moveR(B1,B2).
move(B1,B2) :- moveL(B1,B2).

moveR([x,x,-|B],[-,-,x|B]).
moveR([P|B1],[P|B2]) :- moveR(B1,B2).

moveL(B1,B2) :- reverse(B1,B1r), moveR(B1r,B2r), reverse(B2r,B2).

%% seqMoves([B1,B2,...,Bn]) is true
%% if move(B1,B2), move(B2,B3), ..., move(Bn-1,Bn)
seqMoves([]).
seqMoves([_]).
seqMoves([B1,B2|Bs]) :- move(B1,B2), seqMoves([B2|Bs]).

canSolve(B1,B2) :- seqMoves([B1|Bs]), last(Bs, B2).

%%%%%%%%%%%%%% Madlibs (list processing)

properNoun([joe]).
properNoun([sally]).
properNoun([toledo]).
nounPhrase(N) :- properNoun(N).
nounPhrase([the|N]) :- properNoun(N).
verb([ran]).
verb([jumps]).
verb([sashays]).
verPhrase(VP) := verb(VP).
sentence(S) :- append(NP,VP,S), nounPhrase(NP), verb(VP).

%%% Difference List
dlRepresents(Xs-Ys,Zs) :- append(Zs,Ys,Xs).
