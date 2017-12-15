%% -*- prolog -*-

man(aristotle).
mortal(X) :- man(X).		% for all X

male(barak).
male(fishel).
female(anne).
parent(fishel, barak).
parent(anne, barak).
parent(jacob, fishel).
male(jacob).
parent(toba, fishel).
female(toba).
female(nili).
parent(fishel,nili).
parent(anne,nili).

father(X, Y) :- parent(X, Y), male(X).
sibling(X, Y) :- parent(Z, X), parent(Z, Y).

sister(X, Y) :- sibling(X, Y), female(X).

grandparent(X, Y) :- parent(Z, Y), parent(X, Z).

%% Peano Arithmetic

%% Nat    term representing it
%% 0 =    zero
%% 1 =    s(zero)
%% 2 =    s(s(zero))
%% etc

succ(s(X),X).
%% add(X,Y,Z) means X + Y = Z
add(X,zero,X).
add(X,s(Y),s(Z)) :- add(X,Y,Z).

%%% TRANSCRIPT - SWI Prolog
%% $ swipl

%% ?- ['prolog-1.pl'].
%% Warning: ...
%% true.

%% ?- add(s(s(zero)),s(s(zero)),X).
%% X = s(s(s(s(zero)))) ;
%% false.

%% ?- add(X,Y,s(s(zero))).
%% X = s(s(zero)),
%% Y = zero ;
%% X = Y, Y = s(zero) ;
%% X = zero,
%% Y = s(s(zero)) ;
%% false.

%% ?- add(X,Y,s(s(s(s(s(zero)))))).
%% X = s(s(s(s(s(zero))))),
%% Y = zero ;
%% X = s(s(s(s(zero)))),
%% Y = s(zero) ;
%% X = s(s(s(zero))),
%% Y = s(s(zero)) ;
%% X = s(s(zero)),
%% Y = s(s(s(zero))) ;
%% X = s(zero),
%% Y = s(s(s(s(zero)))) ;
%% X = zero,
%% Y = s(s(s(s(s(zero))))) ;
%% false.
