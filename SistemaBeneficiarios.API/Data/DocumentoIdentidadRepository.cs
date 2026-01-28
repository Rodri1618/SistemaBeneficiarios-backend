using Dapper;
using SistemaBeneficiarios.API.Models;
using System.Data;

namespace SistemaBeneficiarios.API.Data;

public interface IDocumentoIdentidadRepository
{
    Task<IEnumerable<DocumentoIdentidad>> GetAllAsync();
    Task<DocumentoIdentidad?> GetByIdAsync(int id);
}

public class DocumentoIdentidadRepository : IDocumentoIdentidadRepository
{
    private readonly DatabaseContext _context;

    public DocumentoIdentidadRepository(DatabaseContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<DocumentoIdentidad>> GetAllAsync()
    {
        using var connection = _context.CreateConnection();
        return await connection.QueryAsync<DocumentoIdentidad>(
            "sp_ListarDocumentosIdentidad",
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<DocumentoIdentidad?> GetByIdAsync(int id)
    {
        using var connection = _context.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<DocumentoIdentidad>(
            "sp_ObtenerDocumentoIdentidad",
            new { Id = id },
            commandType: CommandType.StoredProcedure
        );
    }
}
