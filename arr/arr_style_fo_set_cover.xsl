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
                  <fo:external-graphic src="images/arrcover.pdf" />
               </fo:block>
            </fo:block-container>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>
