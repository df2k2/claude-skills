# Adding a Scrollbar to Inactive Subscriptions in the Subscription Manager

Learn how to add a scrollbar to the Inactive Subscriptions section in Subscription Manager v0 to prevent page scrolling and create a more compact view.

Your subscribers can view and reactivate their inactive subscriptions within the Inactive Subscriptions section of the Subscription Manager.

Depending on the customer and the number of inactive subscriptions, this list can be quite long and lead to page scrolling. To prevent this, a scrollbar can be added to the Inactive Subscriptions section to make it more compact and to eliminate the page scrolling.

## Requirements

This article only pertains to v0 versions of the Subscription Manager (versions starting with 0.x). Subscription Manager versions 25.x already have the scrollbar out of the box with no action needed!

### How to tell what version you're on

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/0f5a3126136d00f63aed46b389aba7f3ac6835182c6447149a5bdd11d941341e-image2.png" />

***

## Accessing the Advanced Editor

We'll be using the advanced editor to modify the Subscription Manager. You can access it through your Ordergroove Admin:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to **Subscriptions** on the top toolbar, and select **Subscriptions Manager**
3. Toggle **Advanced** on the top left.

> 🚧 Support
>
> Some aspects of this article require technical expertise with coding languages. This is self-serve and outside of the normal support policy.

***

## Adding the Scrollbar

Open up: **/views/inactive-subscriptions.liquid**.

Locate the following lines 2-7:

```liquid
<section id="og-inactive-subscriptions">
{% for subscription in subscriptions | reject('live') %}
{% if index === 0 %}
<h1 class="og-title">{{ 'subscriptions_inactive_header' | t }}</h1>
{% endif %}
<div class="og-inactive-subscription">
```

And replace them with this:

```liquid
<section id="og-inactive-subscriptions">
{% for subscription in subscriptions | reject('live') %}
{% if index === 0 %}
<h1 class="og-title">{{ 'subscriptions_inactive_header' | t }}</h1>
{% endif %}
{% endfor %}
<div class="og-inactive-wrapper">
{% for subscription in subscriptions | reject('live') %}
<div class="og-inactive-subscription">
```

At the end of the file you will need to add a closing `</div>` tag above the closing `</section>` tag.

```liquid
</div>
</div>
</section>
```

Go to Styles section and click + ADD STYLE and add a file called **wrapper.less**.

<Image align="center" width="500px" src="https://files.readme.io/0123952-014a4961-bdeb-4596-8b3d-9f50b49dc4a1.png" />

Inside the new wrapper file, add the following code:

```css
.og-inactive-wrapper{
overflow-y: scroll;
height: 250px;
}

@media (max-width: 430px) {
.og-inactive-wrapper{ 
height: 150px;
}
}
```

**Note**: The height may need to be increased or decreased to achieve desired effect.

Stay within the Styles section, and go into **main.less**. Add the following code.

```css
@import './wrapper.less';
```

The results should look something like this:

<Image align="center" src="https://files.readme.io/1d2d82e-Screen_Shot_2023-07-10_at_12.46.36.png" />