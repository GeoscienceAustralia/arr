<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- This style sheet contains the common elements for ARR -->
    
    <!-- Global Imports -->
    <!-- Import the normal FO stylesheet 
     This path interacts with a catalog so may need to change -->
    <xsl:import href="../../stylesheets-ns/fo/docbook.xsl" />
    
    <!-- Import the Custom Title Declarations -->
    <xsl:import href="./arr_title_fo.xsl" />
    
    <!-- Import the custom equation -->
    <!-- <xsl:import href="./arr_style_equations.xsl" />  -->
    
    
    
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
    
    
    
    <!-- BIBLIOGRAPHY DETAILS -->
    <!-- Force the bibliography to ISO690 style -->
    <xsl:param name="bibliography.style" select="'iso690'"/>
    <!-- Point to the common XML bibliogrpahy database -->
    <xsl:param name="bibliography.collection" select="'../common/bibliography_database.xml'"/>
    
</xsl:stylesheet>