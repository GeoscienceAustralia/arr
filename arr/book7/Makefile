SUBDIRS=chap1 chap2 chap3 chap4 chap5 chap6 chap7 chap8 chap9 chap10
.PHONY: chap_refs chap_refs_clean $(SUBDIRS)

# Build target:
chap_refs:
	@for i in $(SUBDIRS); do \
	(cd $$i; $(MAKE) $(MFLAGS) chap_refs); done

# Clean target
chap_refs_clean:
	@for i in $(SUBDIRS); do \
	(cd $$i; $(MAKE) $(MFLAGS) chap_refs_clean); done
