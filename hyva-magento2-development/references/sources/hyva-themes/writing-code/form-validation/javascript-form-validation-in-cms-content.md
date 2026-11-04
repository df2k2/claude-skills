<!-- source: https://docs.hyva.io/hyva-themes/writing-code/form-validation/javascript-form-validation-in-cms-content.html -->

# JavaScript form validation in CMS content

When creating forms in CMS content, the template providing the form functions needs to be rendered on the page, too.
Usually this is done with the layout XML `<update handle="hyva_form_validation"/>`, but with CMS blocks or pages, that can't be used easily.

A possible workaround is to include the relevant code on the page using the `{{block}}` template filter directive.
The main template is `Hyva_Theme::page/js/advanced-form-validation.phtml`, but extensions or customizations may add additional ones.

This will render the main form validation code inside the CMS content in a HTML content type element, so `hyva.formValidation` can be used in CMS HTML content.

```
{{block class="Magento\Framework\View\Element\Template" template="Hyva_Theme::page/js/advanced-form-validation.phtml"}}
```
