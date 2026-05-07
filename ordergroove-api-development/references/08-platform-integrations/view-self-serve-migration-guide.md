# Self-serve migration guide

Migrating your subscription program over to Ordergroove can be done using Ordergroove’s migration tool.

> 📘 New Tool Available
>
> This guide takes you through a migration with the Legacy Tool. We have a New Migration Tool available with a validation tool built into the process, so there’s no need to run a test migration. [Migrating your Data with the New Migration Tool](https://help.ordergroove.com/hc/en-us/articles/42087029479827) has more information.

***

## Overview

The migration process is broken up into three high-level steps:

1. Preparation - you’ll be getting your migration ready
2. Test migration - you’ll be doing a test migration to ensure your preparations were set up correctly
3. Final migration - you’ll be officially moving over all of your active subscriber data over

> 👍 Timeframes
>
> The timeframes provided are a general estimate, and should not be taken at face value. There are a number of factors that could affect your program launch such as the number of customers to migrate and the size of your migration file.

This guide is meant to help you get through migration in the “happy path scenario” where everything is working as it should. When things are configured correctly, the process can take a few hours with more than 70% of your data importing successfully. In the event you experience errors or some data not successfully migrating, don’t worry, we are here to help. For any questions regarding errors, data issues, or anything else, [open a ticket](https://help.ordergroove.com/hc/en-us/requests/new) and someone from the Ordergroove migrations team will help you.

***

## Preparations

To get your migration started, you’ll need to complete a few steps to prepare for it. You’ll need to:

1. Create a test customer/subscription
2. Confirm your checkout requirements
3. Learn how to build an Ordergroove migration file

### 1. Create a test customer/subscription

*Takes about 5 to 10 minutes to complete*

A test customer/subscription is a subscription in your subscription program associated with you or one of your employees. **Create a customer in your program using your (or another employee’s) information.**

This creates a litmus test of the migration from beginning to end:

1. Extract data from your subscription program
2. Import the test customer/subscription into Ordergroove
3. Place an order through Ordergroove into your Ecomm system
4. Confirm payment processed correctly

If you’d like to create more than one to test, feel free to do so. Make sure to keep the email address for each handy as you will need to reference them later.

### 2. Confirm your checkout requirements

*Takes about 5 minutes to complete*

Let your solutions contact know which fields should be required for payment, customer, billing address and shipping address. **This will need to match the data you're importing**, based on your Ecomm data requirements for checkout.

### 3. Learn how to build an Ordergroove migration file

*Takes more than 1 hour to complete*

At this point you're ready to take on one of the most important steps of the migration: extracting the data from your current subscription program and transforming it into the Ordergroove migration file structure. You can find all the information you need about the file and object structures in the [Knowledge Center](https://help.ordergroove.com/hc/en-us/articles/6351678016403).

While this section is deceptively short, this can take quite a bit of time. One recommendation would be to start small and generate a file with a single customer. You can then use our tools in the Testing data integrity step of the **Test Migration** section below to see how your coming along.

***

## Test Migration

Now that the preparations are complete, you will want to do a test run of the migration. The time this takes depends on the size of data you are migrating over. A more established subscription program means more data therefore means longer migration times. This can range from a few minutes to several hours. But, keep in mind, this is a one time thing you will have to do.

A test migration requires the following:

1. Build the data set
2. Testing the data integrity
3. Resolve errors

By doing a test migration, you will also get familiar with the migration tool and how it works so when the time comes for the final migration, you will fly through it.

### 1. Build the data set

*Takes 10 minutes to more than an 1 hour to complete, depending on data size*

You'll more than likely have set up some automation in order to build the migration file after having tested a handful of records. You'll now want to pull all of your subscription program for a test run of the migration and see how the data integrity holds up.

The time it takes to extract your data and build the migration file depends solely on the size of your subscription program.

### 2. Testing the data integrity

*Takes 10 minutes to an 1 hour to complete, depending on data size*

Now that we've downloaded and transformed the data, it's time to test the data integrity.

1. Go back to the [Migrations](https://rc3.ordergroove.com/tools/program_migrations/) page in Ordergroove.
2. Make sure you’re on the “Test Run” tab

<Image align="center" src="https://files.readme.io/463e9d0-mceclip0.png" />

3. Click on the Upload button and select the “transform” file from the previous step.

A new row will appear in the table below indicating that the Test Run process has begun

<Image align="center" src="https://files.readme.io/761e5a8-mceclip4.png" />

Periodically check back on this page. We’re waiting for the Processing Status column to move from “In Progress…” to “Completed” at which point you can download Unprocessed, Errors, and Successful files.

If you run into any issues here, please [open a ticket](https://help.ordergroove.com/hc/en-us/requests/new) with us.

### 3. Resolve Errors

*Takes 10 minutes to more than 1 hour to complete, depending on data size*

You’ll know the data integrity checks have completed when the row containing "Processing Status" column shows **Completed** for the file you uploaded

<Image align="center" src="https://files.readme.io/d04a270-blobid3.png" />

If instead you see the status as **Cancelled**, you'll want to retry uploading and testing your file.

<Image align="center" src="https://files.readme.io/f1da3c9-blobid4.png" />

You’ll notice that we have three columns:

* **Successful** - a file consisting of all the customers and their respective subscription information that passed initial validations. This file would represent something you could attempt to import in the “Migration” tab - but we’re not ready for that yet
* **Errors** - this file is similar in structure to the “Successful” file except we found some data integrity issues that you’ll need to resolve.
* **Unprocessed** - this file is more for debugging purposes. This represents data that we simply could not put together or understand. Some examples: there are subscriptions referencing a customer that does not exist in the migration file, invalid JSON, etc.

Error remediation can be by and large the most time consuming (and frustrating) part of a migration process. This is why we’re in a preparatory phase - if you get ahead of it now, you won’t feel bad taking a break and coming back to it later.

Here are some resources that we think should be helpful to get you going

* You can get a better understanding of the types of errors you might encounter in the error file in the Errors section in the [Knowledge Center](https://help.ordergroove.com/hc/en-us/articles/6351678016403).
* If you’re feeling more adventurous, we have a script/utility you can use to parse the error file and provide more of a summarized view of the file. It takes the file and focuses on the errors, showing the errors that manifested for each specific customer.

At the end of the day, you’ll have to look in that file to determine which customers are having which problem.

Because we're still in the preparation stages, you’ll want to make any data modifications in your subscription provider or Ecomm platform. After you’ve done so, feel free to go back to step 2 and repeat the subsequent steps until you feel comfortable with the data extraction, transformation, and validation.

***

## Migration Day

At this point, you should already have your program with Ordergroove live.

Now that we've done some practice runs, we should be ready for the real migration. This requires the following:

1. Generating and validating the data
2. Setting up the test customer file
3. Importing the test customer/subscription
4. Placing a test order
5. Validating payment processing
6. Importing the full data set
7. Resolving any errors

### 1. Generating and validating the data

*Takes 10 minutes to more than an 1 hour to complete, depending on data size*

Please refer to step 1 and step 2 in the Test Migration section above for details of how to test the migration file you've built.

### 2. Setting up the test customer file

*Takes about 10 minutes*

In the “success” file, you’ll need to locate the test customer

1. Open the success file
2. Do a search for the email address of the test customer
3. Cut the entire contents of the row corresponding to the test customer
4. Open a new file
5. Paste the data of the test customer into a new file
6. Make sure you don’t leave a blank line in the success file

You’ll want to give the file containing the test customer a representative name, for example: *test\_customer\_for\_og\_migration.json*

If the test customer is in the error file, you can extract it just the same as above, but because there were errors, you’ll need to make some modifications to the data.

### 3. Importing the test customer/subscription

*Takes about 10 minutes to complete*

1. Click on the **Migration** tab on the [Migrations](https://rc3.ordergroove.com/tools/program_migrations/) page in Ordergroove

<Image align="center" src="https://files.readme.io/a00f289-mceclip1.png" />

2. Use the “Upload” button to select the test customer file we created in the previous step.

> ❗️ Warning
>
> **Be extra careful and make sure you pick the correct file.** If you feel you accidentally uploaded the wrong file (aka - the full data set), please reach out to us immediately so we can get in front of halting the process sooner rather than later. There is currently no way for you to stop this process once it begins.

3. A new row will be added to the table and you’ll see that the file you provided will be listed as “In Progress…”

<Image align="center" src="https://files.readme.io/4632952-mceclip4.png" />

When the process is over, download all three file types. If everything worked correctly, both the “Errors” and “Unprocessed” files should be empty and the “Successful” file should contain your test customer. If that’s the case please move on to the *Placing a test order* section below. Otherwise, please keep reading.

#### TEST CUSTOMER IMPORT ERROR

Sometimes, even after all the preparation, the test customer can still result in an error. Please feel free to remediate as you see fit and retry importing the test customer

1. Modify the error file
2. Save your modifications
3. Go back to the start of step 4, Importing the test customer/subscription
4. Be very careful to make sure you pick the correct file.

### 4. Placing a test order

*Takes about 15 to 20 minutes to complete*

Now that the test customer has been successfully imported, the most import question can be answered: *Can a customer be charged when an order is placed?*

To test this, you'll use some of Ordergroove's tools to facilitate and verify this.

1. Navigate to the customer search screen by selecting the “Customers” link under the “Data” section of the navbar

<Image align="center" src="https://files.readme.io/735875f-mceclip2.png" />

2. Search for the test customer's email address
3. Click on the customer row to be brought to a more detailed view. You should take a moment to verify that all the test customer information is as you expected
4. Click “View All” on the left side of the **Orders** section in this view

<Image align="center" src="https://files.readme.io/a924974-mceclip3.png" />

5. Click on the upcoming order of the test customer so it expands
6. Click the “Send Now” button on the top left
7. Click “Save”

<Image align="center" src="https://files.readme.io/538432c-mceclip4.png" />

At this point, we’ll want to wait for the Order Placement system to run. It will fetch the order and attempt to push it into your Ecomm system. Feel free to occasionally reload the page.\
After a little bit, you should see the order update. If you see it was in a “Success” state, move on to the next step, Validating payment processing. Otherwise, here are some notes to consider with respect to failed order placement.

#### If you see a Placement Failure

1. To find out why an order was not successfully placed, checkout our order placement section under the Data section of the navbar

<Image align="center" src="https://files.readme.io/3bdcfbb-mceclip5.png" />

2. In the "Filter" section, set the search filter to “Email”
3. In the “Value” section, provide the test customer email address.

You should see two rows, click on the “Response” button to gain insight as to why the order was rejected.

If the system had a timeout communicating with your Ecomm system, that’s OK. We’ll retry that again.

If there's some data issue, you can make the appropriate updates to the customer in our system. However, it is recommended you go through another test customer to ensure there's no systematic issue with how the data is migrating from your subscription provider to Ordergroove.

If our tools are not sufficient and you need to re-import the test customer, this will requires some help from us. We’ll need to move the test customer “out of the way” so to speak.

It’s worth nothing, this situation is exactly why the test customer is so valuable: it’s much easier to resolve one single customer than an entire program.

Worst case scenario, don't hesitate to [open a ticket](https://help.ordergroove.com/hc/en-us/requests/new) with us.

### 5. Validating payment processing

*Takes about 5 to 10 minutes to complete*

If the order is being reported as "Successful" in both Ordergroove and your Ecomm system, we can now verify that the card was indeed charged successfully.

1. Log in to your Ecomm system
2. Find the test customer
3. Find the order that was placed
4. Confirm the charge was successfully captured by your payment processor.

It may also be worth waiting for the charge to appear on the test customer’s credit card.

### 6. Importing the full data set

*Takes 10 minutes to more than 1 hour to complete, depending on data size*

1. Click on the **Migration** tab on the [Migrations](https://rc3.ordergroove.com/tools/program_migrations/) page in Ordergroove

<Image align="center" src="https://files.readme.io/3ef561b-mceclip1.png" />

2. Click the **Upload** button and select the Successful file downloaded from the previous step 1, Generating and validating the data.
3. A new row will appear in the table below indicating that the import process has begun.
4. Periodically check back on this page. We’re waiting for the Processing Status column to move from “In Progress…” to “Completed” at which point you can download Unprocessed, Errors, and Successful files.

If you’ve followed all of our steps, you should have been able to successfully import a good amount if not all of your data into the Ordergroove platform.

### 7. Resolving any errors

*Takes 10 minutes to more than 1 hour to complete, depending on data size*

Now comes the trickiest part of the migration process: error remediation. Because it’s migration day, any changes you make to remediate errors will have to be done **directly in the Errors file**.

> 🚧 Note
>
> You should always re-run the previous run's error file.

* Each row represents all the data of a customer
* If **ANY** data for the customer has an error, they will appear in this file

Let’s give extra attention to the last bullet: if a customer has multiple subscriptions and only one has an error, all of the good data will be imported. The error file includes all of this data as well as the error data. Take great care when modifying these files.

1. **Errors in Test Run tab\&#xA;**&#x49;f you have an Errors file in the “Test Run” tab, it is recommended to make updates to that file and then execute the “Test Run” tab again. This may produce another Errors file, but any data in the Successful file should be good to go in the “Migration” tab.
2. **Errors in the Migration tab**\
   If you have an Errors file from the “Migration” tab, you'll need to modify this file and retry importing it.

It’s up to you which one you prefer to tackle first and how much time you want to dedicate.

For your own peace of mind, we take many precautions to ensure the migration is an idempotent process, but you can help! Think of re-running errors like a relay race: the previous error file passes the baton to the next runner and so on and so forth until there are hopefully no errors left.

As before, here are some resources that we think should be helpful to get you going. You can get a better understand the types of errors you might encounter in the error file in the **Errors** section in this [KC article](https://help.ordergroove.com/hc/en-us/articles/31436032663699-Troubleshooting-migration-errors).

If you’re feeling more adventurous, we have a [script/utility](https://github.com/ordergroove/migration-utilities/tree/main/errors_summary) you can use to parse the error file and provide more of a summarized view of the file. It takes the file and focuses on the errors, showing the errors that manifested for each specific customer.