# Original lines from version 1 of the Makefile
#include Makefile.base
#FO_XSLTPROC_OPTS = --param fop.extensions 1
#L10N_REVISION = r

#####################################################
# Set some variables:
# A localisation parameter of the revision number from SVN:
L10N_REVISION = r
# Paths which you may wish to customize:
XSLTPROC = xsltproc
XMLLINT = xmllint
FOP = /Users/pbrady/Downloads/fop-1.1/fop
MKDIR = mkdir -p
SVNVERSION = svnversion
DIR_BASE = /Users/pbrady/ncwe/arr_docs/trunk
ARR_STYLESHEET_PATH=./style_guide
# Note: the most of the parameters are provided in the stylesheet, therefore
# the following are really only command options.
XMLLINT_OPTS=--xinclude --relaxng
XSLTPROC_OPTS=--xinclude --output

.PHONY: valid
.PHONY: draft draft_pdf
.PHONY: clean

#####################################################
# Default and utility targets
####################
# Default target: phony target to make draft PDFs
draft: valid

# Clean up:
clean:
	rm arr_draft.fo arr_draft.pdf arr_draft_book?.fo arr_draft_book?.pdf

####################
# Validate the XML
valid: ARR.xml
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng --noout ARR.xml



#####################################################
# Draft Versions
# As a first approximation this assumes that the custom stylesheet is already
# compiled in the stylesheet directory.  This should be fixed.
draft: valid draft_pdf draft_pdf_book1 draft_pdf_book2 draft_pdf_book3 \
	draft_pdf_book4 draft_pdf_book5 draft_pdf_book6 draft_pdf_book7 \
    draft_pdf_book8 draft_pdf_book9

# The entire book:
draft_pdf: arr_draft.fo
	$(FOP) -fo arr_draft.fo -pdf arr_draft.pdf
arr_draft.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft.fo \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml
    
# Book 1
draft_pdf_book1: arr_draft_book1.fo
	$(FOP) -fo arr_draft_book1.fo -pdf arr_draft_book1.pdf
arr_draft_book1.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book1.fo \
    --stringparam rootid book1 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml

# Book 2
draft_pdf_book2: arr_draft_book2.fo
	$(FOP) -fo arr_draft_book2.fo -pdf arr_draft_book2.pdf
arr_draft_book2.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book2.fo \
    --stringparam rootid book2 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml
    
# Book 3
draft_pdf_book3: arr_draft_book3.fo
	$(FOP) -fo arr_draft_book3.fo -pdf arr_draft_book3.pdf
arr_draft_book3.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book3.fo \
    --stringparam rootid book3 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml
    
# Book 4
draft_pdf_book4: arr_draft_book4.fo
	$(FOP) -fo arr_draft_book4.fo -pdf arr_draft_book4.pdf
arr_draft_book4.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book4.fo \
    --stringparam rootid book4 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml

# Book 5
draft_pdf_book5: arr_draft_book5.fo
	$(FOP) -fo arr_draft_book5.fo -pdf arr_draft_book5.pdf
arr_draft_book5.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book5.fo \
    --stringparam rootid book5 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml

# Book 6
draft_pdf_book6: arr_draft_book6.fo
	$(FOP) -fo arr_draft_book6.fo -pdf arr_draft_book6.pdf
arr_draft_book6.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book6.fo \
    --stringparam rootid book6 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml

# Book 7
draft_pdf_book7: arr_draft_book7.fo
	$(FOP) -fo arr_draft_book7.fo -pdf arr_draft_book7.pdf
arr_draft_book7.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book7.fo \
    --stringparam rootid book7 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml

# Book 8
draft_pdf_book8: arr_draft_book8.fo
	$(FOP) -fo arr_draft_book8.fo -pdf arr_draft_book8.pdf
arr_draft_book8.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book8.fo \
    --stringparam rootid book8 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml

# Book 9
draft_pdf_book9: arr_draft_book9.fo
	$(FOP) -fo arr_draft_book9.fo -pdf arr_draft_book9.pdf
arr_draft_book9.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft_book9.fo \
    --stringparam rootid book9 \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml
