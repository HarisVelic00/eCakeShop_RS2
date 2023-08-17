using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models
{
    public class Recenzija
    {
        public int RecenzijaID { get; set; }
        public string SadrzajRecenzije { get; set; }
        public int Ocjena { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public int KorisnikID { get; set; }
        public virtual Korisnik Korisnik { get; set; }
    }
}
