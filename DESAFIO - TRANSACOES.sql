-- Desafio Criando Transações

use transaction_example;
SELECT @@autocommit;
select @@autocommit = 1;
SET @@autocommit = 0;

START TRANSACTION;

	select 
	@nextorder := max(orderNumbers) + 1 Next_number
from 
	orders;

insert into 
	orders
    values (@nextorder, 
			'2005-05-31',
            '2005-06-10',
            '2005-06-11',
            'Despachado',
            2);

select orderNumbers from orders;            
savepoint insercao_order;

-- nova inserção em ordersDetails

insert into ordersDetails values(@nextorder, 181749, 30, '136.30'),
								(@nextorder, 182248, 50, '55.09');
				
rollback to savepoint insercao_order;

rollback; -- total

commit;





-- Desafio Transações com Procedures no MYSQL
use transaction_example;

delimiter //
create procedure sql_fail()
begin
	declare exit handler for sqlexception
		begin
        -- depreciada a partir do 5.5
			get diagnostics condition 1
				@p2 = message_text;
			select @p2 as Transaction_error;
			show errors limit 1;
			rollback;
			-- select 'A transação foi encerrada devido algum erro ocorrido!' as Warning;
	end;
        
        start transaction;
        
       -- select @nextorder := max(orderNumbers) + 1 Next_number
		-- from orders;
        
        insert into orders values(14, '2005-05-31', '2005-06-10', '2005-06-11', 'EM PROGRESSO', 3); 
        insert into ordersDetails values(14, '18_1849', 30, '189.50'),
										(14, '18_2569', 50, '105.09');
        commit;
	end //
delimiter ;

drop procedure sql_fail;
call sql_fail;

select * from orders where orderNumbers = 14;