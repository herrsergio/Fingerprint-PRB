--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.pp_emp_check DROP CONSTRAINT pp_emp_check_pkey;
DROP TABLE public.pp_emp_check;
SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: pp_emp_check; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pp_emp_check (
    store_id smallint DEFAULT 0 NOT NULL,
    date_id date NOT NULL,
    emp_num character varying(6) NOT NULL,
    timein1 timestamp without time zone,
    timeout1 timestamp without time zone,
    timein2 timestamp without time zone,
    timeout2 timestamp without time zone,
    entry_type character varying(5)
);


ALTER TABLE public.pp_emp_check OWNER TO postgres;

--
-- Name: COLUMN pp_emp_check.entry_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN pp_emp_check.entry_type IS 'Ingreso manual o con lector de huellas';


--
-- Name: pp_emp_check_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pp_emp_check
    ADD CONSTRAINT pp_emp_check_pkey PRIMARY KEY (store_id, date_id, emp_num);


--
-- PostgreSQL database dump complete
--

