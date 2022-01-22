CREATE or replace PROCEDURE Test_Reconocer_Ubigeo_Lugar(v_id_Oferta int)
LANGUAGE plpgsql AS
$$
DECLARE
   --_some_id varchar(20);_var_total int; _var_contador int;
   _var_contadorOferta int; _var_totalOferta int; _var_idoferta int ; _var_lugar varchar(100); _var_idubigeo BIGint; _var_departamento varchar(100);_var_provinciaUbigeo varchar(100); _var_provinciaBusqueda int;  _var_distrito  varchar(100);  _var_contadorGlobal int; _var_totalGlobal int ; _var_totalprovincias int; _var_totaldistritoes int ; 
   _var_contadorprovincias int ;_var_contadordepartamentoes int  ; _var_contadordistrito int ; _var_totaldistrito int ; _var_contadorprovincias2 int ; _var_contadordistrito2 int ; _var_provinciaBusqueda1 int; _var_provinciaBusqueda2 int; _var_provinciaBusqueda3 int;
   
BEGIN

	create TEMPORARY table tmp_oferta(
		id int  primary key generated always as identity,
		idoferta int,
		lugar varchar(100)
	);

create TEMPORARY table  tmp_UBIGEO(
	id int primary key generated always as identity,
	idUbigeo bigint,
	departamento varchar(100),
	provincia varchar(100),
	distrito varchar(100)
);

 
create TEMPORARY table  tmp_UBIGEOdepartamentoes(
	id int primary key generated always as identity,
	departamento varchar(100) 
);

insert into tmp_oferta (idoferta,lugar)
select id_oferta, lugar  from oferta where lugar is not null and id_Oferta = v_id_Oferta;


select count(*) into _var_totalOferta from tmp_oferta;

_var_contadorOferta := 1;

INSERT into tmp_UBIGEOdepartamentoes (departamento)
--SELECT departamento,provincia,distrito FROM UBIGEO
SELECT distinct departamento FROM UBIGEO;

select   count(*) into _var_totalGlobal from tmp_UBIGEOdepartamentoes;
 
insert into log (mensaje) values('ENTRE 1');

while _var_contadorOferta <= _var_totalOferta loop
	
	insert into log (mensaje) values('ENTRE 2');
	
	select  idoferta into _var_idoferta    from tmp_oferta where id = _var_contadorOferta;
	select lugar into _var_lugar from tmp_oferta where id = _var_contadorOferta;
	
	_var_contadorGlobal := 1;

	WHILE _var_contadorGlobal <= _var_totalGlobal loop
		insert into log (mensaje) values('ENTRE 3');
		select departamento into _var_departamento from tmp_UBIGEOdepartamentoes where id = _var_contadorGlobal;
		
		insert into log (mensaje) values(_var_departamento);
		insert into log (mensaje) values(_var_lugar);
		
		select  POSITION(upper(_var_departamento) in upper(_var_lugar)) into _var_provinciaBusqueda;
		
		insert into log (mensaje) values(_var_provinciaBusqueda);
		
		_var_provinciaBusqueda1 := 0;
		_var_provinciaBusqueda2 := 0;
        _var_provinciaBusqueda3 := 0;

		if _var_provinciaBusqueda > 0 then
			_var_provinciaBusqueda1 := 1;

			create TEMPORARY table tmp_UBIGEOprovincia(
				id int primary key generated always as identity,
				provincia varchar(100) 
			);

			INSERT into tmp_UBIGEOprovincia (provincia)
			select distinct provincia from UBIGEO where departamento = _var_departamento;

			select count(distinct provincia) into _var_totalprovincias from UBIGEO where departamento = _var_departamento;
			_var_contadorprovincias := 1;

			while _var_contadorprovincias <= _var_totalprovincias loop

				_var_provinciaBusqueda := 0;
				select provincia into _var_provinciaUbigeo from tmp_UBIGEOprovincia where id = _var_contadorprovincias;
				 
				select POSITION(upper(_var_provinciaUbigeo) in upper(_var_lugar)) into _var_provinciaBusqueda;

				if _var_provinciaBusqueda > 0 and _var_provinciaBusqueda2 = 0 then
					_var_provinciaBusqueda2 := 1;
					_var_provinciaBusqueda := 0;

					create TEMPORARY table tmp_UBIGEOdistrito(
						id int primary key generated always as identity,
						distrito varchar(100) 
					);

					select count(distinct distrito) into _var_totaldistritoes from UBIGEO where departamento = _var_departamento and provincia = _var_provinciaUbigeo;

					INSERT into tmp_UBIGEOdistrito (distrito)
					select distinct distrito from UBIGEO where departamento = _var_departamento and provincia = _var_provinciaUbigeo;

					_var_contadordistrito := 1;
					_var_provinciaBusqueda3 := 0;

					while _var_contadordistrito <= _var_totaldistritoes loop
						select  distrito into _var_distrito from tmp_UBIGEOdistrito where id = _var_contadordistrito;

						select  POSITION(upper(_var_distrito) in upper(_var_lugar)) into _var_provinciaBusqueda;

						if _var_provinciaBusqueda > 0 and _var_provinciaBusqueda3 = 0 then

							select idUbigeo into _var_IdUbigeo from UBIGEO where departamento = _var_departamento and provincia =  _var_provinciaUbigeo and distrito = _var_distrito;

							update oferta set idUbigeo = _var_idubigeo where id_oferta = _var_idoferta;

							_var_provinciaBusqueda3 := 1;
							_var_contadordistrito := _var_totaldistritoes;
						end if; 
						_var_contadordistrito := _var_contadordistrito + 1;
					end loop;

					if _var_provinciaBusqueda3 = 0 and _var_provinciaBusqueda2 = 1 and _var_provinciaBusqueda1 = 1 then

						select idUbigeo into _var_IdUbigeo from UBIGEO where departamento = _var_departamento and provincia =  _var_provinciaUbigeo;

						update oferta set idUbigeo = _var_idubigeo where id_oferta = _var_idoferta;
						 
					end if;

					drop table tmp_UBIGEOdistrito;
				end if;
				
				_var_contadorprovincias :=  _var_contadorprovincias + 1;
			end loop;

			if _var_provinciaBusqueda1 = 1 and _var_provinciaBusqueda2  = 0 then

				create TEMPORARY table tmp_UBIGEOprovincia2(
					id int primary key generated always as identity,
					provincia varchar(100) 
				);

				INSERT into tmp_UBIGEOprovincia (provincia)
				select distinct provincia from UBIGEO where departamento = _var_departamento;

				select count(distinct provincia) into _var_totalprovincias from UBIGEO where departamento = _var_departamento;

				_var_contadorprovincias2 := 1;
				while _var_contadorprovincias2 <= _var_totalprovincias loop
				insert into log (mensaje) values('ENTRE 4');
					_var_provinciaBusqueda := 0;
					select provincia into _var_provinciaUbigeo from tmp_UBIGEOprovincia2 where id = _var_contadorprovincias2;
					 
					create TEMPORARY table tmp_UBIGEOdistrito3(
						id int primary key generated always as identity,
						distrito varchar(100) 
					);

					select count(distinct distrito) into _var_totaldistritoes from UBIGEO where departamento = _var_departamento and provincia = _var_provinciaUbigeo;

					INSERT into tmp_UBIGEOdistrito (distrito)
					select distinct  distrito from UBIGEO where departamento = _var_departamento and provincia = _var_provinciaUbigeo;

					_var_contadordistrito2 := 1;
					_var_provinciaBusqueda3 := 0;

					while _var_contadordistrito2 <= _var_totaldistritoes loop
						insert into log (mensaje) values('ENTRE 5');
						select  distrito into _var_distrito from tmp_UBIGEOdistrito3 where id = _var_contadordistrito2;

						select  POSITION(upper(_var_distrito) in upper(_var_lugar)) into _var_provinciaBusqueda;

						
						if _var_provinciaBusqueda > 0 then

							select idUbigeo into _var_IdUbigeo from UBIGEO where departamento = _var_departamento and provincia =  _var_provinciaUbigeo and distrito = _var_distrito;

							update oferta set idUbigeo = _var_idubigeo where id_oferta = _var_idoferta;
							_var_provinciaBusqueda3 := 1;

						end if;
						_var_contadordistrito2 := _var_contadordistrito2 + 1;
					end loop;
					drop table tmp_UBIGEOdistrito3;
					_var_contadorprovincias2 := _var_contadorprovincias2 + 1;
				end loop;

				drop table tmp_UBIGEOprovincia2;
			end if;
			DROP TABLE tmp_UBIGEOprovincia; 
		end if;
		  
		_var_contadorGlobal := _var_contadorGlobal + 1;
	end loop;

	if _var_provinciaBusqueda1 = 1 and _var_provinciaBusqueda2 = 0 and _var_provinciaBusqueda3 = 0 then
		insert into log (mensaje) values('ENTRE 6');
		select idUbigeo into _var_IdUbigeo from UBIGEO where departamento = _var_departamento;
		update oferta set idUbigeo = _var_idubigeo where id_oferta = _var_idoferta;
	end if;

	_var_contadorOferta := _var_contadorOferta + 1;
end loop;

drop table tmp_oferta;
drop table tmp_UBIGEO;
drop table tmp_UBIGEOdepartamentoes;
--   CREATE TEMPORARY TABLE pruebadeComo  
 --  (
   --	id_pr int,
	--valor_pr varchar(20)
  -- );
	
   --SELECT valor INTO _some_id from prueba where id = 1;
   --INSERT INTO prueba (id,valor) VALUES (2,_some_id);
   --INSERT INTO pruebadeComo
   --SELECT id,valor from prueba;
   
   --select count(*) into _var_total from pruebadeComo;
   
  -- _var_contador := 1;
   
   --while _var_contador <= _var_total loop
   --  insert into prueba (id,valor) values (_var_contador,'prueba');
   --  _var_contador := _var_contador + 1;
   --end loop;
   
   --drop table pruebadeComo;
END
$$;