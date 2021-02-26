--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: files; Type: TABLE; Schema: public
--

CREATE TABLE public.files (
                              id bigint NOT NULL,
                              parent_id bigint NOT NULL,
                              fname text NOT NULL,
                              fpath text NOT NULL,
                              size bigint NOT NULL
);

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public
--

CREATE SEQUENCE public.files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- Name: groups; Type: TABLE; Schema: public
--

CREATE TABLE public.groups (
                               id bigint NOT NULL,
                               site_id smallint NOT NULL,
                               site_group_id bigint NOT NULL,
                               metadata jsonb
);

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: torrents; Type: TABLE; Schema: public
--

CREATE TABLE public.torrents (
                                 id bigint NOT NULL,
                                 group_id bigint NOT NULL,
                                 hash text NOT NULL,
                                 site_id smallint NOT NULL,
                                 site_torrent_id bigint NOT NULL,
                                 site_group_id bigint NOT NULL,
                                 metadata jsonb
);

--
-- Name: torrents_id_seq; Type: SEQUENCE; Schema: public
--

CREATE SEQUENCE public.torrents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: torrents_id_seq; Type: SEQUENCE OWNED BY; Schema: public
--

ALTER SEQUENCE public.torrents_id_seq OWNED BY public.torrents.id;


--
-- Name: files id; Type: DEFAULT; Schema: public
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: torrents id; Type: DEFAULT; Schema: public
--

ALTER TABLE ONLY public.torrents ALTER COLUMN id SET DEFAULT nextval('public.torrents_id_seq'::regclass);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: torrents torrents_pkey; Type: CONSTRAINT; Schema: public
--

ALTER TABLE ONLY public.torrents
    ADD CONSTRAINT torrents_pkey PRIMARY KEY (id);


--
-- Name: files_fname_idx; Type: INDEX; Schema: public
--

CREATE INDEX files_fname_idx ON public.files USING btree (fname);


--
-- Name: files_fpath_idx; Type: INDEX; Schema: public
--

CREATE INDEX files_fpath_idx ON public.files USING btree (fpath);


--
-- Name: torrents_hash_idx; Type: INDEX; Schema: public
--

CREATE INDEX torrents_hash_idx ON public.torrents USING btree (hash);


--
-- Name: torrents_s_group_id_idx; Type: INDEX; Schema: public
--

CREATE INDEX torrents_s_group_id_idx ON public.torrents USING btree (site_group_id);


--
-- Name: files files_parent_fkey; Type: FK CONSTRAINT; Schema: public
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_parent_fkey FOREIGN KEY (parent_id) REFERENCES public.torrents(id);


--
-- Name: torrents torrents_group_fkey; Type: FK CONSTRAINT; Schema: public
--

ALTER TABLE ONLY public.torrents
    ADD CONSTRAINT torrents_group_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- PostgreSQL database dump complete
--

