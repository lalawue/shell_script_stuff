#!/bin/bash
#
# Program: Google Sitemap Generator
# Purpose: generate google sitemap for small site's htmls
# Author : Sucha <suchaaa@gmail.com>
# Version: 1.00
# Usage  : fill in your htmlpub dir, sitemap file name, your site location,
#          may be you need to edit the changefreq and priority attribute
#
# History: v1.00 - 2008.12.14
#                * run ok under cygwin

# htmlpub and sitemap relative location
htmlpub=$HOME/workport/homesite/publish
sitemap=$htmlpub/sitemap.txt

# sitemap param for find
suffix="*.html"
time_zone="+08:00"
loc="http://suchang.net/"
lasmod="%TY-%Tm-%TdT%TH:%TM:00$time_zone"
changefreq="weekly"
priority=1.0

# find format
find_ptf_fmt=" <url>\n  <loc>$loc%P</loc>\n  <lastmod>$lasmod</lastmod>\n  <changefreq>$changefreq</changefreq>\n  <priority>$priority</priority>\n </url>\n"

generate_goole_sitemap()
{
    # generate google sitemap
    echo '<?xml version="1.0" encoding="UTF-8"?>' > $sitemap
    echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> $sitemap
    find $htmlpub -name $suffix -printf "$find_ptf_fmt" >> $sitemap
    echo '</urlset>' >> $sitemap

    # zip it
    rm -f $sitemap.gz
    gzip $sitemap
}

generate_goole_sitemap
