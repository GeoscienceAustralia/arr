<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:d="http://docbook.org/ns/docbook"
   xmlns:exsl="http://exslt.org/common"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:stext="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.TextFactory"
   xmlns:simg="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.ImageIntrinsics"
   xmlns:ximg="xalan://com.nwalsh.xalan.ImageIntrinsics"
   xmlns:xtext="xalan://com.nwalsh.xalan.Text"
   xmlns:lxslt="http://xml.apache.org/xslt"
   exclude-result-prefixes="xlink stext xtext lxslt simg ximg d exsl"
   extension-element-prefixes="stext xtext"
   version="1.0">
   <!-- This style sheet holds the draft XHTML5 specific objects. -->

   <!-- First, import the chunked/single page stylesheet -->
   <xsl:import href="../stylesheets-ns/xhtml5/chunk.xsl" />

   <!-- Import the common XHTML5 stylesheet: -->
   <xsl:import href="arr_style_xhtml5_common.xsl" />

   <!-- Chunk Specific Options -->
   <xsl:param name="chunker.output.indent">yes</xsl:param>
   <xsl:param name="chunk.section.depth">0</xsl:param>
   
   <!-- Graphic Parameters 
      Designed to not write into a table and use BootStrap and CSS
      to format. First we set an override parameter to dump the
      table formatting.  Then we override the default d:imagedata
      template to insert:
        -) CSS elements for bootstrap
        -) link elements for lightbox.
      -->
   <xsl:param name="make.graphic.viewport">0</xsl:param>
   <xsl:template match="d:imagedata">
      <xsl:variable name="filename">
         <xsl:call-template name="mediaobject.filename">
            <xsl:with-param name="object" select=".."/>
         </xsl:call-template>
      </xsl:variable>
      
      <xsl:choose>
         <!-- Handle MathML and SVG markup in imagedata -->
         <xsl:when xmlns:mml="http://www.w3.org/1998/Math/MathML" test="mml:*">
            <xsl:apply-templates/>
         </xsl:when>
         
         <xsl:when xmlns:svg="http://www.w3.org/2000/svg" test="svg:*">
            <xsl:apply-templates/>
         </xsl:when>
         
         <xsl:when test="@format='linespecific'">
            <xsl:choose>
               <xsl:when test="$use.extensions != '0'                         and $textinsert.extension != '0'">
                  <xsl:choose>
                     <xsl:when test="element-available('stext:insertfile')">
                        <stext:insertfile href="{$filename}" encoding="{$textdata.default.encoding}"/>
                     </xsl:when>
                     <xsl:when test="element-available('xtext:insertfile')">
                        <xtext:insertfile href="{$filename}"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:message terminate="yes">
                           <xsl:text>No insertfile extension available.</xsl:text>
                        </xsl:message>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <a xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad" href="{$filename}"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="longdesc.uri">
               <xsl:call-template name="longdesc.uri">
                  <xsl:with-param name="mediaobject" select="ancestor::d:imageobject/parent::*"/>
               </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="phrases" select="ancestor::d:mediaobject/d:textobject[d:phrase]                             |ancestor::d:inlinemediaobject/d:textobject[d:phrase]                             |ancestor::d:mediaobjectco/d:textobject[d:phrase]"/>
            
            <xsl:element name="a">
               <xsl:attribute name="href">
                  <xsl:value-of select="$filename"/>
               </xsl:attribute>
               <xsl:attribute name="data-lightbox">
                  <xsl:value-of select="$filename"/>
               </xsl:attribute>
               <xsl:attribute name="data-title">
                  <xsl:value-of select="ancestor::d:mediaobject/preceding-sibling::d:title[1]"/>
               </xsl:attribute>
               <xsl:call-template name="process.image">
                  <xsl:with-param name="alt">
                     <xsl:choose>
                        <xsl:when test="ancestor::d:mediaobject/d:alt">
                           <xsl:apply-templates select="ancestor::d:mediaobject/d:alt"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:apply-templates select="$phrases[not(@role) or @role!='tex'][1]"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:with-param>
                  <xsl:with-param name="longdesc">
                     <xsl:call-template name="write.longdesc">
                        <xsl:with-param name="mediaobject" select="ancestor::d:imageobject/parent::*"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:element>
            
            <xsl:if test="$html.longdesc != 0 and $html.longdesc.link != 0                     and ancestor::d:imageobject/parent::*/d:textobject[not(d:phrase)]">
               <xsl:call-template name="longdesc.link">
                  <xsl:with-param name="longdesc.uri" select="$longdesc.uri"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- We are overriding this template to insert div elements necessary
      for integration with the AJAX by Bennett -->
   <xsl:template name="chunk-element-content" priority="1">
      <xsl:param name="prev"/>
      <xsl:param name="next"/>
      <xsl:param name="nav.context"/>
      <xsl:param name="content">
         <xsl:apply-imports/>
      </xsl:param>
      
      <xsl:call-template name="user.preroot"/>
      
      <html>
         <xsl:call-template name="root.attributes"/>
         <!--
         <xsl:call-template name="html.head">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
         </xsl:call-template>-->
         
         <body>
               <xsl:call-template name="body.attributes"/>
               
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
            <script src="js/lightbox.js"></script>
         </body>
      </html>
      <xsl:value-of select="$chunk.append"/>
   </xsl:template>
   
   <!-- Override to add additional target attributes for Bennett's AJAX -->
   <xsl:template match="d:section">
      <xsl:variable name="depth" select="count(ancestor::d:section)+1"/>
      
      <xsl:call-template name="id.warning"/>
      
      <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
         <xsl:call-template name="common.html.attributes">
            <xsl:with-param name="inherit" select="1"/>
         </xsl:call-template>
         <xsl:call-template name="id.attribute">
            <xsl:with-param name="conditional" select="0"/>
         </xsl:call-template>
         <xsl:attribute name="data-bk">
            <xsl:value-of select="count(ancestor::d:book/preceding-sibling::d:book)+1" />
         </xsl:attribute>
         <xsl:attribute name="data-ch">
            <xsl:value-of select="count(ancestor::d:book/child::d:section)+1" />
         </xsl:attribute>
         <xsl:attribute name="data-sec">
            <xsl:value-of select="blah" />
         </xsl:attribute>
         <xsl:call-template name="section.titlepage"/>
         
         <xsl:variable name="toc.params">
            <xsl:call-template name="find.path.params">
               <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
            </xsl:call-template>
         </xsl:variable>
         
         <xsl:if test="contains($toc.params, 'toc')                   and $depth &lt;= $generate.section.toc.level">
            <xsl:call-template name="section.toc">
               <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
            </xsl:call-template>
            <xsl:call-template name="section.toc.separator"/>
         </xsl:if>
         <xsl:apply-templates/>
         <xsl:call-template name="process.chunk.footnotes"/>
      </xsl:element>
   </xsl:template>
   
   

</xsl:stylesheet>
