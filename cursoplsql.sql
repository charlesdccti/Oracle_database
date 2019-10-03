
-- blocos de PLSQL

DECLARE
    v_id segmercado.id%type := 2;
    v_descricao segmercado.descricao%type := 'atacado';
BEGIN
    INSERT INTO segmercado VALUES (v_id, upper(v_descricao));
    COMMIT;
END;


DECLARE
    v_id segmercado.id%type := 1;
    v_descricao segmercado.descricao%type := 'varejista';
BEGIN
    UPDATE segmercado
        SET descricao = UPPER(v_descricao)
        WHERE id = v_id;
    COMMIT;
END;


DECLARE
    v_id segmercado.id%type := 1;
    v_descricao segmercado.descricao%type := 'varejista';
BEGIN
    UPDATE segmercado
        SET descricao = UPPER(v_descricao)
        WHERE id = v_id;

    v_id := 2;
    v_descricao := 'atacadista';

    UPDATE segmercado
        SET descricao = UPPER(v_descricao)
        WHERE id = v_id;
    COMMIT;
END;


DECLARE
    v_id segmercado.id%type := 3;
    v_descricao segmercado.descricao%type := 'esportivo';
BEGIN
    INSERT INTO segmercado VALUES (v_id, upper(v_descricao));
    COMMIT;
END;


-- criação e execucao de uma procedure 

CREATE OR REPLACE PROCEDURE incluir_segmercado
    (p_id IN segmercado.id%type ,
    p_descricao IN segmercado.descricao%type)
IS
BEGIN
    INSERT into segmercado
        values(p_id, UPPER(p_descricao));
    COMMIT;
END;

EXECUTE incluir_segmercado(4, 'Farmaceutico')



-- criacao e uso de funcoes 

CREATE OR REPLACE FUNCTION obter_descricao_segmercado
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


VARIABLE g_descricao varchar2(100)
EXECUTE :g_descricao := obter_descricao_segmercado (1)
PRINT g_descricao


SET SERVEROUTPUT ON
DECLARE
    v_descricao segmercado.descricao%type;
BEGIN
    v_descricao := obter_descricao_segmercado(2);
    dbms_output.put_line('Descricao: '||v_descricao);
END;



-- Estrutura condicional

CREATE OR REPLACE PROCEDURE INCLUIR_CLIENTE
       (p_id IN cliente.id%TYPE,
       p_razao_social IN cliente.razao_social%TYPE,
       p_CNPJ IN cliente.cnpj%TYPE,
       p_segmercado_id IN cliente.segmercado_id%TYPE,
       p_faturamento_previsto IN cliente.faturamento_previsto%TYPE)
       
      IS
          V_categoria cliente.categoria%TYPE;
          
      BEGIN
      
        IF p_faturamento_previsto < 10000 THEN
            v_categoria := 'PEQUENO';
        ELSIF p_faturamento_previsto < 50000 THEN
            v_categoria := 'MEDIO';
        ELSIF p_faturamento_previsto < 100000 THEN
            v_categoria := 'MEDIO GRANDE';
        ELSE
            v_categoria := 'GRANDE';
        END IF;
        
        
        INSERT INTO cliente
            VALUES (p_id, UPPER(p_razao_social), p_CNPJ, p_segmercado_id, SYSDATE, p_faturamento_previsto, v_categoria);
        COMMIT;
     END ;

   
EXECUTE INCLUIR_CLIENTE(1, 'SUPERMERCADO XYZ', '12345', NULL, 150000)


-- Extracao de codigo

CREATE OR REPLACE FUNCTION categoria_cliente
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




CREATE OR REPLACE PROCEDURE INCLUIR_CLIENTE
       (p_id IN cliente.id%TYPE,
       p_razao_social IN cliente.razao_social%TYPE,
       p_CNPJ IN cliente.cnpj%TYPE,
       p_segmercado_id IN cliente.segmercado_id%TYPE,
       p_faturamento_previsto IN cliente.faturamento_previsto%TYPE)
       
      IS
          V_categoria cliente.categoria%TYPE;
          
      BEGIN
      
        V_categoria := categoria_cliente(p_faturamento_previsto);
        
        INSERT INTO cliente
            VALUES (p_id, UPPER(p_razao_social), p_CNPJ, p_segmercado_id, SYSDATE, p_faturamento_previsto, v_categoria);
        COMMIT;
      END ;


EXECUTE INCLUIR_CLIENTE(2, 'SUPERMERCADO IJK', '67890', NULL, 90000);


SELECT * FROM cliente;


-- Parâmetros IN OUT

CREATE OR REPLACE PROCEDURE FORMAT_CNPJ
    (p_cnpj IN OUT cliente.CNPJ%type)

IS
BEGIN
    p_cnpj := substr(p_cnpj,1,2) ||'/'|| substr(p_cnpj,3);
END;


VARIABLE g_cnpj varchar2(10)
EXECUTE :g_cnpj := '12345'
PRINT g_cnpj

EXECUTE FORMAT_CNPJ(:g_cnpj)

PRINT g_cnpj



CREATE OR REPLACE PROCEDURE INCLUIR_CLIENTE 
   (p_id in cliente.id%type,
    p_razao_social IN cliente.razao_social%type,
    p_CNPJ cliente.CNPJ%type ,
    p_segmercado_id IN cliente.segmercado_id%type,
    p_faturamento_previsto IN cliente.faturamento_previsto%type)
IS
    v_categoria cliente.categoria%type;
    v_CNPJ cliente.cnpj%type := p_CNPJ;

BEGIN

    v_categoria := categoria_cliente(p_faturamento_previsto);

    format_cnpj(v_cnpj);

    INSERT INTO cliente VALUES (p_id, UPPER(p_razao_social), v_CNPJ ,p_segmercado_id, SYSDATE, p_faturamento_previsto, v_categoria);
    COMMIT;

END;


EXECUTE INCLUIR_CLIENTE(3, 'Industria RTY', '12378', NULL, 110000)

select * from cliente

-- Estruturas de repetição

























    












