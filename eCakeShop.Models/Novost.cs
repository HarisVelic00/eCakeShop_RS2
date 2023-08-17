using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models
{
    public class Novost
    {
        [Browsable(false)]
        public int NovostID { get; set; }
        [DisplayName("Dodao korisnik")]
        public string UposlenikIme => $"{Korisnik?.Ime} {Korisnik?.Prezime}";
        public string Naslov { get; set; }
        public string Sadrzaj { get; set; }
        [DisplayName("Slika")]
        public byte[] Thumbnail { get; set; }
        [DisplayName("Datum kreiranja")]
        public DateTime DatumKreiranja { get; set; }
        [Browsable(false)]
        public int KorisnikID { get; set; }
        [Browsable(false)]
        public Korisnik Korisnik { get; set; }
    }
}
