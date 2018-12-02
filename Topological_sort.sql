create or replace function topological_sort() returns table(node integer) as
$$
	begin
		
		drop table if exists temp;
		create table temp(target integer,counter integer);
		insert into temp (select g.target,count(g.target) from graph g group by g.target);
		insert into temp (select distinct g.source,0 from graph g where g.source not in (select t.target from temp t));
		
		drop table if exists ts;
		create table ts(vertices integer);
																							  
		while(select count(*) from temp) > 0
 		loop
 			insert into ts (select t.target from temp t where counter = 0);														 
			update temp set counter=counter-1 where target in(select g.target 
															  from graph g, temp t 
															  where g.source=t.target and t.counter=0);
 			delete from temp where target in (select distinct t.vertices from ts t);																		  
 		end loop; 
		
		return query (select * from tt);
	end;
$$ language plpgsql;
