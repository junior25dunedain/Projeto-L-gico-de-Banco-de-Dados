-- criando esquema do e-commerce
drop database ecommerce;
create database ecommerce;
use ecommerce;

-- criando tabelas 

create table cliente(
	id_cliente int not null auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    cpf char(11) not null,
    endereço varchar(50),
    data_nascimento date not null,
    constraint unico_cpf_cliente unique(cpf)
);
desc cliente;


create table produto(
	id_produto int auto_increment primary key,
    Pname varchar(25) not null,
    classificacao_kids bool default false,
    categoria enum('Eletrônico','Vestimento','Briquedos','Alimentos','Leitura','Moveis') not null,
    avaliação float default 0,
    valor float
    
);

create table pagamento(
	id_pcliente int,
    id_pagamento int,
    forma_pay enum('Boleto','Pix','Cartão'),
    limite_avaliado float,
    primary key(id_pcliente,id_pagamento),
    constraint fk_pagamento_cliente foreign key(id_pagamento) references cliente(id_cliente)
); 


create table pedido(
	id_pedido int auto_increment primary key,
    idorder_cliente int not null,
    status_pedido enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    descrição_pedido varchar(255),
    frete float default 10,
	pagamento bool default false,
    constraint fk_pedido_cliente foreign key(idorder_cliente) references cliente(id_cliente)
			on update cascade
);

create table estoque(
	id_estoque int not null auto_increment primary key,
    local_estoque varchar(45) not null,
    quantidade int default 0
);

create table Fornecedor(
	id_fornecedor int auto_increment primary key,
    razao_social varchar(200) not null, 
    cnpj char(15) not null,
    contato char(11) not null,
    constraint unico_cnpj_fornecedor unique(cnpj)    
);

create table vendedor(
	id_vendedor int auto_increment primary key,
    razao_social varchar(200) not null,
    abstname varchar(200),
    cnpj char(15),
    cpf char(11),
    local_vendedor varchar(200),
    contato char(11) not null,
    constraint unico_cnpj_vendedor unique(cnpj),    
	constraint unico_cpf_vendedor unique(cpf) 

);

create table produto_vendendor(
	idPseller int,
    idP_produto int, 
    pquantidade int default 1,
    primary key(idPseller,idP_produto),
    constraint fk_produto_seller foreign key(idPseller) references vendedor(id_vendedor),
    constraint fk_produto_produto foreign key(idP_produto) references produto(id_produto)
);
desc produto_vendendor;

create table produto_pedido(
	idPOproduto int,
    idPOpedido int,
    poquantidade int default 1,
    postatus enum('Disponível','sem estoque') default 'Disponível',
    primary key (idPOproduto,idPOpedido),
    constraint fk_produtopedido_produto foreign key(idPOproduto) references produto(id_produto),
	constraint fk_produtopedido_pedido foreign key(idPOpedido) references pedido(id_pedido)

);

create table local_estoque(
	idLproduto int,
    idLestoque int,
    poquantidade int default 1,
    localidade varchar(200) not null,
    primary key (idLproduto,idLestoque),
    constraint fk_localestoque_produto foreign key(idLproduto) references produto(id_produto),
	constraint fk_localestoque foreign key(idLestoque) references estoque(id_estoque)

);

create table produto_fornecedor(
	id_Pfornecedor int,
    id_pproduto int,
    quantidade int not null,
    primary key(id_Pfornecedor,id_pproduto),
    constraint fk_produtoforne_fornecedor foreign key(id_Pfornecedor) references Fornecedor(id_fornecedor),
    constraint fk_produtoforne_produto foreign key(id_pproduto) references produto(id_produto)
);

show tables;

use information_schema;
select * from referential_constraints where constraint_schema = 'ecommerce';

-- inserindo dados a base de dados

insert into cliente (Fname, Minit, Lname, cpf, endereço, data_nascimento)
		values('Maria','M','Silva','14725836952','rua silva da prata 36, centro - Campo grande','1980-06-25'),
			  ('Matheus','L','Brito','14725614952','rua black pen 16, distrito - Campo azul','1987-10-06'),
			  ('Ricardo','F','Bertolli','25425836952','rua capitao rodrigues 326, matas - Campo pequeno','1978-02-15'),
			  ('Julia','R','Silva','14725837842','rua luiz da prata 146, malvinas - Campina grande','1998-07-17'),
			  ('Roberta','N','Costa','16635836952','rua silva costa 76, centro - rio grande','1988-09-27'),
              ('Pedro','H','Perrone','34595836952','rua mata grande 168, Prata - São paulo','2002-03-25');
              
 insert into produto (Pname, classificacao_kids, categoria, avaliação, valor)
        values('Fone de ouvido',false,'Eletrônico','4','120.00'),
              ('Carro de controle remoto',true,'Briquedos','3','170.00'),
              ('Camisa polo',false,'Vestimento','5','200.00'),
              ('Sofá de couro',false,'Moveis','5','1800.00'),
              ('Xbox series S',false,'Eletrônico','4','2000.00'),
              ('Picanha',false,'Alimentos','3','100.00'),
              ('A queda de Gondolin',false,'Leitura','5','58.00');
              
select * from cliente;

insert into pedido (idorder_cliente, status_pedido, descrição_pedido, frete, pagamento)
		values(1,null,'compra na loja fisica',null,true),
			  (2,'Confirmado','compra via app',35.60,true),
              (3,'Em processamento','compra na loja fisica',null,false),
              (4,'Confirmado','compra via web site',50,true);
 
 select * from pedido;
              
insert into produto_pedido(idPOproduto, idPOpedido, poquantidade, postatus) values
		  (1,1,2,'Disponível'),
          (2,1,3,'Disponível'),
          (3,2,1,'sem estoque'),
          (4,3,1,null);
select * from produto_pedido;

insert into estoque(local_estoque, quantidade) values
		 ('Rio de janeiro',1500),
         ('Salvador',1300),
         ('Brasilia',1000),
         ('São Paulo',2500),
         ('Natal',1200),
         ('Belem',800);
         
insert into local_estoque(idLproduto, idLestoque, poquantidade, localidade) values
		(1,2,default,'RJ'),
        (2,6,default,'PA'),
        (1,4,2,'SP');

insert into Fornecedor(razao_social, cnpj, contato) values
		('Almeida e filhos',624852684740053,'21968584254'),
        ('Eletrônicos gush',854230684741253,'21964587254'),
        ('Atacadista geral',225552684740000,'81965384254'),
        ('Energia sempre',624858884741200,'83968123654');
select * from Fornecedor;

insert into produto_fornecedor(id_Pfornecedor, id_pproduto, quantidade) values
		(1,1,450),
        (1,2,400),
        (2,4,750),
        (3,3,50),
        (2,5,100);
      
insert into vendedor(razao_social, abstname, cnpj, cpf, local_vendedor, contato) values
	('Tech eletronics','Tech Ele',123852684740053,null,'Rio de Janeiro','21987542101'),
	('Manuel Silva','Mundo dos moveis',null,25635487458,'Salvador','23984746101'),
    ('Kids sun','The sun kids',456852684740053,null,'São paulo','17986542101');

select * from vendedor;

insert into produto_vendendor(idPseller, idP_produto, pquantidade) values
		(1,6,75),
        (2,7,15),
        (3,5,25);
   
   
   
select c.id_cliente as id_Pedidos, concat(c.Fname,' ',c.Lname) as nome_completo, p.status_pedido from cliente c, pedido p where c.id_cliente = p.idorder_cliente order by c.Fname;        

-- recuperando a quantidade de pedidos realizados pelos clientes
select c.id_cliente, c.Fname,count(*) as Numero_pedidos, p.status_pedido from cliente c inner join pedido p on c.id_cliente = p.idorder_cliente
        group by id_cliente having p.status_pedido = 'Confirmado'; 

select max(frete) from pedido;  

select round(sum(valor),2) from produto where categoria = 'Eletrônico';   

select c.id_cliente, c.Fname, pp.postatus as situação from cliente c inner join pedido p on c.id_cliente = p.idorder_cliente
							inner join (select pp.postatus from produto_pedido as pp) on c.id_cliente = pp.idPOpedido; 




