using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Slika
    {
        public int SlikaID { get; set; }
        public byte[]? SlikaByte { get; set; }
        public string? Opis { get; set; }
        public int KorisnikID { get; set; }
        public virtual Korisnik Korisnik { get; set; } = null!;
    }
}
