%% -*- prolog -*-

%%% Difference List
%% dlRepresents(-,-).
dlRepresents(Xs-Ys,Zs) :- append(Zs,Ys,Xs).

%%% How to append two difference lists.
%% want to append: X=[a,b,c|Xt]-Xt
%%                       Y=[d,e,f|Yt]-Yt
%%        yielding Z=[a,b,c,d,e,f|Zt]-Zt
%% dlAppend(X-Xt, Y-Yt, Z-Zt) :- Z=X, Xt=Y, Yt=Zt.
%%  or alternatively just:
dlAppend(X-Y, Y-Yt, X-Yt).

properNoun([joe|X]-X).
properNoun([sally|X]-X).
properNoun([toledo|X]-X).

nounPhrase(N) :- properNoun(N).
nounPhrase([the|N]-Nt) :- properNoun(N-Nt).

stop(['.'|X]-X).
stop(['!'|X]-X).

verb([ran|X]-X).
verb([jumps|X]-X).
verb([sashays|X]-X).
verbPhrase(VP) :- verb(VP).
sentence(S-St) :- nounPhrase(S-NPt), verbPhrase(NPt-VPt), stop(VPt-St).

sentences(Ss-Sst) :- sentence(Ss-Sst).
sentences(Ss-Sst) :- sentence(Ss-S1t), sentences(S1t-Sst).

%%%%%% Type checker for the simply typed lambda calculus.

%%% representation of λ-calc terms:

%%

%%% representation of λ-calc types:
%% Case Analysis: term E can be
%%    - variable
%%    - application
%%    - lambda expression

wellTyped(E) :- globalTypeEnv(Gamma), hasType(E,_,Gamma).
hasTypeG(E,T) :- globalTypeEnv(Gamma), hasType(E,T,Gamma).

%% variable
hasType(E, T, Gamma) :- gammaContains(Gamma, E, T).
%% application
hasType(app(E1,E2), T2, Gamma) :- hasType(E1,(T1->T2),Gamma),
				  hasType(E2,T1,Gamma).
%% λ expression
hasType(lambda(V,T,Body), (T->Tb), Gamma) :-
    hasType(Body, Tb, [[V,T]|Gamma]).

%% type(T) if T is a well formed type.
type(bool).
type(real).
type(T1->T2) :- type(T1), type(T2).

%%% Representation of "type environments", "Gamma".
%%% Represent as association list.
globalTypeEnv([[true,bool],
	       [false,bool],
	       [not,(bool->bool)],
	       [lt,(real->real->bool)],
	       [pi,real],
	       [e,real],
	       [plus,(real->real->real)],
	       [sin,(real->real)]]).

gammaContains(Gamma, E, T) :- member([E,T],Gamma), !.
