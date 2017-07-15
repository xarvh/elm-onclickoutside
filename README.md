# elm-onclickoutside

This package uses `tabindex` and the
[focusout](https://developer.mozilla.org/en-US/docs/Web/Events/focusout)
event to detect when a DOM element, or any of its children, lose focus.

This is useful for UX elements such as dropdowns and modals that should close
whenever the user clicks outside of them.

```elm
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.OnClickOutside


type Msg
    = UserClickedOutsideOfFruitDropdown


dropdownView =
    let
        onClickOutsideAttributes =
            Html.OnClickOutside.withId "fruit-dropdown" UserClickedOutsideOfFruitDropdown

        otherAttributes =
            [ class "generic-dropdown" ]

        allAttributes =
            onClickOutsideAttributes ++ otherAttributes
    in
        div
            allAttributes
            [ text "apples"
            , text "oranges"
            , text "pears"
            ]
```
