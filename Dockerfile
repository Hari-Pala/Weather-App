# Stage 1: Build the React application
# Use a Node.js image to build the app
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the app for production
RUN npm run build

# Stage 2: Serve the application with Nginx
# Use a lightweight Nginx image for the final container
FROM nginx:stable-alpine

# Copy the build output from the builder stage into the Nginx public directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# The default Nginx command will run, serving the application
CMD ["nginx", "-g", "daemon off;"]
