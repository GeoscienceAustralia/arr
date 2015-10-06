<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:d="http://docbook.org/ns/docbook">
    
    
    <!-- Param to force number only in XREFs-->
    <xsl:param name="xref.with.number.and.title" select="0"></xsl:param>
    
    <!-- BIBLIOGRAPHY DETAILS -->
    <!-- Force the bibliography to ISO690 style -->
    <xsl:param name="bibliography.style" select="'iso690'"/>
    <!-- Point to the common XML bibliography database -->
    <xsl:param name="bibliography.collection">file:///arr_references.xml</xsl:param>
    <xsl:param name="bibliography.numbered" select="1"/>

    <!-- Glossary Information -->
    <xsl:param name="glossary.as.blocks" select="1"/>
    <xsl:param name="glossentry.show.acronym" select="'yes'"/>
    <xsl:param name="glossary.sort" select="1"/>
    <xsl:param name="generate.toc">
       appendix  toc,title
       article/appendix  nop
       article   toc,title
       book      toc,title,figure,table,example,equation
       chapter   toc,title
       part      toc,title
       preface   toc,title
       qandadiv  toc
       qandaset  toc
       reference toc,title
       sect1     toc
       sect2     toc
       sect3     toc
       sect4     toc
       sect5     toc
       section   toc
       set       toc,title
    </xsl:param>
    
    <!-- Globally disable comments so that they do not appear unless
         specifically requested -->
    <xsl:param name="show.comments" select="0"></xsl:param>
    
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
