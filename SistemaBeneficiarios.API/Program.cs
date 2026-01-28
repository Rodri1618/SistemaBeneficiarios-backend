using SistemaBeneficiarios.API.Data;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() 
    { 
        Title = "Sistema de Gestión de Beneficiarios API", 
        Version = "v1",
        Description = "API para gestionar beneficiarios de programas sociales multi-país"
    });
});

// Configurar CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp",
        builder =>
        {
            builder.WithOrigins("http://localhost:5173", "http://localhost:3000")
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});

// Registrar servicios
builder.Services.AddSingleton<DatabaseContext>();
builder.Services.AddScoped<IDocumentoIdentidadRepository, DocumentoIdentidadRepository>();
builder.Services.AddScoped<IBeneficiarioRepository, BeneficiarioRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowReactApp");

// app.UseHttpsRedirection();  // Comentado para desarrollo

app.UseAuthorization();

app.MapControllers();

app.Run();
