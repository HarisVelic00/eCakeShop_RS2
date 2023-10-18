using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class NarudzbaController : CRUDController<Models.Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        public NarudzbaController(INarudzbaService service) : base(service) { }
    }
}
