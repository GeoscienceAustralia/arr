<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:d="http://docbook.org/ns/docbook"
   xmlns:exsl="http://exslt.org/common"
   xmlns:str="http://exslt.org/strings"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:stext="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.TextFactory"
   xmlns:simg="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.ImageIntrinsics"
   xmlns:ximg="xalan://com.nwalsh.xalan.ImageIntrinsics"
   xmlns:xtext="xalan://com.nwalsh.xalan.Text"
   xmlns:lxslt="http://xml.apache.org/xslt"
   exclude-result-prefixes="xlink stext xtext str lxslt simg ximg d exsl"
   extension-element-prefixes="stext xtext"
   version="1.0">
   <!-- ARR STYLE CHUNK COMMON
    It is the objects that are common between the vanila XHTML5 build and the
    stripped down build suitable for the AJAX deployment.  See also:
    arr_style_chunk_common.xsl which contains the code that is common across
    chunking and EPUB.
    
    Dr Peter Brady <peter.brady@wmawater.com.au>
    2016-03-30 -->

   <!-- Import the common XHTML5 stylesheet: -->
   <xsl:import href="arr_style_xhtml5_common.xsl" />

   <!-- Chunk Specific Options -->
   <xsl:param name="chunker.output.indent">yes</xsl:param>
   <xsl:param name="chunk.section.depth">0</xsl:param>

   <!-- Graphic Parameters 
      Designed to not write into a table and use BootStrap and CSS
      to format. First we set an override parameter to dump the
      table formatting.  Then we override the default d:imagedata
      template to insert:
        -) CSS elements for bootstrap
        -) link elements for lightbox.
      -->
   <xsl:param name="make.graphic.viewport">0</xsl:param>
   <xsl:template match="d:imagedata">
      <xsl:variable name="filename">
         <xsl:call-template name="mediaobject.filename">
            <xsl:with-param name="object" select=".."/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <!-- Handle MathML and SVG markup in imagedata -->
         <xsl:when xmlns:mml="http://www.w3.org/1998/Math/MathML" test="mml:*">
            <xsl:apply-templates/>
         </xsl:when>

         <xsl:when xmlns:svg="http://www.w3.org/2000/svg" test="svg:*">
            <xsl:apply-templates/>
         </xsl:when>

         <xsl:when test="@format='linespecific'">
            <xsl:choose>
               <xsl:when test="$use.extensions != '0'                         and $textinsert.extension != '0'">
                  <xsl:choose>
                     <xsl:when test="element-available('stext:insertfile')">
                        <stext:insertfile href="{$filename}" encoding="{$textdata.default.encoding}"/>
                     </xsl:when>
                     <xsl:when test="element-available('xtext:insertfile')">
                        <xtext:insertfile href="{$filename}"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:message terminate="yes">
                           <xsl:text>No insertfile extension available.</xsl:text>
                        </xsl:message>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <a xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad" href="{$filename}"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="longdesc.uri">
               <xsl:call-template name="longdesc.uri">
                  <xsl:with-param name="mediaobject" select="ancestor::d:imageobject/parent::*"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="phrases" select="ancestor::d:mediaobject/d:textobject[d:phrase]                             |ancestor::d:inlinemediaobject/d:textobject[d:phrase]                             |ancestor::d:mediaobjectco/d:textobject[d:phrase]"/>

            <xsl:element name="a">
               <xsl:attribute name="href">
                  <xsl:value-of select="$filename"/>
               </xsl:attribute>
               <xsl:attribute name="data-lightbox">
                  <xsl:value-of select="$filename"/>
               </xsl:attribute>
               <xsl:attribute name="data-title">
                  <xsl:value-of select="ancestor::d:mediaobject/preceding-sibling::d:title[1]"/>
               </xsl:attribute>
               <xsl:call-template name="process.image">
                  <xsl:with-param name="alt">
                     <xsl:choose>
                        <xsl:when test="ancestor::d:mediaobject/d:alt">
                           <xsl:apply-templates select="ancestor::d:mediaobject/d:alt"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:apply-templates select="$phrases[not(@role) or @role!='tex'][1]"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:with-param>
                  <xsl:with-param name="longdesc">
                     <xsl:call-template name="write.longdesc">
                        <xsl:with-param name="mediaobject" select="ancestor::d:imageobject/parent::*"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:element>

            <xsl:if test="$html.longdesc != 0 and $html.longdesc.link != 0                     and ancestor::d:imageobject/parent::*/d:textobject[not(d:phrase)]">
               <xsl:call-template name="longdesc.link">
                  <xsl:with-param name="longdesc.uri" select="$longdesc.uri"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   

   <!-- Template override to provide front matter for ARR, eg copyright, ministers text, etc -->
   <xsl:template match="d:set">
      <xsl:call-template name="id.warning"/>

      <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
         <xsl:apply-templates select="." mode="common.html.attributes"/>
         <xsl:call-template name="id.attribute">
            <xsl:with-param name="conditional" select="0"/>
         </xsl:call-template>
         <xsl:call-template name="dir">
            <xsl:with-param name="inherit" select="1"/>
         </xsl:call-template>
         <xsl:call-template name="language.attribute"/>
         <xsl:if test="$generate.id.attributes != 0">
            <xsl:attribute name="id">
               <xsl:call-template name="object.id"/>
            </xsl:attribute>
         </xsl:if>

         <xsl:call-template name="set.titlepage"/>

         <xsl:variable name="toc.params">
            <xsl:call-template name="find.path.params">
               <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
            </xsl:call-template>
         </xsl:variable>

         <xsl:call-template name="make.lots">
            <xsl:with-param name="toc.params" select="$toc.params"/>
            <xsl:with-param name="toc">
               <xsl:call-template name="set.toc">
                  <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
               </xsl:call-template>
            </xsl:with-param>
         </xsl:call-template>

         <xsl:apply-templates/>
         <!-- Insert content between this comment and the corresponding end
              comment below any text that you would like to appear as a
              block below the front page TOC.  This is intended to be items
              such as preface, copyright, foreword from minister.
              NB: it MUST be well formatted XHTML.
              To assist with this process see the files inside the directory:
                  book_front_matter
              These are generally edited by hand and then updated in here.
              Its a total hack but Docbook does not support large paragraph
              blocks in a set and I've not customised a titlepage to do the
              same.
              Peter Brady <peter.brady@wmawater.com.au 2016-03-30 -->
         <hr/>
         <a href="http://creativecommons.org/licenses/by/4.0/"><img src="figures/88x31_cc_40_by.png" alt="Creative Commons License Logo"/></a>
         <p>The Australian Rainfall and Runoff: A guide to flood estimation (ARR) is licensed under the Creative Commons Attribution 4.0 Licence, unless otherwise indicated or marked.</p> 

         <p><strong>Please give attribution to</strong>: © Commonwealth of Australia (Geoscience Australia) 2015.</p>

         <h3>Third-Party Material</h3> 

         <p>The Commonwealth of Australia and the ARR’s contributing authors (through Engineers Australia) have taken steps to both identify third-party material and secure permission for its reproduction and reuse. However, please note that where these materials are not licensed under a Creative Commons licence or similar terms of use, you should obtain permission from the relevant third-party to reuse their material beyond the ways you are legally permitted to use them under the fair dealing provisions of the <a href="http://www.comlaw.gov.au/Details/C2014C00291">Copyright Act 1968</a>.</p>


         <p>
            For further information about the copyright in this document, please contact:<br/>
            Intellectual Property and Copyright Manager<br/>
            Corporate Branch<br/>
            Geoscience Australia<br/>
            GPO Box 378<br/>
            CANBERRA ACT 2601<br/>
            Phone: +61 2 6249 9367 or email: <a href="mailto:copyright@ga.gov.au">copyright@ga.gov.au</a>
         </p>


         <p>ISBN Pending Publication March 2016</p>

         <p>How to reference this book:<br/>
            Ball, J (Ed), Australian Rainfall and Runoff: A Guide to Flood Estimation – Draft for Industry Comment 151205, © Commonwealth of Australia (Geoscience Australia), 2015.</p>  

         <h2>ARR 2016 Ministerial Foreword</h2>

         <p>In late 2010 and early 2011 Queensland and Victoria were devastated by a series of storms, floods and cyclones that resulted in loss of life, significant property damage and financial loss for many communities. Events such as these highlight the challenges in predicting these extreme events as well as managing their impacts.</p>

         <p>The Australian Government recognised this challenge and committed to the comprehensive revision of the Australia Rainfall and Runoff (ARR) guidelines.</p>

         <p>ARR 2016 will have national application and will be essential for policy decisions and projects in areas as diverse as:</p>

         <ul>
            <li>infrastructure such as roads, rail airports, bridges, dams, stormwater and sewer systems</li>
            <li>town planning</li>
            <li>mining</li>
            <li>developing flood management plan for urban and rural communities</li>
            <li>flood warnings and flood emergency management </li>
            <li>operation of regulated river systems, and</li>
            <li>prediction of extreme flood levels.</li>
         </ul>

         <p>The ARR was last updated in 1997. Since then, our understanding of the complexity of the Australian landscape has grown. This understanding has been gained through the collection and analysis of new data, reflective of Australia’s variable landscape. In previous versions of the ARR, only limited Australian data was available so overseas models were applied in many cases. The 2016 revision includes all Australian data, including a national database of extreme flood hazards and 30 years of over 8000 rainfall gauges across the Nation. Not only does the ARR 2016 make use of rich historical data but its dynamic development will allow new data and information to be used as it becomes available. </p>

         <p>The revision of the ARR would not have been possible without the support and funding from the Australian Government as well as the significant contributions from Engineers Australia members, flood practitioners and academia. This collaborative effort is a testament of the community, industry, academia and government to improve our understanding the nature of flooding to reduce the social and economic impacts will contribute to building resilient communities. </p>


         <p><img src="figures/88x32_andrews_sig.png" alt="Ministers Signature"/><br/>
            The Hon Karen Andrews MP<br/>
            Assistant Minister for Science</p>

         <h2>PREFACE</h2>
         <p>Since its first publication in 1958, Australian Rainfall and Runoff (ARR) has remained one of the most influential and widely used guidelines published by Engineers Australia (EA).  The 3rd edition, published in 1987, retained the same level of national and international acclaim as its predecessors. </p>

         <p>With nationwide applicability, balancing the varied climates of Australia, the information and the approaches presented in Australian Rainfall and Runoff are essential for policy decisions and projects involving:</p>

         <ul>
            <li>infrastructure such as roads, rail, airports, bridges, dams, stormwater and sewer systems;</li>
            <li>town planning;</li>
            <li>mining;</li>
            <li>developing flood management plans for urban and rural communities;</li>
            <li>flood warnings and flood emergency management;</li>
            <li>operation of regulated river systems; and</li>
            <li>prediction of extreme flood levels.</li>
         </ul>

         <p>However, many of the practices recommended in the 1987 edition of ARR have become outdated, and no longer represent the accepted views of professionals, both in terms of technique and approach to water management. This fact, coupled with greater understanding of climate and climatic influences makes the securing of current and complete rainfall and streamflow data and expansion of focus from flood events to the full spectrum of flows and rainfall events, crucial to maintaining an adequate knowledge of the processes that govern Australian rainfall and streamflow in the broadest sense, allowing better management, policy and planning decisions to be made.</p>

         <p>One of the major responsibilities of the National Committee on Water Engineering of Engineers Australia is the periodic revision of ARR. While the NCWE had long identified the need to update ARR it had become apparent by 2002 that even with a piecemeal approach the task could not be carried out without significant financial support. In 2008 the revision of ARR was identified as a priority in the Council of Australian Governments endorsed National Adaptation Framework for Climate Change.</p>

         <p>In addition to the update 21 projects were identified with the aim of filling knowledge gaps.  Funding for Stages 1 and 2 of the ARR revision projects were provided by the now Department of the Environment. Stage 3 was funded by Geoscience Australia. Funding for Stages 2 and 3 of Project 1 (Development of Intensity-Frequency-Duration information across Australia) has been provided by the Bureau of Meteorology. The outcomes of the projects assisted the ARR Editorial Team with the compiling and writing of chapters in the revised ARR. Steering and Technical Committees were established to assist the ARR Editorial Team in guiding the projects to achieve desired outcomes.</p>

         <table>
            <tbody>
               <tr>
                  <td>
                     <p>Assoc Prof James Ball<br/>
                        ARR Editor<br/>
                        <img src="figures/88x63_ball_signature.png" alt="Ball Signature"/>
                     </p>
                  </td>
                  <td>
                     <p>Mark Babister<br/>
                        Chair Technical Committee for ARR Revision Projects<br/>
                        <img src="figures/88x23_babister_signature.png" alt="Babister Signature"/>
                     </p>
                  </td>
               </tr>
            </tbody>
         </table>


         <h2>ARR Technical Committee</h2>

         <p>Chair: Mark Babister</p>

         <p>Members:</p>
         <ul>
            <li>Associate Professor James Ball</li>
            <li>Professor George Kuczera</li>
            <li>Professor Martin Lambert</li>
            <li>Dr Rory Nathan </li>
            <li>Dr Bill Weeks</li>
            <li>Associate Professor Ashish Sharma</li>
            <li>Dr Bryson Bates</li>
            <li>Steve Finlay</li>
         </ul>

         <p>Related Appointments:</p>
         <p>ARR Project Engineer: Monique Retallick<br/>
            ARR Admin Support: Isabelle Testoni<br/>
            Assisting TC on Technical Matters: Erwin Weinmann, Dr Michael Leonard</p>

         <h2>Status of this document</h2>

         <p>This document forms part of an industry consultation release of Australian Rainfall and Runoff. We anticipate a complete launch by March 2016.</p>

         <p>In development of this guidance, also discussed in Book 1 of ARR 1987, it was recognised that knowledge and information availability is not fixed and that future research and applications will develop new techniques and information. This is particularly relevant in applications where techniques have been extrapolated from the region of their development to other regions and where efforts should be made to reduce large uncertainties in current estimates of design flood characteristics.</p>

         <p>Therefore, where circumstances warrant, designers have a duty to use other procedures and design information more appropriate for their design flood problem. The authorship team of this edition of Australian Rainfall and Runoff believe that the use of new or improved procedures should be encouraged, especially where these are more appropriate than the methods described in this publication.</p>

         <p>Therefore where relevant this draft of ARR can be used in practice prior to finalisation.</p>

         <p>Care should be taken when combining inputs derived using ARR 1987 and methods described in this document.</p>

         <p>A summary of the status:</p>

         <table border="1">
            <tbody>
               <tr>
                  <th scope="col"><p>Book</p></th>
                  <th scope="col"><p>Content</p></th>
                  <th scope="col"><p>Graphs and Figures</p></th>
                  <th scope="col"><p>Examples</p></th>
               </tr>
               <tr>
                  <td><p>Book 1</p></td>
                  <td><p>Advanced Draft</p></td>
                  <td><p>Advanced Draft</p></td>
                  <td><p>Advanced Draft</p></td>
               </tr>
               <tr>
                  <td><p>Book 2</p></td>
                  <td><p>Working Draft</p></td>
                  <td><p>Working Draft</p></td>
                  <td><p>Working Draft</p></td>
               </tr>
               <tr>
                  <td><p>Book 3</p></td>
                  <td><p>Advanced Draft</p></td>
                  <td><p>Advanced Draft</p></td>
                  <td><p>Advanced Draft</p></td>
               </tr>
               <tr>
                  <td><p>Book 4</p></td>
                  <td><p>In Preparation</p></td>
                  <td><p>In Preparation</p></td>
                  <td><p>In Preparation</p></td>
               </tr>
               <tr>
                  <td><p>Book 5</p></td>
                  <td><p>Working Draft</p></td>
                  <td><p>Working Draft</p></td>
                  <td><p>Working Draft</p></td>
               </tr>
               <tr>
                  <td><p>Book 6</p></td>
                  <td><p>Working Draft</p></td>
                  <td><p>Working Draft</p></td>
                  <td><p>Working Draft</p></td>
               </tr>
               <tr>
                  <td><p>Book 7</p></td>
                  <td><p>In Preparation</p></td>
                  <td><p>In Preparation</p></td>
                  <td><p>In Preparation</p></td>
               </tr>
               <tr>
                  <td><p>Book 8</p></td>
                  <td><p>Advanced Draft</p></td>
                  <td><p>Advanced Draft</p></td>
                  <td><p>Advanced Draft</p></td>
               </tr>
               <tr>
                  <td><p>Book 9</p></td>
                  <td><p>In Preparation</p></td>
                  <td><p>In Preparation</p></td>
                  <td><p>In Preparation</p></td>
               </tr>
            </tbody>
         </table>
      <!-- END OF FRONT PIECE BLOCK -->
   </xsl:element>
</xsl:template>

</xsl:stylesheet>
