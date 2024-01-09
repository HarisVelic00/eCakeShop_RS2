using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class RecenzijaUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Sadrzaj ne smije ostati prazno polje")]
        public string SadrzajRecenzije { get; set; }
        [Required(ErrorMessage = "Ocjena je obavezna")]
        public int Ocjena { get; set; }
        public DateTime DatumKreiranja { get; set; }
        [Required]
        public int KorisnikID { get; set; }
    }
}
