<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:exsl="http://exslt.org/common"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="exsl str"
    exclude-result-prefixes="exsl str xsl"
    version="1.0">
    
    <!-- stripcitations.xsl
        This style sheet is designed to override and replace the
        in text <citation> tags.  We are going this because we
        want to handle the cross references on a per chapter basis
        but still have the possibility to go back to the native
        bibliography handling if needed in the future.
        
        This stylesheet works in a chain and is run after
        citation2ARRrefs.xsl but before the application of the
        general DocBook XSL templates.
        
        Dr Peter Brady <peter.brady@wmawater.com.au>
        2016-06-08
    -->
    
    <!-- General Parameters -->
    <xsl:output method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="yes"/>
    
    <!-- citation template
        The majority of the work is handled here as we override the
        native <citation> elements with <link> elements and insert
        the appropriate content in to the link.
    -->
    <xsl:template match="db:citation">
        <!-- store the <citation> node to pass down -->
        <xsl:variable name="parentCitation" select="."/>
        
        <!-- grab the chapter xml:id as well -->
        <xsl:variable name="chapterID">
            <xsl:value-of select="ancestor::db:chapter/@xml:id"/>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="not(contains(., '+'))">
                <!-- this is the default case, e.g. (Bates et al., 2008) -->
                <!-- Insert the openning parenthesis -->
                <xsl:text>(</xsl:text>
                
                <xsl:choose>
                    <xsl:when test="not(contains(., ','))">
                        <!-- Simple case with only one target -->
                        <!-- remember to strip spaces if there are any -->
                        <xsl:variable name="refIDNoSpaces">
                            <xsl:value-of select="translate(translate(., ' ', ''), '&#xA;', '')"/>
                        </xsl:variable>
                        <xsl:call-template name="insert_link">
                            <xsl:with-param name="label">
                                <xsl:value-of select="$parentCitation/ancestor::db:chapter/descendant::db:para[@xml:id=concat($refIDNoSpaces, '_', $chapterID)]/@abbrev"/>
                            </xsl:with-param>
                            <xsl:with-param name="target">
                                <xsl:value-of select="concat($refIDNoSpaces, '_', $chapterID)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Well, we have to do some more work.  Therefore, we
                            first tokenize the stream and then loop over the
                            results to insert.
                        -->
                        <xsl:variable name="targetRefs">
                            <xsl:call-template name="str:tokenize">
                                <xsl:with-param name="string" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:for-each select="exsl:node-set($targetRefs)//db:token">
                            <xsl:if test="position() != 1">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                            <!-- remember to strip spaces if there are any -->
                            <xsl:variable name="refIDNoSpaces">
                                <xsl:value-of select="translate(translate(., ' ', ''), '&#xA;', '')"/>
                            </xsl:variable>
                            <xsl:call-template name="insert_link">
                                <xsl:with-param name="label">
                                    <xsl:value-of select="$parentCitation/ancestor::db:chapter/descendant::db:para[@xml:id=concat($refIDNoSpaces, '_', $chapterID)]/@abbrev"/>
                                </xsl:with-param>
                                <xsl:with-param name="target">
                                    <xsl:value-of select="concat($refIDNoSpaces, '_', $chapterID)"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Insert the closing parenthesis -->
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- if we are here then, by elimination, we want to
                    insert the alternate format: Bates et al. (2008).
                    This format should really only occur in isolation
                    so the behaviour if it is within a list is
                    undefined
                -->
                <xsl:variable name="trgRefID">
                    <xsl:value-of select="substring-before(., '+')"/>
                </xsl:variable>
                <xsl:call-template name="insert_link_alt">
                    <xsl:with-param name="author">
                        <xsl:value-of select="$parentCitation/ancestor::db:chapter/descendant::db:para[@xml:id=concat($trgRefID, '_', $chapterID)]/@shortname"/>
                    </xsl:with-param>
                    <xsl:with-param name="target">
                        <xsl:value-of select="concat($trgRefID, '_', $chapterID)"/>
                    </xsl:with-param>
                    <xsl:with-param name="year">
                        <xsl:value-of select="$parentCitation/ancestor::db:chapter/descendant::db:para[@xml:id=concat($trgRefID, '_', $chapterID)]/@sortyear"/>
                    </xsl:with-param>
                    <xsl:with-param name="subyear">
                        <xsl:value-of select="$parentCitation/ancestor::db:chapter/descendant::db:para[@xml:id=concat($trgRefID, '_', $chapterID)]/@sortsubyear"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- insert_link_alt
        Worker template to inset the link element itself and its
        interior text for the altenate format: Bates et al, (2008)
    -->
    <xsl:template name="insert_link_alt">
        <xsl:param name="target"/>
        <xsl:param name="author"/>
        <xsl:param name="year"/>
        <xsl:param name="subyear"/>
        
        <!-- open the link -->
        <xsl:element name="link">
            <xsl:attribute name="linkend">
                <xsl:value-of select="$target"/>
            </xsl:attribute>
            
            <!-- insert the author component -->
            <xsl:value-of select="$author"/>
            
            <!-- some formatting -->
            <xsl:text> (</xsl:text>
            
            <!-- the year -->
            <xsl:value-of select="concat($year,$subyear)"/>
            
            <!-- some closing formats -->
            <xsl:text>)</xsl:text>
            
            <!-- close the link -->
        </xsl:element>
    </xsl:template>
    
    <!-- insert_link
        Worker template to inset the link element itself and its
        interior text for the default format: (Bates et al., 2008)
    -->
    <xsl:template name="insert_link">
        <xsl:param name="target"/>
        <xsl:param name="label"/>
        
        <xsl:element name="link">
            <xsl:attribute name="linkend">
                <xsl:value-of select="$target"/>
            </xsl:attribute>
            
            <xsl:value-of select="$label"/>
        </xsl:element>
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
    
    <!-- Utility template to tokenize from:
        http://exslt.org/str/functions/tokenize/str.tokenize.template.xsl
        As at 2016-06-08 -->
    <xsl:template name="str:tokenize">
        <xsl:param name="string" select="''"/>
        <xsl:param name="delimiters" select="','"/>
        <xsl:choose>
            <xsl:when test="not($string)"/>
            <xsl:when test="not($delimiters)">
                <xsl:call-template name="str:_tokenize-characters">
                    <xsl:with-param name="string" select="$string"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="str:_tokenize-delimiters">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="delimiters" select="$delimiters"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="str:_tokenize-characters">
        <xsl:param name="string"/>
        <xsl:if test="$string">
            <token><xsl:value-of select="substring($string, 1, 1)"/></token>
            <xsl:call-template name="str:_tokenize-characters">
                <xsl:with-param name="string" select="substring($string, 2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="str:_tokenize-delimiters">
        <xsl:param name="string"/>
        <xsl:param name="delimiters"/>
        <xsl:variable name="delimiter" select="substring($delimiters, 1, 1)"/>
        <xsl:choose>
            <xsl:when test="not($delimiter)">
                <token><xsl:value-of select="$string"/></token>
            </xsl:when>
            <xsl:when test="contains($string, $delimiter)">
                <xsl:if test="not(starts-with($string, $delimiter))">
                    <xsl:call-template name="str:_tokenize-delimiters">
                        <xsl:with-param name="string" select="substring-before($string, $delimiter)"/>
                        <xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="str:_tokenize-delimiters">
                    <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                    <xsl:with-param name="delimiters" select="$delimiters"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="str:_tokenize-delimiters">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- END STRTOK IMPORT -->
</xsl:stylesheet>