using AutoMapper;
using eCakeShop.Models.Requests;
using eCakeShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public class UlogaService : CRUDService<Models.Uloga, Uloga, object, UlogaUpsertRequest, UlogaUpsertRequest>, IUlogaService
    {
        public UlogaService(eCakeShopContext db, IMapper mapper) : base(db, mapper) { }
    }
}
