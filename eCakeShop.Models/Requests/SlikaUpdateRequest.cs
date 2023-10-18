using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class SlikaUpdateRequest
    {
        [Required(ErrorMessage = "Slika je obavezna")]
        public byte[] SlikaByte { get; set; }
        [Required(AllowEmptyStrings = true)]
        public string Opis { get; set; }
    }
}
