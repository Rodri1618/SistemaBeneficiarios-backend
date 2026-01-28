using Microsoft.AspNetCore.Mvc;
using SistemaBeneficiarios.API.Data;
using SistemaBeneficiarios.API.DTOs;

namespace SistemaBeneficiarios.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BeneficiariosController : ControllerBase
{
    private readonly IBeneficiarioRepository _repository;
    private readonly ILogger<BeneficiariosController> _logger;

    public BeneficiariosController(
        IBeneficiarioRepository repository,
        ILogger<BeneficiariosController> logger)
    {
        _repository = repository;
        _logger = logger;
    }



    /// <summary>
    /// Obtiene todos los beneficiarios con filtro opcional
    /// </summary>
    /// <param name="soloActivos">null = todos, true = solo activos, false = solo inactivos</param>
    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] bool? soloActivos )
    {
        try
        {
            var beneficiarios = await _repository.GetAllAsync();
            return Ok(beneficiarios);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener beneficiarios");
            return StatusCode(500, new { message = "Error al obtener los beneficiarios", error = ex.Message });
        }
    }



    /// <summary>
    /// Obtiene solo los beneficiarios activos
    /// </summary>
    [HttpGet("activos")]
    public async Task<IActionResult> GetActivos()
    {
        try
        {
            var beneficiarios = await _repository.GetActivosAsync();
            return Ok(beneficiarios);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener beneficiarios activos");
            return StatusCode(500, new { message = "Error al obtener los beneficiarios activos", error = ex.Message });
        }
    }

    /// <summary>
    /// Obtiene solo los beneficiarios inactivos
    /// </summary>
    [HttpGet("inactivos")]
    public async Task<IActionResult> GetInactivos()
    {
        try
        {
            var beneficiarios = await _repository.GetInactivosAsync();
            return Ok(beneficiarios);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener beneficiarios inactivos");
            return StatusCode(500, new { message = "Error al obtener los beneficiarios inactivos", error = ex.Message });
        }
    }

    /// <summary>
    /// Obtiene un beneficiario por ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        try
        {
            var beneficiario = await _repository.GetByIdAsync(id);
            
            if (beneficiario == null)
                return NotFound(new { message = "Beneficiario no encontrado" });

            return Ok(beneficiario);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener beneficiario {Id}", id);
            return StatusCode(500, new { message = "Error al obtener el beneficiario", error = ex.Message });
        }
    }

    /// <summary>
    /// Crea un nuevo beneficiario
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CrearBeneficiarioDto beneficiarioDto)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var beneficiario = await _repository.CreateAsync(beneficiarioDto);
            return CreatedAtAction(nameof(GetById), new { id = beneficiario.Id }, beneficiario);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al crear beneficiario");
            return StatusCode(500, new { message = "Error al crear el beneficiario", error = ex.Message });
        }
    }

    /// <summary>
    /// Actualiza un beneficiario existente
    /// </summary>
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] ActualizarBeneficiarioDto beneficiarioDto)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var beneficiario = await _repository.UpdateAsync(id, beneficiarioDto);
            return Ok(beneficiario);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al actualizar beneficiario {Id}", id);
            
            if (ex.Message.Contains("no existe"))
                return NotFound(new { message = ex.Message });
                
            return StatusCode(500, new { message = "Error al actualizar el beneficiario", error = ex.Message });
        }
    }

    /// <summary>
    /// Elimina un beneficiario (soft delete)
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            var result = await _repository.DeleteAsync(id);
            
            if (!result)
                return NotFound(new { message = "Beneficiario no encontrado" });

            return Ok(new { message = "Beneficiario eliminado exitosamente" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al eliminar beneficiario {Id}", id);
            
            if (ex.Message.Contains("no existe"))
                return NotFound(new { message = ex.Message });
                
            return StatusCode(500, new { message = "Error al eliminar el beneficiario", error = ex.Message });
        }
    }

    /// <summary>
    /// Restaura un beneficiario eliminado (reactivar)
    /// </summary>
    [HttpPatch("{id}/restaurar")]
    public async Task<IActionResult> Restore(int id)
    {
        try
        {
            var result = await _repository.RestoreAsync(id);
            
            if (!result)
                return NotFound(new { message = "Beneficiario no encontrado" });

            return Ok(new { message = "Beneficiario restaurado exitosamente" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al restaurar beneficiario {Id}", id);
            
            if (ex.Message.Contains("no existe"))
                return NotFound(new { message = ex.Message });
                
            return StatusCode(500, new { message = "Error al restaurar el beneficiario", error = ex.Message });
        }
    }
}
