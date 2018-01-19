module Example exposing (m, mf, m1, m2, m3, X(..), State(..))

import Reducer exposing (Reducer)
import Machine exposing (Machine)


{-
   EXAMPLES:

   > import Reducer exposing(run)

   > import Machine exposing(accept)

   > import Example exposing(..)

   CONVOLUTION OF FUNCTIONS

   > run m Start [O, O, O, I, O, I]
   Ix : Example.State

   > run mf ( Start, 0 ) [O, O, O, I, O, I]
   (Ix,2) : ( Example.State, Int )

   > run mf ( Start, 0 ) [O, O, O, I, O, I, I]
   (Fail,0) : ( Example.State, Int )

   RUNNING A MACHINE

   Note that machines m1 and m2 are defined below,
   and that m3 = m1 * m2 is their convolution.

   > accept m1 [O, I, O, I]
   (True,Ix) : ( Bool, Example.State )

   > accept m3 [O, I, O, I]
   (True,(Ix,2)) : ( Bool, ( Example.State, Int ) )

   > accept m3 [O, I, O, I, I]
   (False,(Fail,0)) : ( Bool, ( Example.State, Int ) )
-}


m1 =
    Machine Start (\x -> x == Ix) m


type X
    = O
    | I


type State
    = Start
    | Ox
    | Ix
    | Fail


m : Reducer X State
m symbol state =
    case ( state, symbol ) of
        ( Start, O ) ->
            Start

        ( Start, I ) ->
            Ix

        ( Ix, O ) ->
            Ox

        ( Ix, I ) ->
            Fail

        ( Ox, O ) ->
            Fail

        ( Ox, I ) ->
            Ix

        ( Fail, O ) ->
            Fail

        ( Fail, I ) ->
            Fail


m2 =
    Machine 0 (\x -> True) f


f : Reducer State Int
f s n =
    case s of
        Start ->
            0

        Fail ->
            0

        Ox ->
            n

        Ix ->
            n + 1


mf =
    Reducer.convolve m f


m3 =
    Machine.convolve m1 m2
