
create or replace function Dijkstra(s integer) returns table(target integer,distancetotarget integer) as
$$
	declare
		i integer;
	begin
		drop table if exists dk;
		create table dk(source integer,target integer,length integer);
		insert into dk(select g.source,g.target,g.length from graph g where g.source=s);
	
 		i:=(select count(*) from graph);
 		while(i!=0)
 		loop
 			i=i-1;
			insert into dk select * from new_TC_pairs();
			update dk set length=0 where dk.source=dk.target;
 		end loop;
	
		return query(select dk.target,min(dk.length) from dk group by dk.source,dk.target order by dk.target);
	end;
$$ language plpgsql;

create or replace function new_TC_pairs() returns table (source integer,target integer,length integer) as
$$ 
	begin
		return query (select dk.source,graph.target,(graph.length+dk.length) as length 
				 	 from dk, graph 
					  where dk.target=graph.source
					  except
					  select dk.source,graph.target,dk.length
					  from dk,graph where dk.source=graph.target);
	end;
$$ language plpgsql;
