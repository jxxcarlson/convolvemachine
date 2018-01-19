module Machine exposing (Machine, accept, convolve)

{-| This library exposes functions for
running the `accept` function of a finite
or infinite state macihine and also for
forming the convolution of two machines.


# API

@docs Machine, accept, convolve

-}

import Reducer exposing (Reducer)


{-| Type defnition for a (finite-state) machine.
-}
type alias Machine symbol state =
    { initial : state
    , accept : state -> Bool
    , nextState : Reducer symbol state
    }


{-| Type defnition for the `accept` function of a (finite-state) machine.
-}
accept : Machine symbol state -> List symbol -> ( Bool, state )
accept machine inputList =
    let
        result =
            Reducer.run machine.nextState machine.initial inputList

        accepted =
            machine.accept result
    in
        ( accepted, result )


{-| Given two machines, form their convolution.
-}
convolve : Machine a b -> Machine b c -> Machine a ( b, c )
convolve machine1 machine2 =
    let
        initial =
            ( machine1.initial, machine2.initial )

        accept =
            \( state1, state2 ) -> machine1.accept state1 && machine2.accept state2

        nextState =
            Reducer.convolve machine1.nextState machine2.nextState
    in
        Machine initial accept nextState
