/*

| Rol            | Acceso                  | Tablas principales                            |
| ---------------| ------------------------| --------------------------------------------- |
| rol_operador   | SELECT, INSERT          | Pedido, DetallePedido, Incidencia.            |
| rol_supervisor | SELECT, UPDATE, EXECUTE | Todas las tablas operativas + procedimientos  |
| rol_auditor    | SELECT (solo lectura)   | Todo el esquema, sin permisos de modificación |
| rol_admin      | CONTROL                 | Permisos totales                              |

*/


CREATE ROLE rol_operador;
CREATE ROLE rol_supervisor;
CREATE ROLE rol_auditor;
CREATE ROLE rol_admin;

GRANT SELECT, INSERT ON Pedido TO rol_operador;
GRANT SELECT, UPDATE, EXECUTE ON SCHEMA::dbo TO rol_supervisor;
GRANT SELECT ON SCHEMA::dbo TO rol_auditor;
GRANT CONTROL ON DATABASE::tp_idd_1 TO rol_admin;
