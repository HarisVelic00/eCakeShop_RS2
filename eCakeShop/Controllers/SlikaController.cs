using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Database;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class SlikaController : CRUDController<Models.Slika, SlikaSearchObject, SlikaInsertRequest, SlikaUpdateRequest>
    {
        public SlikaController(ISlikaService service) : base(service) { }
    }
}
