using eCakeShop.Models.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public interface IVrstaProizvodaService : ICRUDService<Models.VrstaProizvoda, object, VrstaProizvodaUpsertRequest, VrstaProizvodaUpsertRequest>
    {
    }
}
