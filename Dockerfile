# syntax=docker/dockerfile:1

# tells Docker what image we would like to use to build our application
FROM mcr.microsoft.com/dotnet/sdk:7.0 as build-env

#This instructs Docker to use this path as the default location for all subsequent commands.
WORKDIR /src

#copy only the csproj files and then run dotnet restore
COPY src/*.csproj .
RUN dotnet restore 

#copy the files from the src directory on your local machine to a directory called src in the image.
COPY src .

# run the dotnet publish command to build the project.
RUN dotnet publish -c Release -o /publish

#specify the image that you’ll use to run the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as runtime

#specify the working directory for this stage.
WORKDIR /publish

#copy the /publish directory from the build-env stage into the runtime image.
COPY --from=build-env /publish .

#Expose port 80 to incoming requests.
EXPOSE 80

# tell Docker what command we want to run when our image is executed inside a container.
ENTRYPOINT ["dotnet", "myWebApp.dll"]