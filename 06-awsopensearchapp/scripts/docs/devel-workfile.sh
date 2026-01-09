# Linux commands
# Create diretory/file
mkdir -p 06-awsopensearchapp/scripts
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
dotnet new solution --name awsopensearchapp
dotnet new console --name awsopensearchapp

# Create gitignore file
dotnet new gitignore

# Add projects to Solution | {Ctrl}+{Shift}+P
dotnet sln awsopensearchapp.sln add awsopensearchapp/

dotnet clean
dotnet restore
dotnet build

# Create test project (xUnit)
dotnet new list | grep -i test
dotnet new xunit --name awsopensearchapptst

dotnet sln awsopensearchapp.sln add awsopensearchapptst/

# Add reference project to another project
cd awsopensearchapptst/
dotnet add reference ../awsopensearchapp/awsopensearchapp.csproj

