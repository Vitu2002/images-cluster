# Use Node.js v18 as base image
FROM node:18

# Install libvips to use sharp
RUN apt-get update && \
    apt-get install -y libvips && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and yarn.lock
COPY package.json ./
COPY yarn.lock ./

# Install dependencies
RUN yarn install

# Copy source code
COPY . .

# Compile nest project
RUN yarn build

# Start the application
CMD ["yarn", "start:prod"]