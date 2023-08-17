using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Novost
    {
        public int NovostID { get; set; }
        public string? Naslov { get; set; }
        public string? Sadrzaj { get; set; }
        public byte[]? Thumbnail { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public int KorisnikID { get; set; }
        public virtual Korisnik Korisnik { get; set; } = null!;
    }
}
