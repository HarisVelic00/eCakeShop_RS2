using eCakeShop.Models;
using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class NovostController : CRUDController<Models.Novost, NovostSearchObject, NovostInsertRequest, NovostUpdateRequest>
    {
        public NovostController(INovostService service) : base(service) { }
    }
}
