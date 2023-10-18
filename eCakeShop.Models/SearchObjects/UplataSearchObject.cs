using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.SearchObjects
{
    public class UplataSearchObject : BaseSearchObject
    {
        public int? KorisnikID { get; set; }
        public int? UplataID { get; set; }
    }
}
