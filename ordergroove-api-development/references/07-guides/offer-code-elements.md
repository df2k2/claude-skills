# Offer Code Elements

<HTMLBlock>
  {`
  <h1 id="h_01HNE1G83DHZYBMQ6KFB8XY41H" class="heading-text">og-frequency-status</h1>
  <p>
    This element is aware of the frequency associated with a given optin. This element
    contains three slots - one is displayed when one is subscribed, another when
    one is not subscribed, and another when one is subscribed whilst frequency does
    not match default frequency.
  </p>
  <h2 id="h_01HNE1G83DM4TKXWT5PMDGQNAH" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 50%;">Attribute</th>
        <th style="width: 50%;">Type</th>
      </tr>
      <tr>
        <td style="width: 50%;">default-frequency</td>
        <td style="width: 50%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 50%;">disabled</td>
        <td style="width: 50%;">Boolean</td>
      </tr>
      <tr>
        <td style="width: 50%;">frequency</td>
        <td style="width: 50%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 50%;">product</td>
        <td style="width: 50%;">String</td>
      </tr>
      <tr>
        <td style="width: 50%;">subscribed</td>
        <td style="width: 50%;">Boolean</td>
      </tr>
    </tbody>
  </table>
  <p>&nbsp;</p>
  <h2 id="h_01HNE1G83DC9E67A8MY5HF2G5S" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 20.5714%;">Slot</th>
        <th style="width: 79.2857%;">Default</th>
      </tr>
      <tr>
        <td style="width: 20.5714%;">frequency-mismatch</td>
        <td style="width: 79.2857%;">By default this slot is empty</td>
      </tr>
      <tr>
        <td style="width: 20.5714%;">not-subscribed</td>
        <td style="width: 79.2857%;">By default this slot is empty</td>
      </tr>
      <tr>
        <td style="width: 20.5714%;">subscribed</td>
        <td style="width: 79.2857%;">
          By default this slot displays a formatted version of the frequency
          associated with the option
        </td>
      </tr>
    </tbody>
  </table>
  <p>&nbsp;</p>

  <h1 class="heading-text">og-incentive-text</h1>
  <p>
  	This element displays information from dynamic incentives. By default, the component will search for a ongoing discount class. The attribute "initial" can be specified to force search in initial incentives.
  </p>

  <h2 id="h_01HNE1G83ED7KZWT87TFBZBMK3" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%; height: 66px;" border="1">
    <tbody>
      <tr>
        <th style="width: 15%;">Attribute</th>
        <th style="width: 35%">Description</th>
        <th style="width: 50%;">Example</th>
      </tr>
      <tr>
        <td style="width: 15%;">DiscountAmount </td>
        <td style="width: 35%;">
          Shows discount amount in dollars
        </td>
        <td style="width: 50%;">
          &lt;og-incentive-text from=&quot;DiscountAmount&quot;&gt;&lt;/og-incentive-text&gt;
        </td>
      </tr>
      <tr>
        <td style="width: 15%;">DiscountPercent</td>
        <td style="width: 35%;">
          Shows discount amount in percent
        </td>
        <td style="width: 50%;">
          &lt;og-incentive-text from=&quot;DiscountPercent&quot;&gt;&lt;/og-incentive-text&gt;
        </td>
      </tr>
      <tr>
        <td style="width: 15%;">ShippingDiscountPercent</td>
        <td style="width: 35%;">
          Shows whether or not is free shipping
        </td>
        <td style="width: 50%;">
          &lt;og-incentive-text from=&quot;ShippingDiscountPercent &quot;&gt;&lt;/og-incentive-text&gt;
        </td>
      </tr>
      <tr>
        <td style="width: 15%;">initial</td>
        <td style="width: 35%;">
          Can be applied to Discounts to force showing initial discount
        </td>
        <td style="width: 50%;">
          &lt;og-incentive-text from=&quot;DiscountPercent&quot; initial&gt;&lt;/og-incentive-text&gt;

        </td>
      </tr>
    </tbody>
  </table>
  <p>&nbsp;</p>
  <h1 id="h_01HNE1G83D4GKNFCKXMQDX7B5T" class="heading-text">og-next-upcoming-order</h1>
  <p>
    This element displays the placement date of one's next upcoming order.
  </p>
  <p>&nbsp;</p>
  <h1 id="h_01HNE1G83D7YAH39PE1969TPF4" class="heading-text">og-offer</h1>
  <p>
    This element displays a complete offer, allowing one to opt in, opt out, and
    change the frequency of an optin. The product attribute is required except in
    the case that either preview-standard-offer or preview-upsell-offer are true.
    If the product is upsell-eligible, the element will display an upsell offer.
    If the product is not upsell-eligible but is subscription-eligible, the element
    will display an offer for the specified type, or an offer of radio type if type
    is not specified. Upsell eligibility and subscription eligibility are determined
    at runtime based on response data from a request made for the specified product.
    If a product is neither upsell-eligible nor subscription-eligible, nothing is
    displayed.
  </p>
  <p>
    This element contains two slots. The iu-template slot is displayed when the product
    is upsell-eligible. The standard-template slot is displayed when the product
    is not upsell-eligible but is subscription-eligible.
  </p>
  <div class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83DH6QMN1W0J0Q0VPJZ" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 50%;">Attribute</th>
        <th style="width: 50%;">Type</th>
      </tr>
      <tr>
        <td style="width: 50%;">default-frequency</td>
        <td style="width: 50%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 50%;">preview-standard-offer</td>
        <td style="width: 50%;">Boolean</td>
      </tr>
      <tr>
        <td style="width: 50%;">preview-upsell-offer</td>
        <td style="width: 50%;">Boolean</td>
      </tr>
      <tr>
        <td style="width: 50%;">product</td>
        <td style="width: 50%;">String</td>
      </tr>
      <tr>
        <td style="width: 50%;">product-components</td>
        <td style="width: 50%;">List of Product Components</td>
      </tr>
      <tr>
        <td style="width: 50%;">show-tooltip</td>
        <td style="width: 50%;">Boolean</td>
      </tr>
      <tr>
        <td style="width: 50%;">type</td>
        <td style="width: 50%;">Offer Type</td>
      </tr>
      <tr>
        <td style="width: 50%;">first-order-place-date</td>
        <td style="width: 50%;">String YYYY-MM-DD</td>
      </tr>
      <tr>
        <td style="width: 50%;">product-to-subscribe</td>
        <td style="width: 50%;">String</td>
      </tr>
      <tr>
        <td style="width: 50%;">location</td>
        <td style="width: 50%;">String</td>
      </tr>
    </tbody>
  </table>
  <div class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83D0Y7BCA3YT0EY2AME" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 16.5714%;">Slot</th>
        <th style="width: 83.2857%;">Default</th>
      </tr>
      <tr>
        <td style="width: 16.5714%;">upsell</td>
        <td style="width: 83.2857%;">
          By default, this slot displays an upsell offer comprised of a button,
          which when clicked, displays a modal presenting option to opt in
        </td>
      </tr>
      <tr>
        <td style="width: 16.5714%;">standard-template</td>
        <td style="width: 83.2857%;">
          By default, this slot displays either a radio offer, a select offer,
          or a toggle offer, based on the value of the type attribute
        </td>
      </tr>
    </tbody>
  </table>
  <div id="og-optin-button" class="heading-anchor anchor waypoint"></div>
  <h1 id="h_01HNE1G83D9149DWZZMKMRRTXB" class="heading-text">og-optin-button</h1>
  <p>
    This element allows one to opt in to an offer. One may typically wish to use
    this element in conjunction with og-optout-button to enable the ability to toggle
    one's optin status. This element contains two slots - a default slot, and a label
    slot, which is nested within the default slot and so will only be displayed if
    the default slot has not been overridden.
  </p>
  <p>&nbsp;</p>
  <h2 id="h_01HNE1G83D3HJAW95NXW6PJKGH" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 67%;">Attribute</th>
        <th style="width: 32.8571%;">Type</th>
      </tr>
      <tr>
        <td style="width: 67%;">default-frequency</td>
        <td style="width: 32.8571%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 67%;">frequency</td>
        <td style="width: 32.8571%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 67%;">optin-button-label</td>
        <td style="width: 32.8571%;">String</td>
      </tr>
      <tr>
        <td style="width: 67%;">product</td>
        <td style="width: 32.8571%;">String</td>
      </tr>
      <tr>
        <td style="width: 67%;">subscribed (read-only)</td>
        <td style="width: 32.8571%;">None</td>
      </tr>
    </tbody>
  </table>
  <div id="slots-2" class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83DWWRF9AC9VJWV9XGH" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="height: 14px;">
        <th style="height: 14px; width: 14%;">Slot</th>
        <th style="height: 14px; width: 85.8571%;">Default</th>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 14%;">unnamed slot</td>
        <td style="height: 44px; width: 85.8571%;">
          By default this slot displays a radio button to opt in, along with
          a label to display the value of offerOptInLabel
        </td>
      </tr>
      <tr style="height: 22px;">
        <td style="height: 22px; width: 14%;">label</td>
        <td style="height: 22px; width: 85.8571%;">By default this slot displays the value of offerOptInLabel</td>
      </tr>
    </tbody>
  </table>
  <div id="section-og-optin-status" class="heading-anchor_backwardsCompatibility">
    <h1 class="heading-text">og-optin-status</h1>
  </div>
  <p>
    This element is aware of one's optin status for a given product. One may either
    be subscribed or not subscribed. These two states correspond to eponymously named
    slots. There exist two additional slots, frequency-match and frequency-mismatch
    that may be employed when the frequency of the optin either matches or does not
    match the default frequency.
  </p>
  <p>&nbsp;</p>
  <h2 id="h_01HNE1G83DWSPWSW3ZS9P7BSX4" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%; height: 66px;" border="1">
    <tbody>
      <tr>
        <th style="width: 56.1429%;">Attribute</th>
        <th style="width: 43.7143%;">Type</th>
      </tr>
      <tr>
        <td style="width: 56.1429%;">product</td>
        <td style="width: 43.7143%;">String</td>
      </tr>
      <tr>
        <td style="width: 56.1429%;">subscribed</td>
        <td style="width: 43.7143%;">Boolean</td>
      </tr>
    </tbody>
  </table>
  <p>&nbsp;</p>
  <h2 id="h_01HNE1G83D35B1SBSCAN9XW7W6" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 24.1429%;">Slot</th>
        <th style="width: 75.7143%;">Default</th>
      </tr>
      <tr>
        <td style="width: 24.1429%;">frequency-match</td>
        <td style="width: 75.7143%;">By default this slot is empty</td>
      </tr>
      <tr>
        <td style="width: 24.1429%;">frequency-mismatch</td>
        <td style="width: 75.7143%;">By default this slot is empty</td>
      </tr>
      <tr>
        <td style="width: 24.1429%;">not-subscribed</td>
        <td style="width: 75.7143%;">
          By default, this slot displays the value of optinStatusOptedOutLabel
        </td>
      </tr>
      <tr>
        <td style="width: 24.1429%;">subscribed</td>
        <td style="width: 75.7143%;">
          By default, this slot displays the value of optinStatusOptedInLabel
        </td>
      </tr>
    </tbody>
  </table>
  <div class="rdmd-table">
    <div class="rdmd-table-inner"></div>
  </div>
  <h1 id="h_01HNE1G83DRRT5NYA8SRTKV5H5" class="heading-text">og-optin-toggle</h1>
  <p>
    This element allows one to toggle one's optin status. One may either be subscribed
    or not subscribed. This element contains one unnamed slot.
  </p>
  <div id="attributes-4" class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83DHF5SZW7PK59ZN4BY" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 67%;">Attribute</th>
        <th style="width: 32.8571%;">Type</th>
      </tr>
      <tr>
        <td style="width: 67%;">frequency</td>
        <td style="width: 32.8571%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 67%;">product</td>
        <td style="width: 32.8571%;">String</td>
      </tr>
      <tr>
        <td style="width: 67%;">subscribed (read-only)</td>
        <td style="width: 32.8571%;">None</td>
      </tr>
    </tbody>
  </table>
  <div class="rdmd-table">
    <div class="rdmd-table-inner"></div>
  </div>
  <h2 id="h_01HNE1G83D6YEKSB9HN7PNDCJ2" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 13.2857%;">Slot</th>
        <th style="width: 86.5714%;">Default</th>
      </tr>
      <tr>
        <td style="width: 13.2857%;">unnamed slot</td>
        <td style="width: 86.5714%;">
          By default this slot displays a checkbox to toggle one's optin status,
          along with a label to display the value of optinStatusOptedInLabel
        </td>
      </tr>
    </tbody>
  </table>
  <div class="rdmd-table">
    <div class="rdmd-table-inner">
      <p>&nbsp;</p>
    </div>
  </div>
  <h1 id="h_01HNE1G83DZH8YMJ6Y1APYQRV9" class="heading-text">og-optout-button</h1>
  <p>
    This element allows one to opt out of an offer. One may typically wish to use
    this element in conjunction with og-optin-button to enable the ability to toggle
    one's optin status. This element contains two slots - a default slot, and a label
    slot, which is nested within the default slot and so will only be displayed if
    the default slot has not been overridden.
  </p>
  <div id="attributes-5" class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83D6Z3FCD54F5YYZTT8" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 67%;">Attribute</th>
        <th style="width: 32.8571%;">Type</th>
      </tr>
      <tr>
        <td style="width: 67%;">default-frequency</td>
        <td style="width: 32.8571%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 67%;">frequency</td>
        <td style="width: 32.8571%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 67%;">optin-button-label</td>
        <td style="width: 32.8571%;">String</td>
      </tr>
      <tr>
        <td style="width: 67%;">product</td>
        <td style="width: 32.8571%;">String</td>
      </tr>
      <tr>
        <td style="width: 67%;">subscribed (read-only)</td>
        <td style="width: 32.8571%;">None</td>
      </tr>
    </tbody>
  </table>
  <div class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83DBMB9XCS5FFFEBPHW" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 14%;">Slot</th>
        <th style="width: 85.8571%;">Default</th>
      </tr>
      <tr>
        <td style="width: 14%;">unnamed slot</td>
        <td style="width: 85.8571%;">
          By default this slot displays a radio button to opt out, along with
          a label to display the value of offerOptOutLabel
        </td>
      </tr>
      <tr>
        <td style="width: 14%;">label</td>
        <td style="width: 85.8571%;">By default this slot displays the value of offerOptOutLabel</td>
      </tr>
    </tbody>
  </table>
  <div class="rdmd-table">
    <div class="rdmd-table-inner"></div>
  </div>
  <h1 id="h_01HNE1G83ESWF0REH6KABBH9N8" class="heading-text">og-select-frequency</h1>
  <p>
    This element displays a select control that allows one to view and modify the
    frequency of one's optin.
  </p>
  <p>&nbsp;</p>
  <h2 id="h_01HNE1G83EP3R1AZN33N0YEN6Y" class="heading-text">Attributes</h2>
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 54.4286%;">Attribute</th>
        <th style="width: 45.4286%;">Type</th>
      </tr>
      <tr>
        <td style="width: 54.4286%;">default-frequency</td>
        <td style="width: 45.4286%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 54.4286%;">disabled</td>
        <td style="width: 45.4286%;">Boolean</td>
      </tr>
      <tr>
        <td style="width: 54.4286%;">frequencies</td>
        <td style="width: 45.4286%;">List of Frequencies</td>
      </tr>
      <tr>
        <td style="width: 54.4286%;">frequency (read-only)</td>
        <td style="width: 45.4286%;">Frequency</td>
      </tr>
      <tr>
        <td style="width: 54.4286%;">subscribed (read-only)</td>
        <td style="width: 45.4286%;">None</td>
      </tr>
    </tbody>
  </table>
  <div class="rdmd-table">
    <div class="rdmd-table-inner">
      <br>
      <h2 id="h_01HNE1G83EDS5AGGTH6BMHE6JW">Slots</h2>
      <table style="border-collapse: collapse; width: 100%;" border="1">
        <tbody>
          <tr>
            <th style="width: 12.7143%;">Slot</th>
            <th style="width: 87.1429%;">Default</th>
          </tr>
          <tr>
            <td style="width: 12.7143%;">unnamed slot</td>
            <td style="width: 87.1429%;">
              By default this slot contains the configured frequency as
              select option. You can substitute it with your own<span></span>tags
              with values such as "2w", "3m" or "10d" to represent the
              different frequencies.og-optin-status

            </td>
          </tr>
        </tbody>
      </table>
      <p>&nbsp;</p>
    </div>
  </div>
  <h1 id="h_01HNE1G83E36JPD6E7H4JD5WXT" class="heading-text">og-tooltip</h1>
  <p>
    This element displays a tooltip trigger. When one hovers one's cursor over the
    trigger, a tooltip is displayed.
  </p>
  <div id="slots-6" class="heading-anchor anchor waypoint"></div>
  <h2 id="h_01HNE1G83ED7KZWT87TFBZBMK3" class="heading-text">Slots</h2>
  <table style="border-collapse: collapse; width: 100%; height: 66px;" border="1">
    <tbody>
      <tr>
        <th style="width: 12.7143%;">Slot</th>
        <th style="width: 87.1429%;">Default</th>
      </tr>
      <tr>
        <td style="width: 12.7143%;">trigger</td>
        <td style="width: 87.1429%;">
          By default, this slot displays the value of offerTooltipTrigger
        </td>
      </tr>
      <tr>
        <td style="width: 12.7143%;">content</td>
        <td style="width: 87.1429%;">
          By default, this slot displays the value of offerTooltipContent
        </td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>