<!-- source: https://docs.hyva.io/hyva-themes/faqs/hyva-contribution-guideline.html -->

# How can I contribute to Hyvä?

There are several areas you can contribute to:

- Compatibility Modules (commercial Hyvä license required for access on [gitlab.hyva.io](http://gitlab.hyva.io))
- [Hvvä Themes](https://www.hyva.io/hyva-themes-license.html) (commercial Hyvä license required)
- [Hvvä Checkout](https://www.hyva.io/hyva-checkout.html) (commercial Hyvä license required)
- [Hvvä Enterprise](https://www.hyva.io/hyva-enterprise.html) (commercial Hyvä license required)
- [Hvvä UI](https://www.hyva.io/hyva-ui.html) (commercial Hyvä license required)
- React Checkout (open-source license, free on [github.com](https://github.com/hyva-themes/magento2-react-checkout))
- Hyvä Admin (open-source license, free on [github.com](https://github.com/hyva-themes/magento2-hyva-admin))

This text focuses on Hyvä core contributions.

The open-source projects follow the usual contribution process on github and are not covered in this document.

Compatibility module contributions have their own [compat module contribution guideline](../compatibility-modules/getting-started.html).

Please note, in the following, **gitlab** refers to [gitlab.hyva.io](http://gitlab.hyva.io).

Tip

If you feel lost during any of the following steps, please ask for help in Slack. We are happy to help you and value contributions very much!

## Step by step overview over the Hyvä core contribution process.

1. To contribute, you first need to request gitlab fork permissions from a Hyvä team member in the Hyvä Slack.
2. Fork the repository you want to contribute to into your gitlab group.
3. Probably you now want to clone the repository to your development environment.
4. Please check there is an issue regarding the topic you will be working on in the original gitlab repo.
   Take note of the issue number.
   If there is none, please create an issue with a descriptive title. If relevant, please add information on how the problem can be reproduced.
   This will help speed up the code review process.
   Creating an issue before making a merge request will help people who also encounter the issue pinpoint the problem, and linking merge requests to the issue helps us to build the changelog and giving attribution for new releases!
5. In your local development environment, create a feature branch.
6. Now you get to finally work on the code!
7. Commit your changes. Then go to step 7 and repeat until done.
8. Push the changes to a new branch on gitlab and create the merge request.
   Please link to the issue in the merge request description.

## Outdated Forks

If you are working with an outdated fork of the repository and need to update it to include the latest changes from the Hyvä repository, follow these steps:

1. Run the following command to fetch the latest changes from the Hyvä repository:

   ```
   git fetch upstream
   ```
2. Create a new branch based on the latest upstream changes with the following command:
   `sh
   git checkout -b <branch-name> upstream/<branch-name>`
   Replace  with the appropriate branch name.
3. Push the new branch to your fork on GitLab using the following command:

   ```
   git push origin <branch-name>
   ```

   Ensure that you replace  with the same branch name used in step 2.
