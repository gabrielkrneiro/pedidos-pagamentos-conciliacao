# Orders, Payments, and Reconciliation

A study platform where a company registers customers, creates payment requests, and tracks their payments. Later releases will add a simulated payment provider that sends confirmations, delays, and failures, which the platform will reconcile.

> **Status:** planning. No application code yet. Work is tracked in the [GitHub Project](https://github.com/users/gabrielkrneiro/projects/2).

## MVP 0.1: Create and list payment requests

The first release delivers a working version with:

- Basic customer registration (name and email).
- Payment request creation: customer, description, amount in Brazilian reais (BRL), and due date.
- A searchable, paginated list of payment requests.

All payment requests start as **Pending**. The application serves a single company, and authentication is out of scope for this release.

Milestone: [MVP 0.1 — Create and list payment requests](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/milestone/1)

## Tech stack

| Layer          | Technology               |
| -------------- | ------------------------ |
| Frontend       | Angular                  |
| Backend        | Spring Boot 4.1 (Java 21, Maven) |
| Database       | PostgreSQL, with Flyway migrations |
| Local runtime  | Docker Compose           |

The code lives in a single monorepo. Implementation starts with the backend; the frontend is added later.

## Planned repository structure

```text
.
├── backend/   # Spring Boot API, Flyway migrations, and tests
├── frontend/  # Angular application (placeholder; app added later)
├── docs/      # Data model and other project documentation
└── README.md
```

## Getting started

Setup instructions will be added once the backend and Docker Compose are in place ([#5](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/5), [#6](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/6)). The goal is to start the whole environment with:

```bash
docker compose up --build
```

## Roadmap

After MVP 0.1, planned topics include authentication and permissions, asynchronous payments, refunds, reconciliation, server-sent events (SSE), Redis, RabbitMQ, reports, audit trails, observability, Kubernetes, AWS, and Terraform.

## How work is organized

- **Epic:** a group of user stories that delivers a larger capability ([#1](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/1)).
- **User story:** an outcome a user expects, with acceptance criteria.
- **Task:** technical work needed to deliver a story, added as a sub-issue of that story.
- **Milestone:** the goal of a release.
- **Iteration:** a two-week sprint in the GitHub Project.

A story is **done** when its acceptance criteria can be demonstrated in the running application, a user can complete the flow end to end, data survives a restart, automated tests cover every criterion, and the Product Owner has accepted it.
