using eCakeShop.Models;
using eCakeShop.Models.Requests;
using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCakeShop.Controllers
{
    public class LokacijaController : CRUDController<Models.Lokacija, object, LokacijaUpsertRequest, LokacijaUpsertRequest>
    {
        public LokacijaController(ILokacijaService service) : base(service) { }

        [HttpGet]
        [AllowAnonymous]
        public override IEnumerable<Lokacija> Get([FromQuery] object obj = null)
        {
            return base.Get(obj);
        }
    }
}
