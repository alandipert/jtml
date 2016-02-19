MLTON=docker run -t -v $(shell pwd):/home alandipert/mlton:20130715

jtml: jt.sml jt.mlb
	${MLTON} -link-opt '-static' jt.mlb

clean:
	rm -f jtml
