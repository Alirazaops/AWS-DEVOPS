output "primary_endpoint" {
  value = aws_db_instance.mysql-db.endpoint
}

output "replica_endpoint" {
  value = aws_db_instance.replica.endpoint
}