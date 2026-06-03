# Gerenciador de Itens para Churrasco

Salve Sor! Segue nosso appchurrasco!

## Integrantes do Grupo

* **Victor Roncoleta** — RA: 2410270
* **Ninna Ribeiro** — RA: 2401720

## Estrutura e Evolução do Código

No desenvolvimento do software, priorizamos preservar a integridade das funções base já existentes, passadas pelo professor, porém, adicionamos também novas features!

### Funcionalidades Originais Preservadas
* Estrutura principal da listagem dinâmica de itens na tela inicial.
* Modelo de dados unificado para representação e controle de cada produto.
* Alternância de status do item (pendente ou comprado) via checkbox.
* Mecanismo básico de remoção por meio do gesto de arrastar o card.

### Implementações Extra e Melhorias
* **Filtros de visualização:** Inclusão de seletores no topo da interface para segmentar a lista rapidamente entre todos os itens, apenas pendentes ou apenas comprados.
* **Ordenação por relevância:** Lógica de ordenação em tempo real que move automaticamente os itens marcados como concluídos para o final da lista, priorizando o que ainda precisa ser adquirido no topo da tela.
* **Categorização e identidade visual:** Criação de divisões por tipo (Carne, Bebida e Outros). Cada categoria injeta uma cor específica na borda lateral do card e exibe uma etiqueta descritiva.
* **Gesto duplo para ações rápidas:** O comportamento do componente de arrastar foi estendido. Deslizar para a esquerda confirma a exclusão do registro, enquanto deslizar para a direita abre o formulário inferior preenchido com os dados atuais do item para edição rápida.
* **Validação rigorosa de formulário:** Implementação de tratamento de erros no cadastro, impedindo registros com campos de texto em branco ou quantidades inválidas (menores ou iguais a zero).
* **Limpeza completa em lote:** Botão de ação posicionado na barra superior para limpar toda a lista simultaneamente, acompanhado de uma caixa de diálogo para confirmação do usuário antes da exclusão definitiva.


# Valeu Sor!
