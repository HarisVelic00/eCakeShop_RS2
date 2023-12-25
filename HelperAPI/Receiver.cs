using Microsoft.Extensions.Hosting;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;
using System.Text;

namespace HelperAPI
{
    public class MessageReceiverService : BackgroundService
    {
        private readonly ConnectionFactory _factory;
        private readonly string _queueName = "Queue";

        public MessageReceiverService(ConnectionFactory factory)
        {
            _factory = factory;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            using (var connection = _factory.CreateConnection())
            using (var channel = connection.CreateModel())
            {
                channel.QueueDeclare(queue: _queueName, durable: false, exclusive: false, autoDelete: false, arguments: null);

                var consumer = new EventingBasicConsumer(channel);
                consumer.Received += (model, ea) =>
                {
                    var body = ea.Body.ToArray();
                    var message = Encoding.UTF8.GetString(body);

                    Console.WriteLine("Received message from RabbitMQ: {0}", message);
                };

                channel.BasicConsume(queue: _queueName, autoAck: true, consumer: consumer);

                Console.WriteLine("Waiting for messages.");

                await Task.Delay(Timeout.Infinite, stoppingToken);
            }
        }
    }
}
