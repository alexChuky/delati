-- Table: public.oferta

-- DROP TABLE IF EXISTS public.oferta;

CREATE TABLE IF NOT EXISTS public.oferta
(
    id_oferta integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    id_webscraping integer,
    titulo character varying(200) COLLATE pg_catalog."default",
    empresa character varying(200) COLLATE pg_catalog."default",
    idubigeo integer,
    lugar character varying(100) COLLATE pg_catalog."default",
    tiempo_publicado character varying(100) COLLATE pg_catalog."default",
    salario character varying(100) COLLATE pg_catalog."default",
    modalidad_trabajo character varying(100) COLLATE pg_catalog."default",
    subarea character varying(100) COLLATE pg_catalog."default",
    url_oferta character varying(500) COLLATE pg_catalog."default",
    url_pagina character varying(500) COLLATE pg_catalog."default",
    area character varying(100) COLLATE pg_catalog."default",
    fecha_creacion date,
    fecha_modificacion date,
    oferta_detalle character varying(8000) COLLATE pg_catalog."default",
    fecha_publicacion date,
    time_publicacion character varying(60) COLLATE pg_catalog."default",
    id_anuncioempleo character varying(100) COLLATE pg_catalog."default",
    id_estado character varying(1) COLLATE pg_catalog."default",
    ntitulo character varying(200) COLLATE pg_catalog."default",
    nnivel character varying(30) COLLATE pg_catalog."default",
    modalidad_contrato character varying(20) COLLATE pg_catalog."default",
    htitulo character varying(80) COLLATE pg_catalog."default",
    adhonorem character varying(1) COLLATE pg_catalog."default",
    nivel character varying(30) COLLATE pg_catalog."default",
    htitulo_cat character varying(80) COLLATE pg_catalog."default",
    obs character varying(120) COLLATE pg_catalog."default",
    _empresa character varying(200) COLLATE pg_catalog."default",
    _lugar character varying(200) COLLATE pg_catalog."default",
    _salario character varying(200) COLLATE pg_catalog."default",
    id_empresa integer,
    id_empresa_sup integer,
    moneda character varying(5) COLLATE pg_catalog."default",
    salario_formapago character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT oferta_pkey PRIMARY KEY (id_oferta)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.oferta
    OWNER to postgres;