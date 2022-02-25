/*--------------------------------------roles table---------------------------------------------*/
create table roles(
    role_id SERIAL PRIMARY KEY,
	rolename varchar(100),
	date_created timestamp
);
insert into roles (role_id, rolename, date_created) values (1,'Admin',now());

select * from roles;

/*--------------------------------------users table---------------------------------------------*/
create table users(
    user_id SERIAL PRIMARY KEY,
	username varchar(100),
	first_name varchar(30),
	last_name varchar(30),
	role_id int,
	CONSTRAINT fk_role FOREIGN KEY(role_id) REFERENCES roles(role_id),
	phone varchar(20),
	date_created timestamp,
	date_updated timestamp,
	date_deleted timestamp
);
insert into users(user_id,username,first_name,last_name,phone,date_created)
           values(1,'Prafful','Prafful','Chauhan','9917917222',now());
		   
select * from users;

/*-----------------------------------Category table-------------------------------------------*/
create table category(
    category_id SERIAL PRIMARY KEY,
	category_name varchar(100),
	product_name varchar(100),
	date_created timestamp,
    date_updated timestamp,
	date_deleted timestamp	
);
insert into category(category_id,category_name,product_name,date_created)
           values(1,'Electronics','Headphone',now());
		   
select * from category

/*-------------------------------------product table------------------------------------------------------*/
create table products(
    product_id SERIAL PRIMARY KEY,
	product_name varchar(100),
	category_id int,
	CONSTRAINT fk_category FOREIGN KEY(category_id) REFERENCES category(category_id),
	category_name varchar(100),
	price decimal,
	date_created timestamp,
    date_updated timestamp,
	date_deleted timestamp	
);

insert into products(product_id,product_name,category_name,price,date_created)
           values(1,'Headphone','Electronics',1000.00,now());

select * from products

/*---------------------------------------order table-------------------------------------------------------*/
create table orders(
    order_id SERIAL PRIMARY KEY,
	user_id int,
	CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(user_id),
	product_name varchar(100),
	total decimal,
	date_created timestamp,
    date_updated timestamp,
	date_deleted timestamp	
);


/*-----------------------------------------Invoices table----------------------------------------------------------*/
create table invoice(
    invoice_id SERIAL PRIMARY KEY,
	user_id int,
	CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(user_id),
	product_id int,
	CONSTRAINT fk_product FOREIGN KEY(product_id) REFERENCES products(product_id),
	category_id int,
	product_name varchar(100),
	total decimal,
	CONSTRAINT fk_category FOREIGN KEY(category_id) REFERENCES category(category_id),
	date_created timestamp,
    date_updated timestamp,
	date_deleted timestamp	
);

/*----------------------------------CREATING-Trigger-FUNCTION--------------------------------------*/

             CREATE OR REPLACE FUNCTION fn_generate_invoice_log()
                      RETURNS TRIGGER
                      LANGUAGE PLPGSQL
                      as
                      $$
                        BEGIN
						
                          
                                insert into invoice(invoice_id,product_name,total,date_created) values ((select order_id from orders where order_id=1),
																										(select product_name from orders where order_id=1), 
																										(select total from orders where order_id=1),
																										(select date_created from orders where order_id=1));
                              RETURN NEW;
                              END;
							  
                      $$
/*-----------------------------CREATING TRIGGER-------------------------------*/					  
	                    CREATE TRIGGER trigger_generate_invoice
                          --  BEFORE|AFTER|INSTEAD  INSERT|UPDATE|DELETE|TRUNCATE
                          AFTER INSERT
                            ON orders
                            FOR EACH ROW 
                                EXECUTE PROCEDURE fn_generate_invoice_log();


insert into orders(order_id,product_name,total,date_created)
           values(1,(select product_name from products where product_id=1),1000.00,now());
select * from orders	
select * from invoice																									
select order_id from orders where order_id=1
delete from invoice where invoice_id=1




