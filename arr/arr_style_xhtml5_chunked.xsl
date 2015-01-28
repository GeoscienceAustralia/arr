<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <!-- This style sheet holds the draft XHTML5 specific objects. -->

   <!-- First, import the chunked/single page stylesheet -->
   <xsl:import href="../stylesheets-ns/xhtml5/chunk.xsl" />

   <!-- Import the common XHTML5 stylesheet: -->
   <xsl:import href="arr_style_xhtml5_common.xsl" />

   <!-- Chunk Specific Options -->
   <xsl:param name="chunker.output.indent">yes</xsl:param>

   <!-- We are overriding this template to insert div elements necessary -->
   <!-- for Bootstrap integration -->

</xsl:stylesheet>
