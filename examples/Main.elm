module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput)
import Html.OnClickOutside


type alias Model =
    String


type Msg
    = UserWrites String
    | UserClicksOutside


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserWrites string ->
            string

        UserClicksOutside ->
            ""


view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "background-color", "#88d" )
            , ( "width", "600px" )
            , ( "height", "400px" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            ]
        ]
        [ div
            ([ style
                [ ( "background-color", "#ccc" )
                , ( "width", "400px" )
                , ( "height", "200px" )
                , ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "justify-content", "center" )
                ]
             ]
                ++ Html.OnClickOutside.withId "target-of-onclickoutside" UserClicksOutside
            )
            [ input
                [ value model
                , onInput UserWrites
                ]
                []
            ]
        ]


main =
    Html.beginnerProgram
        { model = "Click outside of the grey div to clear the input"
        , update = update
        , view = view
        }
