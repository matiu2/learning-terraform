output "endpoint" {
  value       = aws_db_instance.matiu-db.endpoint
  description = "The endpoint to connect to the database, in the format host:port"
}
