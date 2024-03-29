NAME         := ssrt
DESCRIPTION  := simplescreenreocrder - now even simpler
VERSION      := 2022.06.14.1
CREATED      := 2020-06-19
UPDATED      := 2022-06-14
AUTHOR       := budRich
ORGANISATION := budlabs
CONTACT      := https://github.com/budlabs/ssrt
USAGE        := ssrt [OPTIONS]

LICENSE      := BSD-2-Clause

# CUSTOM_TARGETS += README.md

README_DEPS  =                      \
	$(DOCS_DIR)/readme_banner.md      \
	$(DOCS_DIR)/readme_install.md     \
	$(CACHE_DIR)/help_table.txt       \
	$(DOCS_DIR)/description.md        \
	$(DOCS_DIR)/releasenotes/0_next.md

README.md: config.mak $(README_DEPS)
	@$(info making $@)
	{
		echo "# $(NAME) - $(DESCRIPTION)"
		cat $(DOCS_DIR)/readme_banner.md
		cat $(DOCS_DIR)/readme_install.md
		echo "## usage"
		echo "    $(USAGE)"
		sed 's/^/    /g' $(CACHE_DIR)/help_table.txt
		cat $(DOCS_DIR)/description.md
	} > $@


MANPAGE_DEPS =                 \
 $(CACHE_DIR)/help_table.txt   \
 $(CACHE_DIR)/long_help.md     \
 $(DOCS_DIR)/description.md    \
 $(CACHE_DIR)/copyright.txt

MANPAGE := $(NAME).1
.PHONY: manpage
manpage: $(MANPAGE)

$(MANPAGE): config.mak $(MANPAGE_DEPS) 
	@$(info making $@)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		# this first "<h1>" adds "corner" info to the manpage
		echo "# $$uppercase_name "           \
				 "$(manpage_section) $(UPDATED)" \
				 "$(ORGANISATION) \"User Manuals\""

		# main sections (NAME|OPTIONS..) should be "<h2>" (##), sub (###) ...
	  printf '%s\n' '## NAME' \
								  '$(NAME) - $(DESCRIPTION)'

		printf '%s\n' "## USAGE" "$(USAGE)"
		cat $(DOCS_DIR)/description.md
		echo "## OPTIONS"
		sed 's/^/    /g' $(CACHE_DIR)/help_table.txt
		cat $(CACHE_DIR)/long_help.md

		printf '%s\n' '## CONTACT' \
			"Send bugs and feature requests to:  " "$(CONTACT)/issues"

		printf '%s\n' '## COPYRIGHT'
		cat $(CACHE_DIR)/copyright.txt

		cat $(DOCS_DIR)/manpage_footer.md

	} | go-md2man > $@
