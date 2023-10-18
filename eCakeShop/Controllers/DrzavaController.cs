using eCakeShop.Models.Requests;
using eCakeShop.Models;
using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCakeShop.Controllers
{
    public class DrzavaController : CRUDController<Models.Drzava, object, DrzavaUpsertRequest, DrzavaUpsertRequest>
    {
        public DrzavaController(IDrzavaService service) : base(service) { }

        [HttpGet]
        [AllowAnonymous]
        public override IEnumerable<Drzava> Get([FromQuery] object obj = null)
        {
            return base.Get(obj);
        }
    }
}
