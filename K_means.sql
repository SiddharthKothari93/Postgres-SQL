create or replace function k_means(k integer) returns table( x float,y float) AS
$$
	declare
		i integer;
	begin
		drop table if exists kmean;
		create table kmean(p integer,x float,y float);
		insert into kmean(select * from dataset order by random() limit k);
		i:=50;
		while (i!=0)
		loop	
			i:=i-1;
			
			drop table if exists centroids;
			create table centroids(p integer,x float,y float,label integer);
			insert into centroids (select distinct d.p, d.x, d.y, km.p
								   from kmean km, dataset d
								   where sqrt((d.x-km.x)^2+(d.y-km.y)^2)= (select min(sqrt((d.x-kmk.x)^2+(d.y-kmk.y)^2))
															  from kmean kmk));

			update kmean km set x=q.x,y=q.y from (select avg(c.x) as x,avg(c.y) as y,c.label
											  from centroids c group by c.label)q
 												where km.p=q.label;
			

		end loop;
		return query (select km.x,km.y from kmean km);
 	end;
$$ language plpgsql;