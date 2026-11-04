<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-6.html -->

# Upgrading to 1.4.6

Hyvä Theme 1.4.6 provides compatibility with Magento 2.4.9 and PHP 8.5.

Safe Module Updates

Even if you aren't ready to update the Default Theme to 1.4.6 just yet,
it's completely safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

Please refer to the changelogs for details about the bugfixes.

The only changes are in the `hyva-themes/magento2-theme-module` package.
The default-theme and default-theme-csp packages are unchanged.

The following diff contains all the changes (besides PHPUnit 12 compatibility in tests):

PHP 8.5 compatibility for hyva-themes/magento2-theme-module

```
diff --git a/src/Console/Command/HyvaConfigGenerate.php b/src/Console/Command/HyvaConfigGenerate.php
index 6ccaf4bf..5be65767 100644
--- a/src/Console/Command/HyvaConfigGenerate.php
+++ b/src/Console/Command/HyvaConfigGenerate.php
@@ -39,7 +39,7 @@ class HyvaConfigGenerate extends Command
         $this->addOption('force', 'f', InputOption::VALUE_NONE, 'No effect, exists for backward compatibility');
     }

-    protected function execute(InputInterface $input, OutputInterface $output): ?int
+    protected function execute(InputInterface $input, OutputInterface $output): int
     {
         if ($input->getOption('info')) {
             return $this->help($output);
diff --git a/src/ViewModel/ReCaptcha.php b/src/ViewModel/ReCaptcha.php
index d41eed18..dfac8a50 100644
--- a/src/ViewModel/ReCaptcha.php
+++ b/src/ViewModel/ReCaptcha.php
@@ -123,7 +123,7 @@ class ReCaptcha implements ArgumentInterface
     {
         $type = $this->getSelectedTypeForForm($formId);

-        return $this->resultFieldNames[$type] ?? 'g-recaptcha-response';
+        return $this->resultFieldNames[(string) $type] ?? 'g-recaptcha-response';
     }

     public function calcJsInstanceSuffix(string $formId): string
```

## Backward compatibility

This release is backward compatible.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#146-2026-05-12)
- [Changelog Theme Module](changelog-theme-module.html#146-2026-05-12)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
