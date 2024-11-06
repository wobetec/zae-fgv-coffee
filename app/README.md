# flutter_application_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Tests

### Create mockito mock

    dart run build_runner build

### Run tests

    flutter test .\test

### Lógica de Programação entre as Telas

Este aplicativo foi desenvolvido para atender tanto usuários comuns quanto membros da equipe de suporte (anteriormente referidos como administradores). A interface é intuitiva e permite que os usuários naveguem facilmente entre as diferentes funcionalidades disponíveis para cada tipo de usuário.

1. HomePage

Descrição: Página inicial do aplicativo.
Funcionalidade:
O usuário pode escolher entre fazer login ou se cadastrar.
Ações Disponíveis:
Sign In: Leva o usuário à LoginPage.
Sign Up: Leva o usuário à SignupPage.
2. LoginPage

Descrição: Página de login para usuários comuns.
Funcionalidade:
Possui um switch no canto superior direito que alterna entre "User" e "Support".
O switch utiliza as cores padrão do aplicativo e possui legendas "User" e "Support" próximas ao botão.
O switch está presente tanto na LoginPage quanto na SignInSupportPage.
Por padrão, o switch está definido como "User".
Ações Disponíveis:
Login como Usuário:
O usuário insere seu email e senha.
Ao clicar em Sign In, é autenticado e redirecionado para a HomeAppPage.
Alternar para Support:
Ao alternar o switch para "Support", o usuário é redirecionado para a SignInSupportPage.
Cadastro de Novo Usuário:
Ao clicar em "Don't have an account? Sign Up.", o usuário é levado à SignupPage.
3. SignInSupportPage

Descrição: Página de login específica para membros da equipe de suporte.
Funcionalidade:
Possui o mesmo switch no canto superior direito para alternar entre "User" e "Support".
Se o switch for alternado para "User", o usuário é redirecionado de volta à LoginPage.
Destinado exclusivamente para login de suporte.
Ações Disponíveis:
Login como Suporte:
O membro da equipe de suporte insere seu nome de usuário e senha.
Ao clicar em Sign In as Support, é autenticado e redirecionado para a SupportProfilePage.
4. SignupPage

Descrição: Página para novos usuários se cadastrarem.
Funcionalidade:
O usuário insere informações como nome, email, senha, etc.
Ações Disponíveis:
Sign Up: Cria uma nova conta e pode redirecionar o usuário para a HomeAppPage após o cadastro bem-sucedido.
5. HomeAppPage

Descrição: Página inicial para usuários comuns após o login.
Funcionalidade:
Exibe uma lista de produtos disponíveis.
O usuário pode navegar pelos produtos e selecionar um para ver mais detalhes.
Navegação:
Rodapé:
Home: Mantém o usuário na HomeAppPage.
Profile: Leva o usuário à UserPage.
6. UserPage

Descrição: Página de perfil do usuário.
Funcionalidade:
Exibe informações pessoais do usuário, como nome de usuário e email.
Oferece opções adicionais relacionadas à conta do usuário.
Ações Disponíveis:
Order History: Leva o usuário à OrderHistoryPage para visualizar seu histórico de pedidos.
My Favorites: Leva o usuário à MyFavoritePage para visualizar produtos favoritos.
Sign Out: Encerra a sessão e redireciona o usuário para a HomePage.
Navegação:
Rodapé:
Home: Leva o usuário de volta à HomeAppPage.
Profile: Mantém o usuário na UserPage.
7. SupportProfilePage

Descrição: Página de perfil para membros da equipe de suporte após o login.
Funcionalidade:
Exibe informações pessoais do membro da equipe de suporte.
Oferece ferramentas e opções específicas para suporte.
Ações Disponíveis:
Reports: Leva o usuário à ReportsPage para gerar e visualizar relatórios.
Sign Out: Encerra a sessão e redireciona o usuário para a HomePage.
8. ReportsPage

Descrição: Página para geração e visualização de relatórios.
Funcionalidade:
Exibe uma lista de relatórios disponíveis, organizados por data.
Permite ao membro da equipe de suporte gerar novos relatórios.
Ações Disponíveis:
Selecionar um Relatório: Visualizar detalhes de um relatório específico.
Generate Report: Gera um novo relatório e notifica o usuário sobre a conclusão.
9. ProductPage

Descrição: Página de detalhes de um produto específico.
Funcionalidade:
Exibe informações detalhadas do produto, incluindo descrição e informações nutricionais.
Mostra imagens do produto.
Ações Disponíveis:
Avaliar o Produto: O usuário pode dar uma nota de 1 a 5 estrelas.
Adicionar aos Favoritos: Um ícone de coração permite que o usuário adicione ou remova o produto de seus favoritos.
Order: Permite que o usuário faça um pedido do produto.
Navegação:
Rodapé:
Home: Leva o usuário de volta à HomeAppPage.
Profile: Leva o usuário à UserPage.
10. MyFavoritePage

Descrição: Página que lista todos os produtos marcados como favoritos pelo usuário.
Funcionalidade:
Permite que o usuário visualize e acesse rapidamente seus produtos favoritos.
Navegação:
Rodapé:
Home: Leva o usuário de volta à HomeAppPage.
Profile: Leva o usuário à UserPage.
11. OrderHistoryPage

Descrição: Página que exibe o histórico de pedidos do usuário.
Funcionalidade:
Lista todos os pedidos feitos pelo usuário, com detalhes como data, produtos e status.
Navegação:
Rodapé:
Home: Leva o usuário de volta à HomeAppPage.
Profile: Leva o usuário à UserPage.
Fluxo de Navegação

Para Usuários Comuns:

Início:
O usuário abre o aplicativo e é apresentado à HomePage.
Login:
O usuário seleciona Sign In e é levado à LoginPage.
Certifica-se de que o switch está definido como User.
Insere suas credenciais e faz login.
Exploração de Produtos:
Após o login, é redirecionado para a HomeAppPage.
Pode navegar pelos produtos e selecionar um para ver detalhes na ProductPage.
Interações Adicionais:
Pode adicionar produtos aos favoritos.
Pode fazer pedidos de produtos.
Perfil e Configurações:
Acessa a UserPage através do rodapé.
Pode visualizar seu histórico de pedidos e favoritos.
Tem a opção de fazer logout.
Para Membros da Equipe de Suporte:

Início:
O usuário abre o aplicativo e é apresentado à HomePage.
Login:
O usuário seleciona Sign In e é levado à LoginPage.
Alterna o switch no canto superior direito para Support, sendo redirecionado para a SignInSupportPage.
Insere suas credenciais de suporte e faz login.
Acesso a Ferramentas de Suporte:
Após o login, é redirecionado para a SupportProfilePage.
Pode gerar e visualizar relatórios na ReportsPage.
Logout:
Tem a opção de fazer logout para encerrar a sessão.