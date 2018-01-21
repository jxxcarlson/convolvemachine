
# Convolve Machine


Convolve Machine (jxxcarlson/convolvemachine) is a package that
allows one to compose finite-state
machines as well as machines with an infinite set of states.

The key construction is convolution of reducers,
a kind of composition.  A reducer is a function
of type `a -> b -> b`.  Transition functions
of finite-state machines are of this type.  Convolution
has this signature:

```
(a -> b -> b) -> (b -> c -> c) -> (a -> (b,c) -> (b,c))
```

If `m` and `f` are reducers, then `m*f = convolve m f` is
also a reducer.

See <a href="http://www.knode.io/#@public/661">On Convolution of Machines</a>
for background on this subject.

## The Examples


Start up `elm repl` and do the imports
listed below.

* > import Reducer exposing(run)
* > import Machine exposing(accept)
* > import Example exposing(..)

### Running a reducer


One "runs" a reducer
on a start state and a list of inputs.
The reducers `m`and `f` as well as
`mf = m*f` are defined in `Example.elm`.


First example:
```
run m Start [O, O, O, I, O, I]
```

In this case the output is
`Ix : Example.State`, which is the final
state reached by running `m` on the given
input.  See <a href="http://www.knode.io/#@public/661">On Convolution of Machines</a>, section 2.1
for an explanation of what is going on here.
In brief, by running the reducer `m`, you
determine whether the sequence of input
symbols is of the form zero or or more O's
followed by one or more OI's.
The reducer `m` belongs
to a finite-state machine with initial
state `Start` and with one final state,
`Ix`.  In the example below, the final
state is `Ix`, so the sequence is accepted.


### Convolution of reducers

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

The above example shows that one may use
a reducer `m` in combination with a reducer `f`
to "make" `m` produce useful output in addition
to recognizing sequences.  No code change for `m`
is needed.

### Convolution of machines

Machines m1 and m2 are defined in module `Example`,
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
