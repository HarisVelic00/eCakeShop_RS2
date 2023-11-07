using eCakeShop.Models;
using eCakeShop.Services.Helpers;
using eCakeShop.Services.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
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
             new Narudzba { NarudzbaID = 7, BrojNarudzbe = Guid.NewGuid().ToString(), DatumNarudzbe = DateTime.Now, IsCanceled = false, IsShipped = false, KorisnikID = 3, UplataID = 7 }
             );

            modelBuilder.Entity<NarudzbaProizvodi>().HasData(
              new NarudzbaProizvodi { NarudzbaProizvodiID = 1, NarudzbaID = 1, ProizvodID = 1, Kolicina = 1 },
              new NarudzbaProizvodi { NarudzbaProizvodiID = 2, NarudzbaID = 1, ProizvodID = 3, Kolicina = 2 },
              new NarudzbaProizvodi { NarudzbaProizvodiID = 3, NarudzbaID = 1, ProizvodID = 4, Kolicina = 1 },
              new NarudzbaProizvodi { NarudzbaProizvodiID = 4, NarudzbaID = 2, ProizvodID = 2, Kolicina = 1 },
              new NarudzbaProizvodi { NarudzbaProizvodiID = 5, NarudzbaID = 2, ProizvodID = 3, Kolicina = 2 },
              new NarudzbaProizvodi { NarudzbaProizvodiID = 6, NarudzbaID = 2, ProizvodID = 5, Kolicina = 2 },
              new NarudzbaProizvodi { NarudzbaProizvodiID = 7, NarudzbaID = 2, ProizvodID = 1, Kolicina = 1 }
             );

            modelBuilder.Entity<Novost>().HasData(
             new Novost { NovostID = 1, DatumKreiranja = DateTime.Now, KorisnikID = 2, Naslov = "Novost 1", Sadrzaj = "Ovo je sadrzaj prve novosti" },
             new Novost { NovostID = 2, DatumKreiranja = DateTime.Now, KorisnikID = 2, Naslov = "Novost 2", Sadrzaj = "Ovo je sadrzaj druge novosti" },
             new Novost { NovostID = 3, DatumKreiranja = DateTime.Now, KorisnikID = 4, Naslov = "Novost 3", Sadrzaj = "Ovo je sadrzaj trece novosti" },
             new Novost { NovostID = 4, DatumKreiranja = DateTime.Now, KorisnikID = 4, Naslov = "Novost 4", Sadrzaj = "Ovo je sadrzaj cetvrte novosti" }
            );

            modelBuilder.Entity<Proizvod>().HasData(
                new Proizvod { ProizvodID = 1, Cijena = 8, Naziv = "Pita od jabuka", VrstaProizvodaID = 7,  Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[0]), Opis = "Pita od jabuka" },
                new Proizvod { ProizvodID = 2, Cijena = 40, Naziv = "Cokoladna torta", VrstaProizvodaID = 1, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[1]), Opis = "Cokoladna torta" },
                new Proizvod { ProizvodID = 3, Cijena = 4, Naziv = "Kroasan", VrstaProizvodaID = 3, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[2]), Opis = "Kroasan" },
                new Proizvod { ProizvodID = 4, Cijena = 20, Naziv = "Cokoladne kocke", VrstaProizvodaID = 2, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[3]), Opis = "Cokoladne kocke" },
                new Proizvod { ProizvodID = 5, Cijena = 3, Naziv = "Sladoled", VrstaProizvodaID = 4, Sifra = Guid.NewGuid().ToString(), Slika = Convert.FromBase64String(Images.Slike[4]), Opis = "Pita od jabuka" }
            );

            modelBuilder.Entity<Recenzija>().HasData(
                new Recenzija { RecenzijaID = 1, DatumKreiranja = DateTime.Now, KorisnikID = 3, Ocjena = 4, SadrzajRecenzije = "Torta je odlicna" },
                new Recenzija { RecenzijaID = 2, DatumKreiranja = DateTime.Now, KorisnikID = 3, Ocjena = 5, SadrzajRecenzije = "Vrhunski sladoled" },
                new Recenzija { RecenzijaID = 3, DatumKreiranja = DateTime.Now, KorisnikID = 3, Ocjena = 3, SadrzajRecenzije = "Kolac je mogao biti bolji" }
            );

            modelBuilder.Entity<Slika>().HasData(
                new Slika { SlikaID = 1, KorisnikID = 2, Opis = "Slika 1" },
                new Slika { SlikaID = 2, KorisnikID = 2, Opis = "Slika 2" },
                new Slika { SlikaID = 3, KorisnikID = 4, Opis = "Slika 3" },
                new Slika { SlikaID = 4, KorisnikID = 4, Opis = "Slika 4" }
             );

            modelBuilder.Entity<Uloga>().HasData(
                new Uloga { UlogaID = 1, Naziv = "Administrator", Opis = "Administrator" },
                new Uloga { UlogaID = 2, Naziv = "Uposlenik", Opis = "Uposlenik" }
            );

            //Promijenit ce se kasnije
            modelBuilder.Entity<Uplata>().HasData(
            new Uplata { UplataID = 1, BrojTransakcije = "pi_3MSSv3ANnFXjgSPx2LOrScMr", DatumTransakcije = DateTime.Now, Iznos = 146 },
            new Uplata { UplataID = 2, BrojTransakcije = "pi_3MSSwtANnFXjgSPx1GLV7ZWR", DatumTransakcije = DateTime.Now, Iznos = 196 },
            new Uplata { UplataID = 3, BrojTransakcije = "pi_3MSSxZANnFXjgSPx1h6sZONh", DatumTransakcije = DateTime.Now, Iznos = 122 },
            new Uplata { UplataID = 4, BrojTransakcije = "pi_3MSSykANnFXjgSPx0j7dwFvL", DatumTransakcije = DateTime.Now, Iznos = 132 },
            new Uplata { UplataID = 5, BrojTransakcije = "pi_3MSSzFANnFXjgSPx1K5yB3MP", DatumTransakcije = DateTime.Now, Iznos = 148 },
            new Uplata { UplataID = 6, BrojTransakcije = "pi_3MSSzgANnFXjgSPx30vUfLBv", DatumTransakcije = DateTime.Now, Iznos = 136 },
            new Uplata { UplataID = 7, BrojTransakcije = "pi_3MST02ANnFXjgSPx28dm4Ke1", DatumTransakcije = DateTime.Now, Iznos = 66 }
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
