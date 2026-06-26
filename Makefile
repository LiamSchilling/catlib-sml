.PHONY: compile
.DEFAULT_GOAL := compile

compile:
	@printf 'CM.make "catlib.cm";\n' | sml
