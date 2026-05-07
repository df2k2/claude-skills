<!-- source: https://docs.hyva.io/hyva-themes/writing-code/form-validation/index.html -->

# Form Validation Overview

Hyvä uses mostly browser [HTML5 input types](https://developer.mozilla.org/en-US/docs/Learn/Forms/HTML5_input_types) and the [Browser constraint validation API](https://developer.mozilla.org/en-US/docs/Web/API/Constraint_validation) for form input validation in the browser.
Relying on native browser functionality reduces the amount of JavaScript on a page and improves accessibility.

This section of the documentation can serve as a brief introduction and brief reference on browser native form validation, but it does not cover all features that are supported by modern browsers.

Additionally, since Hyvä 1.1.14, a [JavaScript form validation](javascript-form-validation.html) using Alpine.js is available, too.
The Hyvä form validation JavaScript library also ensures accessibility best practices are followed.
