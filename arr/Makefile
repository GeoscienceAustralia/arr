# Original lines from version 1 of the Makefile
#include Makefile.base
#FO_XSLTPROC_OPTS = --param fop.extensions 1
#L10N_REVISION = r

#####################################################
# Inlude the book and chapter makefiles
include Makefile.book
include Makefile.chapter

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
clean: clean_draft clean_final

clean_draft: clean_chapter_pdf_final clean_book_pdf_draft
	rm -f arr_draft.fo arr_draft.pdf
    
clean_final:
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
arr_draft.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft.fo \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml
    
# Individual Books
books_draft: books_makefile valid
	make -f Makefile.book all
    
# Individual Chapters
chapters_draft: chapters_makefile valid
	make -f Makefile.chapter all
