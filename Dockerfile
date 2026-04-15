# Usamos la versión estable de Node
FROM node:18-alpine

# Copiamos los archivos de dependencias
COPY package*.json ./

# Instalamos las librerías
RUN npm install

# Copiamos el resto del código
COPY . .

# Exponemos el puerto que usa Railway
EXPOSE 8080

# Comando para arrancar la app
CMD ["node", "index.js"]
