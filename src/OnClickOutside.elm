module OnClickOutside exposing (dropdown, succeedIfClickIsOustideOfClass)

{-| @docs dropdown, succeedIfClickIsOustideOfClass
-}

import Html
import Html.Attributes
import Html.Events
import Json.Decode as Decode exposing (Decoder)


(&>) =
    flip Decode.andThen


succeedIfBloodlineHasClass : String -> Decoder ()
succeedIfBloodlineHasClass targetClassName =
    let
        hasTargetClass className =
            className
                |> String.split " "
                |> List.member targetClassName
    in
        Decode.field "className" Decode.string
            &> \classString ->
                if hasTargetClass classString then
                    Decode.succeed ()
                else
                    Decode.field "parentNode" (succeedIfBloodlineHasClass targetClassName)


invertDecoder : Decoder a -> Decoder ()
invertDecoder decoder =
    Decode.maybe decoder
        &> \maybe ->
            if maybe == Nothing then
                Decode.succeed ()
            else
                Decode.fail ""


{-| This is a Json.Decoder that you can use to decode a DOM
[FocusEvent](https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent).

It will *fail* if `event.relatedTarget` or any of its ancestors have the
given DOM class.

It will succeed otherwise.

-}
succeedIfClickIsOustideOfClass : String -> Decoder ()
succeedIfClickIsOustideOfClass targetClassName =
    succeedIfBloodlineHasClass targetClassName
        |> Decode.field "relatedTarget"
        |> invertDecoder


{-| This is the main fuction of the module, and the one you should be using
most of the times.

This function returns a list of attributes that you should add to the root
elements of all your dropdowns.

The given message will be triggered only when a click happens outside of *all*
dropdowns.

The attributes are `tabindex`, `class` and the `focusout` event handler.

If you need more control over the attributes, you can specify them manually
and then use [succeedIfClickIsOustideOfId](#succeedIfClickIsOustideOfId) to
decode the event.

-}
dropdown : msg -> List (Html.Attribute msg)
dropdown onClickOutsideMsg =
    let
        targetClassName =
            "ElmOnClickOutsideTarget"

        eventDecoder =
            succeedIfClickIsOustideOfClass targetClassName
    in
        [ Html.Attributes.tabindex 0
        , Html.Attributes.class targetClassName
        , Html.Events.on "focusout" <| Decode.map (always onClickOutsideMsg) eventDecoder
        ]
