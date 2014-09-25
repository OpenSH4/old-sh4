$(DEPDIR)/oscam: libusb2 libusb
	svn checkout http://www.streamboard.tv/svn/oscam/trunk $(archivedir)/oscam-svn && \
	cd $(archivedir)/oscam-svn && \
                $(BUILDENV) && \
		make config && \
		make $(BUILDENV) CONF_DIR=/var/keys USE_LIBUSB=1
		rm -rf $(prefix)/OScam
		mkdir $(prefix)/OScam
		cp -pR $(archivedir)/oscam-svn/Distribution/* $(prefix)/OScam/ 
		touch $@

oscam-clean:
	rm -f $(DEPDIR)/oscam

oscam-distclean: oscam-clean
	rm -rf $(archivedir)/oscam-svn
