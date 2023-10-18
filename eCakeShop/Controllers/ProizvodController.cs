using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Database;
using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Mvc;

namespace eCakeShop.Controllers
{
    public class ProizvodController : CRUDController<Models.Proizvod, ProizvodSearchObject, ProizvodInsertRequest, ProizvodUpdateRequest>
    {
        public ProizvodController(IProizvodService service) : base(service) { }

        [HttpGet("{id}/Recommended")]
        public List<Models.Proizvod> Recommend(int id)
        {
            return ((IProizvodService)_service).Recommend(id);
        }
    }
}
