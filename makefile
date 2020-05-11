strip: LanguageParser.h LanguageParser.cpp LanguageParserControl.cpp
	g++ LanguageParserControl.cpp LanguageParser.cpp -o striptext.out
	./striptext.out < final.txt


parse:
	flex parse.l
	bison -d parse.y
	gcc lex.yy.c parse.tab.c -o parse.out
	./parse.out < revised.txt

flex:	
	flex parse.l

bison:	
	bison -d parse.y

compile:	
	gcc lex.yy.c parse.tab.c -o parse.out

runparse:	
	./parse.out < revised.txt
	
remove:
	rm lex.yy.c parse.tab.c parse.tab.h parse.out revised.txt striptext.out a.out abc13.cpp