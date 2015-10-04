<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:d="http://docbook.org/ns/docbook"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <!-- Generate bibliomixed
        This stylesheet is designed to parse XML files and extract xrefs that point
        to bibliography elements, e.g. linkend string contains "bibentry".  It then
        generates a bibliograph XML file that would be included and suitable for
        parsing with a bibliography catalogue file.
        
        Dr Peter Brady <peter.brady@wmawater.com.au>
        2015-10-02
    -->
    
    <!-- Set output method and formatting -->
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Set a default parameter to assume we are building for the entire set -->
    <xsl:param name="target_arch">set</xsl:param>
    
    <xsl:template match="*">
        <xsl:message terminate="no">
            WARNING: Unmatched element: <xsl:value-of select="name()"/>
        </xsl:message>
        
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="/">
        <bibliography arch="{$target_arch}"
            xmlns="http://docbook.org/ns/docbook"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xi="http://www.w3.org/2001/XInclude"
            xmlns:svg="http://www.w3.org/2000/svg"
            xmlns:m="http://www.w3.org/1998/Math/MathML"
            xmlns:html="http://www.w3.org/1999/xhtml"
            xmlns:db="http://docbook.org/ns/docbook"
            version="5.0">
            <xsl:for-each select="//d:xref[not(@linkend = (preceding-sibling::*/@linkend))]">
                <xsl:sort select="@linkend"/>
                <xsl:choose>
                    <xsl:when test="contains(@linkend,'bibentry')">
                        <xsl:element name="bibliomixed">
                            <xsl:attribute name="xml:id">
                                <xsl:value-of select="@linkend" />
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </bibliography>
    </xsl:template>
    
    
</xsl:stylesheet>