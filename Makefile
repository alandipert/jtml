jt: jt.sml
	mlton -link-opt '-static' jt.mlb

clean:
	rm -f jt
