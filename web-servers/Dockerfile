# Use the Node.js Alpine image as the base. It's lightweight and includes npm.
FROM node:18-alpine

# Install curl for debugging and testing purposes inside the container.
RUN apk update && apk add curl

# Set the working directory for subsequent commands.
WORKDIR /usr/src/app

# Copy package files first to leverage Docker's layer caching.
# The `npm install` step will only re-run if these files have changed.
COPY package*.json ./

# Install application dependencies.
RUN npm install

# Copy the rest of your application's source code into the container.
COPY . .

# Expose the port your application will run on.
EXPOSE 3000

# Define the default command to run when the container starts.
CMD [ "npm", "start" ]
