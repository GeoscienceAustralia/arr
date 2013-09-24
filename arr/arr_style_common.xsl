<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:d="http://docbook.org/ns/docbook">
    
    
    <!-- Param to force number only in XREFs-->
    <xsl:param name="xref.with.number.and.title" select="0"></xsl:param>
    
    <!-- BIBLIOGRAPHY DETAILS -->
    <!-- Force the bibliography to ISO690 style -->
    <xsl:param name="bibliography.style" select="'iso690'"/>
    <!-- Point to the common XML bibliogrpahy database -->
    <xsl:param name="bibliography.collection" select="'common/bibliography_database.xml'"/>
    <xsl:param name="bibliography.numbered" select="1"/>
    <xsl:param name="bibliography.style" select="'iso690'"/>
    
    
    <!-- turn hyphenation on or off -->
    <xsl:param name="hyphenate">false</xsl:param>
    
    <!-- Local customisation to include the book number in the
     equation number -->
    <xsl:template match="d:equation" mode="label.markup">
        <!-- Insert the book number -->
        <xsl:number format="1" count="d:book" from="d:set" level="any"/>
        
        <!-- Insert a spacer -->
        <xsl:text>.</xsl:text>
        
        <!--Insert the chapter number -->
        <xsl:number format="1" count="d:chapter" from="d:book" level="any"/>
        
        <!-- Insert a spacer -->
        <xsl:text>.</xsl:text>
        
        <!--Insert the equation number inside the chapter-->
        <xsl:number format="1" count="d:equation" from="d:chapter" level="any"/>
        
    </xsl:template>
    
    <!-- Local customisation to include the book number in the
     figure number -->
    <xsl:template match="d:figure" mode="label.markup">
        <!-- Insert the book number -->
        <xsl:number format="1" count="d:book" from="d:set" level="any"/>
        
        <!-- Insert a spacer -->
        <xsl:text>.</xsl:text>
        
        <!--Insert the chapter number -->
        <xsl:number format="1" count="d:chapter" from="d:book" level="any"/>
        
        <!-- Insert a spacer -->
        <xsl:text>.</xsl:text>
        
        <!--Insert the equation number inside the chapter-->
        <xsl:number format="1" count="d:figure" from="d:chapter" level="any"/>
        
    </xsl:template>
    
    <!-- Local customisation to include the book number in the
     table number -->
    <xsl:template match="d:table" mode="label.markup">
        <!-- Insert the book number -->
        <xsl:number format="1" count="d:book" from="d:set" level="any"/>
        
        <!-- Insert a spacer -->
        <xsl:text>.</xsl:text>
        
        <!--Insert the chapter number -->
        <xsl:number format="1" count="d:chapter" from="d:book" level="any"/>
        
        <!-- Insert a spacer -->
        <xsl:text>.</xsl:text>
        
        <!--Insert the equation number inside the chapter-->
        <xsl:number format="1" count="d:table" from="d:chapter" level="any"/>
        
    </xsl:template>
    
    
</xsl:stylesheet>