module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type_, tabindex)
import Html.Events exposing (onClick, onBlur)
import Html.OnClickOutside


type DropdownId
    = DropdownBlur
    | DropdownOnClickOutside1
    | DropdownOnClickOutside2


type alias Model =
    { maybeOpenDropdown : Maybe DropdownId }


type Msg
    = SelectDropdown (Maybe DropdownId)


update : Msg -> Model -> Model
update msg model =
    case Debug.log "-" msg of
        SelectDropdown maybeDropdownId ->
            { model | maybeOpenDropdown = maybeDropdownId }



-- view


dropdown : DropdownId -> Maybe DropdownId -> (Msg -> List (Html.Attribute Msg)) -> Html Msg
dropdown id maybeOpenDropdown makeAttributes =
    let
        clickOutsideMsg =
            SelectDropdown Nothing

        attributes =
            makeAttributes clickOutsideMsg

        isOpen =
            Just id == maybeOpenDropdown

        triggerMsg =
            if isOpen then
                SelectDropdown Nothing
            else
                SelectDropdown (Just id)

        trigger =
            div
                [ onClick triggerMsg ]
                [ text <| toString id ]

        checkbox =
            input [ type_ "checkbox" ] []

        content =
            if not isOpen then
                text ""
            else
                div
                    []
                    [ checkbox
                    , checkbox
                    ]
    in
        div
            (style
                [ ( "position", "relative" )
                , ( "margin-top", "1rem" )
                ]
                :: attributes
            )
            [ trigger
            , content
            ]


view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "", "" )
            , ( "", "" )
            ]
        ]
        [ dropdown
            DropdownBlur
            model.maybeOpenDropdown
            (\msg ->
                [ onBlur msg
                , tabindex 0
                ]
            )
        , dropdown
            DropdownOnClickOutside1
            model.maybeOpenDropdown
            (\msg -> Html.OnClickOutside.onLoseFocus msg)
        , dropdown
            DropdownOnClickOutside2
            model.maybeOpenDropdown
            (\msg -> Html.OnClickOutside.onLoseFocus msg)
        ]



-- main


main =
    Html.beginnerProgram
        { model = { maybeOpenDropdown = Nothing }
        , update = update
        , view = view
        }
