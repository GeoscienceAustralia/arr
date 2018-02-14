#####################################################
#####################################################
#####################################################
# ARR Build Master Make File
#
# This top level makefile preforms "master" type work, namely:
#   -) builds the common stylesheets necessary for the PDF builds.
#   -) contains build scripts for all the set construction.
#   -) NB: instructions for the individual chapters and book builds are
#      contained in Makefile.chapter and Makefile.book, respectively.  These
#      must be constructed first using bash ./build_make_includes otherwise
#      this Makefile will fail
#
# Dr Peter Brady <peter.brady@wmawater.com.au>
# 2015-10-04

#####################################################
#####################################################
#####################################################
# Set global variables
# Note: the most of the parameters are provided in the stylesheet, therefore
# the following are really only command options.
# A localisation parameter of the revision number from SVN:
L10N_REVISION = r
export XSLTPROC = xsltproc
XMLLINT = xmllint
FOP = AHFCmd
FOP_OPTS = -pgbar -tpdf -pdfver PDF1.7
MKDIR = mkdir -p
SVNVERSION = svnversion
DIR_BASE = /Users/pbrady/ncwe/arr_docs/trunk
XMLLINT_OPTS=--xinclude --relaxng
export XSLTPROC_OPTS=--xinclude --output 

#####################################################
#####################################################
#####################################################
# Set the top level phony targets
.PHONY: valid html epub pdf
.PHONY: draft pdf_draft
.PHONY: clean clean_draft clean_html clean_html_ajax clean_epub
.PHONY: clean_master_refs

#####################################################
# Default and utility targets
####################
# Default target: phony target to make drafts
draft: valid arr_draft.pdf html epub

final: valid pdf html epub

all: valid draft final node_count all_arr.xml

#####################################################
#####################################################
#####################################################
# all_arr.xml and Node Count
# These targets were used as part of testing and are used only to get a total
# node count from the XML.  This was needed as the DeltaXML difference engine
# has a maximum node count limit.
all_arr.xml: valid
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng ARR.xml > all_arr.xml
	tidy -xml -indent -utf8 -quiet all_arr.xml > all_arr_tmp.xml
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng --noout all_arr_tmp.xml
	mv -f all_arr_tmp.xml all_arr.xml

# Node Count
node_count: all_arr.xml
	$(XSLTPROC) --xinclude count_all_nodes.xsl all_arr.xml

clean_all_arr.xml:
	rm -f all_arr_tmp.xml all_arr.xml


#####################################################
#####################################################
#####################################################
# Chapter References
# Set up some utility variables first:
SUBDIRS=book1 book2 book3 book4 book5 book6 book7 book8 book9
.PHONY: chap_refs chap_refs_clean $(SUBDIRS)

# Build target:
chap_refs:
	@for i in $(SUBDIRS); do \
	(cd $$i; $(MAKE) $(MFLAGS) chap_refs); done

# Clean target
chap_refs_clean:
	@for i in $(SUBDIRS); do \
	(cd $$i; $(MAKE) $(MFLAGS) chap_refs_clean); done

#####################################################
#####################################################
#####################################################
# Validate the XML
valid: chap_refs
	$(XSLTPROC) $(XSLTPROC_OPTS) ARR_cite_proc.xml \
		stripcitations.xsl ARR.xml
	$(XSLTPROC) $(XSLTPROC_OPTS) ARR_set.xml \
		mathtypeBlock2Inline.xsl ARR_cite_proc.xml
	$(XMLLINT) $(XMLLINT_OPTS) arrDocBookExtendedGrammar.rng --noout ARR_set.xml 

#####################################################
#####################################################
#####################################################
# Draft PDF of the Entire Set
arr_draft.pdf: arr_draft.fo
	$(FOP) $(FOP_OPTS) -d arr_draft.fo -o arr_draft.pdf
arr_draft.fo: valid arr_title_fo.xsl
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_set_img_scaled.xml \
		scale_images.xsl ARR_set.xml
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_draft.fo \
		arr_style_fo_draft.xsl arr_set_img_scaled.xml

clean_draft:
	rm -f arr_draft.fo arr_draft.pdf arr_set_img_scaled.xml

#####################################################
#####################################################
#####################################################
# PDF of the Entire Set
pdf: arr.fo
	$(FOP) $(FOP_OPTS) -d arr.fo -o arr.pdf
arr.fo: valid arr_title_fo.xsl
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_set_img_scaled.xml \
		scale_images.xsl ARR_set.xml
	$(XSLTPROC) $(XSLTPROC_OPTS) arr.fo \
		arr_style_fo.xsl arr_set_img_scaled.xml

clean_pdf:
	rm -f arr.fo arr.pdf arr_set_img_scaled.xml


#####################################################
#####################################################
#####################################################
# Style Guide Builds
style: arr_style_guide_draft.pdf arr_style_guide_final.pdf

arr_style_guide_valid: style_version.xml
	$(XMLLINT) $(XMLLINT_OPTS) ../docbook/rng/docbookxi.rng --noout arr_style_guide.xml

style_version.xml:
	svn log arr_style_guide.xml --xml > style_version_tmp.xml
	$(XSLTPROC) --output style_version.xml svnlog2db.xsl style_version_tmp.xml
	rm style_version_tmp.xml

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
	$(FOP) -d arr_style_guide_draft.fo -o arr_style_guide_draft.pdf

arr_style_guide_draft.fo: arr_title_fo.xsl
	$(XSLTPROC) $(XSLTPROC_OPTS) arr_style_guide_draft.fo \
		arr_style_fo_draft.xsl arr_style_guide.xml

# Final Builds:
arr_style_guide_final.pdf: arr_style_guide_valid arr_style_guide_final.fo
	$(FOP) -d arr_style_guide_final.fo -o arr_style_guide_final.pdf

arr_style_guide_final.fo: arr_style_fo.xsl
	rm -f style_version.xml
	$(XSLTPROC) --xinclude \
		--output arr_style_guide_final.fo arr_style_fo.xsl \
		arr_style_guide.xml



#####################################################
#####################################################
#####################################################
# HTML Chunked
# NB: the target html_chunked_images is specified inside one of the included
# sub-Makefiles.
html: html_ajax html_chunked
	
html_chunked: valid html_chunked_images
	test -d html_chunked || mkdir html_chunked
	$(XSLTPROC) $(XSLTPROC_OPTS) html_chunked/index.xhtml \
		--param keep.relative.image.uris 0 \
		arr_style_chunk_vanilla.xsl ARR_set.xml
	cp figures/close.png html_chunked/figures
	cp figures/loading.gif html_chunked/figures
	cp figures/next.png html_chunked/figures
	cp figures/prev.png html_chunked/figures
	cp -a css html_chunked/
	cp -a js html_chunked/
	cp -a book_front_matter/figures/* html_chunked/figures/

clean_html:
	rm -rf html_chunked

html_ajax: valid html_chunked
	test -d html_chunked_ajax || mkdir html_chunked_ajax
	cp -a ajax_src_bw/* html_chunked_ajax
	cp -a html_chunked/*xhtml html_chunked_ajax/content/
	cp -a html_chunked/figures/* html_chunked_ajax/figures/
	cp figures/close.png html_chunked_ajax/figures
	cp figures/loading.gif html_chunked_ajax/figures
	cp figures/next.png html_chunked_ajax/figures
	cp figures/prev.png html_chunked_ajax/figures
	# cp -a css html_chunked_ajax/
	# cp -a js html_chunked_ajax/
	cp -a book_front_matter/figures/* html_chunked_ajax/figures/

clean_html_ajax:
	rm -rf html_chunked_ajax


#####################################################
#####################################################
#####################################################
# EPUB3
EPUB_OPTS=--param keep.relative.image.uris 0
epub: valid epub3_images
	$(XSLTPROC) --xinclude --stringparam base.dir epub3/OEBPS \
		--param keep.relative.image.uris 0 \
		arr_style_epub.xsl ARR_set.xml
	mkdir -p epub3/OEBPS/css
	cp -a css/arr_epub.css epub3/OEBPS/css/
	cp -af book_front_matter/frontmatter_epub.xhtml epub3/OEBPS/index.xhtml
	cp -a book_front_matter/figures/* epub3/OEBPS/figures/
	cd epub3 && zip -rX arr.epub mimetype META-INF OEBPS

clean_epub:
	rm -rf epub3

#####################################################
#####################################################
#####################################################
# Build the Reference Library From EndNote
# arr_references.xml: refs_from_endnote.xml
# 	$(XSLTPROC) --output arr_references.xml endnote2docbook.xsl \
# 		refs_from_endnote.xml
#clean_master_refs:
#	rm -rf arr_references.xml

#####################################################
#####################################################
#####################################################
# PHONY Clean Targets
# The individual clean targets are stored within their respective sections.
# Therefore, anything listed here should also be a PHONY at the top of this
# Makefile.
clean: clean_draft clean_final clean_style clean_html clean_html_ajax clean_epub clean_all_arr.xml clean_master_refs chap_refs_clean clean_pdf
	rm -f ARR_set.xml ARR_cite_proc.xml

clean_final: 
	rm -f arr.pdf arr.fo



#####################################################
#####################################################
#####################################################
# Include additional make files that are generated from the
# script: build_make_includes
# include Makefile.book
# include Makefile.chapter
# include Makefile.html_single
include Makefile.html_chunked_vanilla
include Makefile.html_chunked_ajax
include Makefile.epub3
