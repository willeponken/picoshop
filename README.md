picoshop
========
Minimalistic web shop.

## Setup development environment
### Prerequisites
 * Download and install Go

### Database setup
Picoshop forward engineers table creation. You have to create the schema and user though.
#### Create schema
```sql
CREATE SCHEMA IF NOT EXISTS picoshop DEFAULT CHARACTER SET utf8;
```

#### Create user
```sql
CREATE USER picoshop@localhost IDENTIFIED BY '<password here>';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,INDEX,EVENT,DROP,TRIGGER,EXECUTE,SHOW VIEW,CREATE VIEW,CREATE ROUTINE,ALTER ROUTINE,EVENT ON picoshop.* TO picoshop@localhost;
```

### Run Picoshop
 * Run `picoshopd` with `go run cmd/picoshopd/main.go -address=:9090 -source 'picoshop:<password here>@tcp(127.0.0.1:3306)/picoshop'`

## Project status
| Build status |
|:------------:|
| [![Build Status](https://travis-ci.org/wstrm/picoshop.svg?branch=master)](https://travis-ci.org/wstrm/picoshop) |

## Project structure

### Code
![Code project structure tree](https://github.com/wstrm/picoshop/blob/master/doc/patterns/picoshop-project-structure_rev1.png)

<details>
<summary>Description</summary>

 * /cmd - main entry points for each binary
 * /controller - routes according to MVC pattern
 * /doc - documentation
 * /middleware - interceptors for routes
 * /model - interact with database according to MVC pattern
 * /static - content that is served by the web server
 * /tool - developer utilities
 * /view - HTML views that are rendered for each web page

</details>

### Database
![Database ER scheme](https://github.com/wstrm/picoshop/blob/master/doc/database/picoshop_mysql-sql-eer-diagram_rev3.png)
