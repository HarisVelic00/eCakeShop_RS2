using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.SearchObjects
{
    public class NarudzbaSearchObject : BaseSearchObject
    {
        public string? BrojNarudzbe { get; set; }
        public int? KorisnikID { get; set; }
        public DateTime? DatumOd { get; set; }
        public DateTime? DatumDo { get; set; }
        public bool? IsShipped { get; set; }
        public bool? IsCanceled { get; set; }
        public bool? IncludeKorisnik { get; set; }
        public bool? IncludeNarudzbaProizvodi { get; set; }
        public bool? IncludeUplata { get; set; }
    }
}
