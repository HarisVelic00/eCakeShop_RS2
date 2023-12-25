using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class ProizvodInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Naziv ne smije ostati prazno polje")]
        public string Naziv { get; set; }
        [Required(ErrorMessage = "Cijena ne smije ostati prazno polje")]
        public double Cijena { get; set; }
        [Required(ErrorMessage = "Slika je obavezna")]
        public byte[] Slika { get; set; }
        [Required]
        public string Opis { get; set; }
        [Required]
        public int VrstaProizvodaID { get; set; }
    }
}
