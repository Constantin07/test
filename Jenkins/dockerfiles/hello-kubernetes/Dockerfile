FROM paulbouwer/hello-kubernetes:1.5

RUN npm install node-vault

# Overwrite original files
COPY server.js /usr/src/app/
COPY home.handlebars /usr/src/app/views/
