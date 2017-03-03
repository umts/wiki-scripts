This project contains a handful of `rake` tasks that can be executed on a
local clone of a GitHub wiki to automate page categorization, custom formatting,
etc.

Installation
============

Clone your wiki git repository locally. The clone URL can be found in the
sidebar below the page list.  From within your clone, run the following:

```bash
$ curl -L https://github.com/umts/wiki-scripts/archive/master.tar.gz | \
  tar -xz --strip-components=1
```

Tasks
=====

*  `rake wiki:setup` - Make sure required directories and files exist. This
   task is a prerequisite of the others.
*  `rake wiki:categories` - Executes `wiki:categories:build` and
   `wiki:categories:index` below.
*  `rake wiki:categories:build` - Builds a page in the `category-pages/`
   directory for each "tag" in the metadata. See below.
*  `rake wiki:categories:index` - Updates the "Home" page with a list of the
   categories in the wiki.

Categorizing Pages
==================

Pages are categorized using some YAML metadata. Place the following somewhere
in your page - I suggest at the end.

```
<!--
---
tags: [array, of, category, names]
-->
```

Modifying Category Pages
========================

The resulting category pages will have a line on them that looks like

```
<!-- +++ -->
```

Anything you place **above** that line will be preserved when the category
pages are regenerated. Unused category pages are usually deleted, but will
be preserved if there is any content above this line.
