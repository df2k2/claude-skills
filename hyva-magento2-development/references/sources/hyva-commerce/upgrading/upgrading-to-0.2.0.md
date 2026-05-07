<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-0.2.0.html -->

# Upgrading to Hyvä Commerce 0.2.0

This is a maintenance release, mostly focused on bug fixes.

## Notable news

### Hyvä CMS

#### Backward incompatible changes

The Accordion component has been updated with a new structure. Upon upgrading, existing accordion components will display a warning in the editor and will not render until updated.

You have two options to fix this:

1. Manually remove and recreate each accordion component
2. Run the MySQL migration script below on your database

Please take a backup of your database before running the below query

SQL Query to update accordion components

```
-- Update draft_content in hyva_commerce_cms_block table
UPDATE hyva_commerce_cms_block
SET draft_content = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    draft_content,
                    'componentPath":"Hyva_CmsBase::elements\\/accordion.phtml"',
                    'componentPath":"Hyva_CmsBase::elements\\/accordion_item.phtml"'
                ),
                'componentPath":"Hyva_CmsBase::elements\\/accordion-list.phtml"',
                'componentPath":"Hyva_CmsBase::elements\\/accordion_list.phtml"'
            ),
            '"component":"accordion-list"', '"component":"accordion_list"'
        ),
        '"component":"accordion"', '"component":"accordion_item"'
    )
WHERE draft_content LIKE '%"component":"accordion%';

-- Update published_content in hyva_commerce_cms_block table
UPDATE hyva_commerce_cms_block
SET published_content = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    published_content,
                    'componentPath":"Hyva_CmsBase::elements\\/accordion.phtml"',
                    'componentPath":"Hyva_CmsBase::elements\\/accordion_item.phtml"'
                ),
                'componentPath":"Hyva_CmsBase::elements\\/accordion-list.phtml"',
                'componentPath":"Hyva_CmsBase::elements\\/accordion_list.phtml"'
            ),
            '"component":"accordion-list"', '"component":"accordion_list"'
        ),
        '"component":"accordion"', '"component":"accordion_item"'
    )
WHERE published_content LIKE '%"component":"accordion%';

-- Update draft_content in hyva_commerce_cms_page table
UPDATE hyva_commerce_cms_page
SET draft_content = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    draft_content,
                    'componentPath":"Hyva_CmsBase::elements\\/accordion.phtml"',
                    'componentPath":"Hyva_CmsBase::elements\\/accordion_item.phtml"'
                ),
                'componentPath":"Hyva_CmsBase::elements\\/accordion-list.phtml"',
                'componentPath":"Hyva_CmsBase::elements\\/accordion_list.phtml"'
            ),
            '"component":"accordion-list"', '"component":"accordion_list"'
        ),
        '"component":"accordion"', '"component":"accordion_item"'
    )
WHERE draft_content LIKE '%"component":"accordion%';

-- Update published_content in hyva_commerce_cms_page table
UPDATE hyva_commerce_cms_page
SET published_content = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    published_content,
                    'componentPath":"Hyva_CmsBase::elements\\/accordion.phtml"',
                    'componentPath":"Hyva_CmsBase::elements\\/accordion_item.phtml"'
                ),
                'componentPath":"Hyva_CmsBase::elements\\/accordion-list.phtml"',
                'componentPath":"Hyva_CmsBase::elements\\/accordion_list.phtml"'
            ),
            '"component":"accordion-list"', '"component":"accordion_list"'
        ),
        '"component":"accordion"', '"component":"accordion_item"'
    )
WHERE published_content LIKE '%"component":"accordion%';
```

## Changelogs

The changelog is available [here](changelog.html#020-2025-04-17).

## Known Issues

See bugfixes in the [0.3.0 release](upgrading-to-0.3.0.html).
