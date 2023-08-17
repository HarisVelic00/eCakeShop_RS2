using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Proizvod
    {
        public Proizvod()
        {
            NarudzbaProizvodis = new HashSet<NarudzbaProizvodi>();
        }
        public int ProizvodID { get; set; }
        public string? Naziv { get; set; }
        public string? Sifra { get; set; }
        public decimal Cijena { get; set; }
        public byte[]? Slika { get; set; }
        public string? Opis { get; set; }
        public int VrstaProizvodaID { get; set; }
        public virtual VrstaProizvoda VrstaProizvoda { get; set; } = null!;
        public virtual ICollection<NarudzbaProizvodi> NarudzbaProizvodis { get; set; }

    }
}
