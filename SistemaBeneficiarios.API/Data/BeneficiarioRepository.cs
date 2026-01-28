using Dapper;
using SistemaBeneficiarios.API.DTOs;
using SistemaBeneficiarios.API.Models;
using System.Data;

namespace SistemaBeneficiarios.API.Data;

public interface IBeneficiarioRepository
{
    Task<IEnumerable<Beneficiario>> GetAllAsync();
    Task<IEnumerable<Beneficiario>> GetActivosAsync();
    Task<IEnumerable<Beneficiario>> GetInactivosAsync();
    Task<Beneficiario?> GetByIdAsync(int id);
    Task<Beneficiario> CreateAsync(CrearBeneficiarioDto beneficiario);
    Task<Beneficiario> UpdateAsync(int id, ActualizarBeneficiarioDto beneficiario);
    Task<bool> DeleteAsync(int id);
    Task<bool> RestoreAsync(int id);
}

public class BeneficiarioRepository : IBeneficiarioRepository
{
    private readonly DatabaseContext _context;

    public BeneficiarioRepository(DatabaseContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Beneficiario>> GetAllAsync()
    {
        using var connection = _context.CreateConnection();

        // Siempre llamar a sp_ListarTodosBeneficiarios
        return await connection.QueryAsync<Beneficiario>(
            "sp_ListarTodosBeneficiarios",
            commandType: CommandType.StoredProcedure
        );
    }


    public async Task<IEnumerable<Beneficiario>> GetActivosAsync()
    {
        using var connection = _context.CreateConnection();
        return await connection.QueryAsync<Beneficiario>(
            "sp_ListarBeneficiariosActivos",
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<Beneficiario>> GetInactivosAsync()
    {
        using var connection = _context.CreateConnection();
        return await connection.QueryAsync<Beneficiario>(
            "sp_ListarBeneficiariosInactivos",
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<Beneficiario?> GetByIdAsync(int id)
    {
        using var connection = _context.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<Beneficiario>(
            "sp_ObtenerBeneficiario",
            new { Id = id },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<Beneficiario> CreateAsync(CrearBeneficiarioDto beneficiario)
    {
        using var connection = _context.CreateConnection();
        var result = await connection.QueryFirstAsync<Beneficiario>(
            "sp_CrearBeneficiario",
            new
            {
                beneficiario.Nombres,
                beneficiario.Apellidos,
                beneficiario.DocumentoIdentidadId,
                beneficiario.NumeroDocumento,
                beneficiario.FechaNacimiento,
                beneficiario.Sexo
            },
            commandType: CommandType.StoredProcedure
        );
        return result;
    }

    public async Task<Beneficiario> UpdateAsync(int id, ActualizarBeneficiarioDto beneficiario)
    {
        using var connection = _context.CreateConnection();
        var result = await connection.QueryFirstAsync<Beneficiario>(
            "sp_ActualizarBeneficiario",
            new
            {
                Id = id,
                beneficiario.Nombres,
                beneficiario.Apellidos,
                beneficiario.DocumentoIdentidadId,
                beneficiario.NumeroDocumento,
                beneficiario.FechaNacimiento,
                beneficiario.Sexo
            },
            commandType: CommandType.StoredProcedure
        );
        return result;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        using var connection = _context.CreateConnection();
        var result = await connection.QueryFirstOrDefaultAsync<int>(
            "sp_EliminarBeneficiario",
            new { Id = id },
            commandType: CommandType.StoredProcedure
        );
        return result == 1;
    }

    public async Task<bool> RestoreAsync(int id)
    {
        using var connection = _context.CreateConnection();
        var result = await connection.QueryFirstOrDefaultAsync<int>(
            "sp_RestaurarBeneficiario",
            new { Id = id },
            commandType: CommandType.StoredProcedure
        );
        return result == 1;
    }
}
