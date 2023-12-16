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
    public class LokacijaService : CRUDService<Models.Lokacija, Lokacija, object, LokacijaUpsertRequest, LokacijaUpsertRequest>, ILokacijaService
    {
        public LokacijaService(eCakeShopContext context, IMapper mapper) : base(context, mapper) { }
    }
}
