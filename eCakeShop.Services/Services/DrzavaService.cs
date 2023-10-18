using AutoMapper;
using eCakeShop.Models.Requests;
using eCakeShop.Services.Database;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public class DrzavaService : CRUDService<Models.Drzava, Drzava, object, DrzavaUpsertRequest, DrzavaUpsertRequest>, IDrzavaService
    {
        public DrzavaService(eCakeShopContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
