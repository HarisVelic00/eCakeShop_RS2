using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public interface ICRUDService<T, TSearch, TInsertRequest, TUpdateRequest> : IBaseService<T, TSearch>
    {
        T Insert(TInsertRequest request);
        T Update(TUpdateRequest request, int id);
        T Delete(int id);
    }
}
