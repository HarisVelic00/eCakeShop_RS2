using eCakeShop.Services.Database;
using eCakeShop.Services.Services;
using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using eCakeShop.Auth;
using eCakeShop;
using RabbitMQ.Client;
using eCakeShop.Services.RabbitMQ;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme , Id = "basicAuth"}
            },
            new string[]{}
        }
    });
});

builder.Services.AddDbContext<eCakeShopContext>(x => x.UseSqlServer(builder.Configuration.GetConnectionString("eCakeShop")));
builder.Services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddTransient<IDrzavaService, DrzavaService>();
builder.Services.AddTransient<IGradService, GradService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();

builder.Services.AddTransient<IVrstaProizvodaService, VrstaProizvodaService>();
builder.Services.AddTransient<IProizvodService, ProizvodService>();
builder.Services.AddTransient<IKorisnikService, KorisnikService>();

builder.Services.AddTransient<ISlikaService, SlikaService>();
builder.Services.AddTransient<IRecenzijaService, RecenzijaService>();
builder.Services.AddTransient<INovostService, NovostService>();
builder.Services.AddTransient<IProizvodService, ProizvodService>();
builder.Services.AddTransient<INarudzbaService, NarudzbaService>();
builder.Services.AddTransient<IMailProducer, MailProducer>();
builder.Services.AddTransient<ILokacijaService,  LokacijaService>();


builder.Services.AddTransient<IUplataService, UplataService>();
builder.Services.AddAutoMapper(typeof(IDrzavaService));

var factory = new ConnectionFactory() { HostName = "rabbitmq", Port = 5672 };
builder.Services.AddSingleton(factory);


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<eCakeShopContext>();
    dataContext.Database.Migrate();
}

app.Run();