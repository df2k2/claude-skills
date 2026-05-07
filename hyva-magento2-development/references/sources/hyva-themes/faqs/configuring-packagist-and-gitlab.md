<!-- source: https://docs.hyva.io/hyva-themes/faqs/configuring-packagist-and-gitlab.html -->

# Configuring the Hyvä Composer Repository

There are two ways to install Hyvä:

- Using [packagist.com with a license key](../getting-started/index.html#installing-hyva-theme-with-composer)
- As [a technology partner](../getting-started/index.html#installing-hyva-from-gitlab-for-contributors-and-technology-partners), using GitLab as a composer source

Do not use SSH key authentication in CI/CD

GitLab uptime is not guaranteed, so always use packagist.com for build pipelines and production deployments.

If the composer configuration is incomplete, you may encounter one of the errors below.

## Could not resolve host: repo.hyva.io

The host `repo.hyva.io` does not exist. It is an AI hallucination.

The correct Hyvä packagist repository URL follows this format:

```
https://hyva-themes.repo.packagist.com/yourProjectName/
```

Replace `yourProjectName` with the identifier from your Hyvä packagist credentials. You can find it in the email containing your credentials, or in the license instructions on the [Hyvä Hub](https://www.hyva.io/customer/account).

To install Hyvä Theme, follow the step by step instructions in the [Getting Started docs](../getting-started/index.html#installing-hyva-theme-with-composer).

## The project you are looking for could not be found or you don't have permissions to view it

There are two possible reasons: either you have not configured a Hyvä composer repository, or you have configured the packagist.com repository but have not added the authentication key to the `auth.json` file.

Open your `composer.json` and look for the `repositories` section. If there is no record similar to this:

```
"repositories": {
    "private-packagist": {
        "type": "composer",
        "url": "https://hyva-themes.repo.packagist.com/yourProjectName/"
    },
```

follow the steps in the [getting started documentation](../getting-started/index.html).

If the `private-packagist` record is present, you are only missing the authentication key. Run the following command, replacing `yourLicenseAuthentificationKey` with your own key:

```
composer config --auth http-basic.hyva-themes.repo.packagist.com token yourLicenseAuthentificationKey
```

## Composer asks for a GitLab password or shows "git@gitlab.hyva.io: Permission denied"

There are several possible reasons:

### The private SSH key is not loaded

GitLab is configured as a composer repository, but your private SSH key is not available to composer for authentication.

Solution: run `ssh-add` before the composer command to add your SSH key to the SSH agent.

### The public SSH key is not set on the GitLab profile

Your private SSH key is loaded, but your public key is missing from your GitLab account settings. Copy your public key and add it to your GitLab profile using the web interface.

### The composer.lock file still references hyva.gitlab.io

This can happen when Hyvä was initially installed using `hyva.gitlab.io` as a composer repository and the configuration was later replaced with a packagist.com entry. Even though `hyva.gitlab.io` is no longer in `composer.json`, composer will still try to access the GitLab repository.

To fix: delete the `composer.lock` file and run `composer install`.

### Permission denied when installing inside a Docker container

Either your private SSH key was not added on the host system, or SSH agent forwarding is disabled, making the key unavailable from inside the container. First try running `ssh-add` on the host before starting a terminal session in the container. If that does not help, you can mount your `~/.ssh` directory into the container or configure SSH agent forwarding, which depends on your individual system setup.

## Moving from gitlab.hyva.io to packagist.com

Remove all references to `gitlab.hyva.io` git repositories from `composer.json`. Each repository is listed individually, for example:

```
"hyva-themes/magento2-theme-module": {
    "type": "git",
    "url": "git@gitlab.hyva.io:hyva-themes/magento2-theme-module.git"
},
```

Next, delete the `composer.lock` file. Then follow the [getting started instructions](../getting-started/index.html#installing-hyva-theme-with-composer) using a packagist.com key.
