<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/custom-presets.html -->

# Custom Crop Presets

The Image Editor Crop tool ships with a set of default aspect-ratio and dimension presets. Developers can replace or extend these presets so content editors get crop options that match the project's own image sizes.

## Default Crop Presets

The Crop presets are defined in the Image Editor configuration file:

Hyva/ImageEditor/src/view/adminhtml/web/js/image/image-editor-config.js

```
Crop: {
    autoResize: true,
    presetsItems: [
        {
            titleKey: 'Square',
            descriptionKey: '1:1',
            ratio: 1
        },
        {
            titleKey: 'classicTv',
            descriptionKey: '4:3',
            ratio: 4 / 3
        },
        {
            titleKey: 'cinemascope',
            descriptionKey: '21:9',
            ratio: 21 / 9
        }
    ],
    presetsFolders: [
        {
            titleKey: 'Hyva Theme',
            groups: [
                {
                    titleKey: 'Product',
                    items: [
                        {
                            titleKey: 'Product page',
                            width: 700,
                            height: 700,
                            disableManualResize: true,
                            descriptionKey: 'pdpSize'
                        },
                        {
                            titleKey: 'Small image',
                            width: 135,
                            height: 135,
                            disableManualResize: true,
                            descriptionKey: 'smallImageSize'
                        },
                        {
                            titleKey: 'Thumbnail',
                            width: 78,
                            height: 78,
                            disableManualResize: true,
                            descriptionKey: 'thumbSize'
                        }
                    ]
                },
                {
                    titleKey: 'Category',
                    items: [
                        {
                            titleKey: 'Category page grid',
                            width: 240,
                            height: 300,
                            descriptionKey: 'categoryGrid'
                        }
                    ]
                }
            ]
        }
    ]
}
```

## Overriding the Crop Presets

Override the presets with a [Magento JavaScript mixin](https://developer.adobe.com/commerce/frontend-core/javascript/mixins). The example below uses a `Hyva_CustomModule` module.

### Register the mixin

Create a `requirejs-config.js` file in the `view/adminhtml` folder of your module, pointing the mixin at the Image Editor config:

app/code/Hyva/CustomModule/view/adminhtml/requirejs-config.js

```
var config = {
    config: {
        mixins: {
            'Hyva_ImageEditor/js/image/image-editor-config': {
                'Hyva_CustomModule/js/image/custom-editor-config-mixin': true
            }
        }
    }
}
```

### Define the new presets

Define the replacement Crop presets in the mixin file. The mixin receives the current config as `target`, replaces `target.Crop`, and returns it:

app/code/Hyva/CustomModule/view/adminhtml/web/js/image/custom-editor-config-mixin.js

```
define(['mage/translate'], function ($t) {
    /**
     * Inject new button at the second position from the top
     */
    return function (target) {
        var newCrop = {
            autoResize: true,
            presetsItems: [
                {
                    titleKey: 'Custom one',
                    descriptionKey: '1:4',
                    ratio: 1/4
                }
            ],
            presetsFolders: [
                {
                    titleKey: 'Hyva Theme',
                    groups: [
                        {
                            titleKey: 'Product',
                            items: [
                                {
                                    titleKey: 'Product page',
                                    width: 70,
                                    height: 70,
                                    disableManualResize: true,
                                    descriptionKey: 'pdpSize'
                                }
                            ]
                        },
                        {
                            titleKey: 'Category',
                            items: [
                                {
                                    titleKey: 'Category page grid',
                                    width: 240,
                                    height: 300,
                                    descriptionKey: 'categoryGrid'
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        target.Crop = newCrop
        return target;
    };
});
```
