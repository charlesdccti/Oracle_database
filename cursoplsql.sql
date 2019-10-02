
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



    












