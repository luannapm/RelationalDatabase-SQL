/*
EXERC�CIO 1 
Crie o banco de dados treino com as tabelas conforme diagrama.
*/
CREATE DATABASE TREINO
GO
USE TREINO

--CRIAR TABELAS
--CRIANDO TABELA CIDADE
	CREATE TABLE CIDADE
	(ID_CIDADE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CIDADE VARCHAR(60)  NOT NULL,
	UF VARCHAR(2) NOT NULL
	);
--CRIANDO TABELA CATEGORIA DE PRODUTOS
	CREATE TABLE CATEGORIA
	(ID_CATEGORIA INT IDENTITY(1,1)NOT NULL PRIMARY KEY,
	NOME_CATEGORIA VARCHAR(20) NOT NULL
	);
--CRIANDO A TABELA UNIDADE DE MEDIDAS
	CREATE TABLE UNIDADE
	(ID_UNIDADE VARCHAR(3) NOT NULL PRIMARY KEY,
	DESC_UNIDADE VARCHAR(25) NOT NULL
	);
--CRIANDO A TABELA CLIENTE
	CREATE TABLE CLIENTE
	 (ID_CLIENTE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	  NOME_CLIENTE VARCHAR(60) NOT NULL,
	  ENDERECO VARCHAR(60) NOT NULL,
	  NUMERO VARCHAR(10) NOT NULL,
	  ID_CIDADE INT NOT NULL,
	  CEP VARCHAR(9) NOT NULL,
	  CONSTRAINT FK_CLI1 FOREIGN KEY (ID_CIDADE) REFERENCES CIDADE(ID_CIDADE)
	  );


--CRIANDO TABELA VENDEDORES
	CREATE TABLE VENDEDORES
	(ID_VENDEDOR INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_VENDEDOR VARCHAR(60) NOT NULL ,
	SALARIO DECIMAL(10,2) NOT NULL
	);


--CRIANDO A TABELA DE 	
    CREATE TABLE PRODUTOS
	(ID_PROD INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
     NOME_PRODUTO VARCHAR(50) NOT NULL,
     ID_CATEGORIA INT NOT NULL,
	 ID_UNIDADE VARCHAR(3) NOT NULL,
     PRECO decimal(10, 2) NOT NULL,
	 CONSTRAINT FK_MAT1 FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA(ID_CATEGORIA),
	 CONSTRAINT FK_MAT2 FOREIGN KEY (ID_UNIDADE) REFERENCES UNIDADE(ID_UNIDADE)
    );


--CRIA��O DA TABELA VENDAS 
    CREATE TABLE VENDAS 
	(NUM_VENDA INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    DATA_VENDA DATETIME NOT NULL,
    ID_CLIENTE INT NOT NULL,
	ID_VENDEDOR INT NOT NULL,
	STATUS CHAR(1) NOT NULL DEFAULT('N'), --N NORMAL C-- CANCELADA
	CONSTRAINT FK_VND1 FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
	CONSTRAINT FK_VND2 FOREIGN KEY (ID_VENDEDOR) REFERENCES VENDEDORES(ID_VENDEDOR)
    );

--CRIA��O DA TABELA DETALHE VENDA ITEM
	CREATE TABLE VENDA_ITENS
	(NUM_VENDA INT NOT NULL,
	 NUM_SEQ INT NOT NULL,
	 ID_PROD INT NOT NULL,
	 QTDE DECIMAL(10,2) NOT NULL,
	 VAL_UNIT DECIMAL(10,2) NOT NULL,
	 VAL_TOTAL DECIMAL(10,2),
	 CONSTRAINT FK_VNDIT1 FOREIGN KEY (ID_PROD) REFERENCES PRODUTOS(ID_PROD),
	 CONSTRAINT FK_VNDIT2 FOREIGN KEY (NUM_VENDA) REFERENCES VENDAS(NUM_VENDA),
	 CONSTRAINT PK_VNDIT1 PRIMARY KEY (NUM_VENDA,NUM_SEQ)
	 );

/*
EXERC�CIO 2 
Restaurar o arquivo  treino.bak no banco de dados criado.
*/
USE MASTER
RESTORE DATABASE TREINO FROM DISK =N'CAMINHO DO ARQUIVO'
WITH REPLACE
USE TREINO
GO
/*

EXERC�CIO 3 
Liste todos os clientes com seus nomes e com suas respectivas cidade e estados
*/
SELECT CL.NOME_CLIENTE, 
C.NOME_CIDADE AS CIDADE, 
C.UF AS ESTADO 
FROM CLIENTE AS  CL INNER JOIN CIDADE AS C
ON CL.ID_CIDADE = C.ID_CIDADE;
/*

EXERC�CIO 4 
Liste o c�digo do produto, descri��o do produto e descri��o das categorias dos produtos que tenham o valor unit�rio na 
faixa de R$ 10,00 a R$ 1500
*/
SELECT P.ID_PROD, 
P.NOME_PRODUTO AS DESCRICAO_PRODUTO,
P.PRECO AS PRECO_UNITARIO,
CAT.NOME_CATEGORIA AS DESCRICAO_CATEGORIA
FROM PRODUTOS AS P INNER JOIN CATEGORIA AS CAT
ON P.ID_CATEGORIA = CAT.ID_CATEGORIA
WHERE P.PRECO BETWEEN 10 AND 1500
ORDER BY P.PRECO ASC;
/*

EXERC�CIO 5 
Liste o c�digo do produto, descri��o do produto e descri��o da categorias dos produtos, e tamb�m apresente uma coluna condicional  com o  nome de "faixa de pre�o" 
Com os seguintes crit�rios
�	pre�o< 500 : valor da coluna ser�  igual  "pre�o abaixo de 500"
�	pre�o  >= 500 e <=1000 valor da coluna ser� igual  "pre�o entre 500 e 1000"
�	pre�o  > 1000 : valor da coluna ser� igual  "pre�o acima de 1000".
*/
SELECT P.ID_PROD, 
P.NOME_PRODUTO AS DESCRICAO_PRODUTO,
CAT.NOME_CATEGORIA AS DESCRICAO_CATEGORIA,
P.PRECO AS PRECO_UNITARIO,
"FAIXA_PRECO" =   
      CASE     
         WHEN P.PRECO < 500 THEN 'Pre�o abaixo de 500'   
         WHEN P.PRECO >= 500 and P.PRECO <= 1000 THEN 'Pre�o entre 500 e 1000'  
         ELSE 'Pre�o acima de 1000'  
      END
FROM PRODUTOS AS P INNER JOIN CATEGORIA AS CAT
ON P.ID_CATEGORIA = CAT.ID_CATEGORIA;
/*

EXERC�CIO  6
Adicione a coluna faixa_salario na tabela vendedor tipo char(1)
*/
--BEGIN TRANSACTION
ALTER TABLE VENDEDORES 
ADD FAIXA_SALARIO CHAR(1)
--COMMIT 
--ROLLBACK
/*

EXERC�CIO 7 
Atualize o valor do campo faixa_salario da tabela vendedor com um update condicional .
Com os seguintes crit�rios
�	salario <1000 ,atualizar faixa = c
�	salario >=1000  and <2000 , atualizar faixa = b
�	salario >=2000  , atualizar faixa = a

**VERIFIQUE SE OS VALORES FORAM ATUALIZADOS CORRETAMENTE
*/
UPDATE VENDEDORES SET FAIXA_SALARIO=CASE WHEN SALARIO < 1000 THEN 'C'   
                                         WHEN SALARIO >= 1000 and SALARIO < 2000 THEN 'B'  
                                         WHEN SALARIO >= 2000 THEN 'A' END
--SELECT * FROM VENDEDORES;
/*

EXERC�CIO 8
Listar em ordem alfab�tica os vendedores e seus respectivos sal�rios, mais uma coluna, simulando aumento de 12% em seus sal�rios.
*/
SELECT NOME_VENDEDOR, SALARIO, SALARIO * 1.12 AS AUMENTO_SALARIO FROM VENDEDORES ORDER BY NOME_VENDEDOR ASC;
/*

EXERC�CIO 9
Listar os nome dos vendedores, sal�rio atual , coluna calculada com salario novo + reajuste de 18% sobre o sal�rio atual, calcular  a coluna acr�scimo e calcula uma coluna salario novo+ acresc.
Crit�rios
Se o vendedor for  da faixa �C�, aplicar  R$ 120 de acr�scimo , outras faixas de salario acr�scimo igual a 0(Zero )
*/
--DECLANDO AS VARI�VEIS
DECLARE @ACRESC DECIMAL(10,2)=120;
DECLARE @PERCENT_AUMENTO DECIMAL(10,2)=0.18;

--SELECIONANDO OS DADOS
SELECT A.NOME_VENDEDOR,
       A.FAIXA_SALARIO,
       A.SALARIO AS SALARIO_ATUAL,
       A.SALARIO*(1+@PERCENT_AUMENTO) AS SALARIO_NOVO,
       CASE WHEN A.FAIXA_SALARIO ='C' THEN @ACRESC ELSE 0 END ACRESCENT,
       CASE WHEN A.FAIXA_SALARIO ='C' THEN @ACRESC+A.SALARIO*(1+@PERCENT_AUMENTO)
            ELSE A.SALARIO*(1+@PERCENT_AUMENTO) END SALARIO_NOVO_ACRESCENT
FROM VENDEDORES A
ORDER BY 4 DESC
/*

EXERC�CIO 10
Listar o nome e sal�rios do vendedor com menor salario.
*/
SELECT TOP 1 NOME_VENDEDOR, SALARIO FROM VENDEDORES ORDER BY SALARIO ASC
/*

EXERC�CIO 11
Quantos vendedores ganham acima de R$ 2.000,00 de sal�rio fixo?
*/
SELECT COUNT(*)QTD FROM VENDEDORES WHERE SALARIO > 2000; 
/*

EXERC�CIO 12
Adicione o campo valor_total tipo decimal(10,2) na tabela venda.
*/
ALTER TABLE VENDAS 
ADD VALOR_TOTAL DECIMAL(10,2)
/*

EXERC�CIO 13
Atualize o campo valor_tota da tabela venda, com a soma dos produtos das respectivas vendas.
*/
UPDATE VENDAS SET VALOR_TOTAL=(SELECT SUM(VAL_TOTAL) FROM VENDA_ITENS WHERE VENDAS.NUM_VENDA=VENDA_ITENS.NUM_VENDA) 
/*

EXERC�CIO 14
Realize a conferencia do exerc�cio anterior, certifique-se que o valor  total de cada venda e igual ao valor total da soma dos  produtos da venda, listar as vendas em que ocorrer diferen�a.
*/
--PARA MOSTRAR TODOS OS VALORES IGUAIS
SELECT V.NUM_VENDA,
V.VALOR_TOTAL,
SUM(VI.VAL_TOTAL) AS TOTAL_ITENS
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
GROUP BY V.NUM_VENDA,V.VALOR_TOTAL HAVING V.VALOR_TOTAL=SUM(VI.VAL_TOTAL);

--PARA MOSTRAR TODOS OS VALORES DIFERENTES
SELECT V.NUM_VENDA,
V.VALOR_TOTAL,
SUM(VI.VAL_TOTAL) AS TOTAL_ITENS
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
GROUP BY V.NUM_VENDA,V.VALOR_TOTAL HAVING V.VALOR_TOTAL<>SUM(VI.VAL_TOTAL);
/*

EXERC�CIO 15
Listar o n�mero de produtos existentes, valor total , m�dia do valor unit�rio referente ao m�s 07/2018 agrupado por venda.
*/
SELECT V.NUM_VENDA,
COUNT(VI.NUM_SEQ) AS QTD_PRODUT,
SUM(VI.QTDE),
AVG(VI.VAL_UNIT) AS MEDIA_VAL_UNIT,
V.VALOR_TOTAL
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
WHERE MONTH(V.DATA_VENDA)=7
AND YEAR(V.DATA_VENDA)=2018
AND STATUS='N'
GROUP BY V.NUM_VENDA, V.VALOR_TOTAL
/*

EXERC�CIO 16
Listar o n�mero de vendas, Valor do ticket m�dio, menor ticket e maior ticket referente ao m�s 07/2017.
*/
SELECT COUNT(*) QTD_VENDAS,
AVG(VALOR_TOTAL) MEDIA_TOTAL,
MIN(VALOR_TOTAL) MINIMO_TOTAL_TICKET,
MAX(VALOR_TOTAL) MAXIMO_TOTAL_TICKET,
SUM(VALOR_TOTAL) TOTAL_GERAL
FROM VENDAS 
WHERE MONTH(DATA_VENDA)=7
AND YEAR(DATA_VENDA)=2017
AND STATUS='N'
/*

EXERC�CIO 17
Atualize o status das notas abaixo de normal(N) para cancelada (C)
--15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714
*/
UPDATE VENDAS SET STATUS='C'
WHERE NUM_VENDA IN(15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714)
/*

EXERC�CIO 18
Quais clientes realizaram mais de 70 compras?
*/
SELECT 
C.NOME_CLIENTE,
COUNT(V.NUM_VENDA) QTD_COMPRAS
FROM CLIENTE C
INNER JOIN VENDAS V
ON C.ID_CLIENTE=V.ID_CLIENTE
WHERE V.STATUS='N'
GROUP BY C.NOME_CLIENTE HAVING COUNT(V.NUM_VENDA)>70
ORDER BY 2 DESC
/*

EXERC�CIO 19
Listar os produtos que est�o inclu�dos em vendas que a quantidade total de produtos seja superior a 100 unidades.
*/
WITH T1 AS
(SELECT V.NUM_VENDA,
SUM(VI.QTDE) AS QTD
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
WHERE V.STATUS='N'
GROUP BY V.NUM_VENDA HAVING SUM(VI.QTDE)>100)

SELECT A.NUM_VENDA, 
VI.ID_PROD,
P.NOME_PRODUTO,
VI.QTDE
FROM T1 A
INNER JOIN VENDA_ITENS VI
ON A.NUM_VENDA=VI.NUM_VENDA
INNER JOIN PRODUTOS P
ON VI.ID_PROD=P.ID_PROD
/*

EXERC�CIO 20
Trazer total de vendas do ano 2017 por categoria e apresentar total geral
*/
SELECT ISNULL(C.NOME_CATEGORIA,'Total geral') as CATEGORIA,
SUM(V.VALOR_TOTAL) AS VALOR_TOTAL
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
INNER JOIN PRODUTOS P
ON VI.ID_PROD=P.ID_PROD
INNER JOIN CATEGORIA C
ON P.ID_CATEGORIA=C.ID_CATEGORIA
WHERE YEAR(V.DATA_VENDA)=2017
GROUP BY ROLLUP(C.NOME_CATEGORIA)
/*

EXERC�CIO 21
Listar total de vendas do ano 2017 por categoria e m�s a m�s apresentar subtotal dos meses e total geral ano.
*/
--SELECT SUBSTRING(CONVERT(VARCHAR(10),GETDATE(),103),4,10)

SELECT 
   ISNULL(SUBSTRING(CONVERT(VARCHAR(10),V.DATA_VENDA,103),4,10),'TOTAL GERAL') MES,
   ISNULL(C.NOME_CATEGORIA,'Total mes') as CATEGORIA,
   SUM(V.VALOR_TOTAL) AS VALOR_TOTAL
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
INNER JOIN PRODUTOS P
ON VI.ID_PROD=P.ID_PROD
INNER JOIN CATEGORIA C
ON P.ID_CATEGORIA=C.ID_CATEGORIA
WHERE YEAR(V.DATA_VENDA)=2017
AND V.STATUS='N'
GROUP BY ROLLUP(SUBSTRING(CONVERT(VARCHAR(10),V.DATA_VENDA,103),4,10)),C.NOME_CATEGORIA
/*

EXERC�CIO 22
Listar total de vendas por vendedores referente ao ano 2017, m�s a m�s apresentar subtotal do m�s e total geral.
*/
SELECT 
   ISNULL(SUBSTRING(CONVERT(VARCHAR(10),V.DATA_VENDA,103),4,10),'TOTAL GERAL') MES,
   ISNULL(VE.NOME_VENDEDOR,'Total mes') AS VENDEDOR,
   SUM(V.VALOR_TOTAL) AS VALOR_TOTAL
FROM VENDAS V
INNER JOIN VENDEDORES VE
ON V.ID_VENDEDOR=VE.ID_VENDEDOR
WHERE YEAR(V.DATA_VENDA)=2017
AND V.STATUS='N'
GROUP BY ROLLUP(SUBSTRING(CONVERT(VARCHAR(10),V.DATA_VENDA,103),4,10)),VE.NOME_VENDEDOR
/*

EXERC�CIO 23
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias
*/
SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY SUM(VI.VAL_TOTAL) DESC) POSICAO,
         P.NOME_PRODUTO,
		 C.NOME_CATEGORIA,
		 SUM(VI.VAL_TOTAL) AS TOTAL
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
INNER JOIN PRODUTOS P
ON VI.ID_PROD=P.ID_PROD
INNER JOIN CATEGORIA C
ON P.ID_CATEGORIA=C.ID_CATEGORIA
GROUP BY P.NOME_PRODUTO,C.NOME_CATEGORIA
/*

EXERC�CIO 24
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias, calcular seu percentual de participa��o com rela��o ao total geral.
*/
--DECLARANDO VARI�VEIS
DECLARE @ANO VARCHAR(4)='2017';
DECLARE @TOTAL_GERAL DECIMAL(10,2);
-- ATRIBUNDO VALOR TOTAL_GERAL
SELECT @TOTAL_GERAL=SUM(X.VALOR_TOTAL) FROM VENDAS X WHERE YEAR(X.DATA_VENDA)=@ANO
SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY SUM(VI.VAL_TOTAL) DESC) POSICAO,
         P.NOME_PRODUTO,
		 C.NOME_CATEGORIA,
		 SUM(VI.VAL_TOTAL) AS TOTAL,
		 100/@TOTAL_GERAL*SUM(VI.VAL_TOTAL) AS PORCENT_PARTICIP
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
INNER JOIN PRODUTOS P
ON VI.ID_PROD=P.ID_PROD
INNER JOIN CATEGORIA C
ON P.ID_CATEGORIA=C.ID_CATEGORIA
WHERE YEAR(V.DATA_VENDA)=@ANO
AND V.STATUS='N'
GROUP BY P.NOME_PRODUTO,C.NOME_CATEGORIA
/*

EXERC�CIO 25
Listar apenas o produto mais vendido de cada M�s com seu  valor total referente ao ano de 2017.
*/
--ETAPA 1
SELECT
MONTH(V.DATA_VENDA) AS MES,
VI.ID_PROD,
SUM(VI.VAL_TOTAL) AS VALOR
INTO #ETAPA1
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
WHERE YEAR(V.DATA_VENDA)=2017
GROUP BY MONTH(V.DATA_VENDA), VI.ID_PROD
ORDER BY MONTH(V.DATA_VENDA) ASC, 3 DESC

--ETAPA 2
--SELECT COM A #ETAPA1 PARA ALIMENTAR ETAPA 2
SELECT ROW_NUMBER() OVER (PARTITION BY MES ORDER BY MES ASC, VALOR DESC) POSICAO,
MES,
ID_PROD,
VALOR
INTO #ETAPA2
FROM #ETAPA1

--RESULTADO
SELECT
A.POSICAO,
A.MES,
P.NOME_PRODUTO,
A.VALOR
FROM #ETAPA2 A
INNER JOIN PRODUTOS P
ON A.ID_PROD=P.ID_PROD
WHERE A.POSICAO=1
ORDER BY A.MES

--DROP TEMP
DROP TABLE #ETAPA1;
DROP TABLE #ETAPA2;
/*

EXERC�CIO 26
Lista o cliente e a data da �ltima compra de cada cliente.
*/
SELECT 
C.ID_CLIENTE,
C.NOME_CLIENTE,
CAST(V.DATA_VENDA AS DATE) AS DT_ULTIMA_COMPRA,
V.NUM_VENDA
FROM (SELECT ID_CLIENTE, MAX(DATA_VENDA) AS DATA_VENDA FROM VENDAS WHERE STATUS='N' GROUP BY ID_CLIENTE) AS X
INNER JOIN CLIENTE C
ON C.ID_CLIENTE=X.ID_CLIENTE
INNER JOIN VENDAS V
ON C.ID_CLIENTE=V.ID_CLIENTE
AND C.ID_CLIENTE=X.ID_CLIENTE
AND V.DATA_VENDA=X.DATA_VENDA
/*

EXERC�CIO 27
Lista o a data da �ltima venda de cada produto.
*/
SELECT P.ID_PROD,
P.NOME_PRODUTO,
CAST(TAB1.DATA_VENDA AS DATE) AS DATA_VENDA
FROM PRODUTOS P
INNER JOIN (SELECT VI.ID_PROD, MAX(V.DATA_VENDA) AS DATA_VENDA
FROM VENDAS V
INNER JOIN VENDA_ITENS VI
ON V.NUM_VENDA=VI.NUM_VENDA
GROUP BY VI.ID_PROD) TAB1
ON P.ID_PROD=TAB1.ID_PROD