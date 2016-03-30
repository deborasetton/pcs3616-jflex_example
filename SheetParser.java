/**
 * O SheetParser funciona como um filtro do conteúdo original do arquivo.
 * Qualquer conteúdo constante é impresso diretamente na saída, e os
 * placeholders ("????") são substituídos pela média das notas.
 */
public class SheetParser {

    // O parser é um autômato muito simples, composto por dois estados.
    private enum State {
        DEFAULT, READING_GRADES
    }

    // Guarda o estado atual. O estado inicial é o DEFAULT.
    private State currentState = State.DEFAULT;

    // Guarda a soma das notas de um aluno. Usado para calcular a média
    // das notas.
    private double gradeSum = 0.0;

    // Guarda o número de notas lidas.
    private int count = 0;

    /**
     * Este método recebe um token por vez, e toma a ação apropriada de acordo
     * com o tipo do token e com o estado atual que em nos encontramos.
     * @param token
     */
    public void process(Token token) {
        switch (this.currentState) {

            case DEFAULT:
                // Se estamos no estado inicial, a primeira providência é
                // imprimir o token lido, exatamente da forma como ele estava
                // no arquivo de entrada.
                System.out.print(token.getValue());

                // Se o token que acabou de ser lido é uma nota (GRADE), então
                // vamos para o estado READING_GRADES, em que a soma das notas
                // será armazenada, para que a média possa ser calculada.
                if (token.getType() == TokenType.GRADE) {
                    this.currentState = State.READING_GRADES;
                    gradeSum += Float.parseFloat(token.getValue());
                    count++;
                }

                break;

            case READING_GRADES:
                // Se já estávamos lendo notas e encontramos mais uma nota,
                // simplesmente imprimimos a nota e atualizamos as somas.
                if (token.getType() == TokenType.GRADE) {
                    System.out.print(token.getValue());
                    gradeSum += Float.parseFloat(token.getValue());
                    count++;
                }
                // Se o token é um placeholder, a lista de notas do aluno atual
                // acabou, e é necessário imprimir a média final, voltar
                // para o estado inicial e resetar as somas.
                else if (token.getType() == TokenType.AVG_PLACEHOLDER) {
                    System.out.printf("%.2f", gradeSum /count);
                    this.currentState = State.DEFAULT;
                    gradeSum = 0;
                    count = 0;
                }
                // Algum espaço ou separador de coluna. Não é nada interessante,
                // só é necessário imprimir.
                else {
                    System.out.print(token.getValue());
                }
        }
    }
}
