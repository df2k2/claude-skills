# Helper Methods

Ordergroove's offers library registers a global variable, og.offers, that contains a number of useful helper methods.

***

## addOptinChangedCallback

Registers a callback function that is invoked when a user either opts in or opts out of a product offer. This method returns an object as offers module to chain method calls.

### Arguments

| Argument   | Description                                                                                                                                                                |
| :--------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| callbackFn | A function to be called when optin status has been changed. The argument passed to the callback is an object containing the properties productId, components, and optedIn. |

```Text Example callback argument
{ productId: 'a123', components: [ 'a', 'b' ], optedIn: true }
```

### Node/Webpack

```javascript Example
import { addOptinChangedCallback } from '@ordergroove/offers';

function onOptinChanged({ productId, components, optedIn }) {};
addOptinChangedCallback(onOptinChanged);
```

***

## clear

Clears the options from the browser's local storage. This method should be called upon successful checkout.

```javascript UMD
og.offers.clear();
```

***

## config

Configures the library options for advanced usage or customization. This method returns an object as offers module to chain method calls.

### Arguments

| Argument     | Description                                       |
| :----------- | :------------------------------------------------ |
| configObject | A JSON object containing configuration properties |

### configObject JSON Schema

```json
{
  "type": "object",
  "properties": {
    "frequencies": {
      "title": "Available frequencies",
      "type": "array",
      "items": {
        "$ref": "#/definitions/Frequency"
      },
      "default": [
        {
          "every": 1,
          "period": 2
        },
        {
          "every": 2,
          "period": 2
        },
        {}
      ],
      "uniqueItems": true,
      "minItems": 1,
      "maxItems": 99
    },
    "defaultFrequency": {
      "title": "Default frequency selection",
      "$ref": "#/definitions/Frequency"
    },
    "offerType": {
      "title": "Type",
      "type": "string",
      "enum": ["radio", "toggle", "select"],
      "enumNames": ["Radio Button", "Toggle Button", "Select Dropdown"],
      "default": "radio"
    }
  },
  "required": ["frequencies", "defaultFrequency", "offerType"]
}
```

### Node/Webpack and UMD

```javascript Node
import { config } from '@ordergroove/offers';

config({
  frequencies: [
    {
      every: 3,
      period: 2
    },
    {
      every: 2,
      period: 2
    }
  ],
  defaultFrequency: {
    every: 2,
    period: 2
  },
  offerType: 'radio'
});
```

```javascript UMD
og.offers('0e5de2bedc5e11e3a2e4bc764e106cf4', 'staging', '/auth').config({
  frequencies: [
    {
      every: 3,
      period: 2
    },
    {
      every: 2,
      period: 2
    }
  ],
  defaultFrequency: {
    every: 2,
    period: 2
  },
  offerType: 'radio'
});
```

***

## disableOptinChangedCallbacks

Disables all callback functions registered via addOptinChangedCallback.

```javascript Node
import { disableOptinChangedCallbacks } from '@ordergroove/offers';

disableOptinChangedCallbacks();
```

```javascript UMD
og.offers(...).addOptinChangedCallback(() => {});
```

***

## getOptins

Returns a serialized representation of the products that have been opted in to by the customer. The return value is in the format expected by Ordergroove's Purchase POST endpoint, which is called during checkout. The sole argument, `productIds`, is an optional array of product IDs for which to return the serialized optins. If the argument is not supplied, all optins will be returned.

Please note that getOptins is meant to represent the customer's actions of opting in, rather than the state of whether a customer is subscribed. In the case of a product which is "Default to Subscription", the product will not appear as "opted in" with getOptins unless the customer has also clicked the "opt in" button.

### Arguments

| Argument   | Description                                                                                                            |
| :--------- | :--------------------------------------------------------------------------------------------------------------------- |
| productIds | Optional array of product IDs for which to return the serialized optins. If not supplied, all optins will be returned. |

### UMD

```javascript Multiple Products
const result = og.offers.getOptins();
console.log(result);

/**
[
  {
    product: '123',
    subscription_info: {
      components: []
    },
    tracking_override: {
      offer: 'offerId1',
      every: 2,
      every_period: 1,
      session_id: 'sessionId'
    }
  },
  {
    product: '456',
    subscription_info: {
      components: ['a', 'b', 'c']
    },
    tracking_override: {
      offer: 'offerId2',
      every: 3,
      every_period: 1,
      session_id: 'sessionId'
    }
  }
];
**/
```

```javascript Single Product
const result = og.offers.getOptins(['123']);
console.log(result);

/**
[
  {
    product: '123',
    subscription_info: {
      components: []
    },
    tracking_override: {
      offer: 'offerId1',
      every: 2,
      every_period: 1,
      session_id: 'sessionId'
    }
  }
]
**/
```

***

## initialize

To initialize the library you need to call initialize method or shortcut in UMD og.offers. This method returns an object as offers module to chain method calls.

### Arguments

| Argument    | Description                                                                                               |
| :---------- | :-------------------------------------------------------------------------------------------------------- |
| merchantId  | Your merchant public id                                                                                   |
| environment | staging or production                                                                                     |
| authUrl     | The auth url endpoint to resolve customer level auth. Can be json or any response that set-cookie header. |

### Node/Webpack and UMD

```javascript Node
import { initialize } from '@ordergroove/offers';

initialize('0e5de2bedc5e11e3a2e4bc764e106cf4', 'staging', '/auth');
```

```javascript UMD
og.offers('0e5de2bedc5e11e3a2e4bc764e106cf4', 'staging', '/auth');
```

***

## setLocale

Configures the library locale text copies. This method returns an object as offers module to chain method calls.

| Property             | Type    | Description               | Default                                                                                                                                         |
| :------------------- | :------ | :------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| defaultFrequencyCopy | String  | Default frequency copy    | Recommended                                                                                                                                     |
| frequencyPeriods     | Object  | Frequency period names    | `{1:"days",2:"weeks",3:"months"}`                                                                                                               |
| offerEveryLabel      | String  | Subscribe frequency label | Ships Every:                                                                                                                                    |
| offerOptInLabel      | String  | Subscribe option copy     | Subscribe and get 20% off                                                                                                                       |
| offerOptOutLabel     | String  | Subscribe option copy     | One-time                                                                                                                                        |
| offerTooltipContent  | String  | Tool tip copy             | Subscribe to this product and have it conveniently delivered to you at the frequency you choose! Read the FAQ here. Promotion subject to change |
| offerTooltipTrigger  | String  | Tool tip link copy        | More info                                                                                                                                       |
| showTooltip          | Boolean | Display a tooptip         | false                                                                                                                                           |

### Node/Webpack and UMD

```javascript Node
import { setLocale } from '@ordergroove/offers';

setLocale({
  defaultFrequencyCopy: 'Recommended',
  offerOptInLabel: 'Save Lots and Lots of Money',
  offerEveryLabel: 'Ships Every: ',
  offerOptOutLabel: "Don't save money",
  showTooltip: !0,
  offerTooltipTrigger: 'More info',
  offerTooltipContent:
    'Subscribe to this product and have it conveniently delivered to you at the frequency you choose! Read the FAQ here. Promotion subject to change.',
  upsellButtonLabel: 'Add to upcoming subscription order and receive 20% off',
  upsellButtonContent: 'Add to Next Order on ',
  upsellModalContent:
    'Subscribe to this product and have it conveniently delivered to you at the frequency you choose! Read the FAQ here. Promotion subject to change.',
  upsellModalOptOutLabel: 'Get one-time',
  upsellModalOptInLabel: 'Subscribe and get 10% off on every order',
  upsellModalConfirmLabel: 'Add',
  frequencyPeriods: {
    1: 'days',
    2: 'weeks',
    3: 'months'
  }
});

```

```javascript UMD
og.offers(...).config(...).setLocale({
  ...
});
```