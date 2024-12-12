provider "aws" {
  region = "us-east-1"
}

# Generate a random password
resource "random_password" "db_password" {
  length  = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create RDS PostgreSQL instance
resource "aws_db_instance" "postgres" {
  identifier        = "ivanfan-postgres-db"
  engine            = "postgres"
  engine_version    = "16.5"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  username          = "pgadmin"
  password          = random_password.db_password.result
  db_name           = "ivanfandb"
  skip_final_snapshot = true

  # VPC security group (ensure your security group is properly defined)
  #vpc_security_group_ids = ["sg-xxxxxxxx"]

  # Subnet group (ensure your subnet group is properly defined)
  #db_subnet_group_name = "my-db-subnet-group"
}

# Store the password in SSM Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name        = "postgres_db_pass"
  description = "IvanFan RDS PostgreSQL password"
  type        = "SecureString"
  value       = random_password.db_password.result

  # Encryption key for SecureString (optional but recommended)
  key_id = "alias/aws/ssm"  # Using the default AWS SSM key for encryption
}

# Output the password for reference (optional)
output "db_password" {
  value = random_password.db_password.result
  sensitive = true
}
