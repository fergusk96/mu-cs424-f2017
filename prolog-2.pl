%% -*- prolog -*-

%% Peano Arithmetic

%% Nat    term representing it
%% 0 =    zero
%% 1 =    s(zero)
%% 2 =    s(s(zero))
%% etc

%% add(X,Y,Z) means X + Y = Z
%%    add(+,+,-)  means know first two args, figure out third.
%%    add(-,-,+)  ...........last arg, figure out first two.
%%    X add(+,-,-)    not okay?
add(X,zero,X) :- peano(X).
add(X,s(Y),s(Z)) :- add(X,Y,Z).

succ(s(X),X). %% :- peano(X).

peano(zero).
peano(s(X)) :- peano(X).

%%% PROLOG does not do an "occurs check", so a logic variable
%%% can appear inside the value it is bound to.

%% Evaluation model:
%% (pseudocode)

%% logic_variable_value_map prove( goal , logic_variable_value_map e) {
%%     for clause in database {
%% 	 c = fresh_logic_vars(clause);
%% 	 e_0 = unify(goal, lhs(c), e);
%% 	 if succeeded(e_0) {
%% 	     for r in rhs(c), i=1.. {
%%                 e_i = prove(r , e_(i-1));
%%                 if failed(e_i) goto next_clause;
%% 	     }
%%       accept e_i as solution; goto next_clause;
%% 	 }
%%       next_clause:
%%     }

%% Lists:
%% Haskell syntax:    (:) x xs
%%                    x:xs
%%                    [x,x1,x2,...]
%% Scheme: (cons x xs), printed as (x x1 x2 ...)
%% Prolog: '.'(head,tail)
%%         [head|tail]
%%         '.'(x1,'.'(x2,'.'(x3,[])))         [x1,x2,x3]
%%         '.'(x1,'.'(x2,'.'(x3,xs)))         [x1,x2,x3|xs]

%% app(Xs,Ys,Zs)    means Xs and Ys appended is Zs
app([],Ys,Ys).
app([X|Xs],Ys,[X|Zs]) :- app(Xs,Ys,Zs).

%% mem(X,Ys)        means X is an element of Ys
mem(X,[X|_]).
mem(X,[_|Ys]) :- mem(X,Ys).
