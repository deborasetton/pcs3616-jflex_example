/**
 * Erro lançado quando o lexer encontra um caractere inválido.
 */
public class GradeSheetLexerError extends Exception {
    public GradeSheetLexerError(String message) {
        super(message);
    }
}
