using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public interface IBaseService<T, TSearch>
    {
        IEnumerable<T> GetAll(TSearch obj);
        T GetById(int id);
    }
}
