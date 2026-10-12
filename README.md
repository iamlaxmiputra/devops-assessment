\# Hotel Booking Platform — DevOps Assessment



\## 1. Project Overview



This project demonstrates infrastructure as code, containerized PostgreSQL, database migrations, backup and restore procedures, query optimization, and CI validation using GitHub Actions.



The AWS infrastructure is defined using reusable Terraform modules. The configuration is intended for review and validation; \*\*AWS resources have not been deployed\*\*.



\## 2. Architecture



The proposed AWS architecture includes:



\- \*\*VPC:\*\* Isolated network with public and private subnets across two Availability Zones.

\- \*\*Internet Gateway:\*\* Provides internet routing for public subnets.

\- \*\*NAT Gateway:\*\* Allows outbound connectivity from private subnets.

\- \*\*Application Load Balancer:\*\* Receives HTTP traffic and forwards requests to ECS.

\- \*\*Amazon ECS with Fargate:\*\* Runs the application containers in private subnets.

\- \*\*Amazon RDS for PostgreSQL:\*\* Managed database in private subnets, accessible from the ECS security group.

\- \*\*Security Groups:\*\* Restrict application and database traffic.

\- \*\*Terraform:\*\* Defines reusable infrastructure modules and separate Dev and Production configurations.



\### Terraform Modules



| Module | Responsibility |

|---|---|

| `network` | VPC, subnets, routing, Internet Gateway and NAT Gateway |

| `alb` | Load balancer, listener, target group and security group |

| `ecs` | ECS cluster, task definition, service and execution role |

| `rds` | PostgreSQL database, subnet group and security group |



The ECS service currently uses `nginx:stable` as a placeholder container image.



\## 3. Repository Structure



```text

.

├── .github/

│   └── workflows/

│       └── terraform-check.yml

├── database/

│   ├── migrations/

│   │   └── 001\_create\_tables.sql

│   └── seed/

│       └── 001\_seed\_data.sql

├── scripts/

│   ├── backup.sh

│   └── restore.sh

├── backups/

├── terraform/

│   ├── environments/

│   │   ├── dev/

│   │   └── prod/

│   └── modules/

│       ├── network/

│       ├── alb/

│       ├── ecs/

│       └── rds/

├── docker-compose.yml

├── .gitignore

└── README.md

```



\## 4. Local Database Setup



\### Prerequisites



\- Docker Desktop with Docker Compose

\- Git

\- Terraform (for infrastructure validation)



Start PostgreSQL from the project root:



```bash

docker compose up -d

```



Check container status:



```bash

docker compose ps

```



Connect to PostgreSQL:



```bash

docker compose exec postgres psql -U appuser -d hotel\_booking

```



Useful SQL commands:



```sql

SELECT COUNT(\*) FROM hotel\_bookings;

SELECT COUNT(\*) FROM booking\_events;

```



Exit the PostgreSQL shell:



```text

\\q

```



The local database uses the `hotel\_booking` database and initializes its schema and seed data from the SQL files mounted by Docker Compose.



\## 5. Database Design and Query Optimization



The database contains:



\- `hotel\_bookings` — booking records, organization, hotel, city, dates, amount and status.

\- `booking\_events` — events associated with bookings, including JSONB payloads.



The schema includes primary keys, a foreign key, and checks for valid booking dates and non-negative amounts.



The migration also creates indexes to support city/date queries and booking-event lookups. The city/date index includes additional columns to help eligible queries use index-only scans.



Use `EXPLAIN (ANALYZE, BUFFERS)` to evaluate query execution and buffer usage against the local dataset.



\## 6. Database Backup and Restore



Run the backup script from the project root using Git Bash:



```bash

bash ./scripts/backup.sh

```



The backup uses PostgreSQL's custom dump format.



For restore testing, restore into a separate test database rather than overwriting the original database. Confirm that the restored tables and record counts match the source database.



\*\*Note:\*\* Keep database backups containing real or sensitive data out of public repositories.



\## 7. Terraform Validation



Run these commands from each environment directory.



For Dev:



```bash

cd terraform/environments/dev

terraform init -backend=false

terraform fmt -check -recursive ../../..

terraform validate

```



For Production:



```bash

cd terraform/environments/prod

terraform init -backend=false

terraform fmt -check -recursive ../../..

terraform validate

```



The GitHub Actions workflow runs formatting, initialization and validation for both environments on pushes to `main`, pull requests to `main`, and manual workflow dispatches.



Terraform validation checks configuration syntax and consistency; it does not prove that AWS deployment will succeed.



\## 8. Security Considerations



\- The RDS database is configured as private and is not publicly accessible.

\- Database access is restricted to the ECS security group.

\- Database passwords must be supplied securely and must not be committed to Git.

\- The current ALB listener uses HTTP. HTTPS with an ACM certificate should be configured for a production deployment.

\- AWS credentials should be managed through an approved secure identity mechanism if deployment is added later.

\- Review costs and permissions before deploying resources such as NAT Gateways and RDS instances.



\## 9

