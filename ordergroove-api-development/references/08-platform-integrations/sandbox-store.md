# Setting up a Sandbox Store

In this guide we'll set up a Developer Sandbox store on Shopify. We'll set up a developer Shopify store, install Ordergroove, and run through the subscription lifecycle by creating a customer, subscription, and order.

***

## Watch a Video

The following video covers everything in this article:

<HTMLBlock>
  {`
  <div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/1167508370?h=d379030d28&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share" referrerpolicy="strict-origin-when-cross-origin" style="position:absolute;top:0;left:0;width:100%;height:100%;" title="Developer Sandbox Store"></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>
  `}
</HTMLBlock>

Timestamps:

1. Create a Shopify Dev Store - 00:27
2. Install Ordergroove - 02:08
3. Create a new Customer, Subscription, and Order - 07:14

***

## 1. Create a Shopify Dev Store

First up we need a new Shopify Developer Store:

1. Open up the <Anchor label="Shopify dev dashboard" target="_blank" href="https://dev.shopify.com">Shopify dev dashboard</Anchor>
2. Click ***Add dev store***
3. Give your new store a ***Name***
4. Select ***Plus*** for Shopify Plan
5. Check ***Generate test data for store***
6. Click ***Create Store***

With the new store created, go to Products and double check that the test products have loaded in. It just takes a few seconds, so if you don't see any products yet refresh the page.

<Image align="center" src="https://files.readme.io/c7ea8e56877846233efa007c471f78eb4c6fb4b546de9e036cca62349b90d7b7-Shopify_Test_Products.png" />

<br />

### Change the Store Theme

When you create a store with test data, Shopify creates a new ***test data*** theme. We want the original ***Horizon*** theme, so let's change it back:

1. Back in Shopify, click ***Online Store***
2. The Current Theme will be test-data. ***Scroll down*** and locate Horizon.
3. Click ***Publish*** next to Horizon, and ***Publish*** again on the pop-up.
4. This will change the Current Theme to ***Horizon***.

<Image align="center" src="https://files.readme.io/19d7e10f6d4375d9ad1499e4ec58461f93965e3d33aa26e673722a2179980793-Shopify_Theme.png" />

***

## 2. Install Ordergroove

With the Shopify store setup, let's add Ordergroove:

1. Click ***Apps*** on the bottom left. Type in ***Ordergroove***, and ***Search*** in the Shopify App Store.
2. Locate *Ordergroove*, and click ***Install***.

   <Image align="center" src="https://files.readme.io/28bf2b432bff29dace09be251cb27965b15d0d70cb56b5189d23e57e6379aabd-Ordergroove_App_Listing.png" />
3. Shopify will take you to a details page, click ***Install*** again.
4. You'll be redirected to a shortened Ordergroove on-boarding experience. Select ***I'm a dev looking to explore Ordergroove***, and fill out your First Name, Last Name, and Email.
5. When you ***Submit*** the form, it'll ping Ordergroove. You'll need a unique code, please reach out to your Ordergroove Contact.
6. With code in hand, click ***Enter your unique code***, ***paste*** it in, and click ***Submit***.
7. Once Ordergroove loads, click ***Get Started***.
8. Select a few in-stock Shopify sample products to make subscription eligible. We'll need at least one to go through checkout in a minute. Click ***Next*** when you're finished.
9. Ordergroove will explain what a subscription offer is, click ***Next*** to pass through.
10. On the App Embed page, click ***Configure***. It'll open a new tab redirecting you back to your Shopify Store. Make sure Ordergroove Offers Embed is checked on. Then hit ***Save*** and close the tab.

    <Image align="center" width="400px" src="https://files.readme.io/8483434caced6c9b513fee003d4431fac6bbae393d352bca738984a952daef7a-Offers_Embed.png" />
11. Back in Ordergroove, click Next to go to the Customize page. Click ***Customize***. This will take you back to Shopify. Under *Template > Product Information*, click and drag ***Ordergroove Offer*** beneath ***Price***. Click ***Save*** and close the tab.

    <Image align="center" width="350px" src="https://files.readme.io/0a72a27c4130343ae4049103a1fc08d03501875ffcdd105ff78bfe8199f5a9b5-Ordergroove_Offer_Page.png" />
12. Back in Ordergroove, click ***Next***, and ***Go Live***.

### Additional Steps for Sandbox Environments

This wraps up on-boarding for standard merchants. But for a complete sandbox experience we still need to verify data and add a test payment gateway.

Before we head back to Shopify, first let's make sure Ordergroove has all of the sample Shopify products available. In <Anchor label="Ordergroove" target="_blank" href="https://rc3.ordergroove.com/">Ordergroove</Anchor>, go to Data > Products. You should see the list of Shopify sample products. If you don't see any products yet, give it 5-10 minutes and refresh the page. The speed can vary depending on how fast Shopify responds to us.

Here's what it should look like:

<Image align="center" src="https://files.readme.io/9e32ce4af558e66f4f2d19253088b9d4fefdde02acb8d7c5cd9b67d4235bbd9c-Products_Loaded.png" />

### Set up Shopify Payments

Last but not least is Shopify Payments:

1. Open up your new Shopify Developer Store.
2. Go to ***Settings > Payments***.
3. Shopify enables a Bogus Gateway by default. This gateway can't place orders, so let's change that. Click ***Switch to Shopify Payments***, and fill out the form.
   1. **Note**: You do ***NOT*** need to fill in your actual social security number for a test gateway. Shopify requires the number to be in the proper format XXX-XX-XXXX, such as 111-22-3344, but not your actual number. Do not use any personal information for any of these fields. This is safe and expected for a test environment, not for production.
4. Once you submit the form, refresh the page and make sure Test Mode is on. You should see:

   <Image align="center" src="https://files.readme.io/82536d1b2fa18597abfb70a02f111b361dcda06d73e18ebfb37b6d0b4b4b145e-Shopify_Test_Mode.png" />
5. Click ***Activate***.

At this point all of the backend settings are correct. You're ready to put in a test customer and run through checkout.

***

## 3. Test Customer, Subscription, Order

With Shopify and Ordergroove properly set up, we're ready to run through checkout - the end user customer experience. Let's give it a shot:

1. Open up the Shopify admin, and next to Online Store, ***click the Eye***. This will open a new tab, and show you the sample storefront.
2. Click on the ***Account*** icon on the top right. This will create a customer, enter an email you have access to. Shopify will send you a verification code, we'll need it in the next step.

   <Image align="center" src="https://files.readme.io/064a77aeecbc1fc2e0299e46798f67157f14d62bf7e88c6c545bd9d3593d9bcb-Account_Icon.png" />
3. Once you have the code, paste it in and click ***Submit***.
4. Locate one of the test products you marked as subscription eligible, and click on it to ***open up the PDP***.
5. On the product page, select ***Subscribe to save***, and add the product to cart.

<Callout icon="❗️" theme="error">
  If the Subscription widget isn't displaying, reset the product in Ordergroove:

  1. Open up <Anchor label="Ordergroove" target="_blank" href="https://rc3.ordergroove.com/">Ordergroove</Anchor> and go to Data > Products
  2. Locate the product you want to test, and click on the ***Product Name***.
  3. ***Subscription Eligible*** should be toggled on, toggle it off. Give it a few seconds, then toggle it back on.
  4. Click ***View on your site*** at the top of the page to be redirected back to Shopify. The product page should have the Ordergroove widget with ***Subscribe to Save***.
</Callout>

6. The product will be added as a subscription to the cart, you should see the discount in cart. Click **Check out**.
7. Go through checkout. Use fake information for the customer. And when you get to the credit card, use the mock card number 4242 4242 4242 4242. This is Shopify payments default success card.
8. When you're finished, click ***Pay Now*** to complete the order. This will create the Customer, Subscription, and Order for you to view.

### View the test Customer, Subscription, and Order

When you go through checkout, Ordergroove creates the customer and attaches subscription(s) to them and their orders. We can view and modify them in Ordergroove:

1. Open up <Anchor label="Ordergroove" target="_blank" href="https://rc3.ordergroove.com/">Ordergroove</Anchor>, and go to ***Data > Customers***.
2. Search for the test customer you created, and click on their name.
3. This opens up the Customer Service view, the CSA. You can view customer Orders and Subscriptions here. Let's send an order for placement now to see what that looks like.
4. Next to Orders, click ***View All*** and click on the upcoming order.
5. Ordergroove will display the Order Details, and you'll see a few options including Send Now. Click Send Now to send the order to Shopify for placement.

   <Image align="center" width="500px" src="https://files.readme.io/f75ff8c79d8c59c8e7c0c88fd13ca1159f7168d7aae6d8e026b532a665407069-send_now_screenshot.png" />
6. Ordergroove will send the order for placement, and queue up the next Order:

   <Image align="center" width="500px" src="https://files.readme.io/094fcaafca025b6d9eb9c28388dce163f8700fe5734452b071a9743943463a4e-Order_Successful.png" />
7. You can also view this order in the placement logs. Go to Data > Order Logs to see the successful order placement.

You can also see the subscription contract on the customer in Shopify:

1. Open up the Shopify Admin.
2. Click on ***Customers***, and open up the ***test customer*** from earlier.
3. The test customer will have the order we sent for placement, and a Subscription tied to their account.
4. Click on the ***subscription product*** and scroll down. You can find the subscription contract in the ***Purchase Options*** section.

   <Image align="center" src="https://files.readme.io/134e2c9503c80fce51cf5e0eb787d7d47574913336cec9ea03d3dc21fec920b1-Purchase_Options.png" />

<br />