# Step 1: Use an official Node.js runtime as the parent image (LTS version)
FROM node:20

# Step 2: Set the working directory inside the container
# This is where our application files will live
WORKDIR /usr/src/app

# Step 3: Copy the package.json and package-lock.json (if available)
# Doing this first allows Docker to cache dependencies if package.json hasn't changed
COPY package*.json ./

# Step 4: Install the application dependencies
RUN npm install

# Step 5: Copy the rest of the application code into the container
COPY . .

# Step 6: Expose port 3000 to the outside world
# This documents that the container listens on port 3000 at runtime
EXPOSE 3000

# Step 7: Define the command to run the application
# This runs the start script defined in package.json
CMD ["npm", "start"]
