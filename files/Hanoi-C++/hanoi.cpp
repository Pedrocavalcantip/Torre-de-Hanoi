#include <iostream> 
#include <limits>   
void torreDeHanoi(int n, char origem, char destino, char auxiliar) {
    // Caso base da recursão: se houver apenas 1 disco, o movimento é simples.
    if (n == 1) {
        // Move o único disco diretamente da origem para o destino.
        std::cout << "Mova o disco 1 do poste " << origem << " para o poste " << destino << std::endl;
        return; 
    }

    // 1º Passo: Mover a torre de n-1 discos da haste de ORIGEM para a haste AUXILIAR.
    torreDeHanoi(n - 1, origem, auxiliar, destino);

    // 2º Passo: Mover o disco maior (o n-ésimo disco) da haste de ORIGEM para a haste de DESTINO.
    std::cout << "Mova o disco " << n << " do poste " << origem << " para o poste " << destino << std::endl;

    // 3º Passo: Mover a torre de n-1 discos (da haste AUXILIAR) para a haste de DESTINO.
    torreDeHanoi(n - 1, auxiliar, destino, origem);
}

// Função principal, onde o programa começa.
int main() {
    int n; // Variável para armazenar o número de discos.

    // Laço infinito que só será quebrado quando uma entrada válida for fornecida.
    while (true) {
        // Pede ao usuário para inserir o número de discos.
        std::cout << "Digite o número de discos (entre 1 e 9): ";
        std::cin >> n;

        // O usuário digitou algo que NÃO é um número (ex: 'e')?
        if (std::cin.fail()) {
            std::cout << "Entrada inválida. Por favor, digite um NÚMERO." << std::endl;
            std::cin.clear(); // Limpa a flag de erro do std::cin.
            // Descarta toda a entrada inválida que ainda está no buffer, até a próxima quebra de linha.
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            continue; 
        }

        //  O número digitado está dentro do intervalo válido (1 a 9)?
        if (n >= 1 && n <= 9) {
            break; // A entrada é válida! Sai do loop.
        } else {
            // Se o número for inválido, exibe a mensagem de erro.
            std::cout << "Número inválido. Por favor, insira um número entre 1 e 9." << std::endl;
            // O loop continuará e pedirá a entrada novamente.
        }
    }

    // O programa só chega aqui depois que um número válido foi inserido.
    // Chama a função para resolver a Torre de Hanoi.
    torreDeHanoi(n, 'A', 'C', 'B');

    // Imprime uma mensagem final para indicar que todos os movimentos foram concluídos.
    std::cout << "Terminado !" << std::endl;
    
    return 0; 
}