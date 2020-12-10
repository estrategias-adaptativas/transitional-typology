VPATH = lib
vpath %.bib .:bibliography
vpath %.csl _csl
vpath %.yaml .:spec:_data
vpath default.% lib

article.docx : article.md biblio.bib docx.yaml | _csl
	docker run --user `id -u`:`id -g` \
		-v "`pwd`:/data" pandoc/crossref:2.11.0.4 \
		$< -d docx.yaml -o $@

_site/slides/index.html : _slides.md | _site
	@mkdir -p _site/slides
	docker run --user `id -u`:`id -g` \
		-v "`pwd`:/data" pandoc/crossref:2.11.0.4 \
		-o $@ -d revealjs.yaml $<

_site :
	docker run -v "`pwd`:/srv/jekyll" \
		jekyll/jekyll:3.8.5 /bin/bash -c \
		"chmod 777 /srv/jekyll && jekyll build --future"

_csl :
	git clone https://github.com/citation-style-language/styles.git $@

clean :
	-rm -rf _csl _site
# vim: set shiftwidth=2 tabstop=2 :
