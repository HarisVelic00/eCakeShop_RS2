using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Models.Requests
{
    public class KorisnikInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ime ne smije ostati prazno polje")]
        [MinLength(3, ErrorMessage = "Ime ne moze imati manje od 3 slova")]
        public string Ime { get; set; }
        [Required]
        [MinLength(3, ErrorMessage = "Prezime ne moze imati manje od 3 slova")]
        public string Prezime { get; set; }
        [Required]
        public DateTime DatumRodjenja { get; set; }
        public string Email { get; set; }
        public string Telefon { get; set; }
        [Required(ErrorMessage = "Grad ne smije ostati prazno polje")]
        public int GradID { get; set; }
        [Required(ErrorMessage = "Drzava ne smije ostati prazno polje")]
        public int DrzavaID { get; set; }
        [Required(ErrorMessage = "Korisnicko ime ne smije ostati prazno polje")]
        [MinLength(4, ErrorMessage = "Korisnicko ime ne moze imate manje od 4 karaktera")]
        public string KorisnickoIme { get; set; }
        [Required(ErrorMessage = "Lozinka ne smije ostati prazno polje")]
        [MinLength(4, ErrorMessage = "Lozinka ne moze imati manje od 4 karaktera")]
        public string Lozinka { get; set; }
        public List<int> UlogeID { get; set; }
    }
}
