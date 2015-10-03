<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:arrmap="http://www.arr.org.au/arrmap">

    <xsl:variable name="refmap">reftype-map.xsl</xsl:variable> 
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	 
	 
	<xsl:template match="/">		
			<xsl:apply-templates select="records"/>			
	</xsl:template>
	
	<xsl:template name="bblgrphy_tag" match="records">
		<bibliography xmlns="http://docbook.org/ns/docbook" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:xi="http://www.w3.org/2001/XInclude" 
		xmlns:svg="http://www.w3.org/2000/svg" 
		xmlns:m="http://www.w3.org/1998/Math/MathML" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:db="http://docbook.org/ns/docbook" version="5.0" xml:id="bibliography" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:apply-templates select="record"/>
		</bibliography>
		
	</xsl:template>
	
	
	
	<xsl:template name="bblentry_tag" match="records/record">	
		<xsl:variable name="rectype">
			<xsl:value-of select="./ref-type/@name"/>			
		</xsl:variable>
		
		<xsl:variable name="doctype">
			<xsl:value-of select="document($refmap)/xsl:stylesheet/arrmap:map/entry[@key=translate($rectype,$uppercase, $smallcase)]"/>
		</xsl:variable>		
		
		<xsl:variable name="xslt_str">			
			<xsl:value-of select="document($refmap)/xsl:stylesheet/arrmap:map/entry[@key=translate($rectype,$uppercase, $smallcase)]/@xslt"/>
		</xsl:variable>	
		
		<xsl:choose>	  
			<!--docbook type article;Articles, etc., in serials-->
			<xsl:when test="$xslt_str = 'article_serials' or $xslt_str = 'elect_serial_article' ">

				<biblioentry xmlns="http://docbook.org/ns/docbook">
					<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
					<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>				
					<!--<xsl:if test="(./*[local-name() = 'pub-location'] or ./*[local-name() = 'publisher']) and ($rectype = '6' or $rectype ='12') ">-->
					<xsl:call-template name="article"/>

					<xsl:apply-templates select="abstract"/>
					<xsl:apply-templates select="accession-num"/>
					<xsl:apply-templates select="call-num"/>
					<xsl:apply-templates select="coden"/>	
					<xsl:apply-templates select="edition"/>			
					<xsl:apply-templates select="electronic-resource-num"/>
					<xsl:apply-templates select="image"/>
					<xsl:apply-templates select="isbn"/>										
					<xsl:apply-templates select="issue"/>
					<!-- <xsl:apply-templates select="keywords"/>				 -->		
					<xsl:apply-templates select="num-vols"/>
					<xsl:apply-templates select="notes"/>		
					<xsl:apply-templates select="number"/>					
					<xsl:apply-templates select="orig-pub"/>	
					<!-- <xsl:apply-templates select="pages"/>	 -->
					<xsl:apply-templates select="reprint-edition"/>	
					<xsl:apply-templates select="reprint-status"/>						
					<xsl:apply-templates select="report-id"/>								
					<xsl:apply-templates select="secondary-issue"/>	
					<xsl:apply-templates select="section"/>			
					<xsl:apply-templates select="urls"/> 																	
					<!-- <xsl:apply-templates select="volume"/> 		 -->
				</biblioentry>
			 </xsl:when>			 			
			 <!--Doc type monograph; Monograph-->
			<xsl:when test="$xslt_str = 'monograph' ">		
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="monograph"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<xsl:apply-templates select="edition"/>			
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<xsl:apply-templates select="number"/>					
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 																	
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>			 			
             <!--Doc type serial/article;Electronic Serial, Entire/Electronic Serial, Article-->
 			 <xsl:when test="$xslt_str = 'elect_serial_entire' or $xslt_str = 'elect_serial_article' ">		
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="serial_article"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<xsl:apply-templates select="edition"/>			
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<!-- <xsl:apply-templates select="number"/>	 -->				
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 																	
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>  			

			 
			 <!--docbook type serial; Serials-->
			 <xsl:when test="$xslt_str = 'serials' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="serial"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<!-- <xsl:apply-templates select="edition"/>	 -->		
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<!-- <xsl:apply-templates select="isbn"/> -->										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<xsl:apply-templates select="number"/>					
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 																	
						<xsl:apply-templates select="volume"/> 	
				</biblioentry>
			 </xsl:when>
			 
  			 <!--Doc type part;Parts of monograph-->
  			 <xsl:when test="$xslt_str = 'part' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="parts_mg"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<!-- <xsl:apply-templates select="edition"/>	 -->		
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<xsl:apply-templates select="number"/>					
						<!-- <xsl:apply-templates select="orig-pub"/> -->	
						<!-- <xsl:apply-templates select="pages"/> -->	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<!-- <xsl:apply-templates select="section"/> -->			
						<xsl:apply-templates select="urls"/> 																	
						<!-- <xsl:apply-templates select="volume"/> 	 -->	
				</biblioentry>
			 </xsl:when>			
				<!--doc type part;Monographs, databases and computer programs, Parts-->
  			 <xsl:when test="$xslt_str = 'mg_db_cp_parts' ">
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="parts_mgs"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<!-- <xsl:apply-templates select="edition"/>	 -->		
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<!-- <xsl:apply-templates select="number"/>		 -->			
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<!-- <xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 			 -->														
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>			 
			<!--doc type monograph;Monographs, databases and computer programs, Entire-->
  			 <xsl:when test="$xslt_str = 'mg_db_cp_entire' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="monograph"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<!-- <xsl:apply-templates select="edition"/>	 -->		
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<!-- <xsl:apply-templates select="number"/>	 -->				
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<!-- <xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 		 -->															
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>						
			 <!--doc type contribution; Monographs, databases and computer programs, Contributions-->
  			 <xsl:when test="$xslt_str = 'mg_db_cp_contrs' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="contribution_multi"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<!-- <xsl:apply-templates select="edition"/>		 -->	
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<!-- <xsl:apply-templates select="isbn"/>		 -->								
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<xsl:apply-templates select="number"/>					
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 																	
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>			 
			<!--docbook type messagesystem; Entire Message System-->
  			 <xsl:when test="$xslt_str = 'msg_system_entire' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="messagesystem"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<xsl:apply-templates select="edition"/>			
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<!-- <xsl:apply-templates select="number"/>			 -->		
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<!-- <xsl:apply-templates select="urls"/>  -->																	
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>			 
			<!--docbook type message; Electronic Messages-->
  			 <xsl:when test="$xslt_str = 'electronic_msgs' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="message"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<xsl:apply-templates select="edition"/>			
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<!-- <xsl:apply-templates select="number"/>		 -->			
						<xsl:apply-templates select="orig-pub"/>	
						<xsl:apply-templates select="pages"/>	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<!-- <xsl:apply-templates select="urls"/> 	 -->																
						<xsl:apply-templates select="volume"/> 		
				</biblioentry>
			 </xsl:when>			
			 <!--docbook type contribution; Contributions to monographs-->
			 <xsl:when test="$xslt_str = 'contrs_mg' ">	
				<biblioentry xmlns="http://docbook.org/ns/docbook">
						<xsl:attribute name="xml:id"><xsl:value-of select="concat('bibentry_', ./rec-number)"/></xsl:attribute>
						<xsl:attribute name="role"><xsl:value-of select="$doctype"/></xsl:attribute>										
						<xsl:call-template name="contributions"/>
						
						<xsl:apply-templates select="abstract"/>
						<xsl:apply-templates select="accession-num"/>
						<xsl:apply-templates select="call-num"/>
						<xsl:apply-templates select="coden"/>	
						<xsl:apply-templates select="edition"/>			
						<xsl:apply-templates select="electronic-resource-num"/>
						<xsl:apply-templates select="image"/>
						<xsl:apply-templates select="isbn"/>										
						<xsl:apply-templates select="issue"/>
						<xsl:apply-templates select="keywords"/>						
						<xsl:apply-templates select="num-vols"/>
						<xsl:apply-templates select="notes"/>		
						<xsl:apply-templates select="number"/>					
						<xsl:apply-templates select="orig-pub"/>	
						<!-- <xsl:apply-templates select="pages"/> -->	
						<xsl:apply-templates select="reprint-edition"/>	
						<xsl:apply-templates select="reprint-status"/>						
						<xsl:apply-templates select="report-id"/>								
						<xsl:apply-templates select="secondary-issue"/>	
						<xsl:apply-templates select="section"/>			
						<xsl:apply-templates select="urls"/> 																	
						<!-- <xsl:apply-templates select="volume"/> 		 -->
				</biblioentry>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:message terminate="yes">Error! Invalid docbook type - <xsl:value-of select="$xslt_str"/> for record type '<xsl:value-of select="$rectype"/>' and record number '<xsl:value-of select="./rec-number"/>'</xsl:message>
				  <para>
				   <xsl:value-of select="$xslt_str"/>				  
				  </para>
			 </xsl:otherwise>
	</xsl:choose>							 
	</xsl:template>
	
	
	<xsl:template match="/records/record/titles">	
		<xsl:if test="./title">
				<title xmlns="http://docbook.org/ns/docbook">
					<xsl:value-of select="normalize-space(./title)"/>
				</title>			
		</xsl:if>	
		<xsl:if test="./secondary-title">
			<title xmlns="http://docbook.org/ns/docbook" role="secondary" >
				<xsl:value-of select="normalize-space(./secondary-title)"/>
			</title>			
		</xsl:if>
		<xsl:if test="./tertiary-title">
			<title xmlns="http://docbook.org/ns/docbook" role="tertiary" >
				<xsl:value-of select="normalize-space(./tertiary-title)"/>
			</title>
		</xsl:if>
		<xsl:if test="./alt-title">
			<title xmlns="http://docbook.org/ns/docbook" role="alt" >
				<xsl:value-of select="normalize-space(./alt-title)"/>
			</title>
		</xsl:if>
		<xsl:if test="./short-title">
			<titleabbrev xmlns="http://docbook.org/ns/docbook" >
				<xsl:value-of select="normalize-space(./short-title)"/>
			</titleabbrev>
		</xsl:if>
		<xsl:if test="./translated-title">
			<title xmlns="http://docbook.org/ns/docbook" role="translated" >
				<xsl:value-of select="normalize-space(./translated-title)"/>
			</title>
		</xsl:if>
	</xsl:template>
		
	<xsl:template name="title_selector" >
	<xsl:param name="title_child"/>		
			<xsl:for-each select="./titles/*">
				<xsl:if test="local-name() = $title_child">
					<xsl:value-of select="normalize-space(.)"/>.
				</xsl:if>
			</xsl:for-each>
	</xsl:template>	
		
	<xsl:template match="/records/record/contributors/*">
				<xsl:for-each select="./*">							
					<author xmlns="http://docbook.org/ns/docbook">	
						<xsl:variable name="norm_auth">
							<xsl:value-of select="normalize-space(.)"/>
 					    </xsl:variable> 			
 					    <xsl:choose>																						
								<xsl:when test="substring( $norm_auth, string-length($norm_auth), string-length($norm_auth)+1) = ',' ">
									<orgname>
										<xsl:value-of select="substring( $norm_auth, 0, string-length($norm_auth))"/>
									</orgname>
								</xsl:when>
								<xsl:otherwise>												
										<personname>
											<surname><xsl:value-of select="substring-before($norm_auth,',')"/></surname>
											<xsl:variable name="name-after" select="substring-after($norm_auth,',')"/>
											<xsl:choose>
												<xsl:when test="contains($name-after,',')">
													<firstname><xsl:value-of select="substring-before($name-after,',')"/></firstname>	
													<honorific><xsl:value-of select="substring-after($name-after,',')"/></honorific>
												</xsl:when>
												<xsl:when test="contains($name-after,'.')">
													<othername role="mi"><xsl:value-of select="substring-before($name-after,'.')"/></othername>	
													<othername role="fi"><xsl:value-of select="substring-after($name-after,'.')"/></othername>
												</xsl:when>
												<xsl:otherwise>
													<firstname><xsl:value-of select="substring-after($norm_auth,',')"/></firstname>
												</xsl:otherwise>
											</xsl:choose>																																										
										</personname>
										<address><xsl:apply-templates select="../auth-address"/></address>
								</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="../auth-affiliation"/>					    
					</author>
				</xsl:for-each>
	</xsl:template>
	
	<!--Cardinality: 0 to 1-->
	<xsl:template match="/records/record/periodical" >	
		<xsl:if test="./*">
			<biblioset xmlns="http://docbook.org/ns/docbook" relation="journal">
				<xsl:call-template name="periodical_bblset_cont"/>			
			</biblioset>
		</xsl:if>
	</xsl:template>	
	
	<xsl:template name="periodical_bblset_cont">
			<xsl:if test="./full-title">
				<title xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(./full-title)"/></title>					
			</xsl:if>
			<xsl:if test="./abbr-1">
				<abbrev xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(./abbr-1)"/></abbrev>				
			</xsl:if>
			<xsl:if test="./abbr-2">
				<abbrev xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(./abbr-2)"/></abbrev>				
			</xsl:if>
			<xsl:if test="./abbr-3">
				<abbrev xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(./abbr-3)"/></abbrev>				
			</xsl:if>
			 <xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
			</xsl:call-template>
			<xsl:apply-templates select="../pages"/>
			<xsl:apply-templates select="../volume"/>
			<xsl:apply-templates select="../keywords"/>		
	</xsl:template>
		
	<xsl:template match="/records/record/number">							
		<date xmlns="http://docbook.org/ns/docbook" role="cit">
				<xsl:value-of select="normalize-space(.)"/>
		</date>			
	</xsl:template>
	
	<xsl:template match="/records/record/issue">							
		<issuenum xmlns="http://docbook.org/ns/docbook">
				<xsl:value-of select="normalize-space(.)"/>
		</issuenum>			
	</xsl:template>
	
	<xsl:template match="/records/record/secondary-issue">							
		<issuenum xmlns="http://docbook.org/ns/docbook" role="secondary">
				<xsl:value-of select="normalize-space(.)"/>
		</issuenum>			
	</xsl:template>

	<!--Cardinality: 0 to 1-->
	<xsl:template match="/records/record/pages">									
		<pagenums xmlns="http://docbook.org/ns/docbook" ><xsl:value-of select="normalize-space(.)"/></pagenums>			
	</xsl:template>	
	
	<!--Cardinality: 0 to 1-->
	<xsl:template match="/records/record/volume">									
		<volumenum xmlns="http://docbook.org/ns/docbook" ><xsl:value-of select="normalize-space(.)"/></volumenum>			
	</xsl:template>	
	
	<xsl:template match="/records/record/secondary-volume">									
		<volumenum xmlns="http://docbook.org/ns/docbook" role="secondary"><xsl:value-of select="normalize-space(.)"/></volumenum>			
	</xsl:template>	
	
	<xsl:template match="/records/record/num-vols">									
		<manvolnum  xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(.)"/></manvolnum>			
	</xsl:template>	

	<xsl:template match="/records/record/edition">		
			<edition xmlns="http://docbook.org/ns/docbook">
				<xsl:value-of select="normalize-space(.)"/>		
			</edition>	
	</xsl:template>
	
	<xsl:template match="/records/record/section">	
		<bibliomisc xmlns="http://docbook.org/ns/docbook" role="secnum">
			<xsl:value-of select="concat('Section', normalize-space(.))"/>				
		</bibliomisc>
	</xsl:template>
	
	<xsl:template match="/records/record/reprint-edition">							
		<edition xmlns="http://docbook.org/ns/docbook" class="reprint">
				<xsl:value-of select="normalize-space(.)"/>
		</edition>			
	</xsl:template>
	
	<xsl:template match="/records/record/reprint-status">							
		<printhistory xmlns="http://docbook.org/ns/docbook" role="reprint">
			<para><xsl:value-of select="concat(normalize-space(./@date), normalize-space(./@status))"/></para>				
		</printhistory>			
	</xsl:template>

	
	<xsl:template match="/records/record/auth-affiliation">					
		<affiliation xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(.)"/></affiliation>.
	</xsl:template>
	
	<xsl:template match="/records/record/auth-address">					
		<affiliation xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(.)"/></affiliation>.
	</xsl:template>

	<!--Publisher information-->
	<xsl:template match="/records/record/pub-location">					
		<address xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(.)"/></address>
	</xsl:template>
	
	<xsl:template match="/records/record/publisher">			
		<publishername xmlns="http://docbook.org/ns/docbook"><xsl:value-of select="normalize-space(.)"/></publishername>
	</xsl:template>

	<xsl:template match="/records/record/orig-pub">			
		<publishername xmlns="http://docbook.org/ns/docbook" role="original"><xsl:value-of select="normalize-space(.)"/></publishername>
	</xsl:template>
	
	<xsl:template name ="date_selector">
	<xsl:param name="dtnode"/>		
			<xsl:choose>
				<xsl:when test="$dtnode = 'copyright-date'">
					<xsl:for-each select="./dates/copyright-date/*">
						<copyright xmlns="http://docbook.org/ns/docbook">
							<year xmlns="http://docbook.org/ns/docbook">
								<xsl:value-of select="normalize-space(.)"/>
							</year>
						</copyright>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$dtnode = 'pub-dates' ">	
					<xsl:for-each select="./dates/pub-dates/*">
						<pubdate xmlns="http://docbook.org/ns/docbook">						
							<xsl:value-of select="normalize-space(.)"/>														
						</pubdate>
					</xsl:for-each>
				</xsl:when>						
				<xsl:when test="$dtnode = 'year' ">							
					<pubdate xmlns="http://docbook.org/ns/docbook">
						<xsl:value-of select="normalize-space(./dates/year)"/>												
					</pubdate>
				</xsl:when>	
			</xsl:choose>					
	</xsl:template>
	
	
	<!--keywords Cardinality: 0 to 1-->
	<xsl:template match="/records/record/keywords">									
		<keywordset xmlns="http://docbook.org/ns/docbook" >
			<xsl:for-each select="./*">
					<keyword><xsl:value-of select="normalize-space(.)"/></keyword>
			</xsl:for-each>
		</keywordset>	
	</xsl:template>	
	
	<!--isbn Cardinality: 0 to 1-->
	<xsl:template match="/records/record/isbn">									
		<biblioid xmlns="http://docbook.org/ns/docbook" class="isbn">
			<xsl:value-of select="normalize-space(.)"/>
		</biblioid>	
	</xsl:template>	
	
	<xsl:template match="/records/record/accession-num">									
		<biblioid xmlns="http://docbook.org/ns/docbook" class="other">
			<xsl:value-of select="normalize-space(.)"/>
		</biblioid>	
	</xsl:template>	
	
	<xsl:template match="/records/record/call-num">									
		<biblioid xmlns="http://docbook.org/ns/docbook" class="other">
			<xsl:value-of select="normalize-space(.)"/>
		</biblioid>	
	</xsl:template>	
	
	<xsl:template match="/records/record/report-id">									
		<biblioid xmlns="http://docbook.org/ns/docbook" class="other">
			<xsl:value-of select="normalize-space(.)"/>
		</biblioid>	
	</xsl:template>	
	
	<xsl:template match="/records/record/coden">									
		<biblioid xmlns="http://docbook.org/ns/docbook" class="other">
			<xsl:value-of select="normalize-space(.)"/>
		</biblioid>	
	</xsl:template>	
	
	<xsl:template match="/records/record/electronic-resource-num">									
		<biblioid xmlns="http://docbook.org/ns/docbook" class="other">
			<xsl:value-of select="normalize-space(.)"/>
		</biblioid>	
	</xsl:template>	

	
	 <!--abstract Cardinality: 0 to 1-->
	 <xsl:template match="/records/record/abstract">									
		<abstract xmlns="http://docbook.org/ns/docbook">
			<para>
				<xsl:value-of select="normalize-space(.)"/>
			</para>
		</abstract>	
	</xsl:template>	
	 
	 
	 <!--notes Cardinality: 0 to 1-->
	 <xsl:template match="/records/record/notes">									
		<bibliomisc xmlns="http://docbook.org/ns/docbook" role="notes">
			<xsl:value-of select="normalize-space(.)"/>
		</bibliomisc>	
	</xsl:template>	
		 
	 <xsl:template match="/records/record/image">									
		<mediaobject xmlns="http://docbook.org/ns/docbook" >
			<imageobject>
				<imagedata>
					<xsl:attribute name="fileref"><xsl:value-of select="normalize-space(./@file)"/></xsl:attribute>					
				</imagedata>
			</imageobject>
		</mediaobject>	
	</xsl:template>	

	<!--urls Cardinality: 0 to 1
		level 1 children cardinality: 0 to 1
		level	2 children cardinality 1 to many	-->
	<xsl:template match="/records/record/urls">	
		<xsl:for-each select="./*/*">
			<biblioid xmlns="http://docbook.org/ns/docbook" class="uri">				
					<xsl:value-of select="normalize-space(.)"/>			
			</biblioid>	
		</xsl:for-each>		
	</xsl:template>	
	
		 
			<xsl:template name="article">		  
			<!--doc type article;Articles, etc., in serials-->			
				 <biblioset xmlns="http://docbook.org/ns/docbook" relation="article">
					 <authorgroup xmlns="http://docbook.org/ns/docbook">
						 <xsl:apply-templates select="contributors"/>
					 </authorgroup>					  	
					 <title xmlns="http://docbook.org/ns/docbook" >
						<xsl:call-template name="title_selector">					
						 <xsl:with-param name="title_child" select=" 'title' "/>
						</xsl:call-template>
					 </title>					 
				</biblioset>
				<xsl:apply-templates select="periodical"/>							 
			</xsl:template>
			 
			<xsl:template name="monograph">	
			 <!--doc type monogrph; Monograph-->				
				  <title xmlns="http://docbook.org/ns/docbook">
		  				  <xsl:call-template name="title_selector" ><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>				  
				  </title>
				  <bibliomisc xmlns="http://docbook.org/ns/docbook" role="series">
					  <xsl:call-template name="title_selector" ><xsl:with-param name="title_child" select=" 'secondary-title' "/></xsl:call-template>
				  </bibliomisc>
				  <authorgroup xmlns="http://docbook.org/ns/docbook">
					  <xsl:apply-templates select="contributors"/>
				  </authorgroup>
				  <publisher xmlns="http://docbook.org/ns/docbook">
					  <xsl:apply-templates select="publisher"/>
					  <xsl:apply-templates select="pub-location"/>
				  </publisher>
				  <xsl:call-template name="date_selector">
					<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
				  </xsl:call-template>
				    <xsl:call-template name="date_selector">
					<xsl:with-param name="dtnode" select=" 'year' "/>
				  </xsl:call-template>				  				  
			 </xsl:template>			 
			
			<xsl:template name="serial_article">	
             <!--doc type serial/article;Electronic Serial, Entire/Electronic Serial, Article--> 			 
				<xsl:apply-templates select="titles"/>
				<authorgroup xmlns="http://docbook.org/ns/docbook">
					<xsl:apply-templates select="contributors"/>
				</authorgroup>
				<publisher xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="publisher"/>
						<xsl:apply-templates select="pub-location"/>
				</publisher>
				<xsl:call-template name="date_selector">
					<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
				  </xsl:call-template>
				  <xsl:call-template name="date_selector">
					<xsl:with-param name="dtnode" select=" 'year' "/>
				  </xsl:call-template>		
				<xsl:apply-templates select="number"/>
			 </xsl:template>
  			 
			 <xsl:template name="parts_mg">	
  			 <!--doc type part;Parts of monograph-->  			 
					<authorgroup xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="contributors"/>
					</authorgroup>
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>
					</title>
					<xsl:apply-templates select="edition"/>
					<xsl:apply-templates select="volume"/>
					<publisher>
						<xsl:apply-templates select="publisher"/>
						<xsl:apply-templates select="pub-location"/>
						<xsl:apply-templates select="orig-pub"/>
					</publisher>
					<xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="section"/>
					<xsl:apply-templates select="pages"/>
			 </xsl:template>
			
			<xsl:template name="parts_mgs">	
				<!--doc type part;Monographs, databases and computer programs, Parts-->  			 
					<authorgroup xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="contributors"/>
					</authorgroup>
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>
					</title>
					<xsl:apply-templates select="edition"/> 	
					<publisher xmlns="http://docbook.org/ns/docbook">
					  <xsl:apply-templates select="publisher"/>
					  <xsl:apply-templates select="pub-location"/>
				  </publisher>
				  <xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="number"/>
					<xsl:apply-templates select="section"/>
					<xsl:apply-templates select="urls"/>
			 </xsl:template>
			 
			 
			 <xsl:template name="monographs">	
			<!--doc type monograph;Monographs, databases and computer programs, Entire-->  			 
					<authorgroup xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="contributors"/>
					</authorgroup>
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>
					</title>
					<xsl:apply-templates select="edition"/> 	
					<publisher xmlns="http://docbook.org/ns/docbook">
					  <xsl:apply-templates select="publisher"/>
					  <xsl:apply-templates select="pub-location"/>
				    </publisher>
				  <xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="number"/>
					<xsl:apply-templates select="section"/>
					<xsl:apply-templates select="urls"/>
			 </xsl:template>
						
			 <xsl:template name="contribution_multi">	
			 <!--doc type contribution; Monographs, databases and computer programs, Contributions-->  			 
				 <biblioset relation = "part">
					<authorgroup xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="contributors"/>
					</authorgroup>
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>
					</title>
				</biblioset>
				<biblioset relation = "book">
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'secondary' "/></xsl:call-template>
					</title>
					<xsl:apply-templates select="edition"/> 	
					<publisher xmlns="http://docbook.org/ns/docbook">
					  <xsl:apply-templates select="publisher"/>
					  <xsl:apply-templates select="pub-location"/>
				    </publisher>
				     <xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="isbn"/>
				</biblioset>
			 </xsl:template>

			 <xsl:template name="messagesystem">	
			<!--docbook type messagesystem; Entire Message System-->  			 
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>
					</title>
					<publisher xmlns="http://docbook.org/ns/docbook">
						  <xsl:apply-templates select="publisher"/>
						  <xsl:apply-templates select="pub-location"/>
				    </publisher>
				      <xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="number"/>
					<xsl:apply-templates select="urls"/>
			 </xsl:template>
			 
			 <xsl:template name="message">
			<!--docbook type message; Electronic Messages-->  			 
				 <biblioset relation="part">
					<authorgroup xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="contributors"/>
					</authorgroup>
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'title' "/></xsl:call-template>
					</title>
				</biblioset>
				<biblioset relation="book">
					<title xmlns="http://docbook.org/ns/docbook">
						<xsl:call-template name="title_selector"><xsl:with-param name="title_child" select=" 'secondary' "/></xsl:call-template>
					</title>
					<publisher xmlns="http://docbook.org/ns/docbook">
						  <xsl:apply-templates select="publisher"/>
						  <xsl:apply-templates select="pub-location"/>
				    </publisher>
				    <xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="number"/>
					<xsl:apply-templates select="urls"/>
				</biblioset>
			 </xsl:template>
			 
						
			 <xsl:template name="serial">
			 <!--docbook type serial; Serials-->  			 
					 <title xmlns="http://docbook.org/ns/docbook" >
						<xsl:call-template name="title_selector">						
						 <xsl:with-param name="title_child" select=" 'title' "/>
						</xsl:call-template>
					</title>
					<xsl:apply-templates select="edition"/>
					<xsl:call-template name="date_selector">
						<xsl:with-param name="dtnode" select=" 'pub-dates' "/>
					</xsl:call-template>
					<xsl:apply-templates select="isbn"/>
			 </xsl:template>
			
			 <!--docbook type contribution; Contributions to monographs-->
			<xsl:template name="contributions">					 
				<biblioset xmlns="http://docbook.org/ns/docbook" relation="part">
					 <xsl:apply-templates select="contributors"/>
					 <title xmlns="http://docbook.org/ns/docbook" >
						<xsl:call-template name="title_selector">						
						 <xsl:with-param name="title_child" select=" 'title' "/>
						</xsl:call-template>
					</title>					
				</biblioset>
				<biblioset xmlns="http://docbook.org/ns/docbook" relation="book">
					 <xsl:apply-templates select="contributors"/>
					 <title xmlns="http://docbook.org/ns/docbook" >
						<xsl:call-template name="title_selector">						
							<xsl:with-param name="title_child" select=" 'secondary-title' "/>
						</xsl:call-template>
					 </title>					 
					 <publisher xmlns="http://docbook.org/ns/docbook">
						<xsl:apply-templates select="publisher"/>
						<xsl:apply-templates select="pub-location"/>					
					</publisher>
						<xsl:call-template name="date_selector">
							<xsl:with-param name="dtnode" select=" 'pub-date' "/>
						</xsl:call-template>
						<xsl:call-template name="date_selector">
							<xsl:with-param name="dtnode" select=" 'year' "/>
						</xsl:call-template>		
						<xsl:apply-templates select="volume"/>
						<xsl:apply-templates select="pages"/>
				</biblioset>
			 </xsl:template>							
	
</xsl:stylesheet>

