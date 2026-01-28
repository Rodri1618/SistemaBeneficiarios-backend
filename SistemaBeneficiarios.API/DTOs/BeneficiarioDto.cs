using System.ComponentModel.DataAnnotations;

namespace SistemaBeneficiarios.API.DTOs;

public class CrearBeneficiarioDto
{
    [Required(ErrorMessage = "Los nombres son requeridos")]
    [StringLength(100, ErrorMessage = "Los nombres no pueden exceder 100 caracteres")]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son requeridos")]
    [StringLength(100, ErrorMessage = "Los apellidos no pueden exceder 100 caracteres")]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "El tipo de documento es requerido")]
    public int DocumentoIdentidadId { get; set; }

    [Required(ErrorMessage = "El número de documento es requerido")]
    [StringLength(20, ErrorMessage = "El número de documento no puede exceder 20 caracteres")]
    public string NumeroDocumento { get; set; } = string.Empty;

    [Required(ErrorMessage = "La fecha de nacimiento es requerida")]
    public DateTime FechaNacimiento { get; set; }

    [Required(ErrorMessage = "El sexo es requerido")]
    [RegularExpression("^[MF]$", ErrorMessage = "El sexo debe ser M o F")]
    public char Sexo { get; set; }
}

public class ActualizarBeneficiarioDto
{
    [Required(ErrorMessage = "Los nombres son requeridos")]
    [StringLength(100, ErrorMessage = "Los nombres no pueden exceder 100 caracteres")]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son requeridos")]
    [StringLength(100, ErrorMessage = "Los apellidos no pueden exceder 100 caracteres")]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "El tipo de documento es requerido")]
    public int DocumentoIdentidadId { get; set; }

    [Required(ErrorMessage = "El número de documento es requerido")]
    [StringLength(20, ErrorMessage = "El número de documento no puede exceder 20 caracteres")]
    public string NumeroDocumento { get; set; } = string.Empty;

    [Required(ErrorMessage = "La fecha de nacimiento es requerida")]
    public DateTime FechaNacimiento { get; set; }

    [Required(ErrorMessage = "El sexo es requerido")]
    [RegularExpression("^[MF]$", ErrorMessage = "El sexo debe ser M o F")]
    public char Sexo { get; set; }
}
