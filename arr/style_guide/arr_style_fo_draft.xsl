<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- This style sheet extends the common elements for ARR to include
     elements specific to printing the final publication copies -->
    
    
    <!-- Import the normal FO stylesheet
     This path interacts with a catalog so may need to change -->
    <xsl:import href="arr_style_fo_common.xsl" />
    
    <!-- Force draft mode -->
    <xsl:param name="draft.mode" select="'yes'"/>
    <xsl:param name="draft.watermark.image" select="'../../stylesheets-ns/images/draft.png'"/>
    
    
    <!-- Line Spacing -->
    <!-- for draft use double spacing -->
    <xsl:param name="line-height" select="2.4"/>
    
</xsl:stylesheet>