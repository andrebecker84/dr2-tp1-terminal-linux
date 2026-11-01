# Enunciado — DR2 · TP1 (Teste de Performance)

- **Disciplina:** Sistemas Operacionais com Linux e Python
- **Bloco:** Ciência da Computação
- **Turma:** GRLENGR2C2-N2-L1
- **Trimestre:** 26E4_2
- **Professor:** Leonardo Silva da Gloria
- **Instituição:** Instituto Infnet

Texto do enunciado, na íntegra, como foi entregue pela disciplina.

> **Ajuste combinado em 26/10/2026:** o vídeo de defesa foi dispensado. A entrega é só o PDF, com os
> screenshots e os arquivos de evidência (.txt). As partes sobre o vídeo ficam abaixo apenas como registro do texto original.

---

Além dos screenshots, ao final deste Teste de Performance, você deverá gravar um vídeo com duração entre 4 e 6 minutos, no qual deverá:

* Explicar, com suas próprias palavras, o que foi feito em cada conjunto de exercícios;
* Demonstrar no terminal os principais comandos utilizados;
* Comentar brevemente a finalidade de cada comando no contexto do sistema operacional Linux.

## Exercício 1 — Papel do sistema operacional Linux em sistemas computacionais

**Contexto**

Em sistemas computacionais modernos, o sistema operacional é o componente responsável por intermediar o uso do hardware, organizar a execução de programas e fornecer serviços básicos para aplicações. O Linux é amplamente adotado nesses ambientes devido à sua estabilidade, previsibilidade e forte integração com ferramentas utilizadas em ciência da computação. Para atuar de forma consistente nesses contextos, é necessário compreender o papel do Linux como sistema operacional, indo além da simples execução de comandos. Este exercício tem como objetivo consolidar essa compreensão a partir da identificação de informações gerais do sistema e de sua função no ambiente computacional.

**Tarefa do aluno**

1. Acesse um sistema operacional Linux utilizando máquina virtual, WSL ou ambiente nativo
2. Utilize o terminal para identificar as seguintes informações gerais do sistema operacional em execução:
   a) Nome do sistema operacional
   b) Tipo de sistema operacional (baseado em Unix)
   c) Versão do sistema operacional
   d) Arquitetura do sistema (32 ou 64 bits)
3. Crie um arquivo de texto chamado sistema_linux.txt
4. Registre no arquivo todas as informações identificadas

## Exercício 2 — Distribuições Linux e contextos de uso

**Contexto**

O ecossistema Linux é composto por diversas distribuições que compartilham o mesmo núcleo, mas diferem em políticas de atualização, gestão de pacotes, estabilidade e público-alvo. Em ciência da computação, compreender essas diferenças é fundamental para selecionar ambientes adequados ao desenvolvimento, teste e implantação de sistemas. Este exercício foca na identificação prática da distribuição Linux utilizada e na relação entre distribuições e seus contextos típicos de uso, evitando sobreposição com a compreensão geral do papel do sistema operacional.

**Tarefa do aluno**

1. Utilize comandos do terminal para identificar o nome e a versão da distribuição Linux instalada
2. Crie um arquivo de texto chamado distribuicoes.txt
3. Registre no arquivo o nome e a versão da distribuição identificada
4. Cite outras duas distribuições Linux conhecidas
5. Associe cada uma das distribuições citadas a um contexto típico de uso em sistemas computacionais, como desenvolvimento, servidores ou containers

## Exercício 3

**Contexto**

Comandos básicos em linha de comando permitem acesso imediato a informações essenciais do sistema, sendo amplamente utilizados em scripts, automações e rotinas operacionais. Este exercício avalia a execução correta desses comandos e a interpretação de suas saídas.

**Tarefa do aluno**

1. Abra um emulador de terminal e execute, em sequência, os comandos date, cal, df, free e exit
2. Registre a saída de cada comando em um arquivo chamado comandos_basicos.txt.
3. Indique no arquivo quais comandos fornecem informações sobre armazenamento e memória

## Exercício 4

**Contexto**

O acompanhamento de recursos computacionais é fundamental para análise de desempenho, diagnóstico de problemas e planejamento de capacidade. Em sistemas Linux, essas informações são obtidas majoritariamente via linha de comando. Este exercício reforça a prática de coleta e organização dessas informações sem o uso de interfaces gráficas.

**Tarefa do aluno**

1. Utilize o terminal para obter informações sobre o processador do sistema
2. Utilize comandos para identificar dados de memória e armazenamento
3. Salve todas as saídas em um arquivo chamado recursos.txt

Identifique claramente no arquivo quais informações correspondem a CPU, memória e disco

## Exercício 5

**Contexto**

A navegação correta pelo sistema de arquivos é uma competência central em ciência da computação. Arquivos de configuração, logs e aplicações dependem de caminhos corretos e compreensão da hierarquia do sistema. Este exercício avalia a capacidade de navegação utilizando exclusivamente a linha de comando.

**Tarefa do aluno**

1. Navegue até o diretório /var/log utilizando comandos do terminal
2. Confirme o diretório atual
3. Retorne ao diretório pessoal do usuário
4. Registre todos os comandos utilizados em um arquivo chamado navegacao.txt

## Exercício 6

**Contexto**

Sistemas Linux armazenam dados em arquivos de diferentes naturezas, como texto, binários e logs. Identificar tipos de arquivos e visualizar conteúdos de forma segura é essencial para análise e manutenção de sistemas computacionais. Este exercício explora comandos fundamentais para inspeção de arquivos e diretórios.

**Tarefa do aluno**

1. Liste os arquivos do diretório pessoal utilizando ls
2. Escolha três arquivos distintos e utilize file para identificar seus tipos
3. Utilize less para visualizar o conteúdo de um arquivo de texto ou log
4. Registre os resultados em visualizacao.txt

## Exercício 7

**Contexto**

A manipulação de arquivos e diretórios é parte do fluxo cotidiano de trabalho em sistemas Linux. Criar, copiar e remover arquivos exige precisão e atenção ao contexto de execução. Este exercício simula operações comuns realizadas em ambientes computacionais reais.

**Tarefa do aluno**

1. Crie um diretório chamado tp_linux
2. Dentro dele, crie um arquivo chamado teste.txt
3. Copie esse arquivo para teste_backup.txt
4. Remova o arquivo teste.txt
5. Registre os comandos utilizados em manipulacao.txt

## Exercício 8

**Contexto**

O próprio Linux fornece mecanismos robustos de ajuda e documentação. A capacidade de consultar documentação diretamente no sistema é uma competência fundamental para atuação autônoma em ciência da computação. Este exercício avalia o uso consciente desses recursos.

**Tarefa do aluno**

1. Utilize type, which e help para investigar o comando ls
2. Utilize man, apropos, info e whatis para investigar o comando rm
3. Crie um alias simples para o comando ls
4. Registre todas as consultas e o alias criado em comandos_auxiliares.txt

## Exercício 9

**Contexto**

Pipelines permitem combinar comandos simples para formar operações mais expressivas, sendo amplamente utilizados em automação, análise de logs e processamento de dados em sistemas Linux. Este exercício introduz o uso prático de redirecionamento de entrada e saída.

**Tarefa do aluno**

1. Liste os arquivos do diretório /etc
2. Utilize um pipeline para paginar a saída
3. Redirecione o resultado para um arquivo chamado pipeline.txt
4. Verifique o conteúdo utilizando less

## Exercício 10

**Contexto**

Shell expansions permitem criar comandos mais eficientes e expressivos, reduzindo repetição e aumentando produtividade em ambientes computacionais. Este exercício avalia a aplicação correta dessas expansões.

**Tarefa do aluno**

1. Utilize expansões de shell para listar arquivos com extensão .log
2. Utilize expansões para criar múltiplos arquivos simultaneamente
3. Registre os comandos e resultados em expansoes.txt

## Exercício 11

**Contexto**

O uso correto de aspas simples e duplas é essencial para comandos que envolvem espaços, variáveis ou caracteres especiais. Em ambientes de linha de comando, erros nesse aspecto podem causar falhas difíceis de diagnosticar. Este exercício foca na precisão sintática.

**Tarefa do aluno**

1. Crie um arquivo com espaço no nome utilizando aspas adequadas
2. Compare o comportamento de aspas simples e duplas com o comando echo
3. Registre comandos e observações em aspas.txt

## Exercício 12

**Contexto**

A consolidação das competências ocorre quando diferentes conceitos são integrados em um único fluxo de trabalho. Este exercício final simula um cenário real de uso do terminal Linux em sistemas computacionais.

**Tarefa do aluno**

1. Crie um diretório chamado projeto_final
2. Utilize ls, file e less para inspecionar o arquivo
3. Utilize ao menos um comando auxiliar para investigar um dos comandos usados
4. Documente todo o processo em projeto_final.txt

## Entrega

Ao finalizar todos os exercícios:

1. Reúna todos os screenshots e os arquivos de evidência (.txt) gerados durante a execução das tarefas em um único arquivo PDF
2. Grave um vídeo entre 4 e 6 minutos, explicando e demonstrando no terminal as atividades realizadas
   * 2.1. O vídeo deve ser armazenado no seu Google Drive institucional
   * 2.2. Insira o link do vídeo ao final do PDF
3. Nomeie o arquivo conforme o padrão: nome_sobrenome_DR2_TP1.PDF
4. Poste o PDF e o vídeo como resposta a este Teste de Performance no ambiente da disciplina

## Orientações para Defesa do Trabalho em Vídeo

1. Utilize uma ferramenta adequada: É preciso que apareça a tela com seu trabalho e a imagem da sua webcam. Uma sugestão de ferramenta gratuita online para estudantes é o [Loom](https://www.loom.com/). Caso prefira, existe também a opção de baixar a ferramenta [OBS](https://obsproject.com/pt-br/download), dentre outras.
2. Escolha um local adequado: Grave em um ambiente calmo, sem ruídos ou distrações, para garantir boa qualidade de áudio e foco durante a defesa.
3. Webcam ligada: Certifique-se de que a webcam esteja ativada, com boa iluminação e enquadrando você de forma clara e centralizada.
4. Revise o vídeo: Assista a gravação para verificar se o vídeo e o áudio estão bons.
5. Salve o vídeo no Google Drive: Após a gravação, faça o upload do arquivo para o seu Google Drive de aluno Infnet.
6. Altere as permissões de acesso: Configure o compartilhamento do vídeo para "qualquer pessoa com o link" poder visualizar. Copie o link gerado e envie conforme as instruções da atividade.

Os screenshots devem evidenciar claramente os comandos executados e suas respectivas saídas.

O vídeo deve complementar o material escrito, funcionando como uma exposição técnica do conteúdo, demonstrando sua capacidade de operar o terminal Linux e executar corretamente as tarefas solicitadas.
