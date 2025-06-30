# Torre de Hanói em Assembly (NASM)

## Sobre o Projeto
Este projeto é uma implementação do clássico quebra-cabeça matemático "Torres de Hanói", desenvolvido inteiramente em Assembly (NASM) para a arquitetura x86 (32-bit). O programa é interativo, solicitando ao usuário o número de discos (entre 1 e 9) e, em seguida, exibe na tela o passo a passo completo com a solução ótima para resolver o problema.
Este foi um projeto acadêmico desenvolvido para aprofundar os conhecimentos em programação de baixo nível, gerenciamento de memória, chamadas de sistema (syscalls) do Linux e a implementação de algoritmos recursivos em Assembly.
Este projeto foi desenvolvido por Hugo Crasto e Pedro Cavalcanti.

### Divisão de Responsabilidades

* **Hugo Crasto:** Responsável pelo desenvolvimento das **funções auxiliares** que dão suporte ao programa, como as rotinas de entrada/saída de dados, validação da entrada do usuário e as funções de conversão entre caracteres e números.
* **Pedro Cavalcanti:** Responsável pela lógica central do algoritmo, incluindo a implementação da **recursão** (`mover_varios_discos`), do **caso base** (`mover_um_disco`) e pela definição das constantes e variáveis globais do programa (syscalls, mensagens, etc.).

## Tecnologias Utilizadas
* **Linguagem:** Assembly (NASM - Netwide Assembler)
* **Arquitetura:** x86 (32-bit)
* **Sistema Operacional:** Linux (para as syscalls)

## Funcionalidades
* Interface de console para solicitar ao usuário o número de discos.
* Validação de entrada para aceitar apenas números de 1 a 9.
* Implementação do algoritmo recursivo das Torres de Hanói.
* Exibição formatada de cada passo necessário para mover os discos da torre de origem para a torre de destino.
* Uso de funções modulares para entrada, saída e conversão de dados.

## Como Compilar e Executar

Este código foi feito para ser compilado no Linux. Certifique-se de ter o NASM e o LD (linker) instalados.

1.  **Montar o código (criar o arquivo objeto):**
    ```bash
    nasm -f elf32 seu_arquivo.asm -o seu_arquivo.o
    ```

2.  **Lincar o arquivo objeto (criar o executável):**
    ```bash
    ld -m elf_i386 seu_arquivo.o -o seu_executavel
    ```

3.  **Executar o programa:**
    ```bash
    ./seu_executavel
    ```

## Estrutura do Código
O programa é organizado em seções e funções, incluindo:
* `execução_geral`: O ponto de entrada e fluxo principal do programa.
* `resolver_hanoi`: A função que contém a lógica de decisão entre o caso base e o caso recursivo.
* `mover_um_disco`: Implementa a solução para o caso base (N=1).
* `mover_varios_discos`: Simula o passo recursivo (para N>1) através da manipulação de variáveis globais e da pilha.
* **Funções Auxiliares:** Um conjunto de rotinas para tarefas como exibir strings, ler a entrada do usuário, validar dados e converter tipos entre caractere e número.

 ## Fontes de estudo
Como fonte de estudo utilizamos as aulas de arquitetura de processadores, livro (mencionado abaixo) e IA (gemini) para dúvidas cruciais e correção de bugs.
* **ASSEMBLY NA PRÁTICA** por *Fernando Anselmo*.
