namespace eCakeShop.Services.Database
{
    public class Lokacija
    {
        public int LokacijaID { get; set; }
        public string Naziv { get; set; } = null!;
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
