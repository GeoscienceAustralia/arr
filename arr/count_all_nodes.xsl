<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsi="n/a">
   <xsl:output indent="yes"/>
   <xsl:template match="*">
      <output>
         <xsl:value-of select="count(//*)"/>
      </output>
   </xsl:template>
</xsl:stylesheet>
