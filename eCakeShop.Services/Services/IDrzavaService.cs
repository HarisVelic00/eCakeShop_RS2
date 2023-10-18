using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eCakeShop.Models.Requests;

namespace eCakeShop.Services.Services
{
    public interface IDrzavaService : ICRUDService<Models.Drzava, object, DrzavaUpsertRequest, DrzavaUpsertRequest> { }
}
