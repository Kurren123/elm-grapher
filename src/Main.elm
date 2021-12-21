module Main exposing (main)

import Browser
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Complex
import Html as H
import Html.Attributes as Att
import Svg as S
import Transforms


type alias Model =
    { hovering : Maybe CE.Point }


init : Model
init =
    { hovering = Nothing }


type Msg
    = OnHover (Maybe CE.Point)


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnHover hovering ->
            { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
    H.div
        [ Att.style "height" "500px"
        , Att.style "width" "500px"
        , Att.style "margin" "50px"
        ]
        [ C.chart
            [ CA.height 300
            , CA.width 300
            , CE.onMouseMove (OnHover << Just) CE.getCoords
            , CE.onMouseLeave (OnHover Nothing)
            , CA.domain [ CA.lowest -10 CA.exactly, CA.highest 10 CA.exactly ]
            , CA.range [ CA.lowest -10 CA.exactly, CA.highest 10 CA.exactly ]
            ]
            [ C.yAxis [ CA.color CA.darkGray ]
            , C.xAxis [ CA.color CA.darkGray ]
            , case model.hovering of
                Just coords ->
                    C.series .x
                        [ C.scatter .y
                            [ CA.cross
                            , CA.borderWidth 2
                            , CA.border "white"
                            , CA.size 12
                            ]
                        ]
                        [ transformCoords coords ]

                Nothing ->
                    C.none
            ]
        ]


transformCoords : CE.Point -> CE.Point
transformCoords c =
    let
        ( x, y ) =
            transform ( c.x, c.y )
    in
    CE.Point x y


transform : ( Float, Float ) -> ( Float, Float )
transform =
    Transforms.r2ify Complex.cos


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
