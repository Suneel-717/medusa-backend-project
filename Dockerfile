# Use Node.js base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy dependency files first
COPY package.json yarn.lock ./

# Install dependencies using Yarn
RUN yarn install

# Copy the rest of the application code
COPY . .

# Build the Medusa backend
RUN yarn build

# Expose Medusa backend port
EXPOSE 9000

# Start the server
CMD ["yarn", "start"]
