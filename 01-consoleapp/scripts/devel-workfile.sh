# Linux commands
# Create diretory/file
mkdir -p 01-consoleapp/scripts
touch devel-workfile.sh
# Show directory tree from the current directory
tree

# AWS CodeCommit
# Configure credential helper
git config --local \
    credential.helper '!aws codecommit credential-helper --profile default $@'
git config --local credential.UseHttpPath true

# Tutorial consoleapp
# .NET commands
dotnet --help
dotnet --info

dotnet new list

# Add solution in Solution Explorer | Open Solution
dotnet new solution --name consoleapp
dotnet new console --name consoleapp

# Create gitignore file
dotnet new gitignore

# Add projects to Solution | {Ctrl}+{Shift}+P
dotnet sln consoleapp.sln add consoleapp/

dotnet clean
dotnet restore
dotnet build

# .NET default templates for dotnet new
dotnet new globaljson --sdk-version 8.0.302

# Create test project (xUnit)
dotnet new list | grep -i test
dotnet new xunit --name consoleapptst

dotnet sln consoleapp.sln add consoleapptst/

# Add reference project to another project
cd consoleapptst/
dotnet add reference ../consoleapp/consoleapp.csproj

# Test commands
dotnet test --list-tests

dotnet test --verbosity normal
dotnet test --logger "console;verbosity=normal"

dotnet test --filter \
  "FullyQualifiedName=consoleapptst.ProgramTest.Main"

dotnet test --verbosity normal --filter \
  "FullyQualifiedName=consoleapptst.ProgramTest.Main"

