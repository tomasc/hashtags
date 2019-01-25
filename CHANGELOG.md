# CHANGELOG

## 0.2.4

* ADD: `.used_hashtag_classes` method (`Hashtags::Builder.used_hashtag_classes(str, options)`), and its Mongoid extension counterpart (`doc.field_name.used_hashtag_classes`) that returns Array of hashtag classes used in the provided String (resp. stored in Mongoid field). This is useful especially for caching purposes, as it is possible to add cache keys only for hashtags actually used in the text.

## 0.2.3

* explicit `rails-assets-jquery-textcomplete` dependency

## 0.2.2

* refactor to avoid conflicts between classes
* `render_help_for` renamed to `render_hashtags_help_for`
* add `hashtags` class to the `dropdownClassName` option
