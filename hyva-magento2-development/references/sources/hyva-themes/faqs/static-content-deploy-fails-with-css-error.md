<!-- source: https://docs.hyva.io/hyva-themes/faqs/static-content-deploy-fails-with-css-error.html -->

# setup:static-content:deploy fails minifying CSS

We generally recommend disabling the Magento CSS minification, but if Hyvä and Luma themes exist side by side, that may not be an option.
At the time of writing it is not possible to disable CSS minification on a store-view or website scope.
Magento always uses the global scope setting.

Hyvä already generates minified CSS when running the `build` command, so the built-in minification has no benefit for Hyvä themes.

However, depending on the Tailwindcss version and classes used in a Hyvä based theme, the Magento code can fail during the minification process.
This usually happens during the execution of the command `bin/magento setup:static-content:deploy`.

In this case, we recommend enabling CSS minification globally and applying the patch below.

To enable CSS minification run the command

```
bin/magento config:set dev/css/minify_files 1
```

The following patch contributed by Thomas Negeli (Limesoda) resolves the issue:

```
--- a/vendor/tubalmartin/cssmin/src/Minifier.php
+++ b/vendor/tubalmartin/cssmin/src/Minifier.php
@@ -298,43 +298,61 @@ class Minifier
         $css = $this->processDataUrls($css);

         // Process comments
-        $css = preg_replace_callback(
+        $newCss = preg_replace_callback(
             '/(?<!\\\\)\/\*(.*?)\*(?<!\\\\)\//Ss',
             array($this, 'processCommentsCallback'),
-            $css
+            (string)$css
         );
+        if(!is_null($newCss)) {
+            $css = $newCss;
+        }

         // IE7: Process Microsoft matrix filters (whitespaces between Matrix parameters). Can contain strings inside.
-        $css = preg_replace_callback(
+        $newCss = preg_replace_callback(
             '/filter:\s*progid:DXImageTransform\.Microsoft\.Matrix\(([^)]+)\)/Ss',
             array($this, 'processOldIeSpecificMatrixDefinitionCallback'),
-            $css
+            (string)$css
         );
+        if(!is_null($newCss)) {
+            $css = $newCss;
+        }

         // Process quoted unquotable attribute selectors to unquote them. Covers most common cases.
         // Likelyhood of a quoted attribute selector being a substring in a string: Very very low.
-        $css = preg_replace(
+        $newCss = preg_replace(
             '/\[\s*([a-z][a-z-]+)\s*([\*\|\^\$~]?=)\s*[\'"](-?[a-z_][a-z0-9-_]+)[\'"]\s*\]/Ssi',
             '[$1$2$3]',
-            $css
+            (string)$css
         );
+        if(!is_null($newCss)) {
+            $css = $newCss;
+        }

         // Process strings so their content doesn't get accidentally minified
-        $css = preg_replace_callback(
+        $newCss = preg_replace_callback(
             '/(?:"(?:[^\\\\"]|\\\\.|\\\\)*")|'."(?:'(?:[^\\\\']|\\\\.|\\\\)*')/S",
             array($this, 'processStringsCallback'),
-            $css
+            (string)$css
         );
+        if(!is_null($newCss)) {
+            $css = $newCss;
+        }

         // Normalize all whitespace strings to single spaces. Easier to work with that way.
-        $css = preg_replace('/\s+/S', ' ', $css);
+        $newCss = preg_replace('/\s+/S', ' ', (string)$css);
+        if(!is_null($newCss)) {
+            $css = $newCss;
+        }

         // Process import At-rules with unquoted URLs so URI reserved characters such as a semicolon may be used safely.
-        $css = preg_replace_callback(
+        $newCss = preg_replace_callback(
             '/@import url\(([^\'"]+?)\)( |;)/Si',
             array($this, 'processImportUnquotedUrlAtRulesCallback'),
-            $css
+            (string)$css
         );
+        if(!is_null($newCss)) {
+            $css = $newCss;
+        }

         // Process comments
         $css = $this->processComments($css);
```
