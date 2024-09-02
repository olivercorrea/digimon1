# Etapa de construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DigimonApi.csproj", "./"]
RUN dotnet restore "DigimonApi.csproj"
COPY . .
RUN dotnet build "DigimonApi.csproj" -c Release -o /app/build

# Etapa de publicación
FROM build AS publish
RUN dotnet publish "DigimonApi.csproj" -c Release -o /app/publish

# Etapa final: construir la imagen del contenedor
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "DigimonApi.dll"]
