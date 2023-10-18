using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class NarudzbaInsertRequest
    {
        [Required]
        public int KorisnikID { get; set; }
        [Required]
        public int UplataID { get; set; }
        [Required]
        public List<NarudzbaProizvodiInsertRequest> ListaProizvoda { get; set; }
    }
}
