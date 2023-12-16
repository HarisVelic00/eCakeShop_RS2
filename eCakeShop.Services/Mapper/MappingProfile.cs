using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eCakeShop.Models.Requests;
using System.Runtime.CompilerServices;
using eCakeShop.Models;

namespace eCakeShop.Services.Mapper
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Drzava, Drzava>();
            CreateMap<Database.Grad, Grad>();
            CreateMap<Database.Uloga, Uloga>();
            CreateMap<Database.VrstaProizvoda, VrstaProizvoda>();
            CreateMap<Database.Proizvod, Proizvod>();
            CreateMap<Database.Korisnik, Korisnik>();
            CreateMap<Database.KorisnikUloga, KorisnikUloga>();
            CreateMap<Database.Slika, Slika>();
            CreateMap<Database.Recenzija, Recenzija>();
            CreateMap<Database.Novost, Novost>();
            CreateMap<Database.Narudzba, Narudzba>();
            CreateMap<Database.NarudzbaProizvodi, NarudzbaProizvodi>();
            CreateMap<Database.Uplata, Uplata>();
            CreateMap<Database.Lokacija, Lokacija>();



            CreateMap<DrzavaUpsertRequest, Database.Drzava>();
            CreateMap<GradUpsertRequest, Database.Grad>();
            CreateMap<UlogaUpsertRequest, Database.Uloga>();
            CreateMap<VrstaProizvodaUpsertRequest, Database.VrstaProizvoda>();
            CreateMap<ProizvodInsertRequest, Database.Proizvod>();
            CreateMap<ProizvodUpdateRequest, Database.Proizvod>();
            CreateMap<KorisnikInsertRequest, Database.Korisnik>();
            CreateMap<KorisnikUpdateRequest, Database.Korisnik>();
            CreateMap<SlikaInsertRequest, Database.Slika>();
            CreateMap<SlikaUpdateRequest, Database.Slika>();
            CreateMap<RecenzijaInsertRequest, Database.Recenzija>();
            CreateMap<RecenzijaUpdateRequest, Database.Recenzija>();
            CreateMap<NovostInsertRequest, Database.Novost>();
            CreateMap<NovostUpdateRequest, Database.Novost>();
            CreateMap<NarudzbaInsertRequest, Database.Narudzba>();
            CreateMap<NarudzbaUpdateRequest, Database.Narudzba>();
            CreateMap<UplataUpsertRequest, Database.Uplata>();
            CreateMap<LokacijaUpsertRequest, Database.Lokacija>();
        }
    }
}
