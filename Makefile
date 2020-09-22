VPATH = lib
vpath %.bib .:bibliography
vpath %.csl _csl
vpath %.yaml .:spec:_data
vpath default.% lib

article.docx : article.md biblio.bib docx.yaml | _csl
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 \
		$< -d docx.yaml -o $@

_csl :
	git clone https://github.com/citation-style-language/styles.git $@

clean :
	-rm -rf _csl
# vim: set shiftwidth=2 tabstop=2 :
