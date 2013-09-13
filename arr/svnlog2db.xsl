<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet
[
<!ENTITY dbns "http://docbook.org/ns/docbook">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Custom stylesheet to convert an XML subversion log to a docbook
     revhistory document.  It draws inspiration from the similar section in the
     docbook cookbook and the stylesheet in the docbook sourceforce build tree.
     Peter Brady, peter.brady@uts.edu.au
     -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="log">
        <!-- Add the XSL headers-->
		<!--<xsl:element name="revhistory" namespace="http://docbook.org/ns/docbook"
            inherit-namespaces="yes">
            <xsl:apply-templates/>
        </xsl:element>-->
        <revhistory xmlns="http://docbook.org/ns/docbook">
            <xsl:apply-templates select="node()|@*"/>
        </revhistory>
    </xsl:template>
    
    <xsl:template match="logentry">
        <revision xmlns="&dbns;"><xsl:text>&#xa;</xsl:text>
            <revnumber><xsl:value-of select="@revision"/></revnumber><xsl:text>&#xa;</xsl:text>
            <xsl:apply-templates select="date"/>
            <xsl:apply-templates select="author"/>
            <xsl:apply-templates select="msg"/>
        </revision>
    </xsl:template>
    
    <xsl:template match="date">
        <date xmlns="&dbns;"><xsl:value-of select="."/></date><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <xsl:template match="author">
        <author xmlns="&dbns;"><xsl:text>&#xa;</xsl:text>
            <personname><xsl:text>&#xa;</xsl:text>
                <firstname><xsl:value-of select="."/></firstname><xsl:text>&#xa;</xsl:text>
            </personname><xsl:text>&#xa;</xsl:text>
        </author><xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <xsl:template match="msg">
        <revdescription xmlns="&dbns;"><xsl:text>&#xa;</xsl:text>
            <para><xsl:value-of select="."/></para><xsl:text>&#xa;</xsl:text>
        </revdescription><xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
