<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    version="1.0">
    
    <!--
        Mathtype Block to Inline DocBook
        
        MathType defaults to all as display level block for equations
        that are copied out of MathType and into MathML.  For block
        level numbered equations this is perfect.  Hoever, for inline
        equations we need the declaration to be:
        
        <math display="inline" xmlns="http://www.w3.org/1998/Math/MathML">
        
        Fortuantely we know that inline equations are wrapped in the
        DocBook element: <inlineequation>.  Therefore, this stylesheet
        looks for every <math> element whos immediate parent is an
        <inlineequation> element and modifies the display attribute to
        "inline".
        
        Dr Peter Brady <peter.brady@wmawater.com.au>
        2016-06-22
        -->
    
    <!-- General Parameters -->
    <xsl:output method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="yes"/>
    
    <!-- Main Working Template -->
    <xsl:template match="m:math">
        <xsl:choose>
            <xsl:when test="parent::db:inlineequation">
                <!-- this is an inline element -->
                <xsl:element name="math" namespace="http://www.w3.org/1998/Math/MathML">
                    <xsl:attribute name="display">inline</xsl:attribute>
                    <!-- continue to apply the remaining templates -->
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- We are doing a block level element -->
                <xsl:element name="math" namespace="http://www.w3.org/1998/Math/MathML">
                    <xsl:attribute name="display">block</xsl:attribute>
                    <!-- continue to apply the remaining templates -->
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
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