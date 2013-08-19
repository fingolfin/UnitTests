# TODO: configure location of gap?

doc:
	gap makedoc.g

check:
	gap tst/testall.g

archive: check doc
	# TODO: create an archive

upload: archive
	# TODO: upload archive to website, update website

.PHONY: archive check doc upload
