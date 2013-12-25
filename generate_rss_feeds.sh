#!/bin/bash

# Program: Rss generator
# Purpose: Generate rss feeds from emacs-wiki-journal
# Author : Sucha <suchaaa@gmail.com>
# Version: 1.0
# Usage  : Fill in your journal information blow, then run it anywhere.
#
# History: v1.0 - 2005.05.05
#               * Generate rss from the "valid" emacs-wiki-journal file
# 

# Importan elements
#
# The generator NEED some elements in your wiki-journal files
#
# 1. Anchor          : the generator need anchors to locate the items,
#		       and depend it to generate. So anchor prefix is
#		       important to generator.
# 2. Second title    : the second title in emacs-wiki-journal is the real
#		       title in the rss item.
# 3. <!-- date %s -->: it need the date elements to publish the rss
#		       item date
#

# How does it work
#
# 1. Enter your emacs-wiki-journal dir, and scans the journal files in
#    a sort, such as Journal1, Journal2, ... , Journal$maxnum, at last
#    Journal. Visites each file in order.
# 2. Collecting the rss1.0 item elements from the visiting file, and
#    then generate items from the collected elements.
# 3. Visites another file, until all files were visited.
#


# Settins
#
# your wiki-journal dir
journal_wiki_dir=$HOME/workport/homesite/blog
journal_publish_dir=$HOME/workport/homesite/publish/blog

# files do NOT need generating
category_prefix="Category"

# your journal anchor, do NOT need the number at last
anchor="#categorymisc"
del=$(echo "$anchor" | wc -c)

# the rss file name
rss_file="rss.xml"

# The rss1.0 header.
# The "channel about" is where to store your rss file, and title,
# description...
# You know how to correct it.
publish_header()
{
    echo '<?xml version="1.0" encoding="gb2312"?>'
    echo ''
    echo '<rdf:RDF'
    echo '  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
    echo '  xmlns="http://purl.org/rss/1.0/"'
    echo '  xmlns:dc="http://purl.org/dc/elements/1.1/"'
    echo '>'
    echo ''
    echo '<channel rdf:about="http://lalawudrop.51.net/blog/rss.xml">'
    echo '  <title>Journal of sucha</title>'
    echo '  <link>http://lalawudrop/blog/Journal</link>'
    echo '  <description>Lives and essay</description>'
    echo '</channel>'
}


# use the collection item elements to generate rss
generate_rss()
{
    echo "" >> $rss_file
    printf "<item rdf:about=\"http://lalawudrop.51.net/blog/%s.html%s%d\">\n" "$file" "$anchor" "$entries" >> $rss_file
    printf "  <title><![CDATA[%s]]></title>\n" "$title" >> $rss_file
    printf "  <link>http://lalawudrop.51.net/blog/%s.html%s%d</link>\n" "$file" "$anchor" "$entries" >> $rss_file
    printf "  <dc:date>%s</dc:date>\n" "$date" >> $rss_file
    printf "  <description><![CDATA[%s]]></description>\n" "$description" >> $rss_file
    printf "</item>\n" >> $rss_file
    echo "" >> $rss_file
}

# collecting the items from the journal wiki pages
get_items()
{
    entries=0
    while [ "$entries" == "$(cat $file | grep -G $anchor$entries$ | cut -c$del-)" ]; do

	# get item title, date and description
	title=$(cat $file | grep -G "$anchor$entries$" -A 1 | grep "** " | cut -c4-)
	date=$(cat $file | grep -G "$anchor$entries$" -A 3 | grep '<!' | cut -c12-21)
	description=$(cat $file | grep -G "$anchor$entries$" -A 9 | sed '1,5d')

	generate_rss 	# generating the information

	entries=$((entries+1))
    done
}


scan_entries()
{
    # sacn old entries
    for file in [^$category_prefix]*[0-9$]; do
	if [ -f $file ]; then
	    get_items
	fi
    done
    # scan the entries pubilsh latest
    for file in [^$category_prefix]*[a-zA-Z$]; do
	if [ -f $file ]; then
	    get_items
	fi
    done
}


# some publish information 
echo "Updating the rss_feeds now"

# enter the journal wiki dir
cd $journal_wiki_dir

# generate the item 
publish_header > $rss_file     # 1. publish the header
scan_entries                   # 2. collect the item elements, and generate them
echo "</rdf:RDF>" >> $rss_file # 3. at the end

# move the rss file to the journal publish dir
mv $rss_file $journal_publish_dir
