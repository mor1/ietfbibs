#!/bin/sh

SCRIPT=~/src/awk-scripts.git/rfc2bib.awk
INDEX_DIR=~/docs
INDEX=${INDEX_DIR}/1rfc_index.txt

rm -f ${INDEX}
cd ${INDEX_DIR}
wget -q http://www.ietf.org/iesg/1rfc_index.txt
gawk -f $SCRIPT -- $INDEX
