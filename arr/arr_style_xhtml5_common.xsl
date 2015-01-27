<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <!-- This stylesheet contains the customisations that are common across -->
   <!-- the XHTML5 (and hence EPUB3) renders. -->
   <!-- Nota Bene: this sheet is common across both single page or chunked -->
   <!-- Peter Brady peter.brady@wmawater.com.au -->


   <!-- Common javascript/s to add to all builds: -->
   <!--    -) MathJax                             -->
   <!--    -) Bootstrap                           -->
   <xsl:param name="html.script">http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js</xsl:param>
   <xsl:param name="html.script.type">text/javascript</xsl:param>


   <!-- Add a common stylesheet -->
   <xsl:param name="html.stylesheet">https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css</xsl:param>

</xsl:stylesheet>
