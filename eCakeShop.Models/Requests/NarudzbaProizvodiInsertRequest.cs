using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class NarudzbaProizvodiInsertRequest
    {
        public int ProizvodID { get; set; }
        public int Kolicina { get; set; }
    }
}
