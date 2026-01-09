# Tutorial ollamaagentapp
# .NET commands
dotnet new list

dotnet run --configuration Release -- --help
dotnet run --configuration Debug

# Add solution in Solution Explorer | Open Solution
dotnet new solution --name ollamaagentapp
dotnet new console --name ollamaagentapp

# Create gitignore file
dotnet new gitignore

# Add projects to Solution | {Ctrl}+{Shift}+P
dotnet sln ollamaagentapp.sln add ollamaagentapp/

# Add package reference
dotnet add package OllamaSharp --version 3.0.14

# Create test project (xUnit)
dotnet new list | grep -i test
dotnet new xunit --name ollamaagentapptst

dotnet sln ollamaagentapp.sln add ollamaagentapptst/

# Add reference project to another project
cd ollamaagentapptst/
dotnet add reference ../ollamaagentapp/ollamaagentapp.csproj
