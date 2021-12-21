module Transforms exposing (..)


type alias Complex =
    { re : Float, im : Float }


r2ify : (Complex -> Complex) -> ( Float, Float ) -> ( Float, Float )
r2ify fn ( x, y ) =
    let
        result =
            fn { re = x, im = y }
    in
    ( result.re, result.im )
