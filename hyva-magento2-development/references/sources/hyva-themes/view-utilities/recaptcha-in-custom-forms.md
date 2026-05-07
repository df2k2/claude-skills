<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/recaptcha-in-custom-forms.html -->

# reCAPTCHA in custom forms

## Captcha support in Hyvä

Hyvä only supports the following reCaptcha versions:

- [v3 invisible](https://developers.google.com/recaptcha/docs/v3)
- [v2 invisible](https://developers.google.com/recaptcha/docs/invisible) (since Hyvä 1.1.15)
- [v2 checkbox](https://developers.google.com/recaptcha/docs/display) (since Hyvä 1.1.15)

The reCAPTCHA integration has to be fully configured in the system configuration at "Security > Google reCAPTCHA
Storefront".
Your Google API Website Key and Secret Key need to be specified for reCAPTCHA to be available.

Disabling legacy Captcha

We currently don’t support the (old/default) Magento captcha, which is enabled by default.

Please disable the default Captcha integration since otherwise forms won’t work:

```
bin/magento config:set customer/captcha/enable 0
```

Magento allows the configuration of which forms should use reCAPTCHA through the system configuration. This is available only for forms that are part of the Magento store front out of the box.

## Using reCaptcha for custom forms

In the following example, the code required to check the system configuration for a given form is omitted for clarity, as it is often not required for custom forms.

Use the following steps in order to implement reCAPTCHA in custom forms.

Please be aware that the instructions below refer to all three supported versions of reCAPTCHA.
Be sure to only use the code for the version you are implementing.

Info

You can find the declarations of the blocks referenced below in the layout XML file `Magento_ReCaptchaFrontendUi/layout/default.xml`.

### 1. Assign the `recaptcha_validation` child block

Assign the recaptcha validation block matching the desired recaptcha version as a child to the block representing your form.

The `recaptcha_validation`, `recaptcha_validation_invisible` and `recaptcha_validation_recaptcha` blocks are provided by the Hyvä Theme.
The appropriate one needs to be assigned as a child to the block rendering your form using the alias `recaptcha_validation`.

```
<!-- Assuming this is the block representing your custom form -->
<block name="my_form_block" template="My_Module::my-form.phtml">
</block>

<!-- use only the version you are implementing, ignore the others -->

<!--  for reCAPTCHA v3 -->
<move element="recaptcha_validation" destination="my_form_block"
      as="recaptcha_validation"/>

<!-- for reCAPTCHA v2 invisible -->
<move element="recaptcha_validation_invisible" destination="my_form_block"
      as="recaptcha_validation"/>

<!-- for reCAPTCHA v2 checkbox -->
<move element="recaptcha_validation_recaptcha" destination="my_form_block"
      as="recaptcha_validation"/>
```

The parent form block name can only include `A-Z a-z/_` characters. e.g. `name="my_form_block"`

As in [script\_token.phtml] the `action` name is gotten from the parent block's name in layout,
for which `recaptcha.js` only allows these characters, if invalid characters are used the following browser error may present:

`Invalid action name, may only include "A-Z a-z/_". Do not include user-specific information`

### 2. Render the reCAPTCHA hidden field

In your form, render the hidden reCAPTCHA input field and legal notice.
Both are supplied by blocks declared automatically for every page.

```
<?php

use Hyva\Theme\ViewModel\ReCaptcha;

?>
<form action="<?= $escaper->escapeUrl($block->getUrl('my_module/action/post')) ?>"
      method="post"
      id="my-form"
      x-data="initMyForm()"
      @submit.prevent="submitForm()"
>
    <?= $block->getBlockHtml('formkey') ?>

    <!-- Render the hidden input field matching your version -->
    <!-- It will be validated server side. -->

    <!-- for reCAPTCHA v3 -->
    <?= $block->getBlockHtml('recaptcha_input_field') ?>

    <!-- for reCAPTCHA v2 invisible -->
    <?= $block->getBlockHtml('recaptcha_input_field_invisible') ?>

    <!-- for reCAPTCHA v2 checkbox -->
    <?= $block->getBlockHtml('recaptcha_input_field_recaptcha') ?>

    <!-- Other Form Fields Here -->

    <!-- Only for recaptcha v3: render the legal notice block -->
    <div class="w-full grecaptcha-legal">
        <?= $block->getBlockHtml(ReCaptcha::RECAPTCHA_LEGAL_NOTICE_BLOCK) ?>
    </div>

    <!-- Render the submit button -->
    <div class="actions-toolbar">
        <div class="primary">
            <button type="submit" class="action submit primary">
                <?= $escaper->escapeHtml(__('Submit')) ?>
            </button>
        </div>
    </div>
</form>
```

### 3. Add client side reCAPTCHA validation

First, make the form part of an alpine component (if it isn't already anyway).
Then render the `recaptcha_validation` child block declared earlier in step 1 above.

The form element is expected to be assigned to a variable `$form`.
Any errors will be declared on the `this.errors` property of the component.

```
<script>
  function initMyForm() {
    return {
      submitForm() {
        // Do not rename $form!
        // In recaptcha_validation it is expected to be declared

        const $form = document.getElementById('my-form');
        <?= $block->getChildHtml('recaptcha_validation'); ?>

        if (this.errors === 0) {
          $form.submit();
        }
      }
    }
  }
</script>
```
