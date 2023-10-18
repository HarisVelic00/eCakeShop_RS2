using AutoMapper;
using eCakeShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCakeShop.Services.Services
{
    public class CRUDService<T, TDb, TSearch, TInsertRequest, TUpdateRequest> : BaseService<T, TDb, TSearch>,
     ICRUDService<T, TSearch, TInsertRequest, TUpdateRequest> where T : class where TDb : class where TSearch : class where TInsertRequest : class where TUpdateRequest : class
    {
        public CRUDService(eCakeShopContext db, IMapper mapper) : base(db, mapper) { }

        public virtual T Insert(TInsertRequest request)
        {
            var set = _db.Set<TDb>();
            TDb entity = _mapper.Map<TDb>(request);
            set.Add(entity);
            BeforeInsert(request, entity);
            _db.SaveChanges();
            return _mapper.Map<T>(entity);
        }

        public T Update(TUpdateRequest request, int id)
        {
            var set = _db.Set<TDb>();
            var entity = set.Find(id);
            _mapper.Map(request, entity);
            _db.SaveChanges();
            return _mapper.Map<T>(entity);
        }

        public T Delete(int id)
        {
            var set = _db.Set<TDb>();
            var entity = set.Find(id);
            var temp = entity;
            if (entity != null)
            {
                _db.Remove(entity);
            }
            _db.SaveChanges();
            return _mapper.Map<T>(entity);
        }
        public virtual void BeforeInsert(TInsertRequest request, TDb entity) { }
    }
}