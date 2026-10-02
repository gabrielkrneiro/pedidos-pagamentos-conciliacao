# Backend

Spring Boot application for the Orders, Payments, and Reconciliation platform. It exposes the REST API, owns the PostgreSQL schema through Flyway migrations, and contains the backend tests.

> **Status:** not started. This folder is a placeholder created by [#5](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/5).

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
- Spring Boot application bootstrap ([#7](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/7))
- Flyway configuration ([#8](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/8))
- Customer data model, documented in `docs/data-model.md` ([#9](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/9))
- Customers table migration ([#10](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/10))
- `POST /customers` and `GET /customers` endpoints ([#11](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/11), [#12](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/12))
- API tests for customer endpoints ([#13](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/13))

## Getting started

Setup and test instructions will be added once the application is bootstrapped.
