<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/keeping-global-scope-tidy.html -->

# Keeping global JavaScript scope tidy

As a rule of thumb, it is good to keep the global scope `window` namespace clean and tidy.

The reason is to avoid name conflicts and to make it easier for developers to know what is part of the official API and what is an implementation detail that might change in a backward incompatible manner.

### A little primer on JavaScript scope for PHP developers

In PHP functions and classes can not be re-declared, but in JavaScript they can be overwritten (it’s a feature).

Another thing to keep in mind is that in JavaScript, from within a nested scope, all outer scope constants, variables and functions are accessible.

But from outer scope, constants, variables and functions declared in a nested scope are hidden.

## When do we need to declare functions?

We often need to add code to a page.

For example, to initialize non-trivial Alpine.js components, to write event subscriber callbacks, or to provide generic functionality that is used by other code.

Do we need to use global scope for all these?

In a nutshell: no. As always in software development, the proper answer is “it depends”.

- Alpine.js initialization functions need to be declared in global scope because they are referenced by name.
- Event subscribers can be declared privately.
- In Hyvä, providing functionality to other code relies on global scope (the exception being things that can be called using custom events).

In this document we will call everything that is accessible from everywhere global scope, and everything that is hidden we call private scope.

Also, this text will omit some details in favor of clarity.

## Making code private.

To keep code out of the global scope it needs to be declared within a function scope.

```
function () {

   // a private function
   function thisIsNotInGlobalScope() {
        // some code
   }

   // a private constant
   const thisConstantIsPrivate;

   // a private variable
   let thisVariableIsPrivate;
}
// none of the three is visible here outside of the function scope
```

The problem with the above example is that the anonymous function above is not called, and if we would give it a name, that would then be part of the global scope.

The solution to this problem are IIFE.

### IIFE

That funky acronym stands for **I**mmediately **I**nvoked **F**unction **E**xpression.

We use it by wrapping our code in parentheses and calling it as a function:

`(function())()`

This will immediately execute the wrapped anonymous function without it being declared in global scope.

#### IIFE Example:

```
<script>
(
    function() {
        // inside of IIFE
        const bar = 123;
        console.log('in IIFE', bar);
    }
)();

console.log('outside of IIFE', bar);
</script>
```

When a page with the above script is loaded, the console output is:

```
in IIFE 123
Uncaught ReferenceError: bar is not defined
```

This allows us to execute functions on a page without them being called as an event callback or having global scope names.

We can combine an IIFE with registering an event observer, too, in case we don’t want to declare all the code within the `window.addEventListener` callback.

```
<script>
(() => {

    function myEventCallback() {
      // the code
    }

    window.addEventListener('DOMContentLoaded', myEventCallback);

})();
</script>
```

Because the `myEventCallback` function is declared within a function, it is not visible in global scope.

### Event Callbacks

For event subscribers, we have to option to drop our code directly in the callback:

```
<script>
window.addEventListener('DOMContentLoaded', function (event) {
    // my code here
});
</script>
```

This works well for short pieces of code, but once they grow the code is easier to manage if it is split into several functions within an IIFE.
