DROP TABLE Aluno;
DROP TABLE curso;
DROP TABLE exercicio;
DROP TABLE matricula;
DROP TABLE nota;
DROP TABLE resposta;
DROP TABLE secao;

-- eu quero selecionar o aluno e quais cursos ele está matriculado. 

select nome from aluno 
    join matricula on matricula.aluno_id = aluno.id;
   
    
select aluno.nome, curso.nome from aluno 
    join matricula on matricula.aluno_id = aluno.id 
    join curso on curso.id = matricula.curso_id;
    
select a.nome, c.nome from aluno a 
    join matricula m on m.aluno_id = a.id 
    join curso c on c.id = m.curso_id;

-- Exibindo alunos com e sem matrícula, primeikro vamos buscar todos alunos:

select a.nome from aluno a;

-- E depois buscar só os alunos que tem matrícula, onde a matrícula existe, para isso vamos usar o EXISTS:

SELECT * FROM aluno a where EXISTS (
    select m.id from matricula m 
    where m.aluno_id = a.id
);

-- Mas queremos os alunos que não estão matriculados em nenhum curso:

select a.nome from aluno a where not exists(
    select m.id from matricula m where m.aluno_id = a.id
);

-- Existem exercícios não respondidos? gostaríamos de saber os que ainda não foram respondidos:

select * from exercicio e where not exists (
    select r.id from resposta r where r.exercicio_id = e.id
)
order by e.id;

-- quais são os cursos sem matrícula? primeiro vou pegar os cursos que tem matricula...

select c.nome from curso c where exists (
    select m.id from matricula m where m.curso_id = c.id
);


select DISTINCT c.nome from matricula m 
Inner join curso c on (m.curso_id = c.id);

-- Qual a diferenca entre o Exits e o inner join com distict?

-- cursos sem matricula

select c.nome from curso c where not exists (
    select m.id from matricula m where m.curso_id = c.id
);


-- Quero as médias das notas por curso, e agora?

select  n.nota from nota n
    join resposta r on r.id = n.resposta_id
    join exercicio e on e.id = r.exercicio_id
    join secao s on s.id = e.secao_id
    join curso c on c.id = s.curso_id;
    

select c.nome, avg(n.nota) as media from nota n
    join resposta r on r.id = n.resposta_id
    join exercicio e on e.id = r.exercicio_id
    join secao s on s.id = e.secao_id
    join curso c on c.id = s.curso_id;


select c.nome, avg(n.nota) as media from nota n
    join resposta r on r.id = n.resposta_id
    join exercicio e on e.id = r.exercicio_id
    join secao s on s.id = e.secao_id
    join curso c on c.id = s.curso_id
group by c.nome;    


-- Quantidade de exercícios por curso

select count(e.id) from exercicio e
    join secao s on s.id = e.secao_id;


select count(e.id) from exercicio e
    join secao s on s.id = e.secao_id
    join curso c on c.id = s.curso_id;


select c.nome, count(e.id) from exercicio e
    join secao s on s.id = e.secao_id
    join curso c on c.id = s.curso_id
group by c.nome;


-- Quantos alunos temos matriculados em cada curso?

select c.nome from curso c
    join matricula m on m.curso_id = c.id;


select c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on a.id = m.aluno_id;


-- E por fim, adicionamos o COUNT e o agrupamento:

select c.nome, count(a.id) as quantidade from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on a.id = m.aluno_id
group by c.nome;

-- Conte a quantidade de respostas por exercicios

SELECT e.pergunta, count(r.id) as quantidade from exercicio e
    join resposta r on r.id = r.exercicio_id
group by e.pergunta;


-- Filtrando agregações e o HAVING - Selecionando a média das notas de um aluno:

select n.nota from nota n;

select a.nome, c.nome, avg(n.nota) as media from nota n
    join resposta r on r.id = n.resposta_id
    join exercicio e on e.id = r.exercicio_id
    join secao s on s.id = e.secao_id
    join curso c on c.id = s.curso_id
    join aluno a on a.id = r.aluno_id
group by a.nome, c.nome
having avg(n.nota) < 5;



-- Quantos alunos temos matriculados em cada curso?

select c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on m.aluno_id = a.id;
    

select count(a.id) as quantidade, c.nome from curso c
    join matricula m on m.curso_id = c.id  
    join aluno a on m.aluno_id = a.id
group by c.nome;


select count(a.id) as quantidade, c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on m.aluno_id = a.id
group by c.nome
having count(a.id) < 3;

-- Devolva todos os alunos, cursos e a média de suas notas. Lembre-se de agrupar por aluno e por curso.
-- Filtre também pela nota: só mostre alunos com nota média menor do que 5.

select a.nome, c.nome, avg(n.nota) as media from nota n
    join resposta r on r.id = n.resposta_id
    join exercicio e on e.id = r.exercicio_id
    join secao s on s.id = e.secao_id 
    join curso c on c.id = s.curso_id
    join aluno a on a.id = r.aluno_id
group by a.nome, c.nome
having AVG(n.nota) > 5;

-- Exiba todos os cursos e a sua quantidade de matrículas. Mas exiba somente cursos que tenham mais de 1 matrícula.

select c.nome, count(m.id) as quantidade from curso c 
    join matricula m on c.id = m.curso_id
group by c.nome
having count(m.id) > 1;


-- Exiba o nome do curso e a quantidade de seções que existe nele. Mostre só cursos com mais de 3 seções.

select c.nome, count(s.id) as quantidade from curso c 
    join secao s on c.id = s.curso_id
group by c.nome
having count(s.id) > 3;


-- O financeiro também quer saber quantas matrículas temos, mais especificamente para pessoas jurídica ou física

select c.nome, count(m.id) as quantidade from matricula m 
    join curso c on m.curso_id = c.id 
group by c.nome;


select c.nome, count(m.id) as quantidade from matricula m 
    join curso c on m.curso_id = c.id 
where m.tipo = 'PAGA_PJ' or m.tipo = 'PAGA_PF'
group by c.nome;


select c.nome, m.tipo, count(m.id) as quantidade from matricula m 
    join curso c on m.curso_id = c.id 
where m.tipo = 'PAGA_PJ' or m.tipo = 'PAGA_PF'
group by c.nome, m.tipo;


-- Quando uma variavel tiver um grupo de valores, 
-- como "Tipo" no exemplo acima, podemos usar clausula IN

select c.nome, m.tipo, count(m.id) as quantidade from matricula m 
    join curso c on m.curso_id = c.id 
where m.tipo in ('PAGA_PJ', 'PAGA_PF')
group by c.nome, m.tipo;


-- Sabendo quais cursos determinados alunos fizeram

select c.nome from curso c
    join matricula m on m.curso_id = c.id
where m.aluno_id in (1, 3, 4);


select a.nome, c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on m.aluno_id = a.id
where m.aluno_id in (1, 3, 4);


select a.nome, c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on m.aluno_id = a.id
where m.aluno_id in (1, 3, 4)
order by a.nome;

-- Agora que estamos lançando um curso de Oracle Database, queremos divulgá-lo para ex-alunos. 
-- Mas não pra todos ex-alunos, somente os que fizeram o curso de SQL e banco de dados ou PHP e MySql.

select a.nome, c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on m.aluno_id = a.id;

select a.nome, c.nome from curso c
    join matricula m on m.curso_id = c.id
    join aluno a on m.aluno_id = a.id
where c.id in (1, 9);


select distinct tipo from matricula;

-- Traga todos os exercícios e a quantidade de respostas de cada uma. 
-- Mas dessa vez, somente dos cursos com ID 1 e 3.

select e.pergunta, count(r.id) as quantidade from exercicio e 
    join resposta r on e.id = r.exercicio_id
    join secao s on s.id = e.secao_id
    join curso c on s.curso_id = c.id
where c.id in (1,3)
group by e.pergunta;













