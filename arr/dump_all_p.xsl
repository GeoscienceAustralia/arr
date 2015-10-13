<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:d="http://docbook.org/ns/docbook"
   xmlns:date="http://exslt.org/dates-and-times"
   xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions">
   <xsl:output method="text" indent="yes"/>
   <xsl:template match="d:p">
         <xsl:value-of select="."/>
   </xsl:template>
</xsl:stylesheet>
