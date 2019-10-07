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





