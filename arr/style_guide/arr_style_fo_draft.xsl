<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- This style sheet extends the common elements for ARR to include
     elements specific to printing the final publication copies -->
    
    
    <!-- Import the normal FO stylesheet
     This path interacts with a catalog so may need to change -->
    <xsl:import href="arr_style_fo_common.xsl" />
    
    <!-- Force draft mode -->
    <xsl:param name="draft.mode" select="'yes'"/>
    <xsl:param name="draft.watermark.image" select="'../stylesheets-ns/images/draft.png'"/>
    
    
    <!-- Line Spacing -->
    <!-- for draft use double spacing -->
    <xsl:param name="line-height" select="2.4"/>
    
    
    <!-- Set the attributes for the revision history -->
    <xsl:attribute-set name="revhistory.title.properties">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="revhistory.table.properties">
        <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
        <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="revhistory.table.cell.properties">
        <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="padding">4pt</xsl:attribute>
    </xsl:attribute-set>
    
</xsl:stylesheet>