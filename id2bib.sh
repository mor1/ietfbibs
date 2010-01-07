#!/bin/sh

######################################################################
#
# $Id: id2bib,v 1.2 2000/12/20 17:17:13 rmm1002 Exp $
#

SCRIPT=~/src/awk-scripts.git/id2bib.awk
INDEX=~/docs/internet-drafts/1id-abstracts.txt

gawk -f $SCRIPT -- $INDEX
