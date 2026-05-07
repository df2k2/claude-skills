# Domain Objects

## Frequency

Frequency is the cadence at which orders associated with a given optin are placed. Frequency is a tuple consisting of "every" and "every period". "Every period" may be either days, weeks, months, or years, represented as 1, 2, 3, and 4, respectively. "Every" is a multiple applied to period and may be any positive integer excluding 0. Together, "every" and "every period" are represented as a string separated by an underscore.

**Examples**

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 41%;">Frequency</th>
        <th style="width: 59%;">Description</th>
      </tr>
      <tr>
        <td style="width: 41%;">1_1</td>
        <td style="width: 59%;">Every 1 day</td>
      </tr>
      <tr>
        <td style="width: 41%;">2_1</td>
        <td style="width: 59%;">Every 2 days</td>
      </tr>
      <tr>
        <td style="width: 41%;">4_2</td>
        <td style="width: 59%;">Every 4 weeks</td>
      </tr>
      <tr>
        <td style="width: 41%;">4_3</td>
        <td style="width: 59%;">Every 4 months</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## List of Frequencies

A list of frequencies is a space-separate list of frequencies. A list of frequencies is represented as a string.

**Examples**

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 27.4286%;">List of Frequencies</th>
        <th style="width: 72.4286%;">Description</th>
      </tr>
      <tr>
        <td style="width: 27.4286%;">1_3 2_3 3_3</td>
        <td style="width: 72.4286%;">Every 1 month, every two months, every three months</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## List of Product Components (Legacy Bundles)

A list of product components is a space-separated list of products that, together, comprise a single product. One may find this useful for representing bundles or boxes.

**Examples**

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 34.1429%;">List of Product Components</th>
        <th style="width: 65.7143%;">Description</th>
      </tr>
      <tr>
        <td style="width: 34.1429%;">foo bar baz</td>
        <td style="width: 65.7143%;">The product is comprised of the products foo, bar, and baz</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## Offer Type

Offer type refers to the type of user interface element that is displayed for an offer. Offer type is an enumerated string that may be either "radio", "select", or "toggle".