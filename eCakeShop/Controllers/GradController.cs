using eCakeShop.Models;
using eCakeShop.Models.Requests;
using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCakeShop.Controllers
{
    public class GradController : CRUDController<Models.Grad, object, GradUpsertRequest, GradUpsertRequest>
    {
        public GradController(IGradService service) : base(service) { }

        [HttpGet]
        [AllowAnonymous]
        public override IEnumerable<Grad> Get([FromQuery] object obj = null)
        {
            return base.Get(obj);
        }
    }
}
