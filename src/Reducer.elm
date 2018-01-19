module Reducer exposing (Reducer, Runner, run, convolve)

{-| This library exposes functions for
working with Reducers which is a type alias
for the type a -> b -> b. The transition
functions of finite-state machines are
reducers.


# API

@docs Reducer, Runner, run, convolve

-}


{-| type alias Reduce input state
is used to define reducers

    input -> state -> state

The transition functions of a finite-state
machines is a reducer.

-}
type alias Reducer input state =
    input -> state -> state


{-| type alias Runner input state
is used to define functions which
"run" a reducer on a sequence of
inputs. See

    input -> state -> state

See the function `run` below
and the comments in `module Example`
for more on this.

-}
type alias Runner input state =
    Reducer input state -> state -> List input -> state


{-| Consider the function call

    run nextState start inputList

where nextState is a reducer,
start is a state, and inputList
is a list of inputs. This function
call returns the final state achieved
by repeatedly applying the reducer
nextState to incoming inputs.
See the comments in `module Example`
for more on this.

-}
run : Runner input state
run nextState start inputList =
    List.foldl nextState start inputList


{-| Let m and f be reducers.
Then m * f = convolve m f is
also a reducer, a kind of composition
of reducers. See the comments in `module Example`
for more on this, or see
<a href="http://www.knode.io/#@public/661">On Convolution of Machines</a>
-}
convolve : Reducer input state -> Reducer state state2 -> Reducer input ( state, state2 )
convolve m f =
    \x ( q, r ) ->
        let
            qq =
                m x q

            rr =
                f qq r
        in
            ( qq, rr )
