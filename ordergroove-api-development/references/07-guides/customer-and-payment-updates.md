# Customer and Payment Updates

## Customer Contact Details Update

When a customer changes their email address associated with their account, Ordergroove needs to be notified of this change. This notification is sent via a PATCH request to the set contact details endpoint.

**Destination**

Staging: [https://staging.restapi.ordergroove.com/customers/\{merchant\_user\_id}/set\_contact\_details](https://staging.restapi.ordergroove.com/customers/\{merchant_user_id}/set_contact_details)\
Production: [https://restapi.ordergroove.com/customers/\{merchant\_user\_id}/set\_contact\_details](https://restapi.ordergroove.com/customers/\{merchant_user_id}/set_contact_details)

```json Header
headers = {
'authorization': '{"public_id": "<MERCHANT_PUBLIC_ID>", "ts": <SECONDS_SINCE_EPOCH>, "sig_field": "<MERCHANT_USER_ID>", "sig": "<SIGNATURE>"}',
'content-type': 'application/json'
}
```

```json Request Body
{
"email": "<New_Email>",
"merchant": "<Merchant_Public_id>",
"merchant_user_id": "<Merchant_User_Id>",
"phone_number": "<Phone_Number>"
}
```

***

## Customer Contact Details Responses

**Success Response**

If a successful connection is made, the request will always result in a secure HTTP response object with code 200 and a JSON payload

```json
{
"phone_number": "<Phone_Number>",
"email": "<Email>"
}
```

**Error Responses**

In the event of an error with the request, one of the following error codes may be returned with the corresponding JSON payload

```Text 400
{
"[field_name]": "field_name error detail"
}
```

```Text 403
{
"detail": "Authentication Failed"
}
```

```Text 404
{
"detail": "Unable to find requested asset."
}
```

***

## Customer Payment Update

When a customer changes their default payment for subscriptions within their account wallet, Ordergroove needs to be notified of this change. This notification is sent via a POST request to the update payment default endpoint.

**Destination**:

Staging: [https://staging.v2.ordergroove.com/customer/update\_payment\_default](https://staging.v2.ordergroove.com/customer/update_payment_default)\
Production: [https://api.ordergroove.com/customer/update\_payment\_default](https://api.ordergroove.com/customer/update_payment_default)

> 📘 Note
>
> Each field needs to be URL encoded (special characters such as & will otherwise break the update request), not just the encrypted fields. The entire post should not be URL encoded, just the fields individually.

```Text Request
update_request={
    "merchant_id": "<MERCHANT_ID>",
    "user": {
        "user_id": "<MERCHANT_USER_ID>",
        "ts": "<TIME_STAMP>", // timestamp is seconds since epoch
        "sig": "<SIGNATURE>" // Hmac signature based on user id and timestamp | Url encoded
    },
    "payment": {
        "label": "<LABEL>", // optional
        "card_type": "<ENUMERATED_CARD_TYPE>",   //  1 = Visa, 2 = MasterCard, 3= American Express, 4 = Discover
        "cc_exp_date": "<MM/YYYY_AES_ENCRYPTED>", //should be url encoded after being encrypted | Value should always be 12/2099 for PayPal
        "cc_last_4": "<CC_LAST_4_DIGITS_AES_ENCRYPTED>", //should be url encoded after being encrypted
        "cc_holder": "<CC_HOLDER_AES_ENCRYPTED>", //should be url encoded after being encrypted
        "token_id":"<TOKEN_ID>" // optional,
        "billing": { // optional
            "first_name": "<FIRST_NAME>",
            "last_name": "<LAST_NAME>",
            "phone": "<PHONE>",
            "address": "<ADDRESS>",
            "address2": "<ADDRESS2>",
            "city": "<CITY>",
            "country_code": "<COUNTRY_CODE>",
            "zip_postal_code": "<ZIP>",
            "fax": "<FAX>",
            "state_province_code": "<STATE_PROVINCE_CODE>",
            "company_name": "<COMPANY_NAME>"
        }
    }
}
```

***

## Customer Payment Update Responses

**Success Response**

If all validations pass, and the customer payment is updated successfully, this API will simply respond with "SUCCESS".

**Error messages**

The following is the list of possible messages when an "error" result is provided in the response. In case of an error message, no updates to the customer are performed.

* "Invalid Merchant"
* "Invalid Request"
  * An invalid JSON object is the most likely cause of this error
* "Customer does not exist"
* "Could not decode cc\_exp\_date"
* "\<merchant\_name> is not configured to accept \<payment\_field>"