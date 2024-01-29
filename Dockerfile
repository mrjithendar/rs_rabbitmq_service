FROM rabbitmq:latest

# Define custom username and password for RabbitMQ
ENV RABBITMQ_DEFAULT_USER=roboshop
ENV RABBITMQ_DEFAULT_PASS=roboshop123

# Enable the RabbitMQ Management Plugin (optional but useful for monitoring)
RUN rabbitmq-plugins enable rabbitmq_management

# Expose ports for AMQP and RabbitMQ Management
EXPOSE 5672 15672

# Start RabbitMQ server
CMD ["rabbitmq-server"]