module Html.OnClickOutside exposing (onLoseFocus, succeedIfClickIsOustideOfClass)

{-| @docs onLoseFocus, succeedIfClickIsOustideOfClass
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
given DOM id.

It will succeed otherwise.

-}
succeedIfClickIsOustideOfClass : String -> Decoder ()
succeedIfClickIsOustideOfClass targetClassName =
    succeedIfBloodlineHasClass targetClassName
        |> Decode.field "relatedTarget"
        |> invertDecoder


{-| The first argument is the DOM id that you want to assign to the element.

The second argument is the message that you want to trigger when the user
clicks outside the element.

The function returns a list of Html.Attributes to apply to the element.

The attributes are `tabindex`, `id` and the `focusout` event handler.

This function is meant to cover most use cases, but if you need more control
on the attributes, you will have to use
[succeedIfClickIsOustideOfId](#succeedIfClickIsOustideOfId) instead.

-}
onLoseFocus : msg -> List (Html.Attribute msg)
onLoseFocus onClickOutsideMsg =
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
