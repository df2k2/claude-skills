# SFTP File Drops

This guide provides step-by-step instructions for syncing Ordergroove data using scheduled daily export files delivered via SFTP. For detailed information about the structure and contents of each file, refer to our [Scheduled Daily Data Exports](https://help.ordergroove.com/hc/en-us/articles/360051610413-Scheduled-Daily-Data-Exports) documentation.

***

## Overview of Exported Data

The exported data consists of multiple flat files delivered to a designated SFTP location. These files include full data snapshots and delta files containing incremental changes.

### File Types

* **Delta Files**: Contain the records that have been added, updated, or deleted since the last export.
* **Full Export Files**: Contain the complete dataset as of the export time.
  * Used to create a historical backfill for a merchant
  * Available via support request when setting up an SFTP integration for the first time
  * Also available under special circumstances to rematch systems if significant drift occurs

### File Naming Conventions

Files follow a structured naming convention for easy identification:

`<merchant_name><report_name>__<full|delta><DDMMYYYYHHMMSS>.csv`

The datetime in the filename represents when the report was completed and placed on the SFTP server in Central Standard Time (CST).

***

## SFTP File Retrieval

### Connecting to the SFTP Server

Merchants should use their provided credentials to access the SFTP server via an SFTP client or automation script. Example using sftp command-line tool:

`sftp <user>@feeds.ordergroove.com`

Retrieve files using:

`get /outgoing/merchant_orders_20250317_delta.csv`

***

## Processing the Exported Data

### Parsing the CSV Files

Each file follows a structured CSV format with a header row. For example:

order\_id,customer\_id,order\_item\_id,subscription\_id,product\_id,quantity\
12345,67890,98765,54321,1001,1,15.00

Recommended parsing libraries:

* Python: `pandas, csv`
* Java: `OpenCSV`
* SQL: `COPY FROM`

### Delta File Contents

Delta files contain information from the previous business day (based on CST). For example, the Subscription Report will contain current information for all subscriptions that were updated at any point during the previous day.

### Handling Delta Files

Delta files contain changes, and merchants should implement an upsert strategy to integrate them efficiently.

#### Upserting Data into Merchant Database

To upsert (insert new records or update existing ones):

1. Identify the primary key of the record
2. Insert new records if the primary key does not exist
3. Update existing records if the primary key matches

### Handling Specific Reports

#### Order Report

* Returns information on all orders that were placed the previous day.
* Each row represents an **Order Item**, not a full order.
* An **Order** can contain multiple **Order Items**.
* **Order Items** are linked to Subscriptions and Products.
* **Order Items** can move between orders or be removed entirely.
* Primary Key: `Order Item ID`
* Relevant Fields: `Order Status, Place Date, Merchant Product ID, Quantity, Price`

#### Subscription Report

* Tracks all updates to subscriptions that were made the previous day.
* Primary Key: `Subscription ID`
* Relevant Fields: `Subscription Status, Start Date, Cancel Date`
* **Note**: Canceled subscriptions will appear in the daily subscription delta files, as a subscription cancellation counts as an update to the subscription. There is no need to separately process the Subscription Cancellation Report.

### Error Handling

* Log failed records for reprocessing
* Validate data types before insertion
* Use transactions to ensure atomicity

***

## Automating the Process

* Schedule SFTP downloads using `cron` (Linux) or Task Scheduler (Windows).
* Automate ingestion with Python scripts or ETL tools.
* Monitor and alert for missing or malformed files.

***

## Additional Assistance

By following this guide, merchants can automate the synchronization of Ordergroove data using SFTP flat file exports, ensuring accurate and efficient data integration. For additional help, please reach out to your CSM or [contact support](https://help.ordergroove.com/hc/en-us/requests/new).