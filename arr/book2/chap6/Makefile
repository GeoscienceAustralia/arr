.PHONY: chap_refs chap_refs_clean
chap_refs:
	$(XSLTPROC) $(XSLTPROC_OPTS) chap_refs.xml \
		../../citation2ARRrefs.xsl chap6.xml

chap_refs_clean:
	rm -f chap_refs.xml
