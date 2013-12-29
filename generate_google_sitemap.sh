#!/bin/bash
#
# Program: Google Sitemap Generator
# Purpose: generate google sitemap for small site's htmls
# Author : Sucha <suchaaa@gmail.com>
# Version: 1.01
# Usage  : fill in your htmlpub dir, sitemap file name, your site location,
#          may be you need to edit the changefreq and priority attribute
#
# History: v1.01 - 2012.12.28
#                * for new sitemap spec
#          v1.00 - 2008.12.14
#                * run ok under cygwin

# htmlpub and sitemap relative location
htmlpub=$HOME/html_dir
sitemap=$htmlpub/sitemap.xml

# sitemap param for find
suffix="*.html"
loc="http://yoursite.net/"
lasmodFMT="%FT%T%z"             # strftime format
changefreq="weekly"
priority=0.5

# generate google sitemap
generate_google_sitemap()
{
    echo "generate google sitemap for " $loc " in $htmlpub" 

    echo '<?xml version="1.0" encoding="UTF-8"?>' > $sitemap
    echo '<urlset
      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
      <!-- created with shell script in http://www.suchang.net/cs/ScriptStuff.html -->' >>  $sitemap

    for file in $(find $htmlpub -name "$suffix" -type f -print)
    do
        del=$((${#htmlpub} + 2))
        f=$(echo $file | cut -c$del-)

        if [ $(basename $file) == "index.html" ]; then
            pri=1.0
        else
            pri=$priority
        fi

        echo "<url>" >> $sitemap
        echo "<loc>"$loc$f"</loc>" >> $sitemap
        echo "<lastmod>"$(stat -f "%Sm" -t $lasmodFMT $file)"</lastmod>" >> $sitemap
        echo "<changefreq>"$changefreq"</changefreq>" >> $sitemap
        echo "<priority>"$pri"</priority>" >> $sitemap
        echo "</url>" >> $sitemap
    done
    echo '</urlset>' >> $sitemap
}

generate_google_sitemap
