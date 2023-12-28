using eCakeShop.Models;
using eCakeShop.Services.Helpers;
using eCakeShop.Services.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using static System.Net.Mime.MediaTypeNames;

namespace eCakeShop.Services.Database
{
    public class eCakeShopContext : DbContext
    {
        public eCakeShopContext(DbContextOptions<eCakeShopContext> options) : base(options) { }
        public virtual DbSet<Drzava> Drzavas { get; set; } = null!;
        public virtual DbSet<Grad> Grads { get; set; } = null!;
        public virtual DbSet<Korisnik> Korisniks { get; set; } = null!;
        public virtual DbSet<KorisnikUloga> KorisnikUlogas { get; set; } = null!;
        public virtual DbSet<Narudzba> Narudzbas { get; set; } = null!;
        public virtual DbSet<NarudzbaProizvodi> NarudzbaProizvodis { get; set; } = null!;
        public virtual DbSet<Novost> Novosts { get; set; } = null!;
        public virtual DbSet<Proizvod> Proizvods { get; set; } = null!;
        public virtual DbSet<Recenzija> Recenzijas { get; set; } = null!;
        public virtual DbSet<Slika> Slikas { get; set; } = null!;
        public virtual DbSet<Uloga> Ulogas { get; set; } = null!;
        public virtual DbSet<VrstaProizvoda> VrstaProizvodas { get; set; } = null!;
        public virtual DbSet<Uplata> Uplatas { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
               optionsBuilder.UseSqlServer("Data Source=DESKTOP-VLNCSDD;Initial Catalog=eCakeShop;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=True;");
            }
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            var saltAdmin = KorisnikService.GenerateSalt();
            var saltUposlenik = KorisnikService.GenerateSalt();
            var saltUposlenik2 = KorisnikService.GenerateSalt();
            var saltUser = KorisnikService.GenerateSalt();
            var saltUser2 = KorisnikService.GenerateSalt();

            modelBuilder.Entity<Drzava>().HasData(
                new Drzava { DrzavaID = 1, Naziv = "Bosna i Hercegovina" },
                new Drzava { DrzavaID = 2, Naziv = "Hrvatska" },
                new Drzava { DrzavaID = 3, Naziv = "Srbija" }
            );

            modelBuilder.Entity<Grad>().HasData(
                new Grad { GradID = 1, Naziv = "Sarajevo" },
                new Grad { GradID = 2, Naziv = "Zagreb" },
                new Grad { GradID = 3, Naziv = "Beograd" }
            );

            modelBuilder.Entity<Korisnik>().HasData(
                new Korisnik { KorisnikID = 1, Ime = "Admin", Prezime = "Admin", DatumRodjenja = DateTime.Now, DrzavaID = 1, GradID = 1, Email = "admin@gmail.com", KorisnickoIme = "admin", Telefon = "000000000", LozinkaSalt = saltAdmin, LozinkaHash = KorisnikService.GenerateHash(saltAdmin, "admin") },
                new Korisnik { KorisnikID = 2, Ime = "Uposlenik", Prezime = "Uposlenik", DatumRodjenja = DateTime.Now, DrzavaID = 2, GradID = 2, Email = "uposlenik@gmail.com", KorisnickoIme = "uposlenik", Telefon = "000000001", LozinkaSalt = saltUposlenik, LozinkaHash = KorisnikService.GenerateHash(saltUposlenik, "uposlenik") },
                new Korisnik { KorisnikID = 3, Ime = "User", Prezime = "User", DatumRodjenja = DateTime.Now, DrzavaID = 3, GradID = 3, Email = "user@gmail.com", KorisnickoIme = "user", Telefon = "000000002", LozinkaSalt = saltUser, LozinkaHash = KorisnikService.GenerateHash(saltUser, "user") },
                new Korisnik { KorisnikID = 4, Ime = "Uposlenik2", Prezime = "Uposlenik2", DatumRodjenja = DateTime.Now, DrzavaID = 2, GradID = 2, Email = "uposlenik2@gmail.com", KorisnickoIme = "uposlenik2", Telefon = "000000003", LozinkaSalt = saltUposlenik2, LozinkaHash = KorisnikService.GenerateHash(saltUposlenik2, "uposlenik2") },
                new Korisnik { KorisnikID = 5, Ime = "User2", Prezime = "User2", DatumRodjenja = DateTime.Now, DrzavaID = 3, GradID = 3, Email = "user2@gmail.com", KorisnickoIme = "user2", Telefon = "000000002", LozinkaSalt = saltUser2, LozinkaHash = KorisnikService.GenerateHash(saltUser2, "user2") }
            );

            modelBuilder.Entity<KorisnikUloga>().HasData(
                new KorisnikUloga { KorisnikUlogaID = 1, DatumIzmjene = DateTime.Now, KorisnikID = 1, UlogaID = 1 },
                new KorisnikUloga { KorisnikUlogaID = 2, DatumIzmjene = DateTime.Now, KorisnikID = 1, UlogaID = 2 },
                new KorisnikUloga { KorisnikUlogaID = 3, DatumIzmjene = DateTime.Now, KorisnikID = 2, UlogaID = 2 },
                new KorisnikUloga { KorisnikUlogaID = 4, DatumIzmjene = DateTime.Now, KorisnikID = 4, UlogaID = 2 }
            );

            modelBuilder.Entity<Narudzba>().HasData(
             new Narudzba { NarudzbaID = 1, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = true, KorisnikID = 3, UplataID = 1 },
             new Narudzba { NarudzbaID = 2, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = true, KorisnikID = 3, UplataID = 2 },
             new Narudzba { NarudzbaID = 3, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = false, KorisnikID = 3, UplataID = 3 },
             new Narudzba { NarudzbaID = 4, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = false, KorisnikID = 5, UplataID = 4 },
             new Narudzba { NarudzbaID = 5, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = true, KorisnikID = 5, UplataID = 5 },
             new Narudzba { NarudzbaID = 6, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = true, KorisnikID = 5, UplataID = 6 },
             new Narudzba { NarudzbaID = 7, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = false, KorisnikID = 3, UplataID = 7 },
             new Narudzba { NarudzbaID = 8, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = false, KorisnikID = 1, UplataID = 8 },
             new Narudzba { NarudzbaID = 9, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = true, KorisnikID = 1, UplataID = 9 },
             new Narudzba { NarudzbaID = 10, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = false, KorisnikID = 1, UplataID = 10 }
             );

            modelBuilder.Entity<NarudzbaProizvodi>().HasData(
                new NarudzbaProizvodi { NarudzbaProizvodiID = 1, NarudzbaID = 1, ProizvodID = 1, Kolicina = 2 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 2, NarudzbaID = 1, ProizvodID = 4, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 4, NarudzbaID = 2, ProizvodID = 1, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 5, NarudzbaID = 2, ProizvodID = 2, Kolicina = 2 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 6, NarudzbaID = 2, ProizvodID = 7, Kolicina = 2 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 8, NarudzbaID = 3, ProizvodID = 2, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 9, NarudzbaID = 3, ProizvodID = 1, Kolicina = 3 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 10, NarudzbaID = 3, ProizvodID = 6, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 11, NarudzbaID = 3, ProizvodID = 3, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 12, NarudzbaID = 4, ProizvodID = 1, Kolicina = 3 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 13, NarudzbaID = 4, ProizvodID = 2, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 14, NarudzbaID = 4, ProizvodID = 3, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 15, NarudzbaID = 4, ProizvodID = 7, Kolicina = 2 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 19, NarudzbaID = 5, ProizvodID = 3, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 20, NarudzbaID = 5, ProizvodID = 6, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 21, NarudzbaID = 6, ProizvodID = 5, Kolicina = 3 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 22, NarudzbaID = 6, ProizvodID = 2, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 23, NarudzbaID = 6, ProizvodID = 1, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 24, NarudzbaID = 6, ProizvodID = 4, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 25, NarudzbaID = 7, ProizvodID = 1, Kolicina = 2 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 26, NarudzbaID = 7, ProizvodID = 2, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 27, NarudzbaID = 8, ProizvodID = 2, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 30, NarudzbaID = 8, ProizvodID = 6, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 31, NarudzbaID = 9, ProizvodID = 2, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 32, NarudzbaID = 9, ProizvodID = 3, Kolicina = 2 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 33, NarudzbaID = 9, ProizvodID = 4, Kolicina = 1 },
                new NarudzbaProizvodi { NarudzbaProizvodiID = 34, NarudzbaID = 10, ProizvodID = 6, Kolicina = 1 }
             );

            modelBuilder.Entity<Novost>().HasData(
             new Novost { NovostID = 1, DatumKreiranja = DateTime.Now, KorisnikID = 2, Naslov = "Crno-bijeli kokos kolac", Sadrzaj = "Crno-bijeli kokos kolac", Thumbnail = Convert.FromBase64String(Images.Slike[7]) },
             new Novost { NovostID = 3, DatumKreiranja = DateTime.Now, KorisnikID = 4, Naslov = "Topla cokolada", Sadrzaj = "Topla cokolada", Thumbnail = Convert.FromBase64String(Images.Slike[7]) }
            );

            modelBuilder.Entity<Proizvod>().HasData(
                new Proizvod { ProizvodID = 1, Cijena = 8, Naziv = "Pita od jabuka", VrstaProizvodaID = 7, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[0]), Opis = "Pita od jabuka" },
                new Proizvod { ProizvodID = 2, Cijena = 40, Naziv = "Cokoladna torta", VrstaProizvodaID = 1, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[1]), Opis = "Cokoladna torta" },
                new Proizvod { ProizvodID = 3, Cijena = 4, Naziv = "Kroasan", VrstaProizvodaID = 3, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[2]), Opis = "Kroasan" },
                new Proizvod { ProizvodID = 4, Cijena = 20, Naziv = "Cokoladne kocke", VrstaProizvodaID = 2, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[3]), Opis = "Cokoladne kocke" },
                new Proizvod { ProizvodID = 5, Cijena = 3, Naziv = "Sladoled", VrstaProizvodaID = 4, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[4]), Opis = "Pita od jabuka" },
                new Proizvod { ProizvodID = 6, Cijena = 30, Naziv = "Kolac od jagoda", VrstaProizvodaID = 2, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[5]), Opis = "Crno-bijeli kokos kolac" },
                new Proizvod { ProizvodID = 7, Cijena = 40, Naziv = "Cudo od cokolade", VrstaProizvodaID = 2, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[6]), Opis = "Cudo od cokolade" }
                );

            modelBuilder.Entity<Recenzija>().HasData(
                new Recenzija { RecenzijaID = 1, DatumKreiranja = DateTime.Now, KorisnikID = 3, Ocjena = 4, SadrzajRecenzije = "Torta je odlicna" },
                new Recenzija { RecenzijaID = 2, DatumKreiranja = DateTime.Now, KorisnikID = 3, Ocjena = 5, SadrzajRecenzije = "Vrhunski sladoled" }
            );

            modelBuilder.Entity<Slika>().HasData(
                new Slika { SlikaID = 1, KorisnikID = 2, Opis = "Crno-bijeli kokos kolac", SlikaByte = Convert.FromBase64String(Images.Slike[7]) },
                new Slika { SlikaID = 3, KorisnikID = 4, Opis = "Topla cokolada", SlikaByte = Convert.FromBase64String(Images.Slike[7]) }
             );

            modelBuilder.Entity<Uloga>().HasData(
                new Uloga { UlogaID = 1, Naziv = "Administrator", Opis = "Administrator" },
                new Uloga { UlogaID = 2, Naziv = "Uposlenik", Opis = "Uposlenik" }
            );

            modelBuilder.Entity<Uplata>().HasData(
            new Uplata { UplataID = 1, BrojTransakcije = "pi_3OPortLfQTkXq96L2EFmVZB0", DatumTransakcije = DateTime.Now, Iznos = 40 },
            new Uplata { UplataID = 2, BrojTransakcije = "pi_3OPU4CLfQTkXq96L2o5yxbGK", DatumTransakcije = DateTime.Now, Iznos = 40 },
            new Uplata { UplataID = 3, BrojTransakcije = "pi_3OPU3KLfQTkXq96L07lQjpkK", DatumTransakcije = DateTime.Now, Iznos = 120 },
            new Uplata { UplataID = 4, BrojTransakcije = "pi_3OPTmmLfQTkXq96L0kaBF0KX", DatumTransakcije = DateTime.Now, Iznos = 100 },
            new Uplata { UplataID = 5, BrojTransakcije = "pi_3OPTkkLfQTkXq96L3VZHEysK", DatumTransakcije = DateTime.Now, Iznos = 140 },
            new Uplata { UplataID = 6, BrojTransakcije = "pi_3OPTaULfQTkXq96L3nARxQbe", DatumTransakcije = DateTime.Now, Iznos = 130 },
            new Uplata { UplataID = 7, BrojTransakcije = "pi_3OPTV5LfQTkXq96L2MKk0DbD", DatumTransakcije = DateTime.Now, Iznos = 60 },
            new Uplata { UplataID = 8, BrojTransakcije = "pi_3OP90ZLfQTkXq96L1NKEclIO", DatumTransakcije = DateTime.Now, Iznos = 80 },
            new Uplata { UplataID = 9, BrojTransakcije = "pi_3OPSMGLfQTkXq96L0y1fGr7D", DatumTransakcije = DateTime.Now, Iznos = 100 },
            new Uplata { UplataID = 10, BrojTransakcije = "pi_3OPSeGLfQTkXq96L2fKVqBjy", DatumTransakcije = DateTime.Now, Iznos = 100 }
            );

            modelBuilder.Entity<VrstaProizvoda>().HasData(
                new VrstaProizvoda { VrstaProizvodaID = 1, Naziv = "Torta", Opis = "Torta" },
                new VrstaProizvoda { VrstaProizvodaID = 2, Naziv = "Kolac", Opis = "Kolac" },
                new VrstaProizvoda { VrstaProizvodaID = 3, Naziv = "Pecivo", Opis = "Pecivo" },
                new VrstaProizvoda { VrstaProizvodaID = 4, Naziv = "Sladoled", Opis = "Sladoled" },
                new VrstaProizvoda { VrstaProizvodaID = 5, Naziv = "Cokoladni proizvod", Opis = "Cokoladni proizvod" },
                new VrstaProizvoda { VrstaProizvodaID = 6, Naziv = "Desert", Opis = "Desert" },
                new VrstaProizvoda { VrstaProizvodaID = 7, Naziv = "Vocna poslastica", Opis = "Vocna poslastica" },
                new VrstaProizvoda { VrstaProizvodaID = 8, Naziv = "Napici", Opis = "Napici" }
            );
        }
    }
}
