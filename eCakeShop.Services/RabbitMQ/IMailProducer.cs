namespace eCakeShop.Services.RabbitMQ
{
    public interface IMailProducer
    {
        public void SendMessage<T>(T message);
    }
}