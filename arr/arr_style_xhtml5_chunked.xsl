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
   <xsl:template match="*" mode="process.root">
      <xsl:variable name="doc" select="self::*"/>

      <xsl:call-template name="user.preroot"/>
      <xsl:call-template name="root.messages"/>

      <html>
         <xsl:call-template name="root.attributes"/>
         <div class="container-fluid">
         <head>
            <xsl:call-template name="system.head.content">
               <xsl:with-param name="node" select="$doc"/>
            </xsl:call-template>
            <xsl:call-template name="head.content">
               <xsl:with-param name="node" select="$doc"/>
            </xsl:call-template>
            <xsl:call-template name="user.head.content">
               <xsl:with-param name="node" select="$doc"/>
            </xsl:call-template>
         </head>
         <body>
            <xsl:call-template name="body.attributes"/>
            <xsl:call-template name="user.header.content">
               <xsl:with-param name="node" select="$doc"/>
            </xsl:call-template>
            <xsl:apply-templates select="."/>
            <xsl:call-template name="user.footer.content">
               <xsl:with-param name="node" select="$doc"/>
            </xsl:call-template>
         </body>
         </div>
      </html>
      <xsl:value-of select="$html.append"/>

      <!-- Generate any css files only once, not once per chunk -->
      <xsl:call-template name="generate.css.files"/>
   </xsl:template>

</xsl:stylesheet>
