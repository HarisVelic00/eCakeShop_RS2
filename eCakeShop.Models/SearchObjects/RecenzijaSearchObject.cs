using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.SearchObjects
{
    public class RecenzijaSearchObject : BaseSearchObject
    {
        public bool? IncludeKorisnik { get; set; }
    }
}
