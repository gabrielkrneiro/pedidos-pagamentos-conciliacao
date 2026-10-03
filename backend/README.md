# Backend

Spring Boot application for the Orders, Payments, and Reconciliation platform. It exposes the REST API, owns the PostgreSQL schema through Flyway migrations, and contains the backend tests.

> **Status:** bootstrapped ([#7](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/7)). The application starts and exposes a health endpoint; business endpoints are not implemented yet.

## Tech stack

| Concern       | Technology                              |
| ------------- | --------------------------------------- |
| Language      | Java 21                                 |
| Framework     | Spring Boot 4.1 (Web, Validation, Data JPA, Actuator) |
| Build         | Maven                                   |
| Database      | PostgreSQL                              |
| Migrations    | Flyway                                  |
| Tests         | JUnit 5, MockMvc, Testcontainers        |

## Planned work

- Docker Compose for the API and PostgreSQL ([#6](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/6))
- Flyway configuration ([#8](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/8))
- Customer data model, documented in `docs/data-model.md` ([#9](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/9))
- Customers table migration ([#10](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/10))
- `POST /customers` and `GET /customers` endpoints ([#11](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/11), [#12](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/12))
- API tests for customer endpoints ([#13](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/13))

## Getting started

### Prerequisites

- Java 21 (`mise install` picks it up from `mise.toml`)
- Docker, for the local database and for the tests

### Run the API

```bash
cp .env.example .env        # then set POSTGRES_PASSWORD
docker compose up -d        # starts PostgreSQL
./mvnw spring-boot:run
```

Check that it is up: `curl http://localhost:8080/actuator/health` returns `{"status":"UP"}`.

### Run the tests

```bash
./mvnw test
```

The tests start their own PostgreSQL container with Testcontainers, so they don't need `.env` or the Docker Compose database, but Docker must be running.

### Formatting

Java code follows `eclipse-formatter.xml` (2-space indentation, 100-column lines). Check it with `./mvnw spotless:check` and fix it with `./mvnw spotless:apply`. VS Code uses the same profile through `.vscode/settings.json`.
