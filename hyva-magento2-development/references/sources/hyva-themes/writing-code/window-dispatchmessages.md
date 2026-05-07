<!-- source: https://docs.hyva.io/hyva-themes/writing-code/window-dispatchmessages.html -->

# window.dispatchMessages()

Hyvä provides a global function `window.dispatchMessages()` to show messages.

The function takes one or two arguments:

1. An array of message objects.
   Each message object has a `type` and a `text`.
   The type is usually one of `"success"`, `"notice"`, `"warning"` or `"error"`.
   The text is the message to display. HTML and `<br/>` linebreaks in message are possible.
2. The optional second parameter is the duration in ms after which the message disappears. If no duration is supplied, the message will remain until the user dismisses it with a click on the X icon.

```
dispatchMessages([
    {
        type: "success",
        text: "Well done! Make haste, my friend, because this message as ephemeral all good things are!"
    }
], 2000);
```
