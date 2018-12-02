
create or replace function TC()
returns void as
$$
	declare	
		count integer;
	
	begin
		drop table if exists TC;
		create table TC (source integer, target integer, counter integer);
		insert into TC select *,1 from edge;
		
		drop table if exists vertices;
		create table vertices (vertice integer);
		insert into vertices (select distinct source from edge union select distinct target from edge);
		count := (select count(*)*2 from vertices);
		  
		while count != 0
		loop
			insert into TC SELECT TC.source, Edge.target, TC.counter + 1
				    FROM TC INNER JOIN Edge ON (TC.target = Edge.source);
			count:= count - 1;
		end loop;
		
		insert into TC select v1.*, v2.*, 0 
					   from vertices v1, vertices v2  
					   where v1.vertice = v2.vertice;
		
	end;
$$ language plpgsql;

select TC();
select * from TC;

------- For even length path
create or replace function connectedByEvenLengthPath()
returns table (s integer, t integer) as
$$
	begin
		return query (select distinct source, target 
					  from TC
					  where counter%2 = 0);
	end;
$$ language plpgsql;

select * from connectedByEvenLengthPath();

------- For odd length path

create or replace function connectedByOddLengthPath()
returns table (s integer, t integer) as
$$
	begin
		return query (select distinct source, target 
					  from TC
					  where counter%2 != 0);
	end;
$$ language plpgsql;

select * from connectedByOddLengthPath();