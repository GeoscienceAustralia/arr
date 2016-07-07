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
   exclude-result-prefixes="xlink stext xtext str lxslt simg ximg d exsl"
   extension-element-prefixes="stext xtext"
   version="1.0">
   <!-- ARR STYLE CHUNK VANILLA
    This stylesheet holds the customisations that are specific to the the
    vanilla XHTML implementation.  That is, they are all static pages, no AJAX.
    
    Dr Peter Brady <peter.brady@wmawater.com.au>
    2016-03-30 -->

   <!-- First, import the chunked/single page stylesheet -->
   <xsl:import href="../stylesheets-ns/xhtml5/chunk.xsl" />

   <!-- Import the common XHTML5 stylesheet: -->
   <xsl:import href="arr_style_chunk_common.xsl" />

   <!-- Vanilla Specific Options
    NB: there may not be any of these in practice -->

   <!-- Put descriptive labels in the navigation -->
   <xsl:param name="navig.showtitles">1</xsl:param>


</xsl:stylesheet>
