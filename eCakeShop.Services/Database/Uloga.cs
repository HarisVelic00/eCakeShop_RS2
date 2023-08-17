using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Uloga
    {
        public Uloga()
        {
            KorisnikUlogas = new HashSet<KorisnikUloga>();
        }
        public int UlogaID { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Opis { get; set; }
        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
    }
}
