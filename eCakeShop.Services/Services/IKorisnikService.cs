using Azure.Identity;
using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public interface IKorisnikService : ICRUDService<Models.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        Models.Korisnik Login(string username, string password);
        Models.Korisnik AddUloga(int id, KorisnikUpdateRequest request);
        Models.Korisnik DeleteUloga(int id, KorisnikUpdateRequest request);
        Models.Korisnik UpdateMobile (int id, KorisnikMobileUpdateRequest request);
    }
}
