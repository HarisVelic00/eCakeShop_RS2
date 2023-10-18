using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class SlikaInsertRequest
    {
        [Required(ErrorMessage = "Slika je obavezna")]
        public byte[] SlikaByte { get; set; }
        [Required(AllowEmptyStrings = true)]
        public string Opis { get; set; }
        [Required]
        public int KorisnikID { get; set; }
    }
}
