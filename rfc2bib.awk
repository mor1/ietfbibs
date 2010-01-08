#
# Translates rfc-index.txt to a BibTeX file; probably GNU gawk
# specific.
#
# Copyright (C) 2000 Richard Mortier <mort@cantab.net>.  All Rights
# Reserved.
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

######################################################################
#

BEGIN { 

    FS="[.] " ; RS="\n\n" ; 

    # banner
    printf ("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    printf ("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
    printf ("%%\n");
    printf ("%% Date: %s\n", strftime());
    printf ("%%\n");
    printf ("%% This file is auto-generated from rfc-index.txt by rfc2bib.awk\n") ;
    printf ("%% by Richard Mortier (mort@cantab.net).\n") ;
    printf ("\n");
    printf ("@string{ietf=\"{IETF}\"}\n\n") ; 

}

######################################################################
#

/^[0-9][0-9][0-9][0-9]/{
    
    gsub(/[\n]/, "", $0) ;
    gsub(/[ ]+/, " ", $0) ;

    # guard '$', '_', '#' from BibTeX/LaTeX in all fields
    gsub(/\$/, "\\$", $0 ) ; # ");
    gsub(/_/, "\\_", $0 ) ; # ");
    gsub(/\#/, "\\" "\#", $0 ) ; # ");

    number = substr($1, 0, 4) ;
    gsub (/^0+/, "", number) ;
    printf ("@TechReport{rfc:%s,\n", number) ;
    printf ("  key = {RFC%s},\n", number);

    # authors are all the fields "in the middle"; can be separated by
    # commas or ampersands
    authors = $2 ;
    for (i=3 ; i < NF-1 ; i++)
    {
        if (length( $ (i) ) > 1)
        {
            authors = ( authors ".~" $ (i) ) ;
        }
        else
        {
            authors = ( authors "." $ (i) ) ;
        }
    }
    gsub(/,| &/, " and", authors) ;
    gsub(/^ /, "", authors) ;
    if (length(authors) == 0)
    {
	authors = "author list not available" ;
    }
    printf ("  author = {%s},\n", authors ) ;

    # guard capitals and '&' in the title
    tmp = substr($1, 6) ;
    title = gensub(/([A-Z])/, "{\\1}", "g", tmp) ;
    gsub(/&/, "\\" "\\&", title ) ; # ");
    gsub(/ - /, " -- ", title ) ; # ");
    printf ("  title = {%s},\n", title) ;    

    # just let the institution be the IETF for now
    printf ("  institution = ietf,\n") ;

    y_fld = $ (NF-1) ;
    y_pos = length(y_fld) - 3 ;
    year  = substr(y_fld, y_pos, 4) ;
    if (length(year) == 0)
    {
	year = "{year not available}" ;
    }
    printf ("  year = %s,\n", year) ;

    printf ("  type = {RFC},\n") ;
    printf ("  number = %s,\n", number) ;

    # early RFCs: mmm-dd-yyyy ; later RFCs: month yyyy
    m_fld = $ (NF-1) ;
    gsub(/-| |\n|[0-9]/, "", m_fld) ;
    month = substr(tolower(m_fld), 0, 3) ;
    if (length(month) == 0) 
    {
	month = "{month not available}" ;
    }
    printf ("  month = %s,\n", month) ;

    printf ("  annote = {%s},\n", $NF) ;
    printf ("}\n\n") ;

}

######################################################################
######################################################################
