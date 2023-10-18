using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public interface INovostService : ICRUDService<Models.Novost, NovostSearchObject, NovostInsertRequest, NovostUpdateRequest>
    {
    }
}
