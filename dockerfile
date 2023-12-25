FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7166
ENV ASPNETCORE_URLS=http://+:7166

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "eCakeShop/eCakeShop.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "eCakeShop.dll"] 

# # Base image for the main API (eCakeShop)
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base-main
# WORKDIR /app/main
# EXPOSE 7166
# ENV ASPNETCORE_URLS=http://+:7166

# # Build the main API (eCakeShop)
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-main
# WORKDIR /src/main
# COPY eCakeShop ./eCakeShop
# RUN dotnet restore eCakeShop/eCakeShop.csproj
# RUN dotnet publish eCakeShop/eCakeShop.csproj -c Release -o /app/main

# # Final stage for the main API
# FROM base-main AS final-main
# WORKDIR /app/main
# COPY --from=build-main /app/main .

# ENTRYPOINT ["dotnet", "eCakeShop.dll"]

# # Base image for the Helper API (HelperAPI)
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base-helper
# WORKDIR /app/helper
# EXPOSE 7028
# ENV ASPNETCORE_URLS=http://+:7028

# # Build the Helper API (HelperAPI)
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-helper
# WORKDIR /src/helper
# COPY HelperAPI ./HelperAPI
# RUN dotnet restore HelperAPI/HelperAPI.csproj
# RUN dotnet publish HelperAPI/HelperAPI.csproj -c Release -o /app/helper

# # Final stage for the Helper API
# FROM base-helper AS final-helper
# WORKDIR /app/helper
# COPY --from=build-helper /app/helper .

# ENTRYPOINT ["dotnet", "HelperAPI.dll"]
