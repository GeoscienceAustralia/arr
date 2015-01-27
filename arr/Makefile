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

.PHONY: valid html
.PHONY: draft pdf_draft
.PHONY: clean clean_draft clean_html

#####################################################
# Default and utility targets
####################
# Default target: phony target to make draft PDFs
draft: valid arr_draft.pdf all_book_pdf_draft all_chapter_pdf_draft html

final: valid arr.pdf all_book_pdf_final all_chapter_pdf_final html

all: valid draft final

####################
# Clean up:
clean: clean_draft clean_final clean_style clean_html

clean_draft: clean_chapter_pdf_draft clean_book_pdf_draft
	rm -f arr_draft.fo arr_draft.pdf
    
clean_final: clean_chapter_pdf_final clean_book_pdf_final
	rm -f arr.pdf arr.fo
    
clean_html: clean_html_single clean_html_chunked

clean_html_single:
	rm -rf html_single
    
clean_html_chunked:
	rm -rf html_chunked

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
	$(XSLTPROC) --output style_version.xml svnlog2db.xsl tmp.xml
	rm tmp.xml

####################
# PDF
# Common PDF Elements
arr_title_fo.xsl: arr_title_fo.xml
	$(XSLTPROC) --output arr_title_fo.xsl \
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
	$(XSLTPROC) --xinclude \
    --output arr_style_guide_final.fo arr_style_fo.xsl \
    arr_style_guide.xml



#####################################################
#####################################################
#####################################################
# HTML Common Options
html: html_single html_chunked
HTML_OPTS=--param keep.relative.image.uris 0

# HTML Single Page Build
html_single: valid html_single_images
	$(XSLTPROC) $(XSLTPROC_OPTS) html_single/index.xhtml \
    $(HTML_OPTS) \
    ../stylesheets-ns/xhtml5/docbook.xsl ARR.xml

# HTML Chunked Build
html_chunked: valid html_chunked_images
	test -d html_chunked || mkdir html_chunked
	$(XSLTPROC) $(XSLTPROC_OPTS) html_chunked/index.html \
    $(HTML_OPTS) \
    ../stylesheets-ns/xhtml5/chunk.xsl ARR.xml
    
    
#####################################################
#####################################################
#####################################################
# Inlude additional make files that are generated from the
# script: build_make_includes
include Makefile.book
include Makefile.chapter
include Makefile.html_single
include Makefile.html_chunked
