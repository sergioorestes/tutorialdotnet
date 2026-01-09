spavueviteapp# Tutorial spavueviteapp
# .NET commands
dotnet new list

# Create template project
dotnet new mvc -o spavueviteapp

# Add solution in Solution Explorer | Open Solution
dotnet new solution --name spavueviteapp

# Add projects to Solution | {Ctrl}+{Shift}+P (Open Solution)
dotnet sln spavueviteapp.sln add spavueviteapp/

# Setting up the Vue.js Client (TypeScript)
npm create vite@latest ClientApp -- --template vue-ts

cd ClientApp
npm install
npm run dev

npm run build
npm run preview

# Vite.AspNetCore integration
dotnet add package Vite.AspNetCore

# Vite build and deployment
vite build --help

cd ClientApp
vite build

# Kill server
ps -ax | grep vite

npx kill-port 5173
