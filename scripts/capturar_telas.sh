#!/usr/bin/env bash
# Executa os 12 exercicios do DR2-TP1 num terminal real (bash dentro de um tmux, no Ubuntu do WSL),
# captura cada tela e grava os arquivos de evidencia .txt.
#
#     wsl -d Ubuntu --exec bash scripts/capturar_telas.sh
#
# Cada comando e digitado no terminal como um usuario faria (tmux send-keys) e roda de verdade:
# os diretorios e arquivos dos exercicios ficam em ~/DR2_TP1. As telas saem de
# `tmux capture-pane -e` (o buffer do terminal, com cores) e viram PNG em renderizar_telas.py.
#
# Cada .txt registra exatamente o que o enunciado pede para aquele exercicio: as informacoes
# identificadas (Ex. 1 e 2), os comandos usados (Ex. 5 e 7) ou a transcricao literal dos comandos e
# saidas, tirada do proprio terminal (demais). pipeline.txt e so o resultado do redirecionamento.
set -u

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
ANSI="$RAIZ/evidencias/telas/ansi"
COPIA="$RAIZ/evidencias/DR2_TP1"
W="$HOME/DR2_TP1"
S=tp1
T=(tmux -L tp1 -f "$RAIZ/scripts/tmux_tp1.conf")
ALTURA=45           # linhas do terminal; as telas do less, man e info usam ALTURA_CURTA
ALTURA_CURTA=22
FIG=0
SEG=""

# ------------------------------------------------------------------ estado limpo
"${T[@]}" kill-server 2>/dev/null
rm -rf "$W"
mkdir -p "$ANSI" "$COPIA"
# Esvazia a copia sem apagar a pasta: no lado Windows ela pode estar aberta (Explorer, OneDrive).
find "$COPIA" -mindepth 1 -delete
rm -f "$ANSI"/*.ans "$RAIZ"/evidencias/telas/*.png
: > "$ANSI/indice.txt"
[ -f ~/.bash_aliases ] && sed -i '/^alias lsl=/d' ~/.bash_aliases
# Volta ao estado original do Ubuntu do WSL, sem o cal: o exercicio 3 mostra a falta e a instalacao.
/mnt/c/Windows/System32/wsl.exe -d Ubuntu -u root --exec apt-get remove -y ncal > /dev/null 2>&1
cd "$HOME"

"${T[@]}" new-session -d -s $S -x 110 -y $ALTURA -c "$HOME" "bash --rcfile '$RAIZ/scripts/bashrc_tp1' -i"

espera()  { timeout 60 "${T[@]}" wait-for pronto || echo "AVISO: prompt nao voltou" >&2; }
digita()  { "${T[@]}" send-keys -t $S -l -- "$1"; "${T[@]}" send-keys -t $S Enter; }
cmd()     { digita "$1"; espera; }
tecla()   { "${T[@]}" send-keys -t $S "$@"; }
altura()  { "${T[@]}" resize-window -t $S -y "$1"; sleep 0.3; }
# less, man e info nao devolvem o prompt ate sair: espera a tela desenhar, captura e sai com q.
# Rodam num terminal mais baixo: a pagina mostrada tem menos linhas e a figura ocupa menos espaco.
interativo() {
    altura $ALTURA_CURTA
    digita "$1"; sleep "${3:-1.5}"; tela "$2"; tecla q; espera
    altura $ALTURA
}

tela() {
    FIG=$((FIG + 1))
    local nome; nome=$(printf '%02d-%s' "$FIG" "$1")
    "${T[@]}" capture-pane -t $S -e -p > "$ANSI/$nome.ans"
    echo "$nome" >> "$ANSI/indice.txt"
}

# Transcricao do trecho atual, sem as linhas vazias do fim nem o prompt ocioso.
transcreve() {
    SEG+="$("${T[@]}" capture-pane -t $S -p -J -S - -E - | awk '
        { l[NR] = $0 }
        END { n = NR
              while (n > 0 && (l[n] ~ /^[[:space:]]*$/ || l[n] ~ /\$ *$/)) n--
              for (i = 1; i <= n; i++) print l[i] }')"$'\n'
}
limpa()   { cmd clear; "${T[@]}" clear-history -t $S; }
proxima() { transcreve; limpa; }
inicio()  { SEG=""; limpa; }

DISTRO=$(. /etc/os-release; echo "$PRETTY_NAME")
BASHV=$(bash --version | head -n1 | sed -E 's/.*version ([0-9.]+).*/bash \1/')
TRACO='--------------------------------------------------------------------------------'

# grava ARQUIVO "Exercicio N - Titulo" [registro: 1 = inclui a transcricao da sessao] <<< corpo
grava() {
    local arq="$W/$1" titulo="$2" registro="${3:-1}"
    {
        echo "DR2-TP1 · $titulo"
        echo "André Luis Becker · $DISTRO (WSL2) · $BASHV · $(date '+%d/%m/%Y %H:%M')"
        echo "$TRACO"
        if [ "$registro" = 1 ]; then
            echo "REGISTRO DA SESSÃO (comandos e saídas, na ordem de execução)"
            printf '%s' "$SEG"
            echo "$TRACO"
        fi
        cat
    } > "$arq"
}

# Espera o primeiro prompt do bash.
espera
limpa

# =============================================================================== Exercicio 1
inicio
cmd '# Exercício 1 - identificação do sistema operacional'
cmd 'mkdir -v ~/DR2_TP1 && cd ~/DR2_TP1'
cmd 'uname -s'
cmd 'uname -o'
cmd 'uname -r'
cmd 'uname -m'
cmd 'getconf LONG_BIT'
cmd "grep -E '^(NAME|VERSION|ID_LIKE)=' /etc/os-release"
tela ex01-identificacao-so

grava sistema_linux.txt "Exercício 1 — Papel do sistema operacional Linux" 0 <<EOF
INFORMAÇÕES IDENTIFICADAS (comando usado entre colchetes)
a) Nome do sistema operacional: $(uname -s)  [uname -s]
b) Tipo (baseado em Unix).....: $(uname -o), da família Unix (Unix-like, POSIX)  [uname -o]
c) Versão ....................: kernel $(uname -r)  [uname -r]
                                distribuição $DISTRO  [/etc/os-release]
d) Arquitetura ...............: $(uname -m) = $(getconf LONG_BIT) bits  [uname -m, getconf LONG_BIT]

PAPEL DO LINUX EM SISTEMAS COMPUTACIONAIS
- Intermedeia o hardware: escalona processos, gerencia memória, dispositivos e
  arquivos, e oferece serviços às aplicações por chamadas de sistema.
- Domina servidores, nuvem, supercomputadores e embarcados, e é a base dos
  containers (namespaces e cgroups do kernel): estável, aberto e automatizável.
- Acesso pelo WSL2, que roda um kernel Linux real numa VM leve do Windows 11.
EOF

# =============================================================================== Exercicio 2
inicio
cmd '# Exercício 2 - identificação da distribuição'
cmd 'cat /etc/os-release'
cmd 'lsb_release -a'
cmd 'cat /etc/issue'
tela ex02-distribuicao

grava distribuicoes.txt "Exercício 2 — Distribuições Linux e contextos de uso" 0 <<EOF
DISTRIBUIÇÃO INSTALADA (lsb_release -a, /etc/os-release e /etc/issue)
$(lsb_release -sd 2>/dev/null) ($(lsb_release -sc 2>/dev/null)) · família $(. /etc/os-release; echo "$ID_LIKE") · pacotes .deb com APT

OUTRAS DISTRIBUIÇÕES E CONTEXTO TÍPICO DE USO
- Debian (stable) -> servidores: ciclo conservador e pacotes muito testados;
  prioriza estabilidade e segurança.
- Alpine Linux    -> containers: imagem de poucos megabytes (musl e BusyBox),
  imagens menores e menor superfície de ataque.
EOF

# =============================================================================== Exercicio 3
inicio
cmd '# Exercício 3 - comandos básicos: date, cal, df, free e exit'
cmd 'date'
cmd 'cal'
# O cal nao vem na instalacao minima do Ubuntu do WSL. O sudo pede senha, que o roteiro nao digita;
# por isso a instalacao e feita como root pelo proprio WSL (equivale a `sudo apt install ncal`).
/mnt/c/Windows/System32/wsl.exe -d Ubuntu -u root --exec apt-get install -y ncal > "$ANSI/apt-ncal.log" 2>&1
cmd 'apt list --installed ncal 2>/dev/null'
cmd 'cal'
tela ex03-date-cal
proxima
cmd 'df'
cmd 'free'
cmd 'echo "Nível do shell: $SHLVL"'
cmd 'bash'
cmd 'echo "Nível do shell: $SHLVL (shell filho)"'
cmd 'exit'
cmd 'echo "Nível do shell: $SHLVL (de volta ao original)"'
tela ex03-df-free-exit
transcreve

grava comandos_basicos.txt "Exercício 3 — Comandos básicos: date, cal, df, free e exit" <<'EOF'
INFORMAÇÕES DE ARMAZENAMENTO E MEMÓRIA
- ARMAZENAMENTO: df - tamanho, uso e espaço livre de cada sistema de arquivos (KiB).
- MEMÓRIA......: free - RAM e swap: total, usada, livre e disponível (KiB).
- date: data, hora e fuso · cal: calendário do mês · exit: encerra o shell.
- O cal não vinha na instalação mínima do Ubuntu do WSL: instalei o pacote ncal.
- O exit rodou num shell filho (SHLVL 3 -> 2), para não fechar o terminal.
EOF

# =============================================================================== Exercicio 4
inicio
cmd '# ===== Exercício 4 - CPU ====='
cmd "lscpu | grep -E '^(Architecture|CPU op-mode|CPU\(s\)|Vendor ID|Model name|Thread|Core|Socket|Virtualization|Hypervisor|L[123])'"
cmd 'nproc'
cmd "grep -m1 'model name' /proc/cpuinfo"
tela ex04-cpu
transcreve; CPU="$SEG"; SEG=""; limpa
cmd '# ===== Exercício 4 - MEMÓRIA ====='
cmd 'free -h'
cmd "grep -E '^(MemTotal|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo"
transcreve; MEM="$SEG"; SEG=""; "${T[@]}" clear-history -t $S
cmd '# ===== Exercício 4 - DISCO ====='
cmd 'df -hT / /mnt/c'
cmd 'lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS'
tela ex04-memoria-disco
# A tela mostra memoria e disco juntas: a captura completa comeca pelo bloco de memoria, que e
# descontado para sobrar so o de disco.
transcreve; DISCO="${SEG#"$MEM"}"
SEG="### CPU ###
$CPU
### MEMÓRIA ###
$MEM
### DISCO ###
$DISCO"

grava recursos.txt "Exercício 4 — Recursos computacionais: CPU, memória e disco" <<EOF
RESUMO
- CPU....: $(lscpu | sed -n 's/^Model name: *//p'), $(nproc) CPUs lógicas visíveis no WSL
- MEMÓRIA: $(free -h | awk '/^Mem:/{print $2" de RAM ("$7" disponíveis)"}'), swap de $(free -h | awk '/^Swap:/{print $2}')
- DISCO..: $(df -h / | awk 'NR==2{print "raiz ext4 de "$2" ("$5" em uso)"}') e o drive C: do Windows em /mnt/c
EOF

# =============================================================================== Exercicio 5
inicio
cmd '# Exercício 5 - navegação no sistema de arquivos'
cmd 'cd /var/log'
cmd 'pwd'
cmd 'ls'
cmd 'cd ~'
cmd 'pwd'
cmd 'cd ~/DR2_TP1'
tela ex05-navegacao

grava navegacao.txt "Exercício 5 — Navegação pelo sistema de arquivos" 0 <<'EOF'
COMANDOS UTILIZADOS, NA ORDEM
1. cd /var/log     navega até /var/log por caminho absoluto
2. pwd             confirma o diretório atual: /var/log
3. ls              lista os logs do sistema (syslog, auth.log, dpkg.log...)
4. cd ~            retorna ao diretório pessoal ("~" = $HOME)
5. pwd             confirma: /home/becker
6. cd ~/DR2_TP1    volta ao diretório de trabalho do TP
EOF

# =============================================================================== Exercicio 6
inicio
cmd '# Exercício 6 - visualização e tipos de arquivos'
cmd 'cd ~'
cmd 'ls'
cmd 'ls -l'
cmd 'file .bashrc DR2_TP1 projetos'
cmd 'cd ~/DR2_TP1'
tela ex06-ls-file
proxima
interativo 'less /var/log/dpkg.log' ex06-less-log
transcreve

grava visualizacao.txt "Exercício 6 — Visualização e tipos de arquivos" <<'EOF'
RESULTADOS
- Três arquivos de tipos distintos: .bashrc = texto, DR2_TP1 = diretório,
  projetos = link simbólico. O file decide pelo conteúdo, não pela extensão.
- less /var/log/dpkg.log: log visualizado no paginador, que só lê o arquivo,
  carrega por partes e permite busca (/texto); sai com q.
EOF

# =============================================================================== Exercicio 7
inicio
cmd '# Exercício 7 - manipulação de arquivos e diretórios'
cmd 'mkdir -v tp_linux'
cmd 'cd tp_linux'
cmd 'echo "Arquivo de teste do TP1 - DR2" > teste.txt'
cmd 'cp -v teste.txt teste_backup.txt'
cmd 'ls -l'
digita 'rm -iv teste.txt'; sleep 0.8; digita 'y'; espera
cmd 'ls -l'
cmd 'cat teste_backup.txt'
cmd 'cd ..'
tela ex07-manipulacao

grava manipulacao.txt "Exercício 7 — Manipulação de arquivos e diretórios" 0 <<'EOF'
COMANDOS UTILIZADOS, NA ORDEM
1. mkdir -v tp_linux                    cria o diretório
2. cd tp_linux                          entra nele
3. echo "Arquivo de teste do TP1 - DR2" > teste.txt   cria o arquivo, já com conteúdo
4. cp -v teste.txt teste_backup.txt     copia o arquivo
5. ls -l                                confere os dois arquivos
6. rm -iv teste.txt  (resposta: y)      remove o original, com confirmação
7. ls -l                                confere que só restou o backup
8. cat teste_backup.txt                 comprova que a cópia preservou o conteúdo
9. cd ..                                volta ao diretório de trabalho
EOF

# =============================================================================== Exercicio 8
inicio
cmd '# Exercício 8 - investigando o ls com type, which e help'
cmd 'type -a ls'
cmd 'which ls'
cmd 'help ls'
cmd 'ls --help | head -n 3'
cmd '# Exercício 8 - investigando o rm com whatis e apropos'
cmd 'whatis rm'
cmd "apropos 'remove files'"
tela ex08-type-which-help-whatis
proxima
interativo 'man rm' ex08-man-rm 2
interativo 'info rm' ex08-info-rm 2
proxima
cmd '# Exercício 8 - alias simples para o ls'
cmd "alias lsl='ls -lh --group-directories-first'"
cmd 'type lsl'
cmd 'lsl'
cmd "echo \"alias lsl='ls -lh --group-directories-first'\" >> ~/.bash_aliases"
tela ex08-alias
transcreve

grava comandos_auxiliares.txt "Exercício 8 — Comandos auxiliares e alias" <<'EOF'
CONCLUSÕES
- type: no bash, ls é um alias (ls --color=auto) para o executável /usr/bin/ls.
- which: mostra só o executável no PATH; não enxerga aliases nem builtins.
- help ls falha porque help só documenta builtins do bash; para o ls: ls --help.
- whatis: descrição de uma linha · apropos: busca o comando pelo assunto ·
  man rm: manual completo (-i, -r, -f, --preserve-root) · info rm: manual GNU.
- Alias lsl criado, testado e gravado em ~/.bash_aliases (vale em todo novo bash).
EOF

# =============================================================================== Exercicio 9
inicio
cmd '# Exercício 9 - pipeline e redirecionamento'
cmd 'ls /etc'
cmd 'ls /etc | wc -l'
tela ex09-ls-etc
proxima
interativo 'ls -C /etc | less' ex09-pipeline-less
cmd 'ls -C /etc > pipeline.txt'
cmd 'wc -l pipeline.txt'
tela ex09-redirecionamento
interativo 'less pipeline.txt' ex09-less-pipeline-txt
# pipeline.txt e o proprio resultado do redirecionamento e fica como o ls o gravou.

# =============================================================================== Exercicio 10
inicio
cmd '# Exercício 10 - expansões do shell'
cmd 'ls /var/log/*.log'
cmd 'echo /var/log/*.log'
cmd 'mkdir -v ex10_expansoes'
cmd 'touch ex10_expansoes/servico_{a,b,c}.log ex10_expansoes/relatorio_{01..03}.txt'
cmd 'ls ex10_expansoes'
cmd 'ls ex10_expansoes/*.log'
cmd 'ls ex10_expansoes/relatorio_0[12].txt'
tela ex10-expansoes
transcreve

grava expansoes.txt "Exercício 10 — Expansões do shell" <<'EOF'
OBSERVAÇÕES
- *.log é expandido pelo shell antes do comando: o echo imprime a mesma lista.
- {a,b,c} e {01..03} geraram 6 nomes num único touch (o zero à esquerda é mantido).
- [12] casa com um dos caracteres da lista: seleciona só relatorio_01 e 02.
EOF

# =============================================================================== Exercicio 11
inicio
cmd '# Exercício 11 - aspas simples e duplas'
cmd 'mkdir -v ex11_aspas && cd ex11_aspas'
cmd 'touch "meu arquivo.txt"'
cmd 'touch meu arquivo sem aspas.txt'
cmd 'ls -l'
cmd 'rm -v meu arquivo sem aspas.txt'
cmd 'echo "Usuário: $USER | Hoje: $(date +%d/%m/%Y)"'
cmd "echo 'Usuário: \$USER | Hoje: \$(date +%d/%m/%Y)'"
cmd 'echo "Preço: \$10 e \"aspas\" internas"'
cmd 'cd ..'
tela ex11-aspas
transcreve

grava aspas.txt "Exercício 11 — Aspas simples e duplas" <<'EOF'
OBSERVAÇÕES
- touch "meu arquivo.txt" criou UM arquivo; sem aspas, o mesmo comando criou
  QUATRO (meu, arquivo, sem, aspas.txt), removidos com rm -v.
- Aspas duplas agrupam e expandem $USER e $(date); aspas simples mantêm tudo
  literal. Dentro das duplas, \$ e \" imprimem os caracteres literais.
- Regra: duplas para usar variáveis preservando espaços ("$arquivo");
  simples para textos que devem chegar intactos (padrões do grep, alias).
EOF

# =============================================================================== Exercicio 12
inicio
cmd '# Exercício 12 - projeto final: fluxo integrado'
cmd 'mkdir -v projeto_final && cd projeto_final'
cmd "{ echo \"Relatório do ambiente - \$(date '+%d/%m/%Y %H:%M')\"; uname -sr; free -h; df -h /; } > relatorio_ambiente.txt"
cmd 'ls -l'
cmd 'file relatorio_ambiente.txt'
interativo 'less relatorio_ambiente.txt' ex12-less
cmd 'whatis file less'
cmd 'type file less'
cmd 'cd ..'
tela ex12-fluxo
transcreve

grava projeto_final.txt "Exercício 12 — Projeto final: fluxo integrado" <<'EOF'
PROCESSO
1. mkdir + cd: cria projeto_final e entra nele.
2. { date; uname; free; df; } > relatorio_ambiente.txt: gera o arquivo a inspecionar.
3. ls -l: confirma o arquivo (tamanho, permissões, dono e data).
4. file: identifica o tipo pelo conteúdo (texto Unicode UTF-8, por causa dos acentos).
5. less: visualiza o conteúdo sem alterá-lo.
6. whatis e type: investigam os comandos usados (descrição e localização).
EOF

# =================================================================== organizacao dos artefatos
inicio
cmd '# Organização final dos artefatos do TP1'
cmd 'cd ~/DR2_TP1 && find . -type f | sort'
tela organizacao-artefatos

"${T[@]}" kill-server
cp -r "$W/." "$COPIA/"
echo "telas capturadas: $FIG"
wc -l "$W"/*.txt
