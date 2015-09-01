<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:d="http://docbook.org/ns/docbook">
   <!-- This stylesheet contains the customisations that are common across -->
   <!-- the XHTML5 (and hence EPUB3) renders. -->
   <!-- Nota Bene: this sheet is common across both single page or chunked -->
   <!-- Peter Brady peter.brady@wmawater.com.au -->


   <!-- Common javascript/s to add to all builds: -->
   <!--    -) MathJax                             -->
   <!--    -) Bootstrap                           -->
   <!--    -) JQuery                              -->
   <xsl:param name="html.script">http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js</xsl:param>
   <xsl:param name="html.script.type">text/javascript</xsl:param>


   <!-- Add a common stylesheet -->
   <xsl:param name="html.stylesheet">https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css arr.css</xsl:param>

   <!-- Table of Contents Formatting -->
   <xsl:template match="d:book" mode="toc">
      <xsl:param name="toc-context" select="."/>

      <xsl:call-template name="subtoc">
         <xsl:with-param name="toc-context" select="$toc-context"/>
         <xsl:with-param name="nodes" select="EMPTY"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:param name="generate.toc">
      /appendix toc,title
      article/appendix  nop
      /article  toc,title
      book      toc,title,figure,table,example,equation
      /chapter  toc,title
      part      toc,title
      /preface  toc,title
      reference toc,title
      /sect1    toc
      /sect2    toc
      /sect3    toc
      /sect4    toc
      /sect5    toc
      /section  toc
      set       toc
   </xsl:param>

   <!-- Control where the titles go: -->
   <xsl:param name="formal.title.placement">
      figure after
      example before
      equation before
      table before
      procedure before
      task before
   </xsl:param>

   <!-- Table Alternate Row Colouring -->
   <xsl:template match="d:table" mode="htmlTable">
      <xsl:element name="table" namespace="http://www.w3.org/1999/xhtml">
         <xsl:attribute name="class">
            <xsl:text>table table-bordered table-hover table-striped</xsl:text>
         </xsl:attribute>
         <xsl:apply-templates select="@*" mode="htmlTableAtt"/>
         <xsl:call-template name="htmlTable"/>
      </xsl:element>
   </xsl:template>

   <!-- Equation title Customisation -->
   <xsl:param name="local.l10n.xml" select="document('')"/>
   <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
      <l:l10n language="en">
         <l:context name="title">
            <l:template name="equation" text="&#40;%n&#41;"/>
         </l:context>    
         <l:context name="xref">
            <l:template name="equation" text="&#40;%n&#41;"/>
         </l:context>
         <l:context name="xref-number">
            <l:template name="equation" text="&#40;%n&#41;"/>
         </l:context>
      </l:l10n>
   </l:i18n>

</xsl:stylesheet>
