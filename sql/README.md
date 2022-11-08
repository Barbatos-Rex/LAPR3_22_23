# Database Naming Conventions, Documents and Scripts


## Database Naming Conventions

* [Check isolated file](./conventions/Database%20Naming%20Conventions.md)

### Rules

* **Table names** must not include protected keywords for Oracle SQL (ex. User, Dual, Start, etc.)
* **Table names** must follow the proper Camel case with the first letter of name capitalized (ex. Sensor, WaterSensor, Fertilizer, etc. What not to follow: sensor, waterSensor, PoTassicfertilizer,etc.)
* **Table Attributes** must follow proper camel case with first character not capitalized (ex. amount, numberOfSensors, cultivationType, etc.),
* **Table Attributes Constraints**, if inside table creation, may (or may not) have a dedicated name (ex. check (regex_like(code,"\d{8}\w{3}"))).
* **Table Attributes Constraints**, if outside table, as an alter table, it must have a name as the following form CC[TABLE_NAME]_[DESCRIPTION], where CC is the type of constraint (see constraint table in use), [TABLE_NAME] is the name of the table and [DESCRIPTION] is a description to identify what the constraint aims to achieve
* **Primary Key[s]** must be as simple as possible, using camel case, with first character uncapitalized, and, in preference, one word long (ex. code, name, id. What not to follow: idOfTeam, teamId, teamID, ID, Id, iD, idTeam, etc.)
* **Foreign Key[s]** must follow the same rules as **Primary Key[s]** and the name must be related to the relation that results in the **Foreign Key[s]** (ex. Assume entity *Music (M)* has multiple *CD (C)*, *M* "1" -> "1..N" *C*, then the **Foreign Key[s]** name in entity *Music* must be **cd**, and not cdCode, codeOfCd, fkCD, cdFK, etc. )


### Table Resume

|         Database Entity         | Rule                                                                                                                                                                                                                                                                                                                              |
|:-------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|         **Table Name**          | Must not include protected keywords for Oracle SQL (ex. User, Dual, Start, etc.)                                                                                                                                                                                                                                                  |
|                                 | Must follow the proper Camel case with the first letter of name capitalized (ex. Sensor, WaterSensor, Fertilizer, etc. What not to follow: sensor, waterSensor, PoTassicfertilizer,etc.)                                                                                                                                          |
|       **Table Attribute**       | Must follow proper camel case with first character not capitalized (ex. amount, numberOfSensors, cultivationType, etc.)                                                                                                                                                                                                           |
| **Table Attributes Constraint** | If inside table creation, may (or may not) have a dedicated name (ex. check (regex_like(code,"\d{8}\w{3}"))).                                                                                                                                                                                                                     |
|                                 | If outside table, as an alter table, it must have a name as the following form CC[TABLE_NAME]_[DESCRIPTION], where CC is the type of constraint (see constraint table in use), [TABLE_NAME] is the name of the table and [DESCRIPTION] is a description to identify what the constraint aims to achieve                           |
|       **Primary Key[s]**        | Must be as simple as possible, using camel case, with first character uncapitalized, and, in preference, one word long (ex. code, name, id. What not to follow: idOfTeam, teamId, teamID, ID, Id, iD, idTeam, etc.)                                                                                                               |
|       **Foreign Key[s]**        | Must follow the same rules as **Primary Key[s]** and the name must be related to the relation that results in the **Foreign Key[s]** (ex. Assume entity *Music (M)* has multiple *CD (C)*, *M* "1" -> "1..N" *C*, then the **Foreign Key[s]** name in entity *Music* must be **cd**, and not cdCode, codeOfCd, fkCD, cdFK, etc. ) |

### Constraints Table

| Constraint Name | Constraint Key |
|:---------------:|:--------------:|
|   Foreign Key   |     **FK**     |
|   Primary Key   |     **PK**     |
|    Not Null     |     **NN**     |
|     Unique      |     **UQ**     |
|     Default     |     **DF**     |
|      Index      |     **ID**     |

## Docs

* [Check isolated file](./docs/README.md)



## Scripts

* [Check isolated file (Database Structure)](./scripts/structure/README.md)
* [Check isolated file (Database Logic)](./scripts/logic/README.md)

### Database Structure

### Database Logic