# 🗄️ Universal Database Engines & CLI Tools

> Receitas universais em POSIX Shell para provisionamento de motores de bancos de dados relacionais, analíticos (OLAP) e NoSQL.

---

## 🎯 Finalidade

Esta pasta fornece receitas modulares e idempotentes para instalação de motores e clientes de linha de comando de bancos de dados em sistemas **FreeBSD**, **Linux** (Fedora, Debian/Ubuntu, Arch), **macOS** e **Windows** (MSYS2, Scoop, Winget).

Por padrão, a suíte adota o **MariaDB** como implementação aberta compatível com o protocolo MySQL para evitar conflitos de pacotes (`/usr/bin/mysql`), mantendo a receita [`mysql.sh`](mysql.sh) disponível para instalações isoladas do MySQL Community.

---

## 📂 Catálogo de Arquivos

| Arquivo                          | Plataforma                                  | Descrição                                                      |
| :------------------------------- | :------------------------------------------ | :------------------------------------------------------------- |
| [`databases.sh`](databases.sh)   | Linux / FreeBSD / macOS / WSL / MSYS2 / Win | Orquestrador da suíte de bancos de dados (SQLite, PG, MariaDB) |
| [`sqlite.sh`](sqlite.sh)         | Linux / FreeBSD / macOS / WSL / MSYS2 / Win | Instalação do motor embarcado SQLite3                          |
| [`postgresql.sh`](postgresql.sh) | Linux / FreeBSD / macOS / WSL / MSYS2 / Win | Instalação do servidor e cliente PostgreSQL (`psql`)           |
| [`mariadb.sh`](mariadb.sh)       | Linux / FreeBSD / macOS / WSL / MSYS2 / Win | Instalação do servidor e cliente MariaDB (`mariadb` / `mysql`) |
| [`mysql.sh`](mysql.sh)           | Linux / FreeBSD / macOS / WSL / MSYS2 / Win | Instalação alternativa do MySQL Community Server & Client      |
| [`mongodb.sh`](mongodb.sh)       | FreeBSD / Arch / macOS / Windows            | Instalação do MongoDB Server e MongoDB Shell (`mongosh`)       |
| [`redis.sh`](redis.sh)           | Linux / FreeBSD / macOS / Windows           | Instalação do armazenamento em memória Redis / Valkey          |
| [`duckdb.sh`](duckdb.sh)         | Linux / FreeBSD / macOS / WSL / MSYS2 / Win | Instalação do motor analítico colunar serverless DuckDB        |

---

## 🚀 Como Usar via GitHub (Zero-Clone)

Provisionar a suíte completa de bancos de dados:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/databases.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/databases.sh) | sh
```

Instalar apenas PostgreSQL:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/postgresql.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/postgresql.sh) | sh
```

Instalar apenas SQLite:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/sqlite.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/sqlite.sh) | sh
```

Instalar apenas MariaDB:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/mariadb.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/mariadb.sh) | sh
```

Instalar apenas MySQL:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/mysql.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/mysql.sh) | sh
```

Instalar apenas MongoDB:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/mongodb.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/mongodb.sh) | sh
```

Instalar apenas Redis:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/redis.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/redis.sh) | sh
```

Instalar apenas DuckDB:

```sh
curl -fsSL [https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/duckdb.sh](https://raw.githubusercontent.com/GabrielFrigo4/setup/main/common/database/duckdb.sh) | sh
```
