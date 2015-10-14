<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0"
   xmlns:d="http://docbook.org/ns/docbook">
   <!-- ARR ePUB stylesheet
        This stylesheet contains the customisation layers for the ePUB output
        for Australian Rainfall and Runoff.

        Dr Peter Brady <peter.brady@wmawater.com.au>
        2015-10-06 -->

   <!-- First up: import the global, then set our overrides -->
   <xsl:import href="../stylesheets-ns/epub3/chunk.xsl" />

   <!-- Now import the global styles: -->
   <xsl:import href="arr_style_common.xsl" />
   
   <!-- Now, as ePUB is essentially XHTML5, simply import the
      XHTML5 stylesheet -->
   <xsl:import href="arr_style_xhtml5_common.xsl"/> 
   
   <!-- Local overrides for the EPUB -->
   <!-- Chunk Specific Options -->
   <xsl:param name="chunker.output.indent">yes</xsl:param>
   <xsl:param name="chunk.section.depth">0</xsl:param>

</xsl:stylesheet>
