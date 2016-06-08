# Copyright(c) 2000-2016 Richard Mortier <mort@cantab.net>
# Copyright(c) 2010 Paul Jakma <paul@jakma.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

BEGIN {
    FS="[\"<>]";
    RS="(\n[A-Za-z0-9].*\n[^ ]+\n)*  \"";

    # banner
    printf("% This file auto-generated from id-index.txt by id2bib.awk\n");
    printf("% by Richard Mortier <mort@cantab.net>.\n");
    printf("%\n");
    printf("% Date: %s\n", strftime());
    printf("\n");
    printf("@string{ietf=\"{IETF}\"}\n\n");
}

function get_authors(field, i, first) {
    first = 1;
    authors = "";

    for (i = field; i <= NF; i++) {
        if (length($i) == 0) continue;
        if ($i ~ /[0-9]{1,2}[-/][[:alpha:]]{3}[-/][0-9]{2}/)
            break;
        if ($i ~ /(19|20)[0-9]{2}-[0-9]{2}-[0-9]{2}/)
            break;

        if (first) first = 0;
        else authors = authors " and ";
        authors = authors $i;
    }
    return i;
}

NF > 1 {
    # guard '$', '_', '#' from BibTeX/LaTeX in all fields
    gsub(/\$/, "\\$", $0 ); # ");
    gsub(/_/, "\\_", $0 ); # ");
    gsub(/#/, "\\" "#", $0 ); # ");

    for (i = 1; i <= NF; i++) {
        gsub(/[ \n\t]+/, " ", $i);
        sub(/^[ ]+/,"",$i);
    }

    title = gensub(/([A-Z])/, "{\\1}", "g", $1);
    idstr = $3;
    abstract = $4;

    authors = "";
    n=split($2, authors_date, ",");
    for (i=0; i<n-1; i++)
    {
        a = authors_date[i];
        gsub(/[ \n\t]+/, " ", a);
        sub(/^[ ]+/, "", a);

        if(a == "") continue;
        else if(authors == "") authors = a
        else authors = authors " and " a;
    }
    date = authors_date[n-1];
    split(date, ymd, "-");
    year = ymd[1];
    month = ymd[2];
    day = ymd[3];

    printf("@Misc{id:%s,\n", idstr) ;
    printf("  author = {%s},\n", authors) ;
    printf("  title = {%s},\n", title) ;
    printf("  howpublished = {Internet Draft},\n") ;
    printf("  month = %s,\n", month) ;
    printf("  year = %s,\n", year) ;
    printf("  note = {%s},\n", "<" idstr ".txt>") ;
    printf("  abstract = {%s},\n", abstract) ;
    printf("  url = {{http://tools.ietf.org/html/%s}},\n", idstr);
    printf("}\n\n") ;
}
