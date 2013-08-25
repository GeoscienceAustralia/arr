# This is a standalone makefile to test the build system independently from the
# trunk in relation to the style guide only.

# Set some variables:
# A localisation parameter of the revision number from SVN:
L10N_REVISION = r

.PHONY: clean draft final all valid version

#####################################################
# Default and utility targets
####################
# Default target: phony target to make all
all: draft final

####################
# Validate the XML
valid: arr_style_guide.xml
	/usr/bin/xmllint --relaxng ../../docbook/rng/docbookxi.rng --noout \
    --xinclude arr_style_guide.xml

####################
# Clean up
clean:
	rm arr_title_fo.xsl \
    arr_style_guide_draft.fo arr_style_guide_draft.pdf \
    arr_style_guide_final.fo arr_style_guide_final.pdf

####################
# Create the version control template
version:
	@echo '<!DOCTYPE t:templates [' > version.tmp
	@echo '<!ENTITY svn.version "'`svnversion .`'">' >> version.tmp
	@echo '<!ENTITY svn.l10n_revision "r">' >> version.tmp
	@echo '<!ENTITY svn.date "'`date`'">' >> version.tmp
	@echo ']>' >> version.tmp
	@svn log --xml --verbose arr_style_guide.xml >> version.tmp
	@xsltproc --output version.xml svnlog2docbook.xsl version.tmp


#####################################################
# Draft and Final PDF Outputs
####################
# Draft PDF Output:
draft: valid arr_title_fo.xsl arr_style_guide_draft.fo
	/Users/pbrady/Downloads/fop-1.1/fop \
    -fo arr_style_guide_draft.fo -pdf arr_style_guide_draft.pdf

arr_style_guide_draft.fo: arr_style_fo_draft.xsl
	xsltproc --xinclude \
    --output arr_style_guide_draft.fo arr_style_fo_draft.xsl \
    arr_style_guide.xml
    
####################
# Final PDF Output:
final: valid arr_title_fo.xsl arr_style_guide_final.fo
	/Users/pbrady/Downloads/fop-1.1/fop \
    -fo arr_style_guide_final.fo -pdf arr_style_guide_final.pdf

arr_style_guide_final.fo: arr_style_fo.xsl
	xsltproc --xinclude \
    --output arr_style_guide_final.fo arr_style_fo.xsl \
    arr_style_guide.xml

####################
# Common PDF Elements
arr_title_fo.xsl: arr_title_fo.xml
	xsltproc --output arr_title_fo.xsl \
    ../../stylesheets-ns/template/titlepage.xsl \
    ./arr_title_fo.xml
