<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:d="http://docbook.org/ns/docbook"
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
   version='1.0'>

   <xsl:template match="d:set">
      <xsl:variable name="id">
         <xsl:call-template name="object.id"/>
      </xsl:variable>

      <xsl:call-template name="arr.set.front.cover"/>

      <xsl:variable name="preamble"
         select="*[not(self::d:book or self::d:set or self::d:setindex)]"/>

      <xsl:variable name="content" select="d:book|d:set|d:setindex"/>

      <xsl:variable name="titlepage-master-reference">
         <xsl:call-template name="select.pagemaster">
            <xsl:with-param name="pageclass" select="'titlepage'"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="lot-master-reference">
         <xsl:call-template name="select.pagemaster">
            <xsl:with-param name="pageclass" select="'lot'"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$preamble">
         <fo:page-sequence hyphenate="{$hyphenate}"
            master-reference="{$titlepage-master-reference}">
            <xsl:attribute name="language">
               <xsl:call-template name="l10n.language"/>
            </xsl:attribute>
            <xsl:attribute name="format">
               <xsl:call-template name="page.number.format">
                  <xsl:with-param name="master-reference" 
                     select="$titlepage-master-reference"/>
               </xsl:call-template>
            </xsl:attribute>

            <xsl:attribute name="initial-page-number">
               <xsl:call-template name="initial.page.number">
                  <xsl:with-param name="master-reference" 
                     select="$titlepage-master-reference"/>
               </xsl:call-template>
            </xsl:attribute>

            <xsl:attribute name="force-page-count">
               <xsl:call-template name="force.page.count">
                  <xsl:with-param name="master-reference" 
                     select="$titlepage-master-reference"/>
               </xsl:call-template>
            </xsl:attribute>

            <xsl:attribute name="hyphenation-character">
               <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'hyphenation-character'"/>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="hyphenation-push-character-count">
               <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="hyphenation-remain-character-count">
               <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
               </xsl:call-template>
            </xsl:attribute>

            <xsl:apply-templates select="." mode="running.head.mode">
               <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
            </xsl:apply-templates>

            <xsl:apply-templates select="." mode="running.foot.mode">
               <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
            </xsl:apply-templates>

            <fo:flow flow-name="xsl-region-body">
               <xsl:call-template name="set.flow.properties">
                  <xsl:with-param name="element" select="local-name(.)"/>
                  <xsl:with-param name="master-reference" 
                     select="$titlepage-master-reference"/>
               </xsl:call-template>

               <fo:block id="{$id}">
                  <xsl:call-template name="set.titlepage"/>
               </fo:block>
            </fo:flow>
         </fo:page-sequence>
      </xsl:if>

      <xsl:variable name="toc.params">
         <xsl:call-template name="find.path.params">
            <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:if test="contains($toc.params, 'toc')">
         <fo:page-sequence hyphenate="{$hyphenate}"
            master-reference="{$lot-master-reference}">
            <xsl:attribute name="language">
               <xsl:call-template name="l10n.language"/>
            </xsl:attribute>
            <xsl:attribute name="format">
               <xsl:call-template name="page.number.format">
                  <xsl:with-param name="element" select="'toc'"/>
                  <xsl:with-param name="master-reference"
                     select="$lot-master-reference"/>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="initial-page-number">
               <xsl:call-template name="initial.page.number">
                  <xsl:with-param name="master-reference"
                     select="$lot-master-reference"/>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="force-page-count">
               <xsl:call-template name="force.page.count">
                  <xsl:with-param name="master-reference"
                     select="$lot-master-reference"/>
               </xsl:call-template>
            </xsl:attribute>

            <xsl:attribute name="hyphenation-character">
               <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'hyphenation-character'"/>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="hyphenation-push-character-count">
               <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="hyphenation-remain-character-count">
               <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
               </xsl:call-template>
            </xsl:attribute>

            <xsl:apply-templates select="." mode="running.head.mode">
               <xsl:with-param name="master-reference" select="$lot-master-reference"/>
            </xsl:apply-templates>

            <xsl:apply-templates select="." mode="running.foot.mode">
               <xsl:with-param name="master-reference" select="$lot-master-reference"/>
            </xsl:apply-templates>

            <fo:flow flow-name="xsl-region-body">
               <xsl:call-template name="set.flow.properties">
                  <xsl:with-param name="element" select="local-name(.)"/>
                  <xsl:with-param name="master-reference" 
                     select="$lot-master-reference"/>
               </xsl:call-template>

               <xsl:call-template name="set.toc"/>
            </fo:flow>
         </fo:page-sequence>
      </xsl:if>

      <xsl:apply-templates select="$content"/>
      
      <xsl:call-template name="arr.set.back.cover"/>
   </xsl:template>

   <xsl:template name="arr.set.front.cover">
      <xsl:call-template name="page.sequence">
         <xsl:with-param name="master-reference">titlepage</xsl:with-param>
         <xsl:with-param name="content">
            <fo:block-container absolute-position="absolute"
               width="{$page.width}"
               height="{$page.height}"
               top="-(1mm + {$page.margin.top} + {$body.margin.top})"
               left="-({$page.margin.inner})">
               <fo:block text-align="center">
                  <fo:external-graphic src="figures/cover_front.pdf" />
               </fo:block>
            </fo:block-container>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="arr.set.back.cover">
      <xsl:call-template name="page.sequence">
         <xsl:with-param name="master-reference">titlepage</xsl:with-param>
         <xsl:with-param name="content">
            <fo:block-container absolute-position="absolute"
               width="{$page.width}"
               height="{$page.height}"
               top="-(1mm + {$page.margin.top} + {$body.margin.top})"
               left="-({$page.margin.inner})">
               <fo:block text-align="center">
                  <fo:external-graphic src="figures/cover_back.pdf" />
               </fo:block>
            </fo:block-container>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="header.table">
      <xsl:param name="pageclass" select="''"/>
      <xsl:param name="sequence" select="''"/>
      <xsl:param name="gentext-key" select="''"/>
      
      <!-- default is a single table style for all headers -->
      <!-- Customize it for different page classes or sequence location -->
      
      <xsl:choose>
         <xsl:when test="$pageclass = 'index'">
            <xsl:attribute name="margin-{$direction.align.start}">0pt</xsl:attribute>
         </xsl:when>
      </xsl:choose>
      
      <xsl:variable name="column1">
         <xsl:choose>
            <xsl:when test="$double.sided = 0">1</xsl:when>
            <xsl:when test="$sequence = 'first' or $sequence = 'odd'">1</xsl:when>
            <xsl:otherwise>3</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="column3">
         <xsl:choose>
            <xsl:when test="$double.sided = 0">3</xsl:when>
            <xsl:when test="$sequence = 'first' or $sequence = 'odd'">3</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="candidate">
         <fo:table xsl:use-attribute-sets="header.table.properties">
            <xsl:call-template name="head.sep.rule">
               <xsl:with-param name="pageclass" select="$pageclass"/>
               <xsl:with-param name="sequence" select="$sequence"/>
               <xsl:with-param name="gentext-key" select="$gentext-key"/>
            </xsl:call-template>
            
            <fo:table-column column-number="1">
               <xsl:attribute name="column-width">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:call-template name="header.footer.width">
                     <xsl:with-param name="location">header</xsl:with-param>
                     <xsl:with-param name="position" select="$column1"/>
                     <xsl:with-param name="pageclass" select="$pageclass"/>
                     <xsl:with-param name="sequence" select="$sequence"/>
                     <xsl:with-param name="gentext-key" select="$gentext-key"/>
                  </xsl:call-template>
                  <xsl:text>)</xsl:text>
               </xsl:attribute>
            </fo:table-column>
            <fo:table-column column-number="2">
               <xsl:attribute name="column-width">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:call-template name="header.footer.width">
                     <xsl:with-param name="location">header</xsl:with-param>
                     <xsl:with-param name="position" select="2"/>
                     <xsl:with-param name="pageclass" select="$pageclass"/>
                     <xsl:with-param name="sequence" select="$sequence"/>
                     <xsl:with-param name="gentext-key" select="$gentext-key"/>
                  </xsl:call-template>
                  <xsl:text>)</xsl:text>
               </xsl:attribute>
            </fo:table-column>
            <fo:table-column column-number="3">
               <xsl:attribute name="column-width">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:call-template name="header.footer.width">
                     <xsl:with-param name="location">header</xsl:with-param>
                     <xsl:with-param name="position" select="$column3"/>
                     <xsl:with-param name="pageclass" select="$pageclass"/>
                     <xsl:with-param name="sequence" select="$sequence"/>
                     <xsl:with-param name="gentext-key" select="$gentext-key"/>
                  </xsl:call-template>
                  <xsl:text>)</xsl:text>
               </xsl:attribute>
            </fo:table-column>
            
            <fo:table-body>
               <fo:table-row>
                  <xsl:attribute name="block-progression-dimension.minimum">
                     <xsl:value-of select="$header.table.height"/>
                  </xsl:attribute>
                  <fo:table-cell text-align="start"
                     display-align="before">
                     <xsl:if test="$fop.extensions = 0">
                        <xsl:attribute name="relative-align">baseline</xsl:attribute>
                     </xsl:if>
                     <fo:block>
                        <xsl:call-template name="header.content">
                           <xsl:with-param name="pageclass" select="$pageclass"/>
                           <xsl:with-param name="sequence" select="$sequence"/>
                           <xsl:with-param name="position" select="$direction.align.start"/>
                           <xsl:with-param name="gentext-key" select="$gentext-key"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="center"
                     display-align="before">
                     <xsl:if test="$fop.extensions = 0">
                        <xsl:attribute name="relative-align">baseline</xsl:attribute>
                     </xsl:if>
                     <fo:block>
                        <xsl:call-template name="header.content">
                           <xsl:with-param name="pageclass" select="$pageclass"/>
                           <xsl:with-param name="sequence" select="$sequence"/>
                           <xsl:with-param name="position" select="'center'"/>
                           <xsl:with-param name="gentext-key" select="$gentext-key"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right"
                     display-align="before">
                     <xsl:if test="$fop.extensions = 0">
                        <xsl:attribute name="relative-align">baseline</xsl:attribute>
                     </xsl:if>
                     <fo:block>
                        <xsl:call-template name="header.content">
                           <xsl:with-param name="pageclass" select="$pageclass"/>
                           <xsl:with-param name="sequence" select="$sequence"/>
                           <xsl:with-param name="position" select="$direction.align.end"/>
                           <xsl:with-param name="gentext-key" select="$gentext-key"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>
               </fo:table-row>
            </fo:table-body>
         </fo:table>
      </xsl:variable>
      
      <!-- Really output a header? -->
      <xsl:choose>
         <xsl:when test="$pageclass = 'titlepage' and ($gentext-key = 'book' or $gentext-key = 'set')
            and $sequence='first'">
            <!-- no, book titlepages have no headers at all -->
         </xsl:when>
         <xsl:when test="$sequence = 'blank' and $headers.on.blank.pages = 0">
            <!-- no output -->
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$candidate"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="footer.table">
      <xsl:param name="pageclass" select="''"/>
      <xsl:param name="sequence" select="''"/>
      <xsl:param name="gentext-key" select="''"/>
      
      <!-- default is a single table style for all footers -->
      <!-- Customize it for different page classes or sequence location -->
      
      <xsl:choose>
         <xsl:when test="$pageclass = 'index'">
            <xsl:attribute name="margin-{$direction.align.start}">0pt</xsl:attribute>
         </xsl:when>
      </xsl:choose>
      
      <xsl:variable name="column1">
         <xsl:choose>
            <xsl:when test="$double.sided = 0">1</xsl:when>
            <xsl:when test="$sequence = 'first' or $sequence = 'odd'">1</xsl:when>
            <xsl:otherwise>3</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="column3">
         <xsl:choose>
            <xsl:when test="$double.sided = 0">3</xsl:when>
            <xsl:when test="$sequence = 'first' or $sequence = 'odd'">3</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="candidate">
         <fo:table xsl:use-attribute-sets="footer.table.properties">
            <xsl:call-template name="foot.sep.rule">
               <xsl:with-param name="pageclass" select="$pageclass"/>
               <xsl:with-param name="sequence" select="$sequence"/>
               <xsl:with-param name="gentext-key" select="$gentext-key"/>
            </xsl:call-template>
            <fo:table-column column-number="1">
               <xsl:attribute name="column-width">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:call-template name="header.footer.width">
                     <xsl:with-param name="location">footer</xsl:with-param>
                     <xsl:with-param name="position" select="$column1"/>
                     <xsl:with-param name="pageclass" select="$pageclass"/>
                     <xsl:with-param name="sequence" select="$sequence"/>
                     <xsl:with-param name="gentext-key" select="$gentext-key"/>
                  </xsl:call-template>
                  <xsl:text>)</xsl:text>
               </xsl:attribute>
            </fo:table-column>
            <fo:table-column column-number="2">
               <xsl:attribute name="column-width">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:call-template name="header.footer.width">
                     <xsl:with-param name="location">footer</xsl:with-param>
                     <xsl:with-param name="position" select="2"/>
                     <xsl:with-param name="pageclass" select="$pageclass"/>
                     <xsl:with-param name="sequence" select="$sequence"/>
                     <xsl:with-param name="gentext-key" select="$gentext-key"/>
                  </xsl:call-template>
                  <xsl:text>)</xsl:text>
               </xsl:attribute>
            </fo:table-column>
            <fo:table-column column-number="3">
               <xsl:attribute name="column-width">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:call-template name="header.footer.width">
                     <xsl:with-param name="location">footer</xsl:with-param>
                     <xsl:with-param name="position" select="$column3"/>
                     <xsl:with-param name="pageclass" select="$pageclass"/>
                     <xsl:with-param name="sequence" select="$sequence"/>
                     <xsl:with-param name="gentext-key" select="$gentext-key"/>
                  </xsl:call-template>
                  <xsl:text>)</xsl:text>
               </xsl:attribute>
            </fo:table-column>
            
            <fo:table-body>
               <fo:table-row>
                  <xsl:attribute name="block-progression-dimension.minimum">
                     <xsl:value-of select="$footer.table.height"/>
                  </xsl:attribute>
                  <fo:table-cell text-align="start"
                     display-align="after">
                     <xsl:if test="$fop.extensions = 0">
                        <xsl:attribute name="relative-align">baseline</xsl:attribute>
                     </xsl:if>
                     <fo:block>
                        <xsl:call-template name="footer.content">
                           <xsl:with-param name="pageclass" select="$pageclass"/>
                           <xsl:with-param name="sequence" select="$sequence"/>
                           <xsl:with-param name="position" select="$direction.align.start"/>
                           <xsl:with-param name="gentext-key" select="$gentext-key"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="center"
                     display-align="after">
                     <xsl:if test="$fop.extensions = 0">
                        <xsl:attribute name="relative-align">baseline</xsl:attribute>
                     </xsl:if>
                     <fo:block>
                        <xsl:call-template name="footer.content">
                           <xsl:with-param name="pageclass" select="$pageclass"/>
                           <xsl:with-param name="sequence" select="$sequence"/>
                           <xsl:with-param name="position" select="'center'"/>
                           <xsl:with-param name="gentext-key" select="$gentext-key"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="end"
                     display-align="after">
                     <xsl:if test="$fop.extensions = 0">
                        <xsl:attribute name="relative-align">baseline</xsl:attribute>
                     </xsl:if>
                     <fo:block>
                        <xsl:call-template name="footer.content">
                           <xsl:with-param name="pageclass" select="$pageclass"/>
                           <xsl:with-param name="sequence" select="$sequence"/>
                           <xsl:with-param name="position" select="$direction.align.end"/>
                           <xsl:with-param name="gentext-key" select="$gentext-key"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>
               </fo:table-row>
            </fo:table-body>
         </fo:table>
      </xsl:variable>
      
      <!-- Really output a footer? -->
      <xsl:choose>
         <xsl:when test="$pageclass='titlepage' and ($gentext-key='book' or $gentext-key='set') 
            and $sequence='first'">
            <!-- no, book titlepages have no footers at all -->
         </xsl:when>
         <xsl:when test="$sequence = 'blank' and $footers.on.blank.pages = 0">
            <!-- no output -->
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$candidate"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>
