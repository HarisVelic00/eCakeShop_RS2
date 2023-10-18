using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class RecenzijaController : CRUDController<Models.Recenzija, RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    {
        public RecenzijaController(IRecenzijaService service) : base(service) { }
    }
}
