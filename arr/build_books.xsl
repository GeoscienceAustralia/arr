<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'>
    
    <!-- This is a template to parse the input DocBook XML and automatially
     generate the MakeFile to build individual books. -->
    
    <xsl:output method="text" indent="no"/>
    
    <xsl:template match="d:set">        
        <!-- Build some phony arguments -->
        <xsl:text>.PHONY:</xsl:text>
        <xsl:for-each select="d:book">
            <xsl:text> clean_</xsl:text>
            <xsl:value-of select="@xml:id"/><xsl:text>_pdf</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>.PHONY:</xsl:text>
        <xsl:for-each select="d:book">
            <xsl:text> clean_</xsl:text>
            <xsl:value-of select="@xml:id"/><xsl:text>_draft_pdf</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>.PHONY: all_book_pdf all_book_final_pdf all_book_draft_pdf&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        
        <!-- Set the default target -->
        <xsl:text>all_book_pdf: all_book_pdf_final all_book_pdf_draft&#10;</xsl:text>
        <xsl:text>all_book_pdf_final:</xsl:text>
        <xsl:for-each select="d:book">
            <xsl:text> </xsl:text>
            <xsl:value-of select="@xml:id"/><xsl:text>.pdf</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>all_book_pdf_draft:</xsl:text>
        <xsl:for-each select="d:book">
            <xsl:text> </xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>_draft</xsl:text><xsl:text>.pdf</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;&#10;</xsl:text>
        
        <!-- Set some phony targets for cleaning -->
        <xsl:text>clean_book_pdf_all: clean_book_pdf_final clean_book_pdf_draft&#10;</xsl:text>
        <xsl:text>clean_book_pdf_final:</xsl:text>
        <xsl:for-each select="d:book">
            <xsl:text> clean_</xsl:text>
            <xsl:value-of select="@xml:id"/><xsl:text>.pdf</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>clean_book_pdf_draft:</xsl:text>
        <xsl:for-each select="d:book">
            <xsl:text> clean_</xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>_draft.pdf</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;&#10;</xsl:text>
        
        <!-- Step down and build the individual book sections -->
        <xsl:apply-templates select="d:book"/>
    </xsl:template>
    
    <xsl:template match="d:book">
        <!-- This template is called for each d:book element.  It assumes that
         there is a xml:id attribute to uniquely identify the book.  Next the
         template builds a set of make rules to build the:
         
           -draft pdf
           -final pdf
           -clean the draft build and pdf files
           -clean the final build and pdf files
         -->
        <xsl:variable name="book_id" select="@xml:id"/>
        <xsl:variable name="book_name">
            <xsl:value-of select="$book_id"/><xsl:text>_draft</xsl:text>
        </xsl:variable>
        
        <!-- Build the draft book PDFs: -->
        <xsl:value-of select="$book_name"/><xsl:text>.pdf: </xsl:text><xsl:value-of select="$book_name"/><xsl:text>.fo</xsl:text><xsl:text>&#10;</xsl:text>
        <xsl:text>&#9;$(FOP) -d </xsl:text><xsl:value-of select="$book_name"/><xsl:text>.fo -o </xsl:text><xsl:value-of select="$book_name"/><xsl:text>.pdf&#10;</xsl:text>
        <xsl:value-of select="$book_name"/><xsl:text>.fo: arr_title_fo.xsl&#10;</xsl:text>
        <xsl:text>&#9;$(XSLTPROC) $(XSLTPROC_OPTS) </xsl:text><xsl:value-of select="$book_name"/><xsl:text>.fo \&#10;</xsl:text>
        <xsl:text>&#9;--stringparam rootid </xsl:text><xsl:value-of select="$book_id"/><xsl:text> \&#10;</xsl:text>
        <xsl:text>&#9;arr_style_fo_draft.xsl ARR.xml&#10;</xsl:text>
        
        <!--Build the final PDFs: -->
        <xsl:value-of select="$book_id"/><xsl:text>.pdf: </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.fo</xsl:text><xsl:text>&#10;</xsl:text>
        <xsl:text>&#9;$(FOP) -d </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.fo -o </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.pdf&#10;</xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>.fo: arr_title_fo.xsl&#10;</xsl:text>
        <xsl:text>&#9;$(XSLTPROC) $(XSLTPROC_OPTS) </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.fo \&#10;</xsl:text>
        <xsl:text>&#9;--stringparam rootid </xsl:text><xsl:value-of select="$book_id"/><xsl:text> \&#10;</xsl:text>
        <xsl:text>&#9;arr_style_fo.xsl ARR.xml&#10;</xsl:text>
        
        <!-- Build the clean command/s: -->
        <xsl:text>clean_</xsl:text><xsl:value-of select="$book_name"/>.pdf:<xsl:text>&#10;</xsl:text>
        <xsl:text>&#9;rm -f </xsl:text><xsl:value-of select="$book_name"/><xsl:text>.pdf </xsl:text><xsl:value-of select="$book_name"/><xsl:text>.fo&#10;</xsl:text>
        <xsl:text>clean_</xsl:text><xsl:value-of select="$book_id"/>.pdf:<xsl:text>&#10;</xsl:text>
        <xsl:text>&#9;rm -f </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.pdf </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.fo&#10;&#10;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
