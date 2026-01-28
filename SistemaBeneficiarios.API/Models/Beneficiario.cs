namespace SistemaBeneficiarios.API.Models;

public class Beneficiario
{
    public int Id { get; set; }
    public string Nombres { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
    public int DocumentoIdentidadId { get; set; }
    public string? TipoDocumento { get; set; }
    public string? AbreviaturaDocumento { get; set; }
    public string? Pais { get; set; }
    public string NumeroDocumento { get; set; } = string.Empty;
    public DateTime FechaNacimiento { get; set; }
    public char Sexo { get; set; }
    public bool Activo { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime? FechaModificacion { get; set; }
}
