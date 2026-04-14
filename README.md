# English Learning Platform

A full-stack English learning platform inspired by popular language learning
apps. It offers interactive exercises covering all four core skills: listening,
speaking, reading, and writing, along with a built-in admin CMS for managing
courses and content.

Built with Next.js and FastAPI, the codebase is split into clearly separated
modules (client, server, scripts, seed data) and ships with Docker support for
deployment.

## Notable Features

- Based on a popular language learning platforms.
- Various exercise types to fully learn 4 skills: listening, speaking, reading,
  and writing.
- I18N: Multi-language support for UI and content.

## Project Structure

The project is organized into several key modules, orchestrated to work together
seamlessly:

- **[`client/`](./client)**: Frontend application built with **Next.js 14 (App
  Router)** and **Tailwind CSS**.
  - **Admin Dashboard**: A powerful CMS built with **React-Admin** for managing
    courses, units, lessons, and exercises.
  - **Learning UI**: A custom-designed, interactive interface for students to
    practice exercises.
- **[`server/`](./server)**: High-performance backend API built with **FastAPI**
  and **SQLModel**.
  - **Database**: Uses **Microsoft SQL Server** for reliable data storage.
  - **Security**: JWT-based authentication and role-based access control (RBAC).
- **[`scripts/`](./scripts)**: Standalone tools for database migrations and
  maintenance.
- **[`seed_data/`](./seed_data)**: Comprehensive dataset and scripts for
  initializing the platform with modular content.

## Getting Started

[Specification](docs/Specification.md)

[Database schema](docs/Database_Schema.md)

[Exercise Validation](docs/Exercise_Validation.md)

[Docker](docs/Docker.md)
