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
        
        <!-- Book validation -->
        <!-- book6_valid: valid-->
        <xsl:value-of select="$book_id"/><xsl:text>_valid: valid&#10;</xsl:text>
        
        <!-- Common profile per book -->
        <!-- book2_profiled: -->
        <xsl:value-of select="$book_id"/><xsl:text>_profiled: &#10;</xsl:text>
        
        <!-- $(XSLTPROC) -stringparam  profile.arch "book" $(XSLTPROC_OPTS) \
                book2_draft_profiled.xml ../stylesheets-ns/profiling/profile.xsl ARR.xml -->
        <xsl:text>&#9;$(XSLTPROC) --stringparam  profile.arch "book" $(XSLTPROC_OPTS) \&#10;</xsl:text>
        <xsl:text>&#9;&#9;</xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_profiled.xml ../stylesheets-ns/profiling/profile.xsl ARR.xml&#10;</xsl:text>
        
        <!-- Build the draft book PDFs: -->
        <!-- book2_draft.pdf: book2_draft.fo -->
        <xsl:value-of select="$book_name"/>
        <xsl:text>.pdf: </xsl:text>
        <xsl:value-of select="$book_name"/>
        <xsl:text>.fo&#10;</xsl:text>
        
        <!--  $(FOP) -d book2_draft.fo -o book2_draft.pdf -->
        <xsl:text>&#9;$(FOP) -d </xsl:text>
        <xsl:value-of select="$book_name"/>
        <xsl:text>.fo -o </xsl:text>
        <xsl:value-of select="$book_name"/><xsl:text>.pdf&#10;</xsl:text>
        
        <!-- book2_draft.fo: valid arr_title_fo.xsl book6_refs -->
        <xsl:value-of select="$book_name"/>
        <xsl:text>.fo: valid</xsl:text>
        <xsl:text> arr_title_fo.xsl </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>_refs &#10;</xsl:text>
        
        <!-- $(XSLTPROC) $(XSLTPROC_OPTS) book2_draft.fo \
                -stringparam rootid book2 \
                arr_style_fo_draft.xsl book2_draft_profiled.xml -->
        <xsl:text>&#9;$(XSLTPROC) $(XSLTPROC_OPTS) </xsl:text>
        <xsl:value-of select="$book_name"/><xsl:text>.fo \&#10;</xsl:text>
        <xsl:text>&#9;&#9;--stringparam rootid </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text> \&#10;</xsl:text>
        <xsl:text>&#9;&#9;arr_style_fo_draft.xsl </xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_profiled.xml&#10;</xsl:text>
        
        <!--Build the final PDFs: -->
        <!-- book1.pdf: book1_valid book1.fo -->
        <xsl:value-of select="$book_id"/><xsl:text>.pdf: </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>_valid </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>.fo</xsl:text><xsl:text>&#10;</xsl:text>
        
        <!-- $(FOP) -d book1.fo -o book1.pdf -->
        <xsl:text>&#9;$(FOP) -d </xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>.fo -o </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>.pdf&#10;</xsl:text>
        
        <!-- book1.fo: book1_refs arr_title_fo.xsl -->
        <xsl:value-of select="$book_id"/>
        <xsl:text>.fo: </xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_refs arr_title_fo.xsl&#10;</xsl:text>
        <xsl:text>&#9;$(XSLTPROC) --stringparam  profile.arch "book" $(XSLTPROC_OPTS) \&#10;</xsl:text>
        <xsl:text>&#9;&#9;</xsl:text><xsl:value-of select="$book_id"/><xsl:text>_profiled.xml ../stylesheets-ns/profiling/profile.xsl ARR.xml&#10;</xsl:text>
        <xsl:text>&#9;$(XSLTPROC) $(XSLTPROC_OPTS) </xsl:text><xsl:value-of select="$book_id"/><xsl:text>.fo \&#10;</xsl:text>
        <xsl:text>&#9;&#9;--stringparam rootid </xsl:text><xsl:value-of select="$book_id"/><xsl:text> \&#10;</xsl:text>
        <xsl:text>&#9;&#9;arr_style_fo.xsl </xsl:text><xsl:value-of select="$book_id"/><xsl:text>_profiled.xml&#10;</xsl:text>
        
        <!-- Build the book?_refs commands -->
        <!-- book6_refs: -->
        <xsl:value-of select="$book_id"/>
        <xsl:text>_refs:&#10;</xsl:text>
        <!-- $(XSLTPROC) $(XSLTPROC_OPTS) book6_refs.xml \
            -stringparam target_arch book \
            -stringparam rootid book6 \
            -xinclude \
            generate_bibliomixed.xsl ARR.xml -->
        <xsl:text>&#9;$(XSLTPROC) $(XSLTPROC_OPTS) </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>_refs.xml \&#10;</xsl:text>
        <xsl:text>&#9;&#9;--stringparam target_arch book  \&#10;</xsl:text>
        <xsl:text>&#9;&#9;--stringparam rootid </xsl:text><xsl:value-of select="$book_id"/><xsl:text> \&#10;</xsl:text>
        <xsl:text>&#9;&#9;--xinclude  \&#10;</xsl:text>
        <xsl:text>&#9;&#9;generate_bibliomixed.xsl ARR.xml&#10;</xsl:text>
        
        <!-- Build the clean command/s: -->
        <!-- clean_book1_draft.pdf: clean_book1_refs -->
        <xsl:text>clean_</xsl:text>
        <xsl:value-of select="$book_name"/>
        <xsl:text>.pdf: clean_</xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_refs&#10;</xsl:text>
        <!--    rm -f book1_draft.pdf book1_draft.fo book1_draft_profiled.xml -->
        <xsl:text>&#9;rm -f </xsl:text>
        <xsl:value-of select="$book_name"/>
        <xsl:text>.pdf </xsl:text>
        <xsl:value-of select="$book_name"/><xsl:text>.fo </xsl:text>
        <xsl:value-of select="$book_name"/><xsl:text>_profiled.xml&#10;</xsl:text>
         
        <!-- clean_book1.pdf: clean_book1_refs -->
        <xsl:text>clean_</xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>.pdf: clean_</xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_refs&#10;</xsl:text>
        <!--    rm -f book1.pdf book1.fo book1_profiled.xml -->
        <xsl:text>&#9;rm -f </xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>.pdf </xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>.fo </xsl:text>
        <xsl:value-of select="$book_id"/><xsl:text>_profiled.xml&#10;</xsl:text>
                
        <!-- clean_book1_refs: -->
        <xsl:text>clean_</xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_refs:&#10;</xsl:text>
        <!--    rm -f book1_refs.xml -->
        <xsl:text>&#9;rm -f </xsl:text>
        <xsl:value-of select="$book_id"/>
        <xsl:text>_refs.xml&#10;&#10;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
