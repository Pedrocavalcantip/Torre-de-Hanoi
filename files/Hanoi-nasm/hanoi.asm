segment .data
    LF          db     10          ; Define um byte na memória com o valor 10 e LF se torna o rótulo para seu endereço
    NULL        equ     0          ; Define o caractere nulo (NULL) como 0

    SYS_CALL    equ     0x80       ; Invoca a interrupção de chamada de sistema

    SYS_WRITE   equ     4          ; Define o syscall de escrita
    STD_OUT     equ     1          ; Define a saída padrão (stdout)

    SYS_READ    equ     3          ; Define o syscall de leitura
    STD_IN      equ     0          ; Define a entrada padrão (stdin)

    RET_EXIT    equ     0          ; Define o código de saída (0) para o syscall de saída
    SYS_EXIT    equ     1          ; Define o syscall de saída


section .data
    numero_discos   db   'Número de discos de (1 - 9): ', NULL
    texto_posicao    db  'Mova disco ',     NULL
    texto_origem    db   ' da torre ',  NULL
    texto_destino   db   ' para a torre ',  NULL
    texto_finzalizado   db  'Terminado!',   NULL
    caso_erro   db  'Comando inválido! Tente novamente. ',    NULL

    torre_origem    db  'A',    NULL
    torre_auxiliar   db  'B',    NULL
    torre_destino   db  'C',    NULL

;section .bss é usada para declarar variáveis não inicializadas.
; Variáveis não inicializadas são declaradas aqui, como buffers para entrada do usuário e armazenamento de dados temporários.
section .bss
    total_discos resb 1                 ; Buffer para armazenar o número de discos (reserve byte)
    buffer_numero_discos resb 2         ; Buffer para entrada do usuário (1 dígito + Enter)

section .text
    global _start
_start:
;execução_geral é o ponto de entrada do programa e de término do programa.
;É responsável por exibir a mensagem de solicitação, ler a entrada do usuário, validar a entrada e iniciar o processo de resolução do problema de Torre de Hanoi, 
;finalizar a resolução e exibir a mensagem de finalização, e interromper o programa.
execução_geral:
    mov ecx, numero_discos              ;carrega o endereço da string de solicitação em ecx
    call exibir_string                  ;chama a função exibir_string para exibir a mensagem

    mov ecx, buffer_numero_discos       ;carrega o endereço do buffer de entrada em ecx
    call leitura_de_entrada             ;chama a função leitura_de_entrada para capturar a entrada do usuário
    call verificar_entrada              ;chama a função verificar_entrada para validar a entrada do usuário
    call converter_caractere            ;chama a função converter_caractere para converter o caractere ASCII em um número

    mov [total_discos], al              ;armazena o número de discos convertido no buffer total_discos
    call resolver_hanoi                 ;chama a função resolver_hanoi para iniciar o processo de resolução do problema

    mov ecx, texto_finzalizado          ;carrega o endereço da string de finalização em ecx
    call exibir_string                  ;chama a função exibir_string para exibir a mensagem de finalização

    mov eax, SYS_EXIT                   ;carrega o syscall de saída em eax
    mov ebx, RET_EXIT                   ;define o código de saída (0)
    int SYS_CALL                        ;chama a interrupção para sair do programa


;função que resolve o problema de hanoi.
resolver_hanoi:
    cmp byte [total_discos], 1           ;compara o número de discos com 1
    je mover_um_disco                    ;se for igual a 1, salta para mover_um_disco
    jmp mover_varios_discos              ;se for maior que 1, salta para mover_varios_discos

    ;função que move um disco de uma torre para outra.
    mover_um_disco:
    mov ecx, texto_posicao              ;carrega o endereço da string "Mova o disco " em ecx
    call exibir_string                  ;exibe a string
    call escrita_numero_disco           ;chama a função escrita_numero_disco para exibir o número do disco (1)
    mov ecx, texto_origem               ;carrega o endereço da string " da torre " em ecx
    call exibir_string                  ;exibe a string
    mov ecx, torre_origem               ;carrega o endereço da torre de origem em ecx ('A')
    call exibir_string                  ;chama a função exibir_string para exibir a torre de origem
    mov ecx, texto_destino              ;carrega o endereço da string " para a torre " em ecx
    call exibir_string                  ;exibe a string
    mov ecx, torre_destino              ;carrega o endereço da torre de destino em ecx ('C')
    call exibir_string                  ;chama a função exibir_string para exibir a torre de destino
    mov ecx, LF                         ;carrega o endereço da quebra de linha em ecx
    call escrita_de_caractere           ;chama a função escrita_caractere para exibir a quebra de linha
    jmp fim_hanoi                       ;salta para fim_hanoi para finalizar a função

    ;função que move varios discos de uma torre para outra.
    mover_varios_discos:
    ;Toda vez que a função é chamada, ela move n-1 discos da torre de origem para a torre auxiliar, depois move o disco n da torre de origem para a torre de destino e finalmente move os n-1 discos da torre auxiliar para a torre de destino.
    dec byte [total_discos]            ;decrementa o número de discos em 1, total_dicos = total_discos - 1 (n = n-1) , coração da chamada recursiva.

    push word [total_discos]           ;salva o valor atual de total_discos na pilha para restaurar depois, a ordem de execução é importante, usamos word = 2 bytes , sp é 2 bytes.
    push word [torre_origem]           ;salva a torre de origem na pilha
    push word [torre_auxiliar]         ;salva a torre de destino na pilha
    push word [torre_destino]          ;salva a torre auxiliar na pilha

    ; principal chamada recursiva, move os discos de auxiliar para destino. "Engana" a função com a troca de torres.
    mov ax, [torre_auxiliar]           ;carrega a torre auxiliar em ax
    mov bx, [torre_destino]            ;carrega a torre de destino em bx
    mov [torre_destino], ax            ;atualiza a torre de destino com a torre auxiliar
    mov [torre_auxiliar], bx           ;atualiza a torre auxiliar com a torre de destino 

    call resolver_hanoi                ;chama a função recursiva para mover os discos

    ;fim da recursão, restaura os valores das torres e do número de discos.
    pop word [torre_destino]           ;restaura a torre de destino da pilha
    pop word [torre_auxiliar]          ;restaura a torre auxiliar da pilha
    pop word [torre_origem]            ;restaura a torre de origem da
    pop word [total_discos]            ;restaura o número de discos da pilha
    mov ecx, texto_posicao             ;carrega o endereço da string "Mova o disco " em ecx
    call exibir_string                 ;exibe a string
    inc byte [total_discos]            ;incrementa o número de discos em 1, total_dicos = total_discos + 1 (n = n+1) , coração da chamada recursiva.
    call escrita_numero_disco          ;chama a função escrita_numero_disco para exibir o número do disco atual
    dec byte [total_discos]            ;decrementa o número de discos em 1, total_dicos = total_discos - 1 (n = n-1) , coração da chamada recursiva.
    mov ecx, texto_origem              ;carrega o endereço da string " da torre " em ecx
    call exibir_string                 ;exibe a string
    mov ecx, torre_origem              ;carrega o endereço da torre de origem em ecx ('A')
    call exibir_string                 ;chama a função exibir_string para exibir a torre
    mov ecx, texto_destino             ;carrega o endereço da string " para a torre " em ecx
    call exibir_string                 ;exibe a string
    mov ecx, torre_destino             ;carrega o endereço da torre de destino em ecx ('C')
    call exibir_string                 ;chama a função exibir_string para exibir a torre de destino
    mov ecx, LF                        ;carrega o endereço da quebra de linha em ecx
    call escrita_de_caractere          ;chama a função escrita_caractere para exibir
    mov ax, [torre_auxiliar]           ;carrega a torre auxiliar em ax
    mov bx, [torre_origem]             ;carrega a torre de origem em bx
    mov [torre_origem], ax             ;atualiza a torre de origem com a torre auxiliar
    mov [torre_auxiliar], bx           ;atualiza a torre de destino com a torre de origem
    call resolver_hanoi                ;chama a função recursiva para mover os discos restantes

    fim_hanoi:
    ret                                ;retorna da função resolver_hanoi


; imprime uma string na tela, um caractere por vez, até encontrar um marcador de finalo (NULL).
exibir_string:
    push ecx                            ;salva o valor de ecx na pilha
    loop_exibir:
        mov al, [ecx]                   ;carrega o caractere atual da string em al
        cmp al, NULL                    ;compara se o caractere é o marcador de final (NULL)
        je fim_exibir                   ;se for NULL, salta para fim_exibir
        call escrita_de_caractere      ;chama a função escrita_de_caractere para exibir o caractere
        inc ecx                         ;incrementa ecx para o próximo caractere
        jmp loop_exibir                 ;volta para o início do loop para exibir o próximo caractere
    fim_exibir:
        pop ecx                         ;recupera o valor de ecx da pilha
        ret


;função que converte o caractere ASCII da entrada em um número.
converter_caractere:
    mov al, [buffer_numero_discos]      ;carrega o primeiro byte da entrada (ex: '4') em al.
    sub al, '0'                         ;subtrai o valor ASCII de '0' para converter o caractere em um número (ex: '4' -> 4).
    ret


;verificar a entrada do usuario.
verificar_entrada:
    mov al, [buffer_numero_discos]      ;carrega o primeiro byte da entrada em al
    cmp al, '1'                         ;compara se o valor é menor que '1'
    jl entrada_invalida                 ;se for menor, salta para entrada_invalida
    cmp al, '9'                         ;compara se o valor é maior que '9'
    jg entrada_invalida                 ;se for maior, salta para entrada_invalida
    mov dl, [buffer_numero_discos + 1]  ;carrega o segundo byte da entrada em dl
    cmp dl, 10                          ;compara se o segundo byte é igual a 10 (Enter)
    jne entrada_invalida                ;se não for igual, salta para entrada_invalida

    ; Se tudo estiver correto, a entrada é válida.
    entrada_valida:
    ret

    ;caso de entrada invalida, exibe uma mensagem de erro e retorna para a execução geral.
    entrada_invalida:
    mov ecx, caso_erro                  ;carrega o endereço da string de erro em ecx
    call exibir_string                  ;chama a função exibir_string para exibir a mensagem
    mov ecx, LF                         ;carrega o endereço da quebra de linha em ecx
    call escrita_de_caractere              ;chama a função escrita_caractere para exibir a quebra de linha
    jmp execução_geral              ;retorna para a execução geral


;função que exibe um unico caractere na tela.
leitura_de_entrada:
    mov eax, SYS_READ                   ;carrega o syscall de leitura em eax
    mov ebx, STD_IN                     ;define a entrada padrão (stdin)
    mov edx, 2                          ;define o tamanho máximo de leitura (2 bytes: 1 dígito + Enter)
    int SYS_CALL                        ;chama a interrupção para ler a entrada
    ret


;função que exibe um unico caractere na tela.
escrita_de_caractere:
    ; Usa o syscall de escrita para exibir um único caractere.
    mov eax, SYS_WRITE                  ;carrega o syscall de escrita em eax
    mov ebx, STD_OUT                    ;define a saída padrão (stdout)
    mov edx, 1                          ;define o tamanho de escrita (1 byte)
    int SYS_CALL                        ;chama a interrupção para escrever o caractere
    ret

;exibe o numero do disco na tela
escrita_numero_disco:
    ;converte o numero em total_discos para caracterete e exibe.
    mov al, [total_discos]              ;carrega o número de discos em al
    add al, '0'                         ;Soma o valor ASCII de '0' para converter o número em caractere 
    mov [buffer_numero_discos], al      ;armazena o caractere convertido no buffer de entrada
    mov ecx, buffer_numero_discos       ;carrega o endereço do buffer de entrada em ecx
    call escrita_de_caractere              ;chama a função escrita_caractere para exibir o caractere
    ret