# elm-onclickoutside

This is a pure-Elm event handler to close your app's dropdowns when the
user clicks outside of them, which we use in production at [Stax](https://stax.io/).

```elm
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import OnClickOutside


type DropdownId
    = FruitDropdown


type Msg
    = CloseAllDropdowns
    | ToggleDropdown DropdownId


dropdownView =
    let
        onClickOutsideAttributes =
            OnClickOutside.dropdown CloseAllDropdowns

        otherAttributes =
            [ onClick (ToggleDropdown FruitDropdown)
            , class "generic-dropdown"
            ]

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

The handler makes these assumptions:

* When the user clicks on an element that does not belong to any dropdown,
  you want to *close all dropdowns*.

* Your model allows at most one dropdown to be open at any given time.

This means that the app `Model`, rather than containing an Open/Closed state
for each dropdown, which would allow multiple dropdowns to be open at the same
time, will just contain a reference to the dropdown currently open.

As a consequence, whenever the user clicks on a closed dropdown, you *won't
have to bother closing all the others*: just updating the one reference to
the newly opened dropdown will do.

The behavior of the event handler reflects this design: when a dropdown
loses the focus, but the focus moves to a different dropdown, the message
will *NOT* trigger.


## Notes on a dropdown's children

Some dropdown menus contain `input` elements or other elements with a
`tabindex`.
These children cause two kinds of problems:

1. When a child is focused, the dropdown root element will lose focus,
  triggering its own `blur` or `focusout` and closing itself.

  To prevent this, the handler checks whether the triggering child is
  contained in a dropdown.

2. When a child loses focus, the dropdown itself will not receive the
  `blur` event, only the child will.
  To allow the event to bubble up, the handler uses the
  [focusout](https://developer.mozilla.org/en-US/docs/Web/Events/focusout)
  event instead of `blur` (shoutout to [ericgj](https://github.com/ericgj)
  pointing me to `focusout`).

