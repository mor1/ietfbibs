# Copyright(c) 2000-2016 Richard Mortier <mort@cantab.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files(the "Software"), to deal
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
    FS="[.] "; RS="\n\n";

    printf("% This file auto-generated from rfc-index.txt by rfc2bib.awk\n");
    printf("% by Richard Mortier <mort@cantab.net>.\n");
    printf("%\n");
    printf("% Date: %s\n", strftime());
    printf("\n");
    printf("@string{ietf=\"{IETF}\"}\n\n");
}

/^[0-9][0-9][0-9][0-9] Not Issued./ {
    number = substr($1, 0, 4);
    gsub(/^0+/, "", number);

    printf("@TechReport{rfc:%s,\n", number);
    printf("  key = {RFC%s},\n", number);
    printf("  author = {N/A},\n");
    printf("  title = {{Not Issued}},\n");
    printf("  institution = ietf,\n");
    printf("  type = {{RFC}},\n");
    printf("  year = {N/A},\n");
    printf("}\n\n");
    next;
}

/^[0-9][0-9][0-9][0-9] /{
    gsub(/[\n]/, "", $0);
    gsub(/[ ]+/, " ", $0);

    # guard '$', '_', '#' from BibTeX/LaTeX in all fields
    gsub(/\$/, "\\$", $0 ); # ");
    gsub(/_/, "\\_", $0 ); # ");
    gsub(/#/, "\\" "#", $0 ); # ");

    number = substr($1, 0, 4);
    gsub(/^0+/, "", number);
    printf("@TechReport{rfc:%s,\n", number);
    printf("  key = {RFC%s},\n", number);

    # authors are all the fields "in the middle"; can be separated by
    # commas or ampersands
    authors = $2;
    for(i=3; i < NF-1; i++)
    {
        if(length( $(i) ) > 1)
        {
            authors =( authors ".~" $(i) );
        }
        else
        {
            authors =( authors "." $(i) );
        }
    }
    gsub(/,| &/, " and", authors);
    gsub(/^ /, "", authors);
    if(length(authors) == 0)
    {
        authors = "author list not available";
    }
    printf("  author = {%s},\n", authors );

    # guard capitals and '&' in the title
    tmp = substr($1, 6);
    title = gensub(/([A-Z])/, "{\\1}", "g", tmp);
    gsub(/&/, "\\" "\\&", title ); # ");
    gsub(/ - /, " -- ", title ); # ");
    printf("  title = {%s},\n", title);

    # just let the institution be the IETF for now
    printf("  institution = ietf,\n");

    y_fld = $(NF-1);
    y_pos = length(y_fld) - 3;
    year  = substr(y_fld, y_pos, 4);
    if(length(year) == 0)
    {
        year = "{year not available}";
    }
    printf("  year = %s,\n", year);

    printf("  type = {RFC},\n");
    printf("  number = %s,\n", number);

    # early RFCs: mmm-dd-yyyy; later RFCs: month yyyy
    m_fld = $(NF-1);
    gsub(/-| |\n|[0-9]/, "", m_fld);
    month = substr(tolower(m_fld), 0, 3);
    if(length(month) == 0)
    {
        month = "{month not available}";
    }
    printf("  month = %s,\n", month);

    printf("  annote = {%s},\n", $NF);
    printf("}\n\n");
}
