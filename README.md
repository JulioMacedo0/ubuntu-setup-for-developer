# Ubuntu Development Environment Setup

Este script automatiza a instalação e configuração de um ambiente completo de desenvolvimento no Ubuntu, incluindo ferramentas como:

- Git, Curl, Build Essentials
- Java (OpenJDK 17)
- Google Chrome
- Visual Studio Code
- Snap apps: Postman, Spotify, Android Studio
- Homebrew e pacotes recomendados (ex: gcc)
- Flutter + FVM + Slidy
- Node.js (via NVM) e NestJS CLI
- Docker

---

## ✅ Pré-requisitos

- Ubuntu 20.04 ou superior
- Conexão com a internet
- Permissões de `sudo`

---

## 🚀 Como usar

1. Clone ou mova o script para uma pasta local

   cd /caminho/do/script

   Exemplo:
   cd ~/scripts

2. Dê permissão de execução ao script

   chmod +x setup-unbuntu.sh

   Substitua `setup-unbuntu.sh` pelo nome real do seu arquivo.

3. Execute o script

   ./setup-unbuntu.sh

---

## 📦 Softwares instalados

| Categoria          | Ferramentas                                      |
| ------------------ | ------------------------------------------------ |
| Utilitários        | Git, Curl, Fonts Fira Code, Build-Essential      |
| Navegador          | Google Chrome                                    |
| Editor de Código   | Visual Studio Code                               |
| Gerenciadores      | Snap, Homebrew                                   |
| Flutter            | FVM, Flutter (canal stable), Slidy               |
| Android            | Android Studio (via Snap), variáveis de ambiente |
| Java               | OpenJDK 17 (com JAVA_HOME configurado)           |
| Node.js e CLI      | NVM, Node.js v18.17.0, NestJS CLI                |
| Docker             | Docker Engine + configuração de grupo do usuário |
| Outras ferramentas | Postman, Spotify (via Snap)                      |

---

## 🧠 Dicas finais

Após a instalação, reinicie o terminal ou execute:

source ~/.bashrc

Para aplicar todas as variáveis de ambiente (como JAVA_HOME, ANDROID_HOME, PATH, etc).

---

## ✨ Contribuições

Sinta-se livre para modificar ou expandir o script conforme suas necessidades. Pull requests são bem-vindos!

---

## 🛡️ Licença

Este projeto está licenciado sob a licença MIT.
