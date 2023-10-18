using AutoMapper;
using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public class RecenzijaService : CRUDService<Models.Recenzija, Recenzija, RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>, IRecenzijaService
    {
        public RecenzijaService(eCakeShopContext db, IMapper mapper) : base(db, mapper) { }

        public override IQueryable<Recenzija> AddInclude(IQueryable<Recenzija> entity, RecenzijaSearchObject obj)
        {
            if (obj.IncludeKorisnik == true)
            {
                entity = entity.Include(x => x.Korisnik);
            }
            return entity;
        }
    }
}
