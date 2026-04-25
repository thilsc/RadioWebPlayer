# 📻 Web Rádio Player - React.js

Um player de rádio web moderno e responsivo construído com React.js e Vite.

## ✨ Funcionalidades

- **Reprodução de áudio streaming** - Suporte para streams de rádio em tempo real
- **Lista de estações** - Múltiplas estações de rádio portuguesas pré-configuradas
- **Controle de volume** - Ajuste de volume integrado
- **Interface moderna** - Design elegante e responsivo
- **Visualização de áudio** - Animação visual durante a reprodução
- **Indicador de reprodução** - Mostra qual estação está tocando no momento
- **Responsivo** - Funciona perfeitamente em dispositivos móveis e desktop

## 🚀 Tecnologias Utilizadas

- **React.js** - Biblioteca JavaScript para construção de interfaces
- **Vite** - Build tool ultra-rápida
- **CSS3** - Estilização com gradientes e animações
- **HTML5 Audio API** - Reprodução de áudio nativa

## 📁 Estrutura do Projeto

```
radio-web-player/
├── src/
│   ├── components/
│   │   ├── RadioPlayer.jsx      # Componente principal do player
│   │   ├── RadioPlayer.css      # Estilos do player
│   │   ├── StationList.jsx      # Lista de estações
│   │   └── StationList.css      # Estilos da lista
│   ├── data/
│   │   └── stations.js          # Dados das estações de rádio
│   ├── App.jsx                  # Componente principal da aplicação
│   ├── App.css                  # Estilos globais
│   ├── main.jsx                 # Ponto de entrada
│   └── index.css                # Reset CSS
├── public/
├── index.html
├── package.json
└── vite.config.js
```

## 🛠️ Instalação

1. Clone o repositório ou navegue até a pasta do projeto:
```bash
cd radio-web-player
```

2. Instale as dependências:
```bash
npm install
```

3. Inicie o servidor de desenvolvimento:
```bash
npm run dev
```

4. Abra seu navegador e acesse `http://localhost:5173`

## 📦 Comandos Disponíveis

- `npm run dev` - Inicia o servidor de desenvolvimento
- `npm run build` - Compila o projeto para produção
- `npm run preview` - Visualiza a build de produção localmente

## 🎵 Adicionando Novas Estações

Para adicionar novas estações de rádio, edite o arquivo `src/data/stations.js`:

```javascript
{
  id: 9,
  name: "Nome da Rádio",
  frequency: "XX.X FM",
  streamUrl: "https://url-do-stream.com/stream.mp3",
  logo: "https://url-da-logo.com/logo.png",
  genre: "Gênero Musical"
}
```

## 🌟 Recursos Principais

### Player de Rádio
- Botão play/pause com indicador visual
- Controle de volume deslizante
- Informações da estação atual (nome, frequência, gênero)
- Logo da estação
- Visualizador de áudio animado

### Lista de Estações
- Grid responsivo de estações
- Indicador visual da estação em reprodução
- Hover effects para melhor UX
- Logos individuais por estação

## 📱 Responsividade

O player é totalmente responsivo e se adapta a diferentes tamanhos de tela:
- Desktop (≥768px)
- Mobile (<768px)

## 🎨 Personalização

Você pode personalizar as cores e estilos editando os arquivos CSS:
- `src/App.css` - Estilos globais
- `src/components/RadioPlayer.css` - Estilos do player
- `src/components/StationList.css` - Estilos da lista

## 📝 Notas

- Alguns streams podem ter restrições de CORS
- A qualidade do áudio depende da fonte do stream
- Logos das estações são carregados de URLs externas

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir novas funcionalidades
- Enviar pull requests

## 📄 Licença

Este projeto é open source e está disponível sob a licença MIT.

---

Desenvolvido com ❤️ usando React.js
