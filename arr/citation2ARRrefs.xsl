<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:exsl="http://exslt.org/common"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="exsl str"
    exclude-result-prefixes="exsl str xsl"
    version="1.0">
    
    <!-- citation2ARRrefs.xsl
        This XSL stylesheet is designed to hijack standard
        DocBook <citation></citation> tags and convert them
        to ARR specific XREFs.  This should really only be a
        temporary measure as the EndNote to DocBook process
        should be more efficient in the long term.
        
        How this works:
        -) it is designed to process at an individual chapter
        level.
        -) it assumes there is a chap_refs_src.xml file located
        in the same directory as the chapter to process.  This
        is a well formatted DocBook XML file containing the
        formatted references with the <para> elements holding
        the xml:id attribute.
        -) it will generate an XML document chap_refs.xml.
        This generated file contains a section with
        reference blocks and should be included at the
        appropriate location in the chapter.
        -) <citation> tags enclose the unique reference ID.
        -) multiple references are to be comma delimited within
        the <citation> tag.
        
        The aim is to have as close to Harvard style referencing as
        possible.
        
        Dr Peter Brady <peter.brady@wmawater.com.au
        2016-06-07
    -->
    
    <!-- General Parameters -->
    <xsl:output method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="no"/>
    
    <xsl:template match="db:chapter">
        <!-- Get All the Citation Objects
            This first pass goes through to find all unique references.  It
            simply looks at the citation elements and grabs any internal
            unique IDs.  This is to handle cases where the reference is of
            the form:
            <citation>b1_c2_r2,b1_c2_r3</citation>
        -->
        <xsl:variable name="chapterID">
            <xsl:value-of select="@xml:id"/>
        </xsl:variable>
        <xsl:variable name="allCites">
            <xsl:for-each select=".//db:citation">
                <xsl:choose>
                    <xsl:when test="not(contains(., ','))">
                        <!-- simplest case of single reference but first
                            remember to check for the '+' symbol and strip it
                            out.
                        -->
                        <xsl:choose>
                            <xsl:when test="contains(., '+')">
                                <xsl:element name="refid">
                                    <xsl:value-of select="substring-before(., '+')"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="refid">
                                    <xsl:value-of select="translate(translate(., ' ', ''), '&#xA;', '')"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- We need to do some more work here to extract
                            the multiple reference IDs in this value -->
                        <xsl:variable name="subRefs">
                            <xsl:call-template name="str:tokenize">
                                <xsl:with-param name="string" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:for-each select="exsl:node-set($subRefs)//db:token">
                            <!-- remember to strip the '+' if it exists as well
                                as any spaces.
                            -->
                            <xsl:variable name="refIDNoSpaces">
                                <xsl:value-of select="translate(translate(., ' ', ''), '&#xA;', '')"/>
                            </xsl:variable>
                            
                            <!-- now the '+' -->
                            <xsl:choose>
                                <xsl:when test="contains($refIDNoSpaces, '+')">
                                    <xsl:element name="refid">
                                        <xsl:value-of select="substring-before($refIDNoSpaces, '+')"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="refid">
                                        <xsl:value-of select="$refIDNoSpaces"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Next Pass: work only with the unique citations to generate the list
            of reference paragraphs -->
        <xsl:variable name="bibToPrintBase">
            <xsl:for-each select="exsl:node-set($allCites)//db:refid[not(. = preceding-sibling::*/.)]">
                <!-- Assign a conveniance variable:-->
                <xsl:variable name="trgChapID"><xsl:value-of select="."/></xsl:variable>
                
                <!-- Get the external data -->
                <xsl:variable name="refFromFile" select="document('Reference_database.xml')//chapid[text()=$trgChapID]/ancestor::ref"/>
                
                <!-- Do a sanity check to see if we found what we were after -->
                <xsl:if test="not($refFromFile)">
                    <xsl:message>Unable to find ref: "<xsl:value-of select="$trgChapID"/>"</xsl:message>
                    <xsl:message terminate="yes">Check your reference and run "make clean; make"</xsl:message>
                </xsl:if>
                
                <xsl:element name="para">
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="concat($trgChapID, '_', $chapterID)"/>
                    </xsl:attribute>
                    <xsl:attribute name="abbrev">
                        <xsl:value-of select="concat($refFromFile/shortname, ', ', $refFromFile/year)"/>
                    </xsl:attribute>
                    <xsl:attribute name="sortname">
                        <xsl:value-of select="$refFromFile/shortname"/>
                    </xsl:attribute>
                    <xsl:attribute name="sortyear">
                        <xsl:value-of select="$refFromFile/year"/>
                    </xsl:attribute>
                    <xsl:attribute name="basenameyear">
                        <xsl:value-of select="concat($refFromFile/shortname, $refFromFile/year)"/>
                    </xsl:attribute>
                    <xsl:attribute name="sortsubyear">
                        <!-- cheat and assume the default case is that there
                            is only one citation with the combination of author
                            and year.
                        -->
                    </xsl:attribute>
                    <xsl:attribute name="shortname">
                        <xsl:value-of select="$refFromFile/shortname"/>
                    </xsl:attribute>
                    <xsl:value-of select="$refFromFile/longname"/></xsl:element>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Next pass: run through to find any duplicate author/year combinations and
            add the appropriate annotation, e.g.: "a", "b", etc.  We know by now that
            the references are unique so we just copy them across and amend the as
            appropriate.
            
            The logic is:
            -) is the current combination of sortname and sortyear unique?
            -) if so, copy across with no changes
            -) if not, add the appropriate annotations
        -->
        <xsl:variable name="bibToPrintExtended">
            <xsl:for-each select="exsl:node-set($bibToPrintBase)/db:para">
                <xsl:variable name="preceedingRefs" select="preceding-sibling::db:para[@basenameyear = current()/@basenameyear] or following-sibling::*[@basenameyear = current()/@basenameyear]"/>
                <xsl:choose>
                    <xsl:when test="not($preceedingRefs)">
                        <!-- there are no previous that are the same so copy over -->
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- we have to do some work as we've found a duplicate.
                            The general process is to loop through the nodes that
                            we grabbed in $preceedingRefs and update them with 
                            the appropriate sortsubyear attribute
                            
                            But only do this is we are the last node with this combination
                        -->
                        <xsl:variable name="numFollowingSiblings" select="count(following-sibling::*[@basenameyear = current()/@basenameyear])"/>
                        <xsl:if test="$numFollowingSiblings = 0">
                            <xsl:for-each select="exsl:node-set($bibToPrintBase)//db:para[@basenameyear = current()/@basenameyear]">
                                <!-- grab a text representation of the count -->
                                <xsl:variable name="refCount">
                                    <xsl:number value="position()" format="a"/>
                                </xsl:variable>
                                <!-- define a conveniance variable to append the annotation
                                    onto the year.
                                -->
                                <xsl:variable name="yearPlusNote">
                                    <xsl:value-of select="concat(@sortyear, $refCount)"/>
                                </xsl:variable>
                                
                                <!-- do some replacements to append the annotation -->
                                <xsl:variable name="newAbbrev">
                                    <xsl:call-template name="string-replace-all">
                                        <xsl:with-param name="text" select="@abbrev" />
                                        <xsl:with-param name="replace" select="@sortyear" />
                                        <xsl:with-param name="by" select="$yearPlusNote" />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="newValue">
                                    <xsl:call-template name="string-replace-all">
                                        <xsl:with-param name="text" select="." />
                                        <xsl:with-param name="replace" select="concat('(', @sortyear, ')')" />
                                        <xsl:with-param name="by" select="concat('(', $yearPlusNote, ')')" />
                                    </xsl:call-template>
                                </xsl:variable>
                                
                                
                                <!-- now construct the new element -->
                                <xsl:element name="para">
                                    <xsl:attribute name="xml:id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="abbrev">
                                        <xsl:value-of select="$newAbbrev"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="sortname">
                                        <xsl:value-of select="concat(@sortname, $refCount)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="sortyear">
                                        <xsl:value-of select="@sortyear"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="basenameyear">
                                        <xsl:value-of select="concat(@basenameyear, $refCount)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="sortsubyear">
                                        <xsl:value-of select="$refCount"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="shortname">
                                        <xsl:value-of select="@shortname"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$newValue"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        
        
        <!-- Insert the Headers -->
        <xsl:element name="section">
            <xsl:attribute name="version">5.0</xsl:attribute>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat(@xml:id, '_refs')"/>
            </xsl:attribute>
            <xsl:element name="title">References</xsl:element>
            
            <!-- Now sort and print.
                Sorting is done in a few operations to handle:
                -) years
                -) authors
                -) multiple combinations of authors per year
            -->
            <xsl:for-each select="exsl:node-set($bibToPrintExtended)/db:para">
                <xsl:sort select="@sortname" order="ascending"/>
                    <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    
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
    
    <!-- Utility template to replace sub-strings
        From: http://geekswithblogs.net/Erik/archive/2008/04/01/120915.aspx
    -->
    <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text"
                        select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- END STRING REPLACE UTILITY TEMPLATE -->
    
    
</xsl:stylesheet>