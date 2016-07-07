<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:exsl="http://exslt.org/common"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="exsl str"
    exclude-result-prefixes="exsl str xsl"
    version="1.0">
    <!--
        Fit Images
        This stylesheet forces all images to scale to fit the width of the
        page.  Its really only of use for the PDF build as LighBox handles
        image scaling for the HTML and EPUB builds.
        
        Dr Peter Brady <peter.brady@wmawater.com.au>
        2016-06-25
    -->
    
    <!-- General Parameters -->
    <xsl:output method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="yes"/>
    
    <xsl:template match="db:imagedata">
        <xsl:copy>
            <!-- scalefit="1" width="100%" contentdepth="100%" -->
            <xsl:attribute name="scalefit">1</xsl:attribute>
            <xsl:attribute name="width"><xsl:text>100%</xsl:text></xsl:attribute>
            <xsl:attribute name="contentdepth"><xsl:text>100%</xsl:text></xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    
    <!-- Identity template
        copy all text nodes, elements and attributes
    -->   
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <!-- END IDENTITY TEMPLATE -->    
</xsl:stylesheet>