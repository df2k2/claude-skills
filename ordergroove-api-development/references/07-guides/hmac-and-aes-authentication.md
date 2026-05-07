# HMAC and AES Authentication

The following article outlines the details for HMAC authentication and AES encryption. HMAC authentication is used for authenticating API calls as well as authenticating logged-in users to view their subscriptions within the My Account section of your site. Please refer to the specific documentation flow to determine how this authentication is used (for example, API header, cookie, etc). AES encryption is typically used solely for encrypting the credit card expiration date when that data is passed to and from Ordergroove via API.

***

## HMAC Authentication

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #039de7; color: #fff; font-weight: bold;">
        <td style="width: 29%;">Item</td>
        <td style="width: 71%;">Definition</td>
      </tr>
      <tr>
        <td style="width: 29%;">RAW_DATA_POINT</td>
        <td style="width: 71%;">
          One data point used as the input for the signature generation function.
          For the purpose of this integration, this will always be the user
          ID.
        </td>
      </tr>
      <tr>
        <td style="width: 29%;">SECONDS_SINCE_EPOCH</td>
        <td style="width: 71%;">
          The Unix epoch (or Unix time, POSIX time or Unix timestamp) is the
          number of seconds that have elapsed since January 1, 1970 (midnight
          UTC/GMT). This will be a 10-digit number.
        </td>
      </tr>
      <tr>
        <td style="width: 29%;">SHA-256</td>
        <td style="width: 71%;">
          The hash function set as a parameter of the HMAC signature generation
          function.
        </td>
      </tr>
      <tr>
        <td style="width: 29%;">HASH_KEY</td>
        <td style="width: 71%;">
          Secret hash key provided to you by your Ordergroove team, unique
          to your merchant.
        </td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

The signature is created in the following way:

Using the HMAC hash function, generate a signature using SHA-256. The function input also includes the concatenation of RAW\_DATA\_POINT and SECONDS\_SINCE\_EPOCH (see definition above) with a pipe character in between, and the secret hash key.

If you are sending the signature in an HTTP request, you must URL encode it before sending.

Example:

```html
signature=hash_hmac("sha256","<RAW_DATA_POINT>|<SECONDS_SINCE_EPOCH>","<HASH_KEY>");
```

### The HMAC Signature Tool

The HMAC Generator tool contains a form with which you can create a valid HMAC signature. This tool is most often helpful to confirm that your integration is correctly generating the signature that Ordergroove is anticipating.

If you have permissions to use this tool, you’ll find this utility within Ordergroove under [Developers > HMAC Generator](https://rc3.ordergroove.com/tools/hmac_generator/). If you would like to request access to the HMAC Signature Tool, please reach out to Ordergroove support.

### Using the Tool

In the **Unique Identifier** field, enter the customer ID from your e-commerce platform. If no hash key is entered, Ordergroove will use the merchant-level hash key configured for your account in the Ordergroove environment in which you are using the utility.

Finally, the timestamp will automatically generate with the current 10-digit Unix timestamp but can be updated to match the one used in your test request.

When using an HMAC signature for API requests and setting the og\_auth cookie, Ordergroove requires that the timestamp is within the last two hours.

<Image align="center" width="600px" src="https://files.readme.io/aea0f6d-Screen_Shot_2022-09-27_at_2.33.17_PM.png" />

***

## AES Encryption

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #039de7; color: #fff; font-weight: bold;">
        <td style="width: 29%;">Item</td>
        <td style="width: 71%;">Description</td>
      </tr>
      <tr>
        <td style="width: 29%;">Algorithm</td>
        <td style="width: 71%;">AES</td>
      </tr>
      <tr>
        <td style="width: 29%;">Mode</td>
        <td style="width: 71%;">ECB</td>
      </tr>
      <tr>
        <td style="width: 29%;">Padding</td>
        <td style="width: 71%;">Right-padded with '{' characters</td>
      </tr>
      <tr>
        <td style="width: 29%;">Block-size</td>
        <td style="width: 71%;">32 bytes</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

First, with the hash key, generate an **AES** cipher using **ECB** mode. ie: cipher - AES.new(hash\_key)

To encode data:

1. Pad the data you want to encode with the "\{" character so that it is a multiple of 32 characters in length.
   1. Pseduo code example: (data + (32 - length(data) modulus 32) \* "\{" )
   2. If data="something" the result of padding data would be "something\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{\{"
2. Encrypt the padded data with the cipher
   1. Pseudo code example: cipher.encrypt(padded\_data)

To decode data:

1. Decrypt with the cipher
   1. Pseudo code example: cipher.decrypt()
2. Remove all the padding characters
   1. Pseudo code example: decrypted\_data.rstrip("\{")

Examples:

```php
<?php

class Example {
const CYPHER = MCRYPT_RIJNDAEL_128;
const MODE = MCRYPT_MODE_ECB;
const BLOCK_SIZE = 32;
const PADDING = '{';
protected $_hashKey = null;
public function setHashKey($data) {
$this->_hashKey = $data;
}
public function getHexHashKey() {
return pack('H*', bin2hex($this->_hashKey));
}

public function pad($data) {
$data . str_repeat(self::PADDING,(self::BLOCK_SIZE - (strlen($data) % self::BLOCK_SIZE)));
}
public function strip($data) {
return str_replace(self::PADDING, '', $data);
}
public function encrypt($data) {
return trim(base64_encode(mcrypt_encrypt(self::CYPHER, $this->getHexHashKey(), $data, self::MODE)));
}
public function decrypt($data)
{
return $this->strip(mcrypt_decrypt(self::CYPHER,$this->getHexHashKey(),base64_decode($data),self::MODE));
}
}
$obj = new Example;
$obj->setHashKey('Mt!ZQ45q&GHsgiRD8{NB-_h87#rjvbn0');
$ccNumber = '4111111111111111';
echo "Original credit card number: $ccNumber<BR>";
$encryptedCcNumber = $obj->encrypt($ccNumber);
echo "Encrypted credit card number: $encryptedCcNumber<BR>";
$unencryptedCcNumber = $obj->decrypt($encryptedCcNumber);
echo "Unencrypted credit card number: $unencryptedCcNumber";
```

```python
BLOCK_SIZE = 32
PADDING = '{'


def pad(s):
    return s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * PADDING


def EncodeAES(c, s):
    return base64.b64encode(c.encrypt(pad(s)))


def DecodeAES(c, e):
    return c.decrypt(base64.b64decode(e)).rstrip(PADDING)


hash_key = 'Mt!ZQ45q&GHsgiRD8{NB-_h87#rjvbn0'
cipher = AES.new(hash_key)

encoded = EncodeAES(cipher, "something")
something = DecodeAES(cipher, encoded)
```