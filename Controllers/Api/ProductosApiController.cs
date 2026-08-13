using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Controllers.Api;

[ApiController]
[Route("api/[controller]")]
public class ProductosApiController : ControllerBase
{
    private readonly IProductoRepositorio _repo;

    public ProductosApiController(IProductoRepositorio repo) => _repo = repo;

    // GET api/productosapi
    [HttpGet]
    public ActionResult<IEnumerable<Producto>> Get()
    {
        return Ok(_repo.Listar());
    }

    // GET api/productosapi/5
    [HttpGet("{id}")]
    public ActionResult<Producto> Get(int id)
    {
        var producto = _repo.ObtenerPorId(id);

        if (producto == null)
            return NotFound();

        return Ok(producto);
    }

    // POST api/productosapi
    [HttpPost]
    public IActionResult Post(
        [FromBody] Producto producto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);
        _repo.Insertar(producto);

        return Ok(new
        {
            mensaje = "Producto registrado correctamente."
        });
    }

    // PUT api/productosapi/5
    [HttpPut("{id}")]
    public IActionResult Put(int id,[FromBody] Producto producto)
    {
        producto.ProductoId = id;
        _repo.Actualizar(producto);
        return Ok(new
        {
            mensaje = "Producto actualizado correctamente."
        });
    }

    // DELETE api/productosapi/5
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        _repo.Eliminar(id);
        return Ok(new
        {
            mensaje = "Producto eliminado correctamente."
        });
    }
}