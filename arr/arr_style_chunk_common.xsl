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
         <a href="http://creativecommons.org/licenses/by/4.0/"><img src="figures/88x31_cc_40_by.png"
            alt="Creative Commons License Logo" /></a>
         <p>The Australian Rainfall and Runoff: A guide to flood estimation (ARR) is licensed under 
            the Creative Commons Attribution 4.0 Licence, unless otherwise indicated or marked.</p> 
         
         <p><strong>Please give attribution to</strong>: © Commonwealth of Australia 
            (Geoscience Australia) 2019.</p>   
         
         <h3>Third-Party Material</h3>
         
         <p>The Commonwealth of Australia and the ARR’s contributing authors (through Engineers 
            Australia) have taken steps to both identify third-party material and secure permission 
            for its reproduction and reuse. However, please note that where these materials are 
            not licensed under a Creative Commons licence or similar terms of use, you should 
            obtain permission from the relevant third-party to reuse their material beyond the 
            ways you are legally permitted to use them under the fair dealing provisions of the 
            <a href="http://www.comlaw.gov.au/Details/C2014C00291">Copyright Act 1968</a></p>.  
         
         
         <p>If you have any questions about the copyright of the ARR, please contact:<br/>  
            arr_admin@arr.org.au<br/>
            c/o 11 National Circuit,<br/>
            Barton, ACT</p>
         
         <p>ISBN 978-1-925297-07-2</p>
         
         <p><strong>How to reference this book:</strong><br/>
            Ball J, Babister M, Nathan R, Weeks W, Weinmann E, Retallick M, Testoni I, (Editors) 
            Australian Rainfall and Runoff: A Guide to Flood Estimation, © Commonwealth of 
            Australia (Geoscience Australia), 2019.</p>
         
         <p><strong>How to reference Book 9: Runoff in Urban Areas:</strong><br/>
            Coombes, P., and Roso, S. (Editors), 2019 Runoff in Urban Areas, Book 9 in Australian 
            Rainfall and Runoff - A Guide to Flood Estimation, Commonwealth of Australia, © 
            Commonwealth of Australia (Geoscience Australia), 2019.</p>
         
         
         <h2>PREFACE</h2>
         
         <p>Since its first publication in 1958, Australian Rainfall and Runoff (ARR) has remained 
            one of the most influential and widely used guidelines published by Engineers Australia 
            (EA).  The 3rd edition, published in 1987, retained the same level of national and 
            international acclaim as its predecessors.</p> 
         
         <p>With nationwide applicability, balancing the varied climates of Australia, the 
            information and the approaches presented in Australian Rainfall and Runoff are 
            essential for policy decisions and projects involving:</p>
         
         <ul>
            <li>infrastructure such as roads, rail, airports, bridges, dams, stormwater and sewer systems;</li>
            <li>town planning;</li>
            <li>mining;</li>
            <li>developing flood management plans for urban and rural communities;</li>
            <li>flood warnings and flood emergency management;</li>
            <li>operation of regulated river systems; and</li>
            <li>prediction of extreme flood levels.</li>
         </ul>
         
         <p>However, many of the practices recommended in the 1987 edition of ARR have become 
            outdated, and no longer represent industry best practice. This fact, coupled with 
            the greater understanding of climate and flood hydrology derived from the larger 
            data sets now available to us, has provided the primary impetus for revising these 
            guidelines. It is hoped that this revision will lead to improved design practice, 
            which will allow better management, policy and planning decisions to be made.</p>
         
         <p>One of the major responsibilities of the National Committee on Water Engineering 
            of Engineers Australia is the periodic revision of ARR. While the NCWE had long 
            identified the need to update ARR it had become apparent by 2002 that even with 
            a piecemeal approach the task could not be carried out without significant financial 
            support. In 2008 the revision of ARR was identified as a priority in the National 
            Adaptation Framework for Climate Change which was endorsed by the Council of 
            Australian Governments.</p>
         
         <p>In addition to the update, 21 projects were identified with the aim of filling 
            knowledge gaps. Funding for Stages 1 and 2 of the ARR revision projects were 
            provided by the now Department of the Environment. Stage 3 was funded by Geoscience 
            Australia. Funding for Stages 2 and 3 of Project 1 
            (Development of Intensity-Frequency-Duration information across Australia) has been 
            provided by the Bureau of Meteorology. The outcomes of the projects assisted the 
            ARR Editorial Team with the compiling and writing of chapters in the revised ARR. 
            Steering and Technical Committees were established to assist the ARR Editorial Team 
            in guiding the projects to achieve desired outcomes.</p>
         
         <table class="blank_table">
            <tbody>
               <tr>
                  <td>
                     <p>Assoc Prof James Ball<br /> ARR Editor<br />
                        <img src="figures/88x63_ball_signature.png" alt="Ball Signature" />
                     </p>
                  </td>
                  <td>
                     <p>Mark Babister<br /> Chair Technical Committee for ARR Revision Projects<br />
                        <img src="figures/88x23_babister_signature.png" alt="Babister Signature" />
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
         
         <p>ARR Project Engineer: Monique Retallick<br /> ARR Admin Support: Isabelle Testoni<br />
            Assisting TC on Technical Matters: Erwin Weinmann, Dr Michael Leonard</p>
         
         <h2>ARR Editorial Team</h2>
         
         <p>Editors:</p>
         
         <ul>
            <li>James Ball</li>
            <li>Mark Babister</li>
            <li>Rory Nathan</li>
            <li>Bill Weeks</li>
            <li>Erwin Weinmann</li>
            <li>Monique Retallick</li>
            <li>Isabelle Testoni</li>
         </ul>
         
         <p>Associate Editors for Book 9 - Runoff in Urban Areas</p>
         
         <ul>
            <li>Peter Coombes</li>
            <li>Steve Roso</li>
         </ul>
         
         <p>Editorial assistance: Mikayla Ward</p>
         
         <h2>Status of this document</h2>
         
         <p>This document is a living document and will be regularly
            updated in the future.</p>
         
         <p>In development of this guidance, also discussed in Book 1 of
            ARR 1987, it was recognised that knowledge and information availability is not fixed and
            that future research and applications will develop new techniques and information. This is
            particularly relevant in applications where techniques have been extrapolated from the
            region of their development to other regions and where efforts should be made to reduce
            large uncertainties in current estimates of design flood characteristics. </p>
         <p>Therefore,
            where circumstances warrant, designers have a duty to use other procedures and design
            information more appropriate for their design flood problem. The Editorial team of this
            edition of Australian Rainfall and Runoff believe that the use of new or improved procedures
            should be encouraged, especially where these are more appropriate than the methods described
            in this publication. </p>
         
         <p>Care should be taken when combining inputs derived using ARR 1987
            and methods described in this document.</p>
         
         <h3>What is new in ARR 2019?</h3>
         <p>Geoscience
            Australia, on behalf of the Australian Government, asked the National Committee on Water
            Engineers (NCWE) - a specialist committee of Engineers Australia - to continue overseeing
            the technical direction of ARR. ARR's success comes from practitioners and researchers
            driving its development; and the NCWE is the appropriate organisation to oversee this work.
            The NCWE has formed a sub-committee to lead the ongoing management and development of ARR
            for the benefit of the Australian community and the profession. The current membership of
            the ARR management subcommittee includes Mark Babister, Robin Connolly, Rory Nathan and Bill
            Weeks. </p>
         <p>The ARR team have been working hard on finalising ARR since it was released in
            2016. The team has received a lot of feedback from industry and practitioners, ranging from
            substantial feedback to minor typographical errors. Much of this feedback has now been
            addressed. Where a decision has been made not to address the feedback, advice has been
            provided as to why this was the case. </p>
         <p>A new version of ARR is now available. ARR 2019
            is a result of extensive consultation and feedback from practitioners. Noteworthy updates
            include the completion of Book 9, reflection of current climate change practice and
            improvements to user experience, including the availability of the document as a PDF.
         </p><h3>Key updates in ARR 2019</h3><table frame="border" align="left">
            <col width="33%" />
            <col width="33%" />
            <col width="33%" />
            <thead>
               <tr>
                  <th>Update</th>
                  <th>ARR 2016</th>
                  <th>ARR 2019</th>
               </tr>
            </thead>
            <tbody>
               <tr>
                  <td>Book 9</td>
                  <td>Available as “rough” draft</td>
                  <td>Peer reviewed and completed</td>
               </tr>
               <tr>
                  <td>Guideline formats</td>
                  <td>Epub version and Web-based version</td>
                  <td>Following practitioner feedback, a pdf version of ARR 2019 is now available</td>
               </tr>
               <tr>
                  <td>User experience</td>
                  <td>Limited functionality in web-based version</td>
                  <td>Additional pdf format available</td>
               </tr>
               <tr>
                  <td>Climate change</td>
                  <td>Reflected best practice as of 2016 Climate Change policies</td>
                  <td>Updated to reflect current practice</td>
               </tr>
               <tr>
                  <td>PMF chapter</td>
                  <td>Updated from the guidance provided in 1998 to include current best practice</td>
                  <td>Minor edits and reflects differences required for use in dam studies and floodplain
                     management</td>
               </tr>
               <tr>
                  <td>Examples</td>
                  <td></td>
                  <td>Examples included for Book 9</td>
               </tr>
               <tr>
                  <td>Figures</td>
                  <td></td>
                  <td>Updated reflecting practitioner feedback</td>
               </tr>
            </tbody>
         </table>
         <hr/>
         <p>As of May 2019, this version is
            considered to be final.</p>
      <!-- END OF FRONT PIECE BLOCK -->
   </xsl:element>
</xsl:template>

</xsl:stylesheet>
