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

.PHONY: valid all
.PHONY: draft draft_pdf
.PHONY: clean

#####################################################
# Default and utility targets
####################
# Default target: phony target to make draft PDFs
draft: valid draft_pdf books_draft chapters_draft

# Clean up:
clean: books_draft_clean
	rm arr_draft.fo arr_draft.pdf
books_draft_clean: books_makefile
	make -f Makefile.book clean_all_draft
books_final_clean: books_makefile
	make -f Makefile.book clean_all_final

####################
# Validate the XML
valid: ARR.xml
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng --noout ARR.xml



#####################################################
# Draft Versions
# As a first approximation this assumes that the custom stylesheet is already
# compiled in the stylesheet directory.  This should be fixed.

# The entire book:
draft_pdf: arr_draft.fo
	$(FOP) -fo arr_draft.fo -pdf arr_draft.pdf
arr_draft.fo:
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft.fo \
	$(ARR_STYLESHEET_PATH)/arr_style_fo_draft.xsl ARR.xml
    
# Individual Books
books_makefile:
		xsltproc --xinclude -o Makefile.book build_books.xsl ARR.xml
books_draft: books_makefile valid
	make -f Makefile.book all
    
# Individual Chapters
chapters_makefile:
		xsltproc --xinclude -o Makefile.chapter build_chapters.xsl ARR.xml
chapters_draft: chapters_makefile valid
	make -f Makefile.chapter all
