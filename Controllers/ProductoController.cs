using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Models;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR","VENTAS")]
public class ProductoController : Controller
{
    private readonly IProductoRepositorio _productoRepositorio;
    private readonly ICategoriaRepositorio _categoriaRepositorio;

    public ProductoController(IProductoRepositorio productoRepositorio,ICategoriaRepositorio categoriaRepositorio)
    {
        _productoRepositorio = productoRepositorio;
        _categoriaRepositorio = categoriaRepositorio;
    }

    // GET: /Producto?buscar=polo&pagina=1
    public IActionResult Index(string? buscar,int pagina = 1)
    {
        const int tamanoPagina = 5;
        List<Producto> productos;
        int totalRegistros;

        if (!string.IsNullOrWhiteSpace(buscar))
        {
            productos = _productoRepositorio.Listar(buscar);
            totalRegistros = productos.Count;
        }
        else
        {
            productos = _productoRepositorio.ListarPaginado( pagina, tamanoPagina, out totalRegistros);
        }

        ViewBag.Buscar = buscar;
        ViewBag.Pagina = pagina;
        ViewBag.TotalPaginas = (int)Math.Ceiling(totalRegistros / (double)tamanoPagina);
        ViewData["Titulo"] = "Gestión de productos";
        return View(productos);
    }

    // GET: /Producto/Detalle/5
    public IActionResult Detalle(int id)
    {
        var producto = _productoRepositorio.ObtenerPorId(id);

        if (producto is null)
        {
            return NotFound();
        }

        return View(producto);
    }

    // GET: /Producto/Registrar
    [HttpGet]
    public IActionResult Registrar()
    {
        var modelo = new ProductoFormularioViewModel
        {
            Producto = new Producto
            {
                Activo = true
            },

            Categorias = _categoriaRepositorio.ListarActivas()
        };
        return View(modelo);
    }

    // POST: /Producto/Registrar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Registrar(
        ProductoFormularioViewModel modelo)
    {
        if (!ModelState.IsValid)
        {
            modelo.Categorias = _categoriaRepositorio.ListarActivas();
            return View(modelo);
        }

        try
        {
            if (modelo.Producto.Personalizable)
                modelo.Producto.Stock = 0;

            _productoRepositorio.Insertar(modelo.Producto);
            TempData["Exito"] = $"Producto '{modelo.Producto.Nombre}' registrado correctamente.";
            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message
            );

            modelo.Categorias = _categoriaRepositorio.ListarActivas();
            return View(modelo);
        }
    }

    // GET: /Producto/Editar/5
    [HttpGet]
    public IActionResult Editar(int id)
    {
        var producto = _productoRepositorio.ObtenerPorId(id);
        if (producto is null)
        {
            return NotFound();
        }
        var modelo = new ProductoFormularioViewModel
        {
            Producto = producto,
            Categorias = _categoriaRepositorio.ListarActivas()
        };

        return View(modelo);
    }

    // POST: /Producto/Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Editar(
        ProductoFormularioViewModel modelo)
    {
        if (!ModelState.IsValid)
        {
            modelo.Categorias =  _categoriaRepositorio.ListarActivas();
            return View(modelo);
        }
        try
        {
            if (modelo.Producto.Personalizable)
                modelo.Producto.Stock = 0;

            _productoRepositorio.Actualizar(modelo.Producto);
            TempData["Exito"] = $"Producto '{modelo.Producto.Nombre}' actualizado correctamente.";
            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError( string.Empty, ex.Message
            );
            modelo.Categorias =  _categoriaRepositorio.ListarActivas();
            return View(modelo);
        }
    }

    // POST: /Producto/Eliminar/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int id)
    {
        try
        {
            _productoRepositorio.Eliminar(id);
            TempData["Exito"] = "Producto desactivado correctamente.";
        }
        catch (SqlException ex)
        {
            TempData["Error"] = ex.Message;
        }
        return RedirectToAction(nameof(Index));
    }
}