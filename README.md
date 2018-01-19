
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

* > import Reducer exposing(run)
* > import Machine exposing(accept)
* > import Example exposing(..)

Convolution of reducers
-----------------------

A reducer is any function of type
`a -> b -> b`. We run various reducers
on inputs like `[O, O, O, I, O, I]`.
Reducers `m` and `f` are defined in
`module Example` and reducer `mf` is
defined there as the convolution `m * f`.

In the examples below, `m` is a reducer
which recognizes sequences like
OOOIOI that begin with zero or more
O's and are followed by one or more
OI's.  The reducer `m` belongs
to a finite-state machine with initial
state `Start` and with one final state,
`Ix`.  In the example below, the final
state is `Ix`, so the sequence is accepted.

```
> run m Start [O, O, O, I, O, I]
Ix : Example.State
```

The reducer `mf = m * f` is the convolution
of reducers `m` and `f`.  In the first
example below, the sequence is accepted
by the machine and the number of `I`'s
is counted.  In the second example, the
sequence is rejected.

```
> run mf ( Start, 0 ) [O, O, O, I, O, I]
(Ix,2) : ( Example.State, Int )

> run mf ( Start, 0 ) [O, O, O, I, O, I, I]
(Fail,0) : ( Example.State, Int )
```

Running a machine
-----------------

Machines m1 and m2 are defined in module Examples,
and `m3 = m1 * m2` is defined there as their convolution.
The `accept` function takes a machine and and input list
as arguments and returns a tuple `(result, state)`,
where `result` is `True` or `False` depending on whether
the sequence is accepted or not.  The second component,
`state`, is the final state of the machine.
```
> accept m1 [O, I, O, I]
(True,Ix) : ( Bool, Example.State )

> accept m3 [O, I, O, I]
(True,(Ix,2)) : ( Bool, ( Example.State, Int ) )

> accept m3 [O, I, O, I, I]
(False,(Fail,0)) : ( Bool, ( Example.State, Int ) )
```
