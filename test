#### Curry Howard Isomorphism ####

Type environment (denoted Γ) is a list of terms and their corresponding types

Typing Rules

Rule 1. 

[<img src="https://latex.codecogs.com/png.latex?\frac{\Gamma&space;\vdash&space;e_{1}:\alpha&space;\rightarrow&space;\beta&space;\;&space;\;&space;\;&space;\;&space;\Gamma&space;\vdash&space;e_{2}:\alpha&space;}&space;{\Gamma&space;\vdash&space;e_{1}&space;\;&space;\;&space;e_{2}:\beta&space;}">](http://mathurl.com)


[<img src="https://latex.codecogs.com/png.latex?\frac{\Gamma&space;\vdash&space;\alpha&space;\rightarrow&space;\beta&space;\;&space;\;&space;\;&space;\;&space;\Gamma&space;\vdash&space;\alpha&space;}&space;{\Gamma&space;\vdash&space;\beta&space;}">](http://mathurl.com)

Rule 2.

[<img src="https://latex.codecogs.com/png.latex?\frac{b:\alpha&space;\in&space;\Gamma&space;}&space;{\Gamma&space;\vdash&space;b:\alpha&space;}">](http://mathurl.com)

Rule 3.

[<img src="https://latex.codecogs.com/png.latex?\frac{\Gamma&space;\cup&space;\left\{&space;v:&space;\alpha&space;\right&space;\}&space;\vdash&space;e:&space;\beta&space;}{\Gamma&space;\vdash&space;\lambda&space;\left&space;(&space;v:\alpha&space;\right&space;).e:\alpha&space;\rightarrow&space;\beta&space;b:\alpha&space;}">]()

[<img src="https://latex.codecogs.com/png.latex?\frac{\Gamma&space;\cup&space;\left&space;\{&space;\alpha&space;\right&space;\}&space;\vdash&space;\beta&space;}&space;{\Gamma&space;\vdash&space;\alpha&space;\rightarrow&space;\beta&space;}">](http://mathurl.com)

1.
[<img src="https://latex.codecogs.com/png.latex?\left&space;(&space;A\rightarrow&space;\left&space;(&space;B\rightarrow&space;C&space;\right&space;)&space;\right&space;)\rightarrow&space;\left&space;(&space;B\rightarrow&space;\left&space;(&space;A\rightarrow&space;C&space;\right&space;)&space;\right&space;)">](http://mathurl.com)

[<img src="https://latex.codecogs.com/png.latex?\lambda&space;x:A\rightarrow&space;B\rightarrow&space;C.\lambda&space;y:B.\lambda&space;z:A.xzy">](http://mathurl.com)

2.
[<img src="https://latex.codecogs.com/png.latex?\left&space;(&space;A\rightarrow&space;B&space;\right&space;)\rightarrow&space;\left&space;(&space;\left&space;(&space;B\rightarrow&space;C&space;\right&space;)\rightarrow&space;\left&space;(&space;A\rightarrow&space;C&space;\right&space;)&space;\right&space;)">](http://mathurl.com)

[<img src="https://latex.codecogs.com/png.latex?\lambda&space;x:A\rightarrow&space;B.\lambda&space;y:B\rightarrow&space;C.\lambda&space;z:A.y(xz)">](http://mathurl.com)

terms without free variables in λ-Caculus are called combinators since it amount to..


Combinator logic

[<img src="https://latex.codecogs.com/png.latex?I=&space;\lambda&space;x.x">]()

[<img src="https://latex.codecogs.com/png.latex?K=&space;\lambda&space;x.\lambda&space;y.x">](http://mathurl.com)

[<img src="https://latex.codecogs.com/png.latex?S=&space;\lambda&space;f.\lambda&space;g.\lambda&space;x.f\left&space;(&space;x&space;\right&space;)\left&space;(&space;gx&space;\right&space;)">](http://mathurl.com)

these small few combinators give turing equivalence
