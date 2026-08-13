using QuestPDF.Infrastructure;
using SportWear.Web.Data;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Data.Repositorios;
using SportWear.Web.Services;

var builder = WebApplication.CreateBuilder(args);
QuestPDF.Settings.License = LicenseType.Community;

builder.Services.AddControllersWithViews();
builder.Services.AddHttpClient();
builder.Services.AddScoped<ConexionBD>();
builder.Services.AddScoped<IUsuarioRepositorio,UsuarioRepositorio>();
builder.Services.AddScoped<IProductoRepositorio, ProductoRepositorio>();
builder.Services.AddScoped<ICategoriaRepositorio,CategoriaRepositorio>();
builder.Services.AddScoped<IClienteRepositorio, ClienteRepositorio>();
builder.Services.AddScoped<IClienteAccesoRepositorio, ClienteAccesoRepositorio>();
builder.Services.AddScoped<ISolicitudConfeccionRepositorio,SolicitudConfeccionRepositorio>();
builder.Services.AddScoped<ICotizacionRepositorio,CotizacionRepositorio>();
builder.Services.AddScoped<IPedidoRepositorio, PedidoRepositorio>();
builder.Services.AddScoped<IVentaRepositorio, VentaRepositorio>();
builder.Services.AddScoped<IFavoritoRepositorio, FavoritoRepositorio>();
builder.Services.AddScoped<IReporteRepositorio, ReporteRepositorio>();



builder.Services.AddDistributedMemoryCache();
builder.Services.AddScoped<CotizacionPdfService>();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.Name = ".SportWear.Session";
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("PermitirTodo", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseCors("PermitirTodo");

app.UseSession();

app.UseAuthorization();

app.MapControllers();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Catalogo}/{action=Index}/{id?}");

app.Run();