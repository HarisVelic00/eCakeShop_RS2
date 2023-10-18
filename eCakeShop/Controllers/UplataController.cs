using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class UplataController : CRUDController<Models.Uplata, UplataSearchObject, UplataUpsertRequest, UplataUpsertRequest>
    {
        public UplataController(IUplataService service) : base(service) { }
    }
}
