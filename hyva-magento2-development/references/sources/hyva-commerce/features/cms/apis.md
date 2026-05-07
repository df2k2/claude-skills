<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/apis.html -->

# Hyvä CMS APIs

Hyvä CMS exposes a **REST API** and a **GraphQL API** for working with CMS content (available since v1.1.0). This page summarizes the APIs and where to find the full documentation.

## Hyvä CMS REST API: Full CRUD (Admin-Token Authorization)

The **Hyvä CMS REST API** gives you full create, read, update, and delete (CRUD) access to Hyvä CMS data. You can only access the REST API when authorized with an admin token.

- **Authorization**: You must be authorized with an admin token before calling the REST API.
- **Full reference**: The complete REST API documentation is available in **Swagger**. Add `/swagger` to your Magento base URL (for example, `https://your-store.com/swagger`) to view and try the endpoints. Adobe Commerce also documents how to [generate a local REST reference](https://developer.adobe.com/commerce/webapi/rest/quick-reference/generate-local/).

[![

Your browser does not support the video tag.
](videos/accessing-REST-docs-poster.jpg)](videos/accessing-REST-docs.mp4)

- **Typical use**: Use the Hyvä CMS REST API when building features such as moving content between environments, integrations etc.

Developer mode required

You must be in **Magento developer mode** to access the REST API Swagger documentation at `/swagger`. In production or default mode, the Swagger UI is not available.

## Hyvä CMS GraphQL API: Fetching Published Frontend Content

The **Hyvä CMS GraphQL API** is mainly for **fetching** published Hyvä CMS content for the frontend. It is intended for building frontend features that need that content.

- **Access**: The GraphQL API is public; no authentication is required.
- **Data**: Not all internal data is exposed. Responses are **sanitized** before being sent to the frontend. Sensitive identifier fields and draft content are not included in the response.
- **Queries**: Use the available GraphQL queries (for example, `hyvaCmsPage`, `hyvaCmsBlock`, `hyvaCmsBlocks`) to retrieve published Hyvä CMS content, rendered HTML, and Tailwind CSS.
- **Full reference**: Magento provides GraphQL documentation (schema explorer and docs) in your Magento instance. For an overview of how to access the GraphQL endpoint and explore the schema (for example, with the Altair GraphQL Client or Browser extension), see Adobe Commerce's [GraphQL overview](https://developer.adobe.com/commerce/webapi/graphql/).

[![

Your browser does not support the video tag.
](videos/accessing-graphQL-docs-poster.jpg)](videos/accessing-graphQL-docs.mp4)

- **Typical use**: Use the Hyvä CMS GraphQL API for frontend apps and storefronts that need published Hyvä CMS content and rendered HTML or Tailwind CSS.
