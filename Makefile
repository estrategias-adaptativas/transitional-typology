VPATH = . assets
vpath %.bib .:_bibliography
vpath %.html . _includes _layouts _site
vpath %.scss _sass slides/reveal.js/css/theme/template
vpath %.yaml .:_spec:_data
vpath default.% _lib
vpath reference.% _lib

PANDOC_VERSION  := 2.14.1
JEKYLL_VERSION  := 4.2.0
PANDOC/CROSSREF := docker run --rm -v "`pwd`:/data" \
	-u "`id -u`:`id -g`" pandoc/crossref:$(PANDOC_VERSION)
JEKYLL := palazzo/jekyll-tufte:$(JEKYLL_VERSION)-$(PANDOC_VERSION)

ASSETS  = $(wildcard assets/*)
SASS    = _revealjs-settings.scss \
					mixins.scss settings.scss theme.scss

# {{{1 Recipes
#      =======
article.docx :

.PHONY : _site
_site : _site/slides/index.html assets/css/main.scss
	@echo "####################"
	@docker run --rm -v "`pwd`:/srv/jekyll" \
		$(JEKYLL) /bin/bash -c "chmod 777 /srv/jekyll && jekyll build --future"

.PHONY : serve
serve : _site/slides/index.html assets/css/main.scss
	@echo "####################"
	@docker run --rm -v "`pwd`:/srv/jekyll" \
		-h "0.0.0.0:127.0.0.1" -p "4000:4000" \
		$(JEKYLL) jekyll serve --future

%.docx : %.md references.bib docx.yaml
	docker run --user `id -u`:`id -g` \
		-v "`pwd`:/data" pandoc/crossref:2.14.1 \
		$< -d _spec/docx.yaml -o $@

slides/index.html : _slides/index.md _revealjs.yaml references.bib
	@$(PANDOC/CROSSREF) -o $@ -d _revealjs.yaml $<
	@echo $(@D)

clean :
	-rm -rf _csl _site
# vim: set shiftwidth=2 tabstop=2 :
