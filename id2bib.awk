#
# Attempt to do for Internet Drafts (1id-abstracts.txt) what rfc2bib
# does for rfc-index.txt.  Doesn't work that well since
# 1id-abstracts.txt is far less regularly structured.
#
# Copyright (C) 2000 Richard Mortier <mort@cantab.net>.  All Rights
# Reserved.
# Copyright (C) 2010 Paul Jakma <paul@jakma.org>. Etc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

BEGIN {
    FS="[\",<>]";
    RS="(\n[A-Za-z0-9].*\n[^ ]+\n)*  \"";
    
    # banner
    printf ("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    printf ("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
    printf ("%%\n");
    printf ("%% Date: %s\n", strftime());
    printf ("%%\n");
    printf ("%% This file is auto-generated from 1id-abstracts.txt by id2bib.awk\n") ;
    printf ("%% by Richard Mortier (mort@cantab.net).  Consequently it gets\n") ;
    printf ("%% slightly confused by some entries, so as always\n") ;
    printf ("%%\n");
    printf ("%%                      PROOF-READ YOUR DOCUMENT!\n");
    printf ("%%\n");
    printf ("\n");
    printf ("@string{ietf=\"{IETF}\"}\n\n");
}

function get_authors(field, i, first) {
    first = 1;
    authors = "";
    
    for (i = field; i <= NF; i++) {
        if (length($i) == 0) continue;
        if ($i ~ /[0-9]{1,2}[-/][[:alpha:]]{3}[-/][0-9]{2}/) 
            break;

        if (first) first = 0;
        else authors = authors " and ";
        authors = authors $i;
    }
    return i;
}

NF > 1 {
    for (i = 1; i <= NF; i++) {
        gsub(/[ \n\t]+/, " ", $i);
        sub(/^[ ]+/,"",$i);
    }

    numfield = 0;

    i = 1
    while (i <= NF) {
        if (length($i) == 0) {
            i++;
            continue;
        }
        
        nexti = i + 1;
            
        if (numfield == 0) {
            title =  gensub(/([A-Z])/, "{\\1}", "g", $1);
        } else if (numfield == 1) {
            nexti = get_authors(i);
        } else if (numfield == 2) {
            split ($i, date, "-");
            month = date[2];
            year = "20" date[3];
        } else if (numfield == 3) {
            gsub (/\.txt/, "", $i);
            idstr = $i;
        } else if (numfield == 4) {
            abstract =  $i;
        } else if (numfield > 4) {
            # The FS will have split the abstract up on any commas it contains
            abstract = abstract ", " $i;
        }
        numfield++;
        i = nexti;
    }

    printf ("@Misc{id:%s,\n", idstr) ;
    printf ("  author = {%s},\n", authors) ;
    printf ("  title = {%s},\n", title) ;
    printf ("  howpublished = {Internet Draft},\n") ;
    printf ("  month = %s,\n", month) ;
    printf ("  year = %s,\n", year) ;
    printf ("  note = {%s},\n", "<" idstr ".txt>") ;
    printf ("  abstract = {%s},\n", abstract) ;
    printf ("  url = {{http://tools.ietf.org/html/%s}},\n", idstr); 
    printf ("}\n\n") ;
}
