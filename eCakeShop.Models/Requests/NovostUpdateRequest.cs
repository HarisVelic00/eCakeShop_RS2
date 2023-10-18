using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class NovostUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Naslov ne smije ostati prazno polje")]
        public string Naslov { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Sadrzaj ne smije ostati prazno polje")]
        public string Sadrzaj { get; set; }
        [Required(ErrorMessage = "Slika je obavezna")]
        public byte[] Thumbnail { get; set; }
        [Required]
        public DateTime DatumKreiranja { get; set; }
    }
}
