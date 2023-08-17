using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Korisnik
    {
        public Korisnik()
        {
            KorisnikUlogas = new HashSet<KorisnikUloga>();
        }
        public int KorisnikID { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public DateTime DatumRodjenja { get; set; }
        public string? Email { get; set; }
        public string? Telefon { get; set; }
        public int GradID { get; set; }
        public int DrzavaID { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        public string LozinkaHash { get; set; } = null!;
        public string LozinkaSalt { get; set; } = null!;

        public virtual Drzava Drzava { get; set; } = null!;
        public virtual Grad Grad { get; set; } = null!;
        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
    }
}
