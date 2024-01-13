using AutoMapper;
using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Database;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

namespace eCakeShop.Services.Services
{
    public class NarudzbaService : CRUDService<Models.Narudzba, Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>, INarudzbaService
    {
        public NarudzbaService(eCakeShopContext db, IMapper mapper) : base(db, mapper) { }

        public override Models.Narudzba Insert(NarudzbaInsertRequest request)
        {
            var entity = base.Insert(request);

            foreach (var proizvod in request.ListaProizvoda)
            {
                Database.NarudzbaProizvodi Proizvod = new Database.NarudzbaProizvodi();
                Proizvod.ProizvodID  = proizvod.ProizvodID;
                Proizvod.Kolicina = proizvod.Kolicina;
                Proizvod.NarudzbaID = entity.NarudzbaID;
                _db.Add(Proizvod);
            }
            _db.SaveChanges();
            return entity;
        }

        public override IQueryable<Narudzba> AddInclude(IQueryable<Narudzba> entity, NarudzbaSearchObject obj)
        {
            if (obj.IncludeKorisnik == true)
            {
                entity=entity.Include(x => x.Korisnik);
            }

            if (obj.IncludeNarudzbaProizvodi == true)
            {
                entity=entity.Include(x => x.Korisnik).Include(x => x.NarudzbaProizvodis).ThenInclude(x => x.Proizvod).ThenInclude(x => x.VrstaProizvoda);
            }

            if (obj.IncludeUplata == true)
            {
                entity=entity.Include(x => x.Uplata);
            }
            return entity;
        }

        public override void BeforeInsert(NarudzbaInsertRequest insert, Narudzba entity)
        {
            entity.BrojNarudzbe = Guid.NewGuid().ToString();
            entity.IsCanceled = false;
            entity.IsShipped = false;
            entity.KorisnikID = insert.KorisnikID;
            entity.DatumNarudzbe = DateTime.Now;
            entity.UplataID = insert.UplataID;
        }

        public override IQueryable<Narudzba> AddFilter(IQueryable<Narudzba> entity, NarudzbaSearchObject obj)
        {
            if (!string.IsNullOrWhiteSpace(obj.BrojNarudzbe))
            {
                entity = entity.Where(x => x.BrojNarudzbe.StartsWith(obj.BrojNarudzbe));
            }

            if (obj.KorisnikID.HasValue)
            {
                entity = entity.Where(x => x.KorisnikID == obj.KorisnikID);
            }

            if (obj.DatumOd.HasValue)
            {
                entity = entity.Where(x => x.DatumNarudzbe.Date >= obj.DatumOd.Value);
            }

            if (obj.DatumDo.HasValue)
            {
                entity = entity.Where(x => x.DatumNarudzbe.Date <= obj.DatumDo.Value);
            }

            if (obj.IsShipped.HasValue)
            {
                entity = entity.Where(x => x.IsShipped == obj.IsShipped);
            }

            if (obj.IsCanceled.HasValue)
            {
                entity = entity.Where(x => x.IsCanceled == obj.IsCanceled);
            }

            return entity;
        }
    }
}
