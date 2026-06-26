.PHONY: compile clean
.DEFAULT_GOAL := compile

compile:
	@printf 'CM.make "catlib.cm";\n' | sml

clean:
	@find . -type d -name '*.cm' -print0 | xargs -0 rm -rf
