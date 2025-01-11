# Stage 1: Build the application
FROM node:16 AS build-stage

# Set the working directory inside the container
WORKDIR /app

# Install dependencies
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy all source files into the container
COPY . .

# Stage 2: Create a smaller runtime image
FROM node:16-slim AS production-stage

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage to minimize image size
COPY --from=build-stage /app/package*.json ./

# Install production dependencies (no dev dependencies)
RUN npm install --only=production

# Copy the rest of the source code (only the app code, excluding build tools)
COPY --from=build-stage /app ./

# Expose the port the app runs on (change as necessary)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]

