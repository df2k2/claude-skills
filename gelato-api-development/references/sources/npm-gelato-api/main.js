const debug = require('debug')('gelato');
const request = require('superagent');
let gelato = (key, options)=>{
	let opt = Object.assign(
		{}, 
		{url: options.test ? 'https://api-test.gelato.com/v2/' : 'https://api.gelato.com/v2/'}, 
		options ? options: {}
	);
	let wrapRequest = (type, endpoint)=>{
		return request[type](opt.url + endpoint).set({
			'Content-Type': 'application/json',
			'X-API-KEY': key
		});
	}
	debug('Init options', opt);
	return {
		example: ()=>{			
			let dummyReference = new Date().valueOf();
			return {
			    "order": {
			        "orderReferenceId": dummyReference+1,
			        "customerReferenceId": dummyReference+2,
			        "currencyIsoCode": "USD"
			    },
			    "recipient": {
			        "countryIsoCode": "US",
			        "firstName": "Bertram",
			        "lastName": "Gilfoyle",
			        "addressLine1": "5230 Newell Road",
			        "addressLine2": "",
			        "stateCode": "CA",
			        "city": "Palo Alto",
			        "postcode": "94301",
			        "email": "betram@piedpiper.com",
			        "phone": "+1555320018"
			    },
			    "products": [{
			        "itemReferenceId": dummyReference+3,
			        "productUid": "cards_pf_a5_pt_350-gsm-coated-silk_cl_4-4_ver",
			        "pdfUrl": "http://example.com/print_job.pdf",
			        "quantity": 100
			    }]
			 }			
		},
		quote: (options) =>{
			debug('create quote promise with ', options);
			return wrapRequest('post', 'quote').send(options);
		},
		order: (id) =>{
			debug('create order promise with ', options);
			return wrapRequest('post', 'order/create').send({
				"promiseUid": id
			});
		},
		cancel: (id) =>{
			debug('create cancel promise with ', options);
			return wrapRequest('post', 'order/cancel').send({
				'orderReferenceId': id
			});
		},
		status: (id)=>{
			debug('create status promise with ', options);
			return wrapRequest('get', 'order/status/'+id);
		}
	}
};
module.exports = gelato;