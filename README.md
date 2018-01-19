
Machine
=======

Machine is a package that allows one to compose finite-state
machines as well as their analogues where the set of states
may be infinite.  
See <a href="http://www.knode.io/#@public/661">On Convolution of Machines</a>
for background on this subject.

Example
-------

Start up `elm repl` and do imports
listed below.

> import Reducer exposing(run)
> import Machine exposing(accept)
> import Example exposing(..)

Convolution of reducers
-----------------------

A reducer is any function of type
`a -> b -> b`. We run various reducers
on inputs like `[O, O, O, I, O, I]`.
Reducers `m` and `f` are defined in
`module Example` and reducer `mf` is
defined there as the convolution `m * f`.

> run m Start [O, O, O, I, O, I]
Ix : Example.State

> run mf ( Start, 0 ) [O, O, O, I, O, I]
(Ix,2) : ( Example.State, Int )

> run mf ( Start, 0 ) [O, O, O, I, O, I, I]
(Fail,0) : ( Example.State, Int )

Running a machine
-----------------

Machines m1 and m2 are defined in module Examples,
and `m3 = m1 * m2` is define there as their convolution.

> accept m1 [O, I, O, I]
(True,Ix) : ( Bool, Example.State )

> accept m3 [O, I, O, I]
(True,(Ix,2)) : ( Bool, ( Example.State, Int ) )

> accept m3 [O, I, O, I, I]
(False,(Fail,0)) : ( Bool, ( Example.State, Int ) )
