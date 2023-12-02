using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class KorisnikMobileUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ime ne smije ostati prazno polje")]
        [MinLength(3, ErrorMessage = "Ime ne moze imati manje od 3 slova")]
        public string Ime { get; set; }
        [Required]
        [MinLength(3, ErrorMessage = "Prezime ne moze imati manje od 3 slova")]
        public string Prezime { get; set; }
        [Required]
        public string Email { get; set; }
        public string Telefon { get; set; }
    }
}
