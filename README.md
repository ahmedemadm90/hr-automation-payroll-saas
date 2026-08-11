# HR Automation & Payroll SaaS

PeopleFlow is a comprehensive HR and payroll product for modern teams. It features a multi-tenant Laravel backend for company management, a Flutter mobile portal for employee self-service (attendance and leaves), and an n8n workflow for syncing payroll data with accounting platforms.

## Product surface

| Area | Implemented capability |
|---|---|
| Multi-tenancy | Company isolation, roles (Admin, HR, Employee), and tenant-scoped records |
| Attendance | Geo-fenced mobile clock-in/out and daily status tracking |
| Leave Management | Employee requests and HR approval workflow with status history |
| Payroll | Automated monthly payroll generation based on base salary and attendance |
| Mobile Portal | Flutter Material 3 interface for employees to manage their work lifecycle |
| Automation | n8n integration for syncing approved payrolls with external accounting APIs |

## Run the backend

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Seeded credentials:

| User | Email | Password | Role |
|---|---|---|---|
| HR Manager | `hr@techcorp.test` | `password` | HR Admin |
| Employee | `ahmed@techcorp.test` | `password` | Standard Employee |

The seeded company is `Tech Corp` with a pre-configured salary structure for all employees.

## Run the Flutter mobile app

```bash
cd frontend
flutter pub get
flutter test
flutter analyze
flutter run
```

The app is configured for an Android emulator (`10.0.2.2`). It allows employees to clock in/out, view their attendance history, and submit new leave requests for HR approval.

## Payroll & Accounting Sync (n8n)

Import `workflows/payroll_sync.json` into n8n. This workflow acts as a bridge:
1. **Trigger**: Laravel sends a payload of approved payrolls.
2. **Logic**: n8n formats the data for external consumption.
3. **Delivery**: Syncs records with QuickBooks, Xero, or banking APIs.

Configure these environment variables in n8n:
- `ACCOUNTING_API_URL`: Your accounting software endpoint.
- `ACCOUNTING_TOKEN`: API authentication secret.

## API surface

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `/api/v1/auth/register` | Create a company and admin account |
| `POST` | `/api/v1/auth/login` | Issue an employee API token |
| `POST` | `/api/v1/employee/attendance/clock-in` | Record daily attendance with location |
| `GET` | `/api/v1/employee/leave-requests` | List user's leave history |
| `POST` | `/api/v1/hr/payroll/generate` | Generate monthly payroll for the company |
| `POST` | `/api/v1/hr/leaves/{id}/approve` | Approve a pending leave request |

## Validation

```bash
cd backend
php artisan test --compact

cd ../frontend
flutter analyze
```

## SaaS roadmap

The architecture is built for scale. Future commercial features include automated tax calculations, document management (contracts/ID), performance reviews, recruitment pipelines (ATS), and direct bank transfer integrations via n8n.

## Author

Ahmed Emad — Backend, Mobile, and Automation Developer.
