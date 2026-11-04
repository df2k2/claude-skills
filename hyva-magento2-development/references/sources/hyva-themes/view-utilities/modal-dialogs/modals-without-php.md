<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/modals-without-php.html -->

# Modals without the PHP ViewModel

Pre-1.5.0 only

The techniques on this page apply to the legacy modal system only. Since Hyvä 1.5.0 the recommended way to create a modal without the PHP view model is to use the [`x-htmldialog` Alpine plugin](../../working-with-alpinejs/alpine-plugins/x-htmldialog.html) directly on a native HTML `<dialog>` element.

It is possible to use Hyvä modal dialogs without a PHP view model.
When doing so, an overlay element using `x-spread="overlay()" x-bind="overlay()"` has to be added manually to the markup.

Why `x-spread` and `x-bind`?

To be compatible with both Alpine.js v2 and v3, both attributes need to be used.
If you don't want compatibility with both versions of Alpine.js, use only one of
\* Alpine.js v2: `x-spread="overlay()"`
\* Alpine.js v3 `x-bind="overlay()"`

Also, the dialog content has to be wrapped with an element using `x-ref="dialog"`.

One use case for this is inside of CMS HTML content.

## Example JS only modal

Here is an example of a dialog with a counter that does not use the PHP Modal view model:

```
<div x-data="{...hyva.modal(), n: 0}">
    <button @click="show" type="button" class="btn mt-40">
        <?= $escaper->escapeHtml(__('Open')) ?>
    </button>

    <div
        x-cloak
        x-spread="overlay()"
        x-bind="overlay()"
        class="fixed inset-0 flex items-center justify-center text-left bg-black bg-opacity-50 z-30"
    >
        <div
            x-ref="dialog"
            role="dialog"
            aria-labelledby="the-label"
            class="inline-block max-h-screen overflow-auto bg-white shadow-xl rounded-lg p-10 text-gray-700"
        >
            <div id="the-label"><?= $escaper->escapeHtml(__('Modal without PHP')) ?></div>
            <div>
                <?= $escaper->escapeHtml(__('Counter:'))?> <span x-text="n">?</span>
                <button class="btn" @click="n++"><?= $escaper->escapeHtml('Increment') ?></button>
            </div>
            <div class="mt-20 flex justify-between gap-2">
                <button @click="hide" type="button" class="btn">
                    <?= $escaper->escapeHtml(__('Cancel')) ?>
                </button>
                <button x-focus-first @click="alert('click')" type="button" class="btn btn-primary">
                    <?= $escaper->escapeHtml(__('Okay')) ?>
                </button>
            </div>
        </div>

    </div>
</div>
```

## Nested modals without the PHP view model

When using nested modal dialogs without the PHP view model, the dialog reference names have to be managed manually.
The dialog reference names have to be specified on `show` and `overlay` calls:

```
<div x-data="hyvaModal">
    <button @click="show('outer', $event)" type="button" class="btn mt-40"><?= $escaper->escapeHtml(__('Open Outer')) ?></button>

    <div
        x-cloak
        x-bind="overlay('outer')"
        x-spread="overlay('outer')"
        class="fixed inset-0 flex items-center justify-center text-left bg-black bg-opacity-50 z-30"
    >
        <div
            x-ref="outer"
            role="dialog"
            aria-labelledby="outer-label"
            class="inline-block max-h-screen overflow-auto bg-white shadow-xl rounded-lg p-10 text-gray-700"
        >
            <div id="outer-label"><?= $escaper->escapeHtml(__('Outer Modal')) ?></div>

            <div>
                <div
                    x-cloak
                    x-bind="overlay('inner')"
                    x-spread="overlay('inner')"
                    class="fixed inset-0 flex items-center justify-center text-left bg-black bg-opacity-50"
                >
                    <div
                        x-ref="inner"
                        role="dialog"
                        aria-labelledby="inner-label"
                        class="inline-block max-h-screen overflow-auto bg-white shadow-xl rounded-lg p-10 text-gray-700"
                    >
                        <div id="inner-label"><?= $escaper->escapeHtml(__('Inner Modal')) ?></div>
                        <div class="mt-20 flex justify-between gap-2">
                            <button @click="hide" type="button" class="btn">
                                <?= $escaper->escapeHtml(__('Cancel')) ?>
                            </button>
                            <button x-focus-first @click="alert('It is done.')" type="button" class="btn btn-primary">
                                <?= $escaper->escapeHtml(__('Do it!')) ?>
                            </button>
                        </div>
                    </div>

                </div>
            </div>

            <div class="mt-20 flex justify-between gap-2">
                <button @click="hide" type="button" class="btn">
                    <?= $escaper->escapeHtml(__('Cancel')) ?>
                </button>
                <button x-focus-first @click="show('inner', $event)" type="button" class="btn btn-primary">
                    <?= $escaper->escapeHtml(__('Open Inner')) ?>
                </button>
            </div>
        </div>

    </div>
</div>
```
