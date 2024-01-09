using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models
{
    public class Lokacija
    {
        public int LokacijaID { get; set; }
        public string Naziv { get; set; } 
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
