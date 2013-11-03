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
FOP = fop
MKDIR = mkdir -p
SVNVERSION = svnversion
DIR_BASE = /Users/pbrady/ncwe/arr_docs/trunk
# Note: the most of the parameters are provided in the stylesheet, therefore
# the following are really only command options.
XMLLINT_OPTS=--xinclude --relaxng
XSLTPROC_OPTS=--xinclude --output

.PHONY: valid
.PHONY: draft pdf_draft
.PHONY: clean clean_draft

#####################################################
# Default and utility targets
####################
# Default target: phony target to make draft PDFs
draft: valid arr_draft.pdf all_book_pdf_draft all_chapter_pdf_draft

final: valid arr.pdf all_book_pdf_final all_chapter_pdf_final

all: valid draft final

####################
# Clean up:
clean: clean_draft clean_final clean_style

clean_draft: clean_chapter_pdf_draft clean_book_pdf_draft
	rm -f arr_draft.fo arr_draft.pdf
    
clean_final: clean_chapter_pdf_final clean_book_pdf_final
	rm -f arr.pdf arr.fo

####################
# Validate the XML
valid: ARR.xml
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng --noout ARR.xml



#####################################################
# Draft Versions
# As a first approximation this assumes that the custom stylesheet is already
# compiled in the stylesheet directory.  This should be fixed.

# The entire book:
arr_draft.pdf: arr_draft.fo
	$(FOP) -fo arr_draft.fo -pdf arr_draft.pdf
arr_draft.fo: arr_title_fo.xsl
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft.fo \
	arr_style_fo_draft.xsl ARR.xml
    
# Draft books and chapters are in the included Makefiles
    
    
    
#####################################################
#####################################################
#####################################################
# Style Guide Builds
style: arr_style_guide_draft.pdf arr_style_guide_final.pdf

arr_style_guide_valid: style_version.xml
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng --noout arr_style_guide.xml
    
style_version.xml:
	svn log arr_style_guide.xml --xml > tmp.xml
	xsltproc --output style_version.xml svnlog2db.xsl tmp.xml
	rm tmp.xml

####################
# PDF
# Common PDF Elements
arr_title_fo.xsl: arr_title_fo.xml
	xsltproc --output arr_title_fo.xsl \
    ../stylesheets-ns/template/titlepage.xsl \
    ./arr_title_fo.xml
    
clean_style:
	rm -f style_version.xml arr_style_guide_final.fo arr_style_guide_final.pdf \
    arr_style_guide_draft.fo arr_style_guide_draft.pdf arr_title_fo.xsl
    
# Draft Builds:
arr_style_guide_draft.pdf: arr_style_guide_valid arr_style_guide_draft.fo
	$(FOP) -fo arr_style_guide_draft.fo -pdf arr_style_guide_draft.pdf
    
arr_style_guide_draft.fo: arr_title_fo.xsl
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_style_guide_draft.fo \
    arr_style_fo_draft.xsl arr_style_guide.xml

# Final Builds:
arr_style_guide_final.pdf: arr_style_guide_valid arr_style_guide_final.fo
	$(FOP) -fo arr_style_guide_final.fo -pdf arr_style_guide_final.pdf

arr_style_guide_final.fo: arr_style_fo.xsl
	rm -f style_version.xml
	xsltproc --xinclude \
    --output arr_style_guide_final.fo arr_style_fo.xsl \
    arr_style_guide.xml



#####################################################
#####################################################
#####################################################
# Inlude the book and chapter makefiles
include Makefile.book
include Makefile.chapter
