# Tutorial 02-classlib
# .NET commands
dotnet new list

# .NET default templates for dotnet new
dotnet new solution
dotnet new gitignore

dotnet new classlib
dotnet new mstest

# Add projects to solution
dotnet sln add classlibraryapp/classlibraryapp.csproj
dotnet sln add classlibrarytst/classlibrarytst.csproj

# Add soluction in Solution Explorer | Open Solution
mv classlibraryapp 02-classlibraryapp

# Add project reference to test project
dotnet add reference ../classlibraryapp/classlibraryapp.csproj
