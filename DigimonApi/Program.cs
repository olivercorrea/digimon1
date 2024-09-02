using Microsoft.AspNetCore.Mvc;
using RestSharp;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors();

builder.WebHost.UseUrls("http://0.0.0.0:80");

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors(policy => policy
    .AllowAnyOrigin()
    .AllowAnyHeader()
    .AllowAnyMethod()
    .WithExposedHeaders("Content-Type")
    .WithExposedHeaders("Authorization")
);

app.MapGet("/recommendations", async ([FromQuery] string digimonName) =>
{
    var client = new RestClient("http://my-flask-container:5000");
    var request = new RestRequest("/recommend", Method.Get);
    request.AddParameter("digimon_name", digimonName);
    var response = await client.ExecuteAsync<List<string>>(request);

    if (response.IsSuccessful && response.Data != null)
    {
        return Results.Ok(response.Data);
    }
    return Results.BadRequest("Unable to get recommendations");
});

app.Run();
