<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/custom-presets.html -->

# Image Editor Customization

## Provide custom dimensions for the Crop tool

Image Editor configuration file is located in:

```
Hyva/ImageEditor/src/view/adminhtml/web/js/image/image-editor-config.js
```

This is how the Crop tool presets look like by default:

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

You can modify it by using [Magento javascript mixins](https://developer.adobe.com/commerce/frontend-core/javascript/mixins)

Create a `requirejs-config.js` file inside `view/adminhtml` folder of a custom module of yours.
Here is an example of how the above file should look like in a `Hyva_CustomModule` module:

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

Define the new Crop presets for the module in the `custom-editor-config-mixin.js` file like shown below:

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
