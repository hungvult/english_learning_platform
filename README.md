# English Learning Platform

## Installation For Windows Users (I haven't tested on this platform yet)

The repository already includes both `server/` and `seed_data/`, so you only
clone this project once. For native Windows 11 development, use PowerShell and
run the backend, seed script, and frontend in separate terminals.

### 1. Install prerequisites

- Git
- Python 3.12 or newer
- Node.js 20 or newer
- SQL Server 2022 Developer or Express
- Microsoft ODBC Driver 18 for SQL Server
- PowerShell

### 2. Clone the repository

```powershell
git clone https://github.com/hungvult/english_learning_platform.git
cd English_Learning_Platform
git clone https://github.com/hungvult/english_learning_platform/client.git
git clone https://github.com/hungvult/english_learning_platform/server.git
git clone https://github.com/hungvult/english_learning_platform/seed_data.git
```

### 3. Prepare SQL Server

Make sure your SQL Server service is running, then create a database named
`EnglishLearning` in your local SQL Server instance. If you already have
`sqlcmd` installed, you can do that from PowerShell:

```powershell
sqlcmd -S localhost -U sa -P "YourStrong!Passw0rd" -Q "IF DB_ID('EnglishLearning') IS NULL CREATE DATABASE EnglishLearning;"
```

If you prefer SSMS, run the same `CREATE DATABASE EnglishLearning;` statement
there.

If you are using the same credentials as the seed script, the connection string
looks like this:

```text
mssql+pyodbc://sa:YourStrong!Passw0rd@localhost:1433/EnglishLearning?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes
```

If your SQL Server password is different, update the connection string
accordingly.

### 4. Set up the backend

```powershell
cd server
Copy-Item .env.example .env
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Edit `server/.env` so `DATABASE_URL` points to your local SQL Server database.
The backend uses the same `.env` file when it runs locally.

### 5. Seed the database

Run the seed script from a new PowerShell window. The `seed_data/` folder is
already part of this repository, so there is nothing else to clone.

```powershell
cd seed_data
$env:SERVER_PATH = "..\server"
$env:DATABASE_URL = "mssql+pyodbc://sa:YourStrong!Passw0rd@localhost:1433/EnglishLearning?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"
python seed.py
```

The seed script creates tables if needed and is safe to run multiple times.

### 6. Run the backend

Keep the backend terminal open and start FastAPI with Uvicorn:

```powershell
cd server
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 7. Set up the frontend

Open another PowerShell window for the client:

```powershell
cd client
Copy-Item .env.example .env.local
npm install
npm run dev
```

### 8. Open the application

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Swagger UI: http://localhost:8000/docs

## Installation For Docker Enjoyers (Recommended)

[Navigate to here](./Docker.md)
