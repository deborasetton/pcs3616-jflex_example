/* ------------------------ Início da seção "UserCode" ---------------------- */

/*
 * Exemplo de especificação de um analisador léxico usado para processar uma
 * planilha de notas.
 */

%%

/* -------------- Início da seção "Options and Declarations" ---------------- */

// Essa diretiva indica que o JFlex irá criar uma classe chamada GradeSheetLexer
// em um arquivo chamado GradeSheetLexer.java.
%class GradeSheetLexer

// Com esta diretiva, o número da linha atual será acessível pela variável yyline.
%line

// Com esta diretiva, o número da coluna atual será acessível pela variável yycolumn.
%column

// Esta diretiva faz com que o método de scanning (o método que encontra o
// próximo token retorne um objeto do tipo Token (veja o arquivo Token.java).
%type Token

// Esta diretiva é usada para adicionar um "throws GradeSheetLexerError" na
// assinatura do método de scanning.
%yylexthrow GradeSheetLexerError

/*
  Declarações

  Todo código entre %{ e %} (que devem aparecer sempre no início de uma linha)
  será copiado exatamente como aparece para o código-fonte final do lexer.

  Aqui, você pode declarar, por exemplo, atributos e métodos que são usados
  nas "ações" do lexer, na seção "Lexical Rules".
*/

%{
    /*
     * Cria um novo token de um determinado tipo, valor e informações
     * de linha e coluna fornecidas pelo lexer.
     */
    private Token token(TokenType type, String value) {
        return new Token(yyline, yycolumn, type, value);
    }
%}

/*
  Declarações de macros

  Macros, para o JFlex, são apenas expressões regulares que serão usadas na
  seção Lexical Rules deste arquivo. Macros podem ser aninhadas, mas NÃO podem
  resultar em uma definição recursiva.
*/

// Um terminador de linha pode ser um \r (carriage return), \n (line feed) ou
// \r\n (compatibilidade com Windows).
LINE_TERMINATOR = \r|\n|\r\n

// Espaço em branco é um terminador de linha, caractere de espaço, \t ou \f.
WHITESPACE      = {LINE_TERMINATOR} | [ \t\f]

// Separador das colunas da planilha
COL_SEP         = "|"

// Linha horizontal da planilha (HR = Horizontal Ruler)
HR              = "-"+

// Um número USP é uma sequência de 7 dígitos.
NUSP            = [0-9]{7}

// Marcador de cálculo pendente.
AVG_PLACEHOLDER = "????"

// Uma string qualquer. Este tipo aparece no nome do aluno e nos títulos das
// colunas.
STR       = [A-Z][A-Za-z0-9]+

// Nota de um aluno.
GRADE      = [0-9]+ ("." [0-9]+)?

%%

/* --------------------- Início da seção "Lexical Rules" ------------------- */

/*
  Esta seção contém expressões regulares associadas a ações, i.e., código Java
  que será executado quando uma determinada expressão casar com parte da
  cadeia de entrada.

  Cada linha abaixo é uma regra léxica. O código Java entre chaves, denominado
  "ação", será executado sempre que a expressão regular à esquerda for
  encontrada.

  A ação pode conter qualquer tipo de código Java, e não é obrigatório retornar
  um valor. Se uma ação não retornar um valor, o token atual é simplesmente
  descartado, e o analisador começa a procurar o próximo.
 */

{AVG_PLACEHOLDER}  { return token(TokenType.AVG_PLACEHOLDER, yytext()); }
{COL_SEP}          { return token(TokenType.COL_SEP, yytext());         }
{HR}               { return token(TokenType.HR, yytext());              }
{STR}              { return token(TokenType.STR, yytext());             }
{WHITESPACE}       { return token(TokenType.WHITESPACE, yytext());      }

// Repare que, por causa da forma como as expressões regulares NUSP e GRADE
// foram definidas, existe uma ambiguidade: a sequência "1234567", teoricamente,
// poderia ser considerada uma nota (GRADE).
// Neste caso, entram em ação as regras de precedência, e a regra {NUSP}, por
// aparecer primeiro, será a regra escolhida.

{NUSP}             { return token(TokenType.NUSP, yytext());            }
{GRADE}            { return token(TokenType.GRADE, yytext());           }

// Regra para casos de erro: se chegarmos aqui, é porque não houve uma regra
// válida para aplicar à sequência de caracteres atual.

[^]                { throw new GradeSheetLexerError("Illegal character <" + yytext() + ">"); }
