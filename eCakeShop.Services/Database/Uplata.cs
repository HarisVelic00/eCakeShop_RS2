using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Database
{
    public class Uplata
    {
        public int UplataID { get; set; }
        public double Iznos { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public string? BrojTransakcije { get; set; }
    }
}
