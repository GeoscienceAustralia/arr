<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:d="http://docbook.org/ns/docbook"
   xmlns:exsl="http://exslt.org/common"
   xmlns:str="http://exslt.org/strings"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:stext="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.TextFactory"
   xmlns:simg="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.ImageIntrinsics"
   xmlns:ximg="xalan://com.nwalsh.xalan.ImageIntrinsics"
   xmlns:xtext="xalan://com.nwalsh.xalan.Text"
   xmlns:lxslt="http://xml.apache.org/xslt"
   xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks"
   exclude-result-prefixes="xlink stext xtext str lxslt simg ximg d exsl suwl"
   extension-element-prefixes="stext xtext "
   version="1.0">
   <!-- This style sheet holds the draft XHTML5 specific objects. -->

   <!-- First, import the chunked/single page stylesheet -->
   <xsl:import href="../stylesheets-ns/xhtml5/chunk.xsl" />

   <!-- Import the common XHTML5 stylesheet: -->
   <xsl:import href="arr_style_chunk_common.xsl" />

   <!-- Parameter Changes Specified by Bennet to move to AJAX delivery -->
   <xsl:param name="suppress.navigation" select="1"></xsl:param>
   <xsl:param name="chunker.output.omit-xml-declaration">yes</xsl:param>


<!-- We are overriding this template to insert div elements necessary
      for integration with the AJAX by Bennett -->
   <xsl:template name="chunk-element-content" priority="1">
      <xsl:param name="prev"/>
      <xsl:param name="next"/>
      <xsl:param name="nav.context"/>
      <xsl:param name="content">
         <xsl:apply-imports/>
      </xsl:param>

      <!--<xsl:call-template name="user.preroot"/>-->

      <!--<html>-->
         <xsl:call-template name="root.attributes"/>
         <!--
         <xsl:call-template name="html.head">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
         </xsl:call-template>-->

         <!--<body>
               <xsl:call-template name="body.attributes"/>-->

               <!--<xsl:call-template name="html5.header.navigation">
                  <xsl:with-param name="prev" select="$prev"/>
                  <xsl:with-param name="next" select="$next"/>
                  <xsl:with-param name="nav.context" select="$nav.context"/>
               </xsl:call-template>-->

               <xsl:call-template name="user.header.content"/>

               <xsl:copy-of select="$content"/>

               <xsl:call-template name="user.footer.content"/>

               <!--<xsl:call-template name="html5.footer.navigation">
                  <xsl:with-param name="prev" select="$prev"/>
                  <xsl:with-param name="next" select="$next"/>
                  <xsl:with-param name="nav.context" select="$nav.context"/>
               </xsl:call-template>-->
            <!--<script src="js/lightbox.js"></script>
         </body>
      </html>-->
      <xsl:value-of select="$chunk.append"/>
   </xsl:template>

</xsl:stylesheet>
