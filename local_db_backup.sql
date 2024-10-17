--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-10-17 10:08:32

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 24592)
-- Name: clocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clocks (
    id bigint NOT NULL,
    "time" timestamp(0) without time zone,
    status boolean DEFAULT false NOT NULL,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--ALTER TABLE public.clocks OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24591)
-- Name: clocks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER SEQUENCE public.clocks_id_seq OWNER TO postgres;

--
-- TOC entry 4873 (class 0 OID 0)
-- Dependencies: 218
-- Name: clocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clocks_id_seq OWNED BY public.clocks.id;


--
-- TOC entry 215 (class 1259 OID 24577)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24583)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24582)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4874 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 221 (class 1259 OID 24606)
-- Name: workingtime; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workingtime (
    id bigint NOT NULL,
    start timestamp(0) without time zone,
    "end" timestamp(0) without time zone,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--ALTER TABLE public.workingtime OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24605)
-- Name: workingtimes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workingtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER SEQUENCE public.workingtimes_id_seq OWNER TO postgres;

--
-- TOC entry 4875 (class 0 OID 0)
-- Dependencies: 220
-- Name: workingtimes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workingtimes_id_seq OWNED BY public.workingtime.id;


--
-- TOC entry 4703 (class 2604 OID 24595)
-- Name: clocks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clocks ALTER COLUMN id SET DEFAULT nextval('public.clocks_id_seq'::regclass);


--
-- TOC entry 4702 (class 2604 OID 24586)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 24609)
-- Name: workingtime id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workingtime ALTER COLUMN id SET DEFAULT nextval('public.workingtimes_id_seq'::regclass);


--
-- TOC entry 4865 (class 0 OID 24592)
-- Dependencies: 219
-- Data for Name: clocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clocks (id, "time", status, user_id, inserted_at, updated_at) FROM stdin;
1	2024-10-14 08:08:50	t	3	2024-10-14 08:08:50	2024-10-14 08:08:50
2	2024-10-14 08:09:07	t	3	2024-10-14 08:09:07	2024-10-14 08:09:07
3	2024-10-14 12:33:08	t	3	2024-10-14 12:33:08	2024-10-14 12:33:08
4	2024-10-14 12:33:10	t	3	2024-10-14 12:33:10	2024-10-14 12:33:10
\.


--
-- TOC entry 4861 (class 0 OID 24577)
-- Dependencies: 215
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20241008075236	2024-10-08 15:07:08
20241008075250	2024-10-08 15:07:08
20241008075257	2024-10-08 15:07:08
20241008082207	2024-10-08 15:07:08
20241008085516	2024-10-08 15:07:08
20241008091442	2024-10-08 15:07:08
20241008092236	2024-10-08 15:07:08
20241008133046	2024-10-08 15:07:08
\.


--
-- TOC entry 4863 (class 0 OID 24583)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, inserted_at, updated_at) FROM stdin;
1	tomi	tom@tom.com	2024-10-09 12:09:44	2024-10-09 12:09:44
3	ugo	ugo@epitech.com	2024-10-09 13:17:48	2024-10-10 12:26:20
\.


--
-- TOC entry 4867 (class 0 OID 24606)
-- Dependencies: 221
-- Data for Name: workingtime; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workingtime (id, start, "end", user_id, inserted_at, updated_at) FROM stdin;
1	2024-10-14 10:41:00	2024-10-18 17:30:00	3	2024-10-14 08:42:07	2024-10-14 08:42:07
\.


--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 218
-- Name: clocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clocks_id_seq', 4, true);


--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 16, true);


--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 220
-- Name: workingtimes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workingtimes_id_seq', 1, true);


--
-- TOC entry 4711 (class 2606 OID 24598)
-- Name: clocks clocks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clocks
    ADD CONSTRAINT clocks_pkey PRIMARY KEY (id);


--
-- TOC entry 4707 (class 2606 OID 24581)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4709 (class 2606 OID 24590)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4714 (class 2606 OID 24611)
-- Name: workingtime workingtimes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workingtime
    ADD CONSTRAINT workingtimes_pkey PRIMARY KEY (id);


--
-- TOC entry 4712 (class 1259 OID 24604)
-- Name: clocks_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clocks_user_id_index ON public.clocks USING btree (user_id);


--
-- TOC entry 4715 (class 1259 OID 24617)
-- Name: workingtimes_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX workingtimes_user_id_index ON public.workingtime USING btree (user_id);


--
-- TOC entry 4716 (class 2606 OID 24599)
-- Name: clocks clocks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clocks
    ADD CONSTRAINT clocks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4717 (class 2606 OID 24612)
-- Name: workingtime workingtimes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workingtime
    ADD CONSTRAINT workingtimes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2024-10-17 10:08:36

--
-- PostgreSQL database dump complete
--

