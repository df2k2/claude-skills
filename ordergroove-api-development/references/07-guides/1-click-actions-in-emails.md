# 1-Click Actions in Emails

Ordergroove supports 1-Click URLs in emails to redirect customers to a location of your choice. This is usually used to delay or cancel future shipments.

For general information about 1-Click and the actions available, take a look at <Anchor label="1-Click Actions Overview" target="_blank" href="https://help.ordergroove.com/hc/en-us/articles/28107418301587-1-Click-Actions-Overview">1-Click Actions Overview</Anchor> in the Knowledge Center. In this guide we'll go through how to set it up.

***

## 1. Email Setup

Reach out to Ordergroove, we will add a token value as a dynamic field in the email trigger content.

<Image align="center" width="500px" src="https://files.readme.io/9902917-skiporder.jpg" />

***

## 2. Confirmation Experience

Once the customer has reached the landing page and completed the one-click flow confirmation that you have built, you will follow the steps below to trigger the confirmation to Ordergroove.

1. Take the token query parameter value from the URL
2. Decode this value using JS built-in functions

```json
JSON.parse(atob(decodeURIComponent(encoded_token_value)))
```

Decoding from Step 2 will give you a value such as:

```Text Response
{
experience: "skip_order",
auth: {
public_id: "ca80b8701d2711eba195bc764e10b970"
sig: "Bp165d886LT2CKW9Hppv5LPja4k8dTtG8STDtub/jgs="
ts: 1585925651
trust_level: "recognized"
sig_field: "26115443"
},
resource_id: "c1e7a5766f9811eabe8abc764e10028e"
}
```

3. Take the value of the resource\_id and hit the Ordergroove lego endpoint
   1. Staging: [https://staging.restapi.ordergroove.com/orders/](https://staging.restapi.ordergroove.com/orders/)\<resource\_id>/cancel/
   2. Production: [https://restapi.ordergroove.com/orders/](https://restapi.ordergroove.com/orders/)\<resource\_id>/cancel/

* **With the following Headers**
  * 'Authorization': JSON.stringify(\<auth>),
  * 'Content-Type': 'application/json'

4. **The value of \<auth> will be taken directly from the parsed token value:**

```Text Token
{
public_id: "ca80b8701d2711eba195bc764e10b970"
sig: "Bp165d886LT2CKW9Hppv5LPja4k8dTtG8STDtub/jgs="
ts: 1585925651
trust_level: "recognized"
sig_field: "26115443"
}
```

<Image align="center" width="650px" src="https://files.readme.io/12e8120-skiporder2.jpg" />

You've now implemented a Skip Order feature into your order reminder emails.