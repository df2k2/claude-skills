# Legacy Subscription Manager v0 Components & Containers

This article is an overview of the liquid file structure of the Subscription Manager and where components and containers can be modified or restyled. We discuss the high-level overview of the Subscription Manager that can be seen Out of the box (OOTB.)

***

## Subscription Manager Wrapper

<HTMLBlock>
  {`
  <p>
    The entire Subscription Manager is wrapped in a Container and can be found in:
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #FF2600;"></span>
    <strong>Views &gt; main.liquid</strong>
  </p>
  <p>Within this container, there are three distinct sections.</p>
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #000000;"></span>
    <strong>Order Processing</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #669C35;"></span>
    <strong>Upcoming Orders</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #5E30EB;"></span>
    <strong>Inactive Subscriptions</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/00f63db-SMI_1.png" />

***

## Orders Processing

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #000000;"></span>
    <strong>Views &gt; orders-processing.liquid</strong>
  </p>
  <p>
    This section appears when a customer's order is being processed.&nbsp;
  </p>
  `}
</HTMLBlock>

Order Processing Section - More Details

<Image align="center" src="https://files.readme.io/af129f0-Screen_Shot_2023-06-16_at_14.53.00.png" />

***

## Upcoming Orders Section

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #669C35;"></span>
    <strong>Views &gt; orders-unsent.liquid</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #00C7FC;"></span>
    <strong>Views &gt; order-unsent.liquid</strong>
  </p>
  <p>
    (depending on the specific version of your Subscription Manager, this could be
    found in orders-unsent.liquid)
  </p>
  <p>
    This section shows the upcoming orders for the customer.
  </p>
  `}
</HTMLBlock>

Unsent Order Section - More Details

<Image align="center" src="https://files.readme.io/fcd90f6-SMI_2.png" />

***

## Inactive Subscriptions

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #5E30EB;"></span>
    <strong>Views &gt; inactive-subscriptions.liquid</strong>
  </p>
  <p>
    This section contains all inactive subscriptions for a customer.
  </p>
  `}
</HTMLBlock>

Inactive Subscriptions Section - More Details

<Image align="center" src="https://files.readme.io/23a5237-Screen_Shot_2023-06-16_at_14.04.21.png" />