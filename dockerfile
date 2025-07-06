# Dockerfile

# Estágio de Build (SDK)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

# Copia os arquivos do projeto e restaura as dependências
COPY *.csproj .
RUN dotnet restore

# Copia o resto do código fonte e publica a aplicação
COPY . .
RUN dotnet publish -c Release -o /app/publish --no-restore

# Estágio Final (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Define a porta que a aplicação irá expor
EXPOSE 8080

# Ponto de entrada para rodar a aplicação
ENTRYPOINT ["dotnet", "MeuAppNetLinux.dll"]