# npm-gelato-api

Promise wrapper for interacting with Gelato Print API


## Installation
```
npm install print-api
```


## Initiating print api
For all request we require a valid API KEY. Apply for API key [here](https://www.gelato.com/)
```
const gelato = require('print-api')('<YOUR API KEY>', {
	test: true
});

```

## Methods

### Example
Get an example request body for a quote request

```
gelato.example()
```

### Quote
Get a price and delivery quote for the specified product

```
gelato.quote(<options>)
```

### Order
Place an order with a specific price and delivery promise
```
gelato.order(<promiseUid>)
```

### Status
Check status of an order
```
gelato.status(<orderReferenceId>)
```

### Cancel
Cancel an order, available until the Job is sent for printing
```
gelato.cancel(<orderReferenceId>)
```
