﻿using eCakeShop.Models.Requests;
using eCakeShop.Services.Services;

namespace eCakeShop.Controllers
{
    public class VrstaProizvodaController : CRUDController<Models.VrstaProizvoda, object, VrstaProizvodaUpsertRequest, VrstaProizvodaUpsertRequest>
    {
        public VrstaProizvodaController(IVrstaProizvodaService service) : base(service) { }
    }
}
