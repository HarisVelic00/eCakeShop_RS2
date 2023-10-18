using eCakeShop.Models.Requests;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class UlogaController : CRUDController<Models.Uloga, object, UlogaUpsertRequest, UlogaUpsertRequest>
    {
        public UlogaController(IUlogaService service) : base(service) { }
    }
}
