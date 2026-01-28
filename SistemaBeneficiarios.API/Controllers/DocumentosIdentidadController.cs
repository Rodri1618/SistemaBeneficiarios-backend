using Microsoft.AspNetCore.Mvc;
using SistemaBeneficiarios.API.Data;

namespace SistemaBeneficiarios.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DocumentosIdentidadController : ControllerBase
{
    private readonly IDocumentoIdentidadRepository _repository;
    private readonly ILogger<DocumentosIdentidadController> _logger;

    public DocumentosIdentidadController(
        IDocumentoIdentidadRepository repository,
        ILogger<DocumentosIdentidadController> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    /// <summary>
    /// Obtiene todos los tipos de documentos de identidad activos
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        try
        {
            var documentos = await _repository.GetAllAsync();
            return Ok(documentos);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener documentos de identidad");
            return StatusCode(500, new { message = "Error al obtener los documentos de identidad", error = ex.Message });
        }
    }

    /// <summary>
    /// Obtiene un tipo de documento de identidad por ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        try
        {
            var documento = await _repository.GetByIdAsync(id);
            
            if (documento == null)
                return NotFound(new { message = "Documento de identidad no encontrado" });

            return Ok(documento);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener documento de identidad {Id}", id);
            return StatusCode(500, new { message = "Error al obtener el documento de identidad", error = ex.Message });
        }
    }
}
