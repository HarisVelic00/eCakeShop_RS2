using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Recenzija
    {
        public int RecenzijaID { get; set; }
        public string? SadrzajRecenzije { get; set; }
        public int Ocjena { get; set; }
        public DateTime DatumKreiranja { get; set; } = DateTime.Now.Date;
        public int KorisnikID { get; set; }
        public virtual Korisnik Korisnik { get; set; } = null!;
    }
}
