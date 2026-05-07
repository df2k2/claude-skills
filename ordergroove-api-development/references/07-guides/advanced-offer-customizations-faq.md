# Advanced Offer Customizations & FAQ

<HTMLBlock>
  {`
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "How do I know which template is being used on my site?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>Our system will seek to find the offer template that matches what is being called on the site from within the location tag contained inside the <code>og-offer</code> snippet. For example: <code>&lt;og-offer product=\"44358808797284\" location=\"pdp\" os-version=\"2\" subscribed=\"\" frequency=\"4287332452\"&gt;</code></p><p>If no location is specified, the system will load the Default template.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "How can I see what location, if any, is tagged on my page?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>The fastest way to determine the location tagging of an offer is to inspect the page. Highlight a section of the offer, right-click, and select Inspect to view the underlying HTML and find the location attribute on the og-offer element.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "I have a lot of templates and some are even named the same. How do I know which is being used on my site?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>Our system will search for templates from oldest to newest created. From the Templates section, this will essentially be left to right, top to bottom. If two templates share the same name, the site will serve up the template that appears first in this order, because it is the older of the two and will be found first by our system.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "I don't see a location specified on my PDP. What does that mean?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>In these instances, the Default template will be loaded by the system.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "I don't have a template stored in Ordergroove that matches the location that I'm calling on my PDP. What does that mean?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>The Default template will be loaded if the system is not able to find a match to what you're calling from the location=\"\" tag.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "I'm having trouble targeting certain sections of the offer using CSS. What are the current styling limitations of styling OG hosted offers?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>We've worked hard to encapsulate our offers to avoid styling or functionality collisions when we integrate with your site. You'll see that some parts of the offer exist within a #shadow-root element. At this time, our developers have not yet exposed some of those elements for modification. Some clients have made customizations to those elements by creating custom code from their side and adding it to their site files outside of Ordergroove.</p>"
        }
      }
    ]
  }
  </script>
  `}
</HTMLBlock>

## Advanced Modifications to Offers

### Radio button/checkbox reset

It is possible to customize the radio buttons/checkboxes themselves but requires some added HTML before we can style. Putting a `<button>` element within the components will allow us to apply styling to that.

#### HTML

```html
<og-optout-button>
   <button slot="default" role="radio" type="radio"  class="og-optout-btn">One-time purchase</button>
</og-optout-button>


<og-optin-button>
   <button slot="default" role="radio" type="radio" class="og-optin-btn">
   Subscribe to this product
   </button>
</og-optin-button>
```

#### CSS

```css
/* Subscribe & Deliver One time button */
.og-optout-btn, .og-optin-btn{
   background: transparent;
   position: relative;
   display: inline-block;
   font-family: inherit;
   border: none;
   cursor: pointer;
}
/*resets & styles radio buttons*/
.og-optout-btn::before, .og-optin-btn::before{
   content: " ";
   -webkit-appearance: none;
   -moz-appearance: none ;
   appearance: none;
   display: inline-block;
   position: absolute ;
   top: 0 ;
   left: 0 ;
   height: 16px;
   width: 16px;
   border-radius: 50% ;
   cursor: pointer ;
   outline: none ;
}
/* Radio button selected*/
.og-optout-btn::before, og-optin-button[subscribed] > .og-optin-btn::before{
   border: 1px solid black;
   box-shadow: inset 0 0 0 2px transparent, inset 0 0 0 12px blue;
   -webkit-box-shadow: inset 0 0 0 2px transparent, inset 0 0 0 12px blue;
   -moz-box-shadow: inset 0 0 0 2px transparent, inset 0 0 0 12px blue;
}
/* Radio button not selected */
og-optout-button[subscribed] > .og-optout-btn::before, .og-optin-btn::before{
   border: 1px solid #000;
   box-shadow: inset 0 0 0 12px white;
   -webkit-box-shadow: inset 0 0 0 12px white;
   -moz-box-shadow: inset 0 0 0 12px white;
}
```

### Frequency drop down toggle

To hide/show the frequency selector based on whether a customer has opted into a subscription or not also requires some reconfiguration of the HTML so that the frequency selector is an adjacent sibling of the Opt-In component.

<Image align="center" src="https://files.readme.io/09559478d6187260bb84f948bd4508f1e249899c60712fb59c4a7a6674f7b32b-image1.png" />

<Image align="center" src="https://files.readme.io/7a7c468ebce2b544be571d4149043bd1616d030b381ec3d71618ead4cab4ed46-image2.png" />

#### HTML

```html
<og-when test="regularEligible" class="og-offer"><!-- PDP Offer -->
   <div class="og-default-row">
     <og-optout-button>
         <button slot="default" role="radio" type="radio"  class="og-optout-btn">One-time purchase</button>
     </og-optout-button>
   </div>
  
   <div class="og-optin-row"><!-- og-subscription-row -->
     <div>
       <og-optin-button>
           <button slot="default" role="radio" type="radio" class="og-optin-btn">
           Subscribe to this product
           </button>
       </og-optin-button>
       <div class="og-frequency-row">
           <p class="og-shipping">ship every
               <og-select-frequency>
                   <option value="1_2">1 WEEK</option>
                   <option value="2_2" selected>2 WEEKS</option>
               </og-select-frequency>
           </p>
       </div>
     </div>
    
     <og-tooltip placement="top">
       <span slot="trigger" class="og-tooltip"><span class="og-tooltip-inner">?</span></span>
       <p slot="content" class="og-tooltip-content">
         This is our tooltip, to learn more, visit our <a href="#">FAQ page</a>.
       </p>
     </og-tooltip>
   </div><!-- og-subscription-row -->
</og-when> <!-- PDP Offer -->
```

#### CSS

```css
/* toggles the frequency to hide/show based on radio button */
og-optin-button[subscribed] + .og-frequency-row{
   display: initial;
}
og-optin-button + .og-frequency-row{
   display: none;
}
```

***

## Frequently Asked Questions

### How do I know which template is being used on my site?

Our system will seek to find the offer template that matches what is being called on the site from within the location tag contained inside the `og-offer` snippet.

```
<og-offer product="44358808797284" location="pdp" os-version="2" subscribed="" frequency="4287332452">
```

<Image align="center" width="85% " src="https://files.readme.io/42e049a78c150948bf6a256611a0862584e796b02fd9df6a860d50b0ef460068-image5.png" />

If no location is specified the system will load the Default template.

<br />

***

### How can I see what location, if any, is tagged on my page?

The fastest way to determine the location tagging of an offer is to inspect the page. Highlight a section of the offer and right-click, select **Inspect**.

<HTMLBlock>
  {`
  <div style="padding:64.35% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/1051287115?h=a072b28ea8&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media" style="position:absolute;top:0;left:0;width:100%;height:100%;" title="How to inspect my offers location"></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>
  `}
</HTMLBlock>

***

### I have a lot of templates and some are even named the same. How do I know which is being used on my site?

Our system will search for templates from Oldest to Newest created. From the Templates section this will basically be Left to Right, Top to Bottom.

<Image align="center" width="85% " src="https://files.readme.io/ad82807bd5400b8033d4e7d80ea4a6c68e072fbb272ec169784ed727900df185-image3.png" />

So in this example, there are 2 identical templates named new-pdp. The site will serve up the template in the top right corner of this screenshot because it is the older of the two and will be found first by our system.

<br />

***

### I don’t see a location specified on my PDP. What does that mean?

In these instances the Default template will be loaded by the system.

<br />

***

### I don’t have a template stored in Ordergroove that matches the location that I’m calling on my PDP. What does that mean?

The Default template will be loaded if the system is not able to find a match to what you’re calling from the location=”” tag.

<br />

***

### I’m having trouble targeting certain sections of the offer using CSS. What are the current styling limitations of styling OG hosted offers?

We’ve worked hard to encapsulate our offers to avoid styling or functionality collisions when we integrate with your site. You’ll see that some parts of the offer exist within a #shadow-root element.

<Image align="center" width="85% " src="https://files.readme.io/7a671ad8c56a93aaf0474d2fc6a367eecacdebccd6ea221a0bf84946cea036b1-image4.png" />

At this time our developers have not yet exposed some of those elements for modification. We have had clients make customizations to those elements by creating custom code from their side and adding it to their site files outside of Ordergroove.