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
    public class GradService : CRUDService<Models.Grad, Grad, object, GradUpsertRequest, GradUpsertRequest>, IGradService
    {
        public GradService(eCakeShopContext db, IMapper mapper) : base(db, mapper) { }
    }
}
