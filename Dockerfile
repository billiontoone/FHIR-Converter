# Use the official .NET 6.0 SDK image from Microsoft, compatible with ARM64 architecture
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the entire solution to the container
COPY . ./

# Restore dependencies
RUN dotnet restore "src/Microsoft.Health.Fhir.Liquid.Converter.Tool/Microsoft.Health.Fhir.Liquid.Converter.Tool.csproj"

# Build the application
RUN dotnet publish "src/Microsoft.Health.Fhir.Liquid.Converter.Tool/Microsoft.Health.Fhir.Liquid.Converter.Tool.csproj" -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
COPY --from=build-env /app/data ./data

ENTRYPOINT ["dotnet", "Microsoft.Health.Fhir.Liquid.Converter.Tool.dll"]