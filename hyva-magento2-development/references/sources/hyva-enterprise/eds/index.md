<!-- source: https://docs.hyva.io/hyva-enterprise/eds/index.html -->

# Edge Delivery Services (EDS)

## Overview

Hyvä Enterprise can be integrated with Adobe Edge Delivery Services (commonly referred to as EDS) so both are used side-by-side.

The architectural concept is to manage content pages through EDS, and commerce pages through Adobe Enterprise running Hyvä Enterprise.
Common elements can be shared, for example, the main navigation or the footer.

Additionally, content blocks created in AEM, such as rich product descriptions, can be displayed on specific Hyvä Enterprise pages.

Content originating from Adobe Commerce such as items in the shopping cart are also available on EDS pages.

A proof of concept tech demo can be found at [eds-demo.hyva.io](https://eds-demo.hyva.io).

The following high-level diagram illustrates the setup.

[![hyva_edge_diagram.webp](img/hyva_edge_diagram.webp)](img/hyva_edge_diagram.webp)

## How can it be implemented?

Hyvä EDS needs to be implemented for each project. It is not a simple installation, but rather a customized implementation adjusted for the project's requirements.
Hyvä Enterprise license holders can request access to the proof-of-concept code, to follow the same approaches.

## Technical approaches used for eds-demo.hyva.io

The demo implementation aims to reduce development time by sharing different aspects of the tech stack.

### Shared tailwindcss styles

Both EDS pages and Adobe Commerce pages share tailwindcss-based styles.

This approach maintains a consistent visitor experience in addition to reducing development time. Tailwindcss being an industry standard allows quick onboarding of developers.

### Main menu and footer

For consistency, the main menu and the footer links are maintained in AEM and shown on both the EDS pages and the Adobe Commerce pages.

### Mini Cart

The mini-cart included on EDS pages uses the same data from the browser local-storage used by Hyvä. This keeps the user experience consistent. It has the added benefit of being fast because it can be rendered without any additional API calls.

The same approach can also be used to add more customer session-specific user interface components to EDS pages.

### Embedding AEM Content on Adobe Commerce Pages

Any EDS content can be embedded on Adobe Commerce pages as needed.
This is possible using a PHP view model or a CMS widget. A PageBuilder content-type proof of concept was developed, too, but it is not used in this demo.
One use case for embedding AEM content in Adobe Commerce pages could be to provide additional product descriptions maintained in Google Docs or Microsoft Word via AEM / EDS.

In the demo, only the main menu and the footer on Adobe pages are examples of embedded content.

### Rendering Products on EDS pages

If needed, product carousels from Hyvä could also be embedded as EDS blocks on pages maintained in AEM.
This would require including Alpine.js on EDS pages so product swatches are functional without re-implementing them with vanilla JavaScript.
