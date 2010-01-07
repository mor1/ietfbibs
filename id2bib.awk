######################################################################
#
# $Id: id2bib.awk,v 1.1 2000/09/08 11:29:25 rmm1002 Exp $
#

# Attempt to do for Internet Drafts (1id-abstracts.txt) what rfc2bib
# does for rfc-index.txt.  Doesn't work that well since
# 1id-abstracts.txt is far less regularly structured.

# (C) 2000 Richard Mortier, rmm1002@cl.cam.ac.uk

# See http://www.cl.cam.ac.uk/~rmm1002/code.html for updates, etc.

######################################################################
#

BEGIN { 

    FS="\"," ; RS=".[\t ]*\n([\t ]*\n)+  \"";

    # banner
    printf ("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    printf ("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
    printf ("%%\n");
    printf ("%% Date: %s\n", strftime());
    printf ("%%\n");
    printf ("%% This file is auto-generated from 1id-abstracts.txt by id2bib.awk\n") ;
    printf ("%% by Richard Mortier (rmm1002@cl.cam.ac.uk).  Consequently it gets\n") ;
    printf ("%% slightly confused by some entries, so as always\n") ;
    printf ("%%\n");
    printf ("%%                      PROOF-READ YOUR DOCUMENT!\n")
    printf ("%%\n");
    printf ("\n");
    printf ("@string{ietf=\"{IETF}\"}\n\n") ; 

}

######################################################################
#

{
    title = gensub(/([A-Z])/, "{\\1}", "g", $1) ;

    split ($2, t, "<") ; 

    split (t[1], tt, ",") ;
    tt_len = 0;
    for (x in tt)
    {
	tt_len++ ;
    }
    authors = tt[1] ;
    for (i=2; i<tt_len-1; i++)
    {
	if (length(tt[i]) > 0) 
	{
	    authors = authors " and " tt[i] ;
	}
    }

    split (tt[tt_len-1], date, "/") ;
    month = date[1] ;
    year = date[3] ;
    if      (int(month) ==  1) { month = "jan" }
    else if (int(month) ==  2) { month = "feb" }
    else if (int(month) ==  3) { month = "mar" }
    else if (int(month) ==  4) { month = "apr" }
    else if (int(month) ==  5) { month = "may" }
    else if (int(month) ==  6) { month = "jun" }
    else if (int(month) ==  7) { month = "jul" }
    else if (int(month) ==  8) { month = "aug" }
    else if (int(month) ==  9) { month = "sep" }
    else if (int(month) == 10) { month = "oct" }
    else if (int(month) == 11) { month = "nov" }
    else if (int(month) == 12) { month = "dec" }

    split (t[2], tt, ">") ;
    number = tt[1] ;
    gsub (/\.txt/, "", number) ;
    abstract = tt[2] ;
    gsub(/[ ]+|[\n]+/, " ", abstract) ;

    printf ("@Misc{id:%s,\n", number) ;
    printf ("  author = {%s},\n", authors) ;
    printf ("  title = {%s},\n", title) ;
    printf ("  howpublished = {Internet Draft},\n") ;
    printf ("  month = %s,\n", month) ;
    printf ("  year = %s,\n", year) ;
    printf ("  note = {%s},\n", "<" number ".txt>") ;
    printf ("  abstract = {%s},\n", abstract) ;
    printf ("}\n\n") ;
}

######################################################################
######################################################################
