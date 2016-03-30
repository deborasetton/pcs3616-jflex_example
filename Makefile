CP         = .
JAVA       = java
JAVAC      = javac
JAVACFLAGS = -cp $(CP)
JFLEX      = /opt/jflex/jflex-1.6.1/lib/jflex-1.6.1.jar

test: test_valid test_invalid

test_valid: build/GradeSheetLexer.class
	@ echo 'Testando exemplo de arquivo válido.'
	@ echo
	@ echo 'Entrada:'
	@ cat sheet_valid.txt
	@ echo
	@ echo 'Saída:'
	@ java -cp build Main sheet_valid.txt

test_invalid: build/GradeSheetLexer.class
	@ echo 'Testando exemplo de arquivo inválido.'
	@ echo
	@ echo 'Entrada:'
	@ cat sheet_invalid.txt
	@ echo
	@ echo 'Saída:'
	@ java -cp build Main sheet_invalid.txt

build/GradeSheetLexer.class: GradeSheetLexer.java build
	@ $(JAVAC) $(JAVACFLAGS) GradeSheetLexerError.java  GradeSheetLexer.java  Main.java  SheetParser.java  Token.java  TokenType.java
	@ mv *.class build/

build:
	@ mkdir build

GradeSheetLexer.java: grade_sheet.flex
	@ $(JAVA) -jar $(JFLEX) grade_sheet.flex

clean:
	rm -rf build
	rm -rf *~
	rm -rf GradeSheetLexer.java
