--------------------------------------------------------
--  Arquivo criado - Quinta-feira-Outubro-03-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CLIENTE
--------------------------------------------------------

  CREATE TABLE "CURSOPLSQL"."CLIENTE" 
   (	"ID" NUMBER(5,0), 
	"RAZAO_SOCIAL" VARCHAR2(100 BYTE), 
	"CNPJ" VARCHAR2(20 BYTE), 
	"SEGMERCADO_ID" NUMBER(5,0), 
	"DATA_INCLUSAO" DATE, 
	"FATURAMENTO_PREVISTO" NUMBER(10,2), 
	"CATEGORIA" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table SEGMERCADO
--------------------------------------------------------

  CREATE TABLE "CURSOPLSQL"."SEGMERCADO" 
   (	"ID" NUMBER(5,0), 
	"DESCRICAO" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into CURSOPLSQL.CLIENTE
SET DEFINE OFF;
Insert into CURSOPLSQL.CLIENTE (ID,RAZAO_SOCIAL,CNPJ,SEGMERCADO_ID,DATA_INCLUSAO,FATURAMENTO_PREVISTO,CATEGORIA) values ('1','SUPERMERCADO XYZ','12345','2',to_date('03/10/19','DD/MM/RR'),'150000','GRANDE');
Insert into CURSOPLSQL.CLIENTE (ID,RAZAO_SOCIAL,CNPJ,SEGMERCADO_ID,DATA_INCLUSAO,FATURAMENTO_PREVISTO,CATEGORIA) values ('2','SUPERMERCADO IJK','67890','2',to_date('03/10/19','DD/MM/RR'),'90000','MEDIO GRANDE');
Insert into CURSOPLSQL.CLIENTE (ID,RAZAO_SOCIAL,CNPJ,SEGMERCADO_ID,DATA_INCLUSAO,FATURAMENTO_PREVISTO,CATEGORIA) values ('3','INDUSTRIA RTY','12/378','2',to_date('03/10/19','DD/MM/RR'),'110000','GRANDE');
REM INSERTING into CURSOPLSQL.SEGMERCADO
SET DEFINE OFF;
Insert into CURSOPLSQL.SEGMERCADO (ID,DESCRICAO) values ('2','ATACADISTA');
Insert into CURSOPLSQL.SEGMERCADO (ID,DESCRICAO) values ('3','ESPORTIVO');
Insert into CURSOPLSQL.SEGMERCADO (ID,DESCRICAO) values ('4','FARMACEUTICO');
Insert into CURSOPLSQL.SEGMERCADO (ID,DESCRICAO) values ('1','VAREJISTA');
--------------------------------------------------------
--  DDL for Index SEGMERCADO_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "CURSOPLSQL"."SEGMERCADO_ID_PK" ON "CURSOPLSQL"."SEGMERCADO" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index CLIENTE_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "CURSOPLSQL"."CLIENTE_ID_PK" ON "CURSOPLSQL"."CLIENTE" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Procedure ATUALIZAR_CLI_SEG_MERCADO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CURSOPLSQL"."ATUALIZAR_CLI_SEG_MERCADO" 
    (p_id IN cliente.id%type,
     p_segmercado_id IN cliente.segmercado_id%type)
IS
    e_cliente_id_inexistente exception;
BEGIN
    UPDATE cliente
        SET segmercado_id = p_segmercado_id
        WHERE id = p_id;
    IF SQL%NOTFOUND then
        RAISE e_cliente_id_inexistente;
    END IF;
    COMMIT;
EXCEPTION
    WHEN e_cliente_id_inexistente then
        raise_application_error(-20100,'Cliente inexistente');
END;

/
--------------------------------------------------------
--  DDL for Procedure FORMAT_CNPJ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CURSOPLSQL"."FORMAT_CNPJ" 
    (p_cnpj IN OUT cliente.CNPJ%type)

IS
BEGIN
    p_cnpj := substr(p_cnpj,1,2) ||'/'|| substr(p_cnpj,3);
END;

/
--------------------------------------------------------
--  DDL for Procedure INCLUIR_CLIENTE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CURSOPLSQL"."INCLUIR_CLIENTE" 
   (p_id in cliente.id%type,
    p_razao_social IN cliente.razao_social%type,
    p_CNPJ cliente.CNPJ%type ,
    p_segmercado_id IN cliente.segmercado_id%type,
    p_faturamento_previsto IN cliente.faturamento_previsto%type)
IS
    v_categoria cliente.categoria%type;
    v_CNPJ cliente.cnpj%type := p_CNPJ;
    e_null exception;
    pragma exception_init (e_null, -1400);

BEGIN

    v_categoria := categoria_cliente(p_faturamento_previsto);

    format_cnpj(v_cnpj);

    INSERT INTO cliente VALUES (p_id, UPPER(p_razao_social), v_CNPJ ,p_segmercado_id, SYSDATE, p_faturamento_previsto, v_categoria);
    COMMIT;

EXCEPTION
    WHEN dup_val_on_index then
        raise_application_error(-20010,'Cliente já cadastrado');
    WHEN e_null then
        raise_application_error(-20015,'A coluna ID tem preenchimento obrigatório');
    WHEN others then
        raise_application_error(-20020,sqlerrm());
END;

/
--------------------------------------------------------
--  DDL for Procedure INCLUIR_SEGMERCADO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CURSOPLSQL"."INCLUIR_SEGMERCADO" 
    (p_id IN segmercado.id%type ,
     p_descricao IN segmercado.descricao%type)
IS
BEGIN
    INSERT into segmercado
        values(p_id, UPPER(p_descricao));
    COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Function CATEGORIA_CLIENTE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CURSOPLSQL"."CATEGORIA_CLIENTE" 
    (p_faturamento_previsto IN cliente.faturamento_previsto%type)
    RETURN cliente.categoria%type
IS
BEGIN
    IF p_faturamento_previsto < 10000 THEN
        RETURN 'PEQUENO';
    ELSIF p_faturamento_previsto < 50000 THEN
        RETURN 'MEDIO';
    ELSIF p_faturamento_previsto < 100000 THEN
        RETURN 'MEDIO GRANDE';
    ELSE
        RETURN 'GRANDE';
    END IF;
END;

/
--------------------------------------------------------
--  DDL for Function OBTER_DESCRICAO_SEGMERCADO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CURSOPLSQL"."OBTER_DESCRICAO_SEGMERCADO" 
    (p_id IN segmercado.id%type)
    RETURN segmercado.descricao%type
IS
    v_descricao segmercado.descricao%type;
BEGIN
    SELECT descricao INTO v_descricao
        FROM segmercado
        WHERE id = p_id;
    RETURN v_descricao;
END;

/
--------------------------------------------------------
--  Constraints for Table CLIENTE
--------------------------------------------------------

  ALTER TABLE "CURSOPLSQL"."CLIENTE" ADD CONSTRAINT "CLIENTE_ID_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table SEGMERCADO
--------------------------------------------------------

  ALTER TABLE "CURSOPLSQL"."SEGMERCADO" ADD CONSTRAINT "SEGMERCADO_ID_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CLIENTE
--------------------------------------------------------

  ALTER TABLE "CURSOPLSQL"."CLIENTE" ADD CONSTRAINT "CLIENTE_SEGMERCADO_FK" FOREIGN KEY ("SEGMERCADO_ID")
	  REFERENCES "CURSOPLSQL"."SEGMERCADO" ("ID") ENABLE;
