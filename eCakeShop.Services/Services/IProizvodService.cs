using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public interface IProizvodService : ICRUDService<Models.Proizvod, ProizvodSearchObject, ProizvodInsertRequest, ProizvodUpdateRequest>
    {
        List<Models.Proizvod> Recommend(int korisnikID);
    }
}
