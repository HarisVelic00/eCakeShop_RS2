using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCakeShop.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class CRUDController<T, TSearch, TInsertRequest, TUpdateRequest> : BaseController<T, TSearch> where T : class where TSearch : class where TInsertRequest : class where TUpdateRequest : class
    {
        public CRUDController(ICRUDService<T, TSearch, TInsertRequest, TUpdateRequest> service) : base(service) { }

        [HttpPost]
        public virtual T Insert([FromBody] TInsertRequest request)
        {
            return ((ICRUDService<T, TSearch, TInsertRequest, TUpdateRequest>)_service).Insert(request);
        }

        [HttpPut("{id}")]
        public T Update([FromBody] TUpdateRequest request, int id)
        {
            return ((ICRUDService<T, TSearch, TInsertRequest, TUpdateRequest>)_service).Update(request, id);
        }

        [HttpDelete("{id}")]
        public T Delete(int id)
        {
            return ((ICRUDService<T, TSearch, TInsertRequest, TUpdateRequest>)_service).Delete(id);
        }
    }
}
