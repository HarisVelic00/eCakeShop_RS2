using eCakeShop.Models.Requests;
using eCakeShop.Models.SearchObjects;
using eCakeShop.Services.RabbitMQ;
using eCakeShop.Services.Services;
using Microsoft.AspNetCore.Mvc;

namespace eCakeShop.Controllers
{
    public class NarudzbaController : CRUDController<Models.Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        private readonly IMailProducer _rabbitMQProducer;
        public NarudzbaController(INarudzbaService service, IMailProducer rabbitMQProducer) : base(service)
        {
            _rabbitMQProducer = rabbitMQProducer;
        }

        public class EmailModel
        {
            public string Sender { get; set; }
            public string Recipient { get; set; }
            public string Subject { get; set; }
            public string Content { get; set; }

        }
        [HttpPost("SendConfirmationEmail")]
        public IActionResult SendConfirmationEmail([FromBody] EmailModel model)
        {
            try
            {
                _rabbitMQProducer.SendMessage(model);
                Thread.Sleep(TimeSpan.FromSeconds(15));
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
