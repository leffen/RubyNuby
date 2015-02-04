# naive makefile for generating the presentation
#
#

RAW_PRES = presentation.sgml
TMP = tmp/
HTML = html/
CODE = code/
PRES = pres.sgml


# SGML2HTML = sgml2html
SGML2HTML = linuxdoc -B html
SGML2LATEX = linuxdoc -B latex


STANDALONE = standalone_presentation
STANDALONE_SGML = $(addsuffix .sgml, $(STANDALONE))
STANDALONE_PS = $(addsuffix .ps, $(STANDALONE))
STANDALONE_LATEX = $(addsuffix .tex, $(STANDALONE))


EDIT = ruby bin/edit.rb
RB2HTML_RB = bin/rb2htmlz.rb
RB2SGML_RB = bin/rb2sgml.rb
RB2HTML = ruby bin/rb2htmlz.rb
RB2SGML = ruby bin/rb2sgml.rb
RUBY = ruby

FULL_HTML  = $(HTML)flat_$(PRES).html
EMPTY_HTML = $(TMP)flat_*.html
FLAT_PRES   = $(TMP)flat_$(PRES)

EMPTY_ONLINE_HTML = $(TMP)pres*.html


# Source code example source
SAMPLE_CODE_FILES = $(notdir $(wildcard code/*.rb))

#SAMPLE_CODE_FILES = heiverden1.rb tall1.rb \
	 tekst1.rb	tekst2.rb 	\
	 utput1.rb	variabler1.rb 	\
	 hvis1.rb	hvis2.rb 	\
	 gjenta1.rb	gjenta2.rb 	\
	 iter1.rb 	iter2.rb \
	 metoder1.rb 	

#Same source, restrained to CODE sections
SAMPLE_CODE = $(addprefix html/code/,$(SAMPLE_CODE_FILES))

SAMPLE_CODE_HTML = $(addprefix tmp/,$(addsuffix .html,$(SAMPLE_CODE_FILES)))
SAMPLE_CODE_SGML = $(addprefix tmp/,$(addsuffix .sgml,$(SAMPLE_CODE_FILES)))

SAMPLE_CODE_HTMLSECTIONS = $(addsuffix _section,$(SAMPLE_CODE_HTML))
SAMPLE_CODE_SGMLSECTIONS = $(addsuffix _section,$(SAMPLE_CODE_SGML))

CLEAN_FILES = $(PRES) $(FLAT_PRES) $(EMPTY_HTML) \
	$(SAMPLE_CODE_HTML) $(SAMPLE_CODE_HTMLSECTIONS) $(SAMPLE_CODE_SGMLSECTIONS)\
	$(TMP)*


# Insert code snipppets into HTML
presentation :  $(FULL_HTML)

online : $(SAMPLE_CODE_HTMLSECTIONS) $(EMPTY_ONLINE_HTML)
	$(EDIT) -InsertSampleCode $(EMPTY_ONLINE_HTML)

standalone : $(STANDALONE_SGML) 



ps : $(STANDALONE_PS)
	cp $(STANDALONE_PS) $(HTML)rubynuby.ps

smallps : $(STANDALONE_PS)
	mpage -4 $(STANDALONE_PS) > $(HTML)rubynu_4.ps
	mpage -2 $(STANDALONE_PS) > $(HTML)rubynu_2.ps

pdf : $(STANDALONE_PS)
	ps2pdf $(STANDALONE_PS) $(HTML)rubynuby.pdf



all : presentation online standalone ps pdf smallps

$(STANDALONE_SGML) : $(PRES) $(SAMPLE_CODE) #$(SAMPLE_CODE_SGMLSECTIONS)
	$(EDIT) -InsertSampleCodeStandalone $(PRES) $(STANDALONE_SGML)
#$(EDIT) -InsertSGMLSampleCode $(PRES) $(STANDALONE_SGML)

$(FULL_HTML) : $(EMPTY_HTML) $(SAMPLE_CODE_HTMLSECTIONS) $(SAMPLE_CODE)
	$(EDIT) -InsertSampleCode $(EMPTY_HTML)

#$(SAMPLE_CODE_HTML) : $(SAMPLE_CODE) 
#	$(EDIT) -Htmlify $(SAMPLE_CODE)


# HTML without source code inserted
$(EMPTY_HTML) : $(FLAT_PRES)
	$(SGML2HTML) -I $(FLAT_PRES) 
	mv flat_* tmp

$(EMPTY_ONLINE_HTML) : $(PRES)
	$(SGML2HTML) -I $(PRES)
	mv pres*.html tmp


# flatten the sections so we get slides, not serveral on one page.
$(FLAT_PRES) : $(PRES)
	$(EDIT) -Flatten $(PRES) $(FLAT_PRES)


# Raw input into "real" SGML by doing Umlaut gsub'ing.
$(PRES) : $(RAW_PRES)
	$(EDIT) -Umlaut $< $@

$(STANDALONE_PS) : $(STANDALONE_SGML)
	echo $(STANDALONE_PS)
	$(SGML2LATEX) --output=ps --charset=latin $(STANDALONE_SGML)

$(STANDALONE_LATEX) : $(STANDALONE_SGML)
	$(SGML2LATEX) --output=tex --charset=latin $(STANDALONE_SGML)




#################
# general rules




# Retain only the body part for insertion into remaining doc.
$(TMP)%.rb.html_section : $(TMP)%.rb.html
	$(EDIT) -StripToHtmlSection  $< $@ \
		$(subst .rb.html,.rb,$(subst $(TMP),$(CODE),$<))

# Generate HTML of files
$(TMP)%.rb.html : $(HTML)code/%.rb
	cat $< | $(RB2HTML)  >   $@

$(TMP)%.rb.sgml_section : $(HTML)code/%.rb
	$(RB2SGML) $<  >   $@

# Strip down to contents of <CODE></CODE> tags
$(HTML)code/%.rb : $(CODE)%.rb
	$(EDIT) -StripRbCode $< $@



clean : 
	rm -f $(CLEAN_FILES) > /dev/null