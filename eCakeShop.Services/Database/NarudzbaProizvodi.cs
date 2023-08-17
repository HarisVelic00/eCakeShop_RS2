using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class NarudzbaProizvodi
    {
        public int NarudzbaProizvodiID { get; set; }
        public int ProizvodID { get; set; }
        public int NarudzbaID { get; set; }
        public int Kolicina { get; set; }
        public virtual Proizvod Proizvod { get; set; } = null!;
        public virtual Narudzba Narudzba { get; set; } = null!;
    }
}
