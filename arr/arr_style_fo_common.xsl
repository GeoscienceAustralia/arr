<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:date="http://exslt.org/dates-and-times">
    <!-- This style sheet contains the common elements for ARR FO Processing -->
    
    <!-- Global Imports -->
    <!-- Import the normal FO stylesheet
     This path interacts with a catalog so may need to change -->
    <xsl:import href="../stylesheets-ns/fo/docbook.xsl" />
    
    <!-- Import the Custom Title Declarations -->
    <xsl:import href="./arr_title_fo.xsl" />
    
    <!-- Import the Common ARR Style Elements -->
    <xsl:import href="arr_style_common.xsl" />
    
    
    
    <!-- Define some parameters first -->
    <!-- Globally turn on FOP -->
    <xsl:param name="fop1.extensions" select="1"/>
    
    
    
    
    
    
    
    <!-- Page Details -->
    <!-- Define the we are using A4 -->
    <xsl:param name="paper.type" select="'A4'"/>
    
    <!-- Set Margins and Indents -->
	<!-- No paragraph indent: -->
    <xsl:param name="body.start.indent" select="'0pt'"/>
    
    
    
    
    <!-- Font Details -->
    <!-- Force the base font to be 11pt Times -->
    <xsl:param name="body.font.master" select="11"/>
    <xsl:param name="body.font.family" select="'serif'"/>
    <!-- Force the title font to be Times, with other customisations
     handled in the arr_title_fo.xml -->
    <xsl:param name="title.font.family" select="'serif'"/>
    
    <!-- Section Fonts -->
    <!-- In the style guide this is level 2-->
    <xsl:attribute-set name="section.title.level1.properties">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <!-- In the style guide this is level 3-->
    <xsl:attribute-set name="section.title.level2.properties">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <!-- In the style guide this is level 4-->
    <xsl:attribute-set name="section.title.level3.properties">
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    
    
    
    <!-- Section and Chapter numbering -->
    <xsl:param name="section.autolabel" select="1"/>
    <xsl:param name="section.label.includes.component.label" select="1"/>
    
    
    
    
    <!-- titles of figures and tables -->
    <xsl:param name="formal.title.placement">
        figure after
        example before
        equation before
        table before
        procedure before
    </xsl:param>
    <xsl:attribute-set name="formal.title.properties" use-attribute-sets="normal.para.spacing">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="hyphenate">false</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    
    
    <!-- Equations centred with number on the right -->
    <xsl:template name="equation.without.title">
        <!-- Lay out equation and number next to equation using a table -->
        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="proportional-column-width(15)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body start-indent="0pt" end-indent="0pt">
                <fo:table-row>
                    <fo:table-cell padding-end="6pt" text-align="center">
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="equation.number.properties">
                        <fo:block>
                            <xsl:text>(</xsl:text>
                            <xsl:apply-templates select="." mode="label.markup"/>
                            <xsl:text>)</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
     </xsl:template>
    
    
    <!-- Default Table Formatting -->
    <xsl:template name="table.row.properties">
        <xsl:variable name="rownum">
            <xsl:number from="d:tbody" count="d:tr"/>
        </xsl:variable>
        
        
        <xsl:choose>
            <xsl:when test="name(..) = 'tbody'">
                <xsl:choose>
                    <xsl:when test="$rownum mod 2">
                        <xsl:attribute name="background-color">#d9d9d9</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="background-color">#eeeeee</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Header and Footer Changes:
       - Move the "Draft" marks to the footer"
     -->
    <xsl:template name="header.content">
        <xsl:param name="pageclass" select="''"/>
        <xsl:param name="sequence" select="''"/>
        <xsl:param name="position" select="''"/>
        <xsl:param name="gentext-key" select="''"/>
        
        <!--
         <fo:block>
         <xsl:value-of select="$pageclass"/>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="$sequence"/>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="$position"/>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="$gentext-key"/>
         </fo:block>
         -->
        
        <fo:block>
            
            <!-- sequence can be odd, even, first, blank -->
            <!-- position can be left, center, right -->
            <xsl:choose>
                <xsl:when test="$sequence = 'blank'">
                    <!-- nothing -->
                </xsl:when>
                
                <xsl:when test="$position='left'">
                    <!-- Same for odd, even, empty, and blank sequences -->
                    <!--<xsl:call-template name="draft.text"/>-->
                    <!--
                    <xsl:call-template name="arr.draft.status">
                    	<xsl:with-param name="position" select="$position"/>
                    </xsl:call-template>-->
                </xsl:when>
                
                <xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
                    <xsl:if test="$pageclass != 'titlepage'">
                        <xsl:choose>
                            <xsl:when test="ancestor::d:book and ($double.sided != 0)">
                                <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                retrieve-position="first-including-carryover"
                                retrieve-boundary="page-sequence"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:when>
                
                <xsl:when test="$position='center'">
                    <!-- nothing for empty and blank sequences -->
                </xsl:when>
                
                <xsl:when test="$position='right'">
                    <!-- Same for odd, even, empty, and blank sequences -->
                    <!--<xsl:call-template name="draft.text"/>-->
                    <xsl:call-template name="arr.draft.status">
                    	<xsl:with-param name="position" select="$position"/>
                    </xsl:call-template>
                </xsl:when>
                
                <xsl:when test="$sequence = 'first'">
                    <!-- nothing for first pages -->
                </xsl:when>
                
                <xsl:when test="$sequence = 'blank'">
                    <!-- nothing for blank pages -->
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>
    <xsl:template name="footer.content">
        <xsl:param name="pageclass" select="''"/>
        <xsl:param name="sequence" select="''"/>
        <xsl:param name="position" select="''"/>
        <xsl:param name="gentext-key" select="''"/>
        
        <!--
         <fo:block>
         <xsl:value-of select="$pageclass"/>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="$sequence"/>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="$position"/>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="$gentext-key"/>
         </fo:block>
         -->
        
        <fo:block>
            <!-- pageclass can be front, body, back -->
            <!-- sequence can be odd, even, first, blank -->
            <!-- position can be left, center, right -->
            <xsl:choose>
                <xsl:when test="$pageclass = 'titlepage'">
                    <!-- nop; no footer on title pages -->
                </xsl:when>
                
                <xsl:when test="$double.sided != 0 and $sequence = 'even'
                    and $position='left'">
                    <fo:page-number/>
                </xsl:when>
                
                <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
                    and $position='right'">
                    <fo:page-number/>
                </xsl:when>
                
                <xsl:when test="$double.sided = 0 and $position='center'">
                    <fo:page-number/>
                </xsl:when>
                
                <xsl:when test="$double.sided = 0 and $position='left'">
                    <!-- Same for odd, even, empty, and blank sequences -->
                    <xsl:call-template name="draft.text"/>
                    <xsl:choose>
                        <xsl:when test="$draft.mode = 'yes'">
                            <xsl:text> Printed: </xsl:text>
                            <xsl:call-template name="datetime.format">
                                <xsl:with-param name="date" select="date:date-time()"/>
                                <xsl:with-param name="format" select="'Y-m-d'"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:when test="$sequence='blank'">
                    <xsl:choose>
                        <xsl:when test="$double.sided != 0 and $position = 'left'">
                            <fo:page-number/>
                        </xsl:when>
                        <xsl:when test="$double.sided = 0 and $position = 'center'">
                            <fo:page-number/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- nop -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                <xsl:when test="$double.sided = 0 and $position='right'">
                    <!-- Same for odd, even, empty, and blank sequences -->
                    <xsl:call-template name="draft.text"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <!-- nop -->
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    
    <!-- Set Title Page -->
    <xsl:template name="set.titlepage.recto">
        <fo:block>
            <fo:table inline-progression-dimension="100%" table-layout="fixed">
                <fo:table-column column-width="100%"/>
                <fo:table-body>
                    <fo:table-row height="20cm">
                        <fo:table-cell display-align="center">
                            <fo:block text-align="center">
                                <xsl:choose>
                                    <xsl:when test="d:setinfo/d:title">
                                        <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:title"/>
                                    </xsl:when>
                                    <xsl:when test="d:info/d:title">
                                        <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:title"/>
                                    </xsl:when>
                                    <xsl:when test="d:title">
                                        <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:title"/>
                                    </xsl:when>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row >
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
    
    <!-- Book Title Page -->
    <xsl:template name="book.titlepage.recto">
        <fo:block>
            <fo:table inline-progression-dimension="100%" table-layout="fixed">
                <fo:table-column column-width="100%"/>
                <fo:table-body>
                    <fo:table-row height="20cm">
                        <fo:table-cell display-align="center">
                            <fo:block text-align="center">
                                <xsl:text>BOOK </xsl:text><xsl:number format="1" count="d:book" from="d:set" level="any"/>
                            </fo:block>
                            <fo:block text-align="center">
                                <xsl:choose>
                                    <xsl:when test="d:bookinfo/d:title">
                                        <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:setinfo/d:title"/>
                                    </xsl:when>
                                    <xsl:when test="d:info/d:title">
                                        <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:title"/>
                                    </xsl:when>
                                    <xsl:when test="d:title">
                                        <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:title"/>
                                    </xsl:when>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row >
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
    
    <!-- Author Template -->
    <xsl:template match="d:author" mode="titlepage.mode">
        <fo:block text-align="center">
            <xsl:call-template name="anchor"/>
            <xsl:choose>
                <xsl:when test="d:orgname">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="person.name"/>
                    <xsl:if test="d:affiliation/d:orgname">
                        <fo:block font-size="12pt" font-weight="normal">
                            <xsl:apply-templates select="d:affiliation/d:orgname" mode="titlepage.mode"/>
                        </fo:block>
                    </xsl:if>
                    <xsl:if test="d:email|d:affiliation/d:address/d:email">
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="(d:email|d:affiliation/d:address/d:email)[1]"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>
    
    
    <!-- Template to insert the status of the document -->
    <xsl:template name="arr.draft.status">
        <xsl:param name="position" select="''"/>
        <xsl:choose>
            <xsl:when test="$draft.mode = 'yes'">
                <xsl:choose>
                    <xsl:when test="$position='left' and ancestor::d:book/@status">
                        <xsl:text>Book Status: </xsl:text><xsl:value-of select="ancestor::d:book/@status"/>
                    </xsl:when>

                    <xsl:when test="$position='right' and ancestor-or-self::d:chapter/@status">
                        <xsl:text>Chapter Status: </xsl:text><xsl:value-of select="ancestor-or-self::d:chapter/@status"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- Landscape Figures -->
    <xsl:template match="d:figure[processing-instruction('landscapeFigure')]">
        <fo:block-container reference-orientation="90">
            <xsl:apply-imports/>
        </fo:block-container>
    </xsl:template>
</xsl:stylesheet>