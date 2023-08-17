using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models
{
    public class KorisnikUloga
    {
        public int KorisnikUlogaID { get; set; }
        public int KorisnikID { get; set; }
        public int UlogaID { get; set; }
        public DateTime DatumIzmjene { get; set; }
        public virtual Uloga Uloga { get; set; }
    }
}
