module Main exposing (..)

import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events
import Html.OnClickOutside


type DropdownId
    = DropdownBlur1
    | DropdownBlur2
    | DropdownFocusout1
    | DropdownFocusout2
    | DropdownOnClickOutside1
    | DropdownOnClickOutside2


type alias Model =
    { maybeOpenDropdown : Maybe DropdownId }


type Msg
    = SelectDropdown (Maybe DropdownId)


update : Msg -> Model -> Model
update msg model =
    case msg of
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
                [ Html.Events.onClick triggerMsg
                , style
                    [ ( "border", "1px solid" )
                    , ( "background-color", "#bbb" )
                    ]
                ]
                [ text <| toString id ]

        checkbox =
            input [ Html.Attributes.type_ "checkbox" ] []

        content =
            if not isOpen then
                text ""
            else
                div
                    [ style
                        [ ( "border", "1px solid" )
                        , ( "background-color", "#ccc" )
                        ]
                    ]
                    [ checkbox
                    , checkbox
                    ]
    in
        div
            (style
                [ ( "position", "relative" )
                , ( "margin-top", "1rem" )
                , ( "width", "200px" )
                ]
                :: attributes
            )
            [ trigger
            , content
            ]


view : Model -> Html Msg
view model =
    let
        blurAttributes msg =
            [ Html.Events.onBlur msg
            , Html.Attributes.tabindex 0
            ]

        focusoutAttributes msg =
            [ Html.Events.on "focusout" (Json.Decode.succeed msg)
            , Html.Attributes.tabindex 0
            ]

        onClickOutsideAttributes msg =
            Html.OnClickOutside.onLoseFocus msg
    in
        div
            []
            [ div
                [ style
                    [ ( "display", "grid" )
                    , ( "grid-template-columns", "1fr 1fr 1fr" )
                    , ( "width", "800px" )
                    ]
                ]
                [ div
                    []
                    [ text "blur event"
                    , dropdown DropdownBlur1 model.maybeOpenDropdown blurAttributes
                    , dropdown DropdownBlur2 model.maybeOpenDropdown blurAttributes
                    ]
                , div
                    []
                    [ text "focusout event"
                    , dropdown DropdownFocusout1 model.maybeOpenDropdown focusoutAttributes
                    , dropdown DropdownFocusout2 model.maybeOpenDropdown focusoutAttributes
                    ]
                , div
                    []
                    [ text "OnClickOutside.onLoseFocus"
                    , dropdown DropdownOnClickOutside1 model.maybeOpenDropdown onClickOutsideAttributes
                    , dropdown DropdownOnClickOutside2 model.maybeOpenDropdown onClickOutsideAttributes
                    ]
                ]
            , div
                [ style
                    [ ( "margin-top", "1rem" ) ]
                ]
                [ text "If the dropdown contains any tabindexed element, clicking on that element will close the dropdown" ]
            ]



-- main


main =
    Html.beginnerProgram
        { model = { maybeOpenDropdown = Nothing }
        , update = update
        , view = view
        }
