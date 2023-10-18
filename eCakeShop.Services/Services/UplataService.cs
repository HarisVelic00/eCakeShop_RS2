using AutoMapper;
using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public class UplataService : CRUDService<Models.Uplata, Uplata, UplataSearchObject, UplataUpsertRequest, UplataUpsertRequest>, IUplataService
    {
        public UplataService(eCakeShopContext db, IMapper mapper) : base(db, mapper) { }

        public override void BeforeInsert(UplataUpsertRequest request, Uplata entity)
        {
            entity.DatumTransakcije = DateTime.Now;
        }
    }
}
