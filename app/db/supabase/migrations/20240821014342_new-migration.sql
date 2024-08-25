--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-08-21 02:54:07

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
-- TOC entry 904 (class 1247 OID 16724)
-- Name: domaine_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.domaine_type AS ENUM (
    'Informatique',
    'Math‚matiques',
    'Langues',
    'Sciences'
);


ALTER TYPE public.domaine_type OWNER TO postgres;

--
-- TOC entry 901 (class 1247 OID 16716)
-- Name: format_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.format_type AS ENUM (
    'Vid‚o',
    'Texte',
    'Quiz'
);


ALTER TYPE public.format_type OWNER TO postgres;

--
-- TOC entry 898 (class 1247 OID 16708)
-- Name: niveau_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.niveau_type AS ENUM (
    'D‚butant',
    'Interm‚diaire',
    'Avanc‚'
);


ALTER TYPE public.niveau_type OWNER TO postgres;

--
-- TOC entry 895 (class 1247 OID 16703)
-- Name: sexe_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sexe_type AS ENUM (
    'M',
    'F'
);


ALTER TYPE public.sexe_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16581)
-- Name: administrateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrateur (
    id integer NOT NULL
);


ALTER TABLE public.administrateur OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16559)
-- Name: apprenant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.apprenant (
    id integer NOT NULL,
    datederniereinscription date
);


ALTER TABLE public.apprenant OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16677)
-- Name: article; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.article (
    idarticle integer NOT NULL,
    idediteur integer,
    titre character varying(255) NOT NULL,
    contenu text
);


ALTER TABLE public.article OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16676)
-- Name: article_idarticle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.article_idarticle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.article_idarticle_seq OWNER TO postgres;

--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 231
-- Name: article_idarticle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.article_idarticle_seq OWNED BY public.article.idarticle;


--
-- TOC entry 229 (class 1259 OID 16648)
-- Name: certification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.certification (
    idcertification integer NOT NULL,
    idformation integer,
    idformateur integer,
    datedelivrance date
);


ALTER TABLE public.certification OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16647)
-- Name: certification_idcertification_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.certification_idcertification_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.certification_idcertification_seq OWNER TO postgres;

--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 228
-- Name: certification_idcertification_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.certification_idcertification_seq OWNED BY public.certification.idcertification;


--
-- TOC entry 221 (class 1259 OID 16592)
-- Name: cours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cours (
    idcours integer NOT NULL,
    niveau character varying(50),
    format character varying(50),
    domaine character varying(50),
    prix numeric(10,2),
    CONSTRAINT cours_domaine_check CHECK (((domaine)::text = ANY ((ARRAY['IA'::character varying, 'Donn‚es'::character varying])::text[]))),
    CONSTRAINT cours_format_check CHECK (((format)::text = ANY ((ARRAY['En ligne'::character varying, 'Pr‚sentiel'::character varying])::text[]))),
    CONSTRAINT cours_niveau_check CHECK (((niveau)::text = ANY ((ARRAY['D‚butant'::character varying, 'Interm‚diaire'::character varying, 'Avanc‚'::character varying])::text[])))
);


ALTER TABLE public.cours OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16591)
-- Name: cours_idcours_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cours_idcours_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cours_idcours_seq OWNER TO postgres;

--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 220
-- Name: cours_idcours_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cours_idcours_seq OWNED BY public.cours.idcours;


--
-- TOC entry 230 (class 1259 OID 16664)
-- Name: editeur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editeur (
    idediteur integer NOT NULL,
    nom character varying(255),
    prenom character varying(255)
);


ALTER TABLE public.editeur OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16569)
-- Name: formateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formateur (
    id integer NOT NULL,
    nom character varying(255) NOT NULL,
    prenom character varying(255) NOT NULL,
    cv text
);


ALTER TABLE public.formateur OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16614)
-- Name: formation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formation (
    idformation integer NOT NULL,
    idapprenant integer,
    idformateur integer,
    idcours integer,
    datedebut date,
    datefin date,
    montantpaye numeric(10,2)
);


ALTER TABLE public.formation OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16613)
-- Name: formation_idformation_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formation_idformation_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.formation_idformation_seq OWNER TO postgres;

--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 224
-- Name: formation_idformation_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formation_idformation_seq OWNED BY public.formation.idformation;


--
-- TOC entry 223 (class 1259 OID 16602)
-- Name: module; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.module (
    idmodule integer NOT NULL,
    idcours integer,
    nommodule character varying(255) NOT NULL
);


ALTER TABLE public.module OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16601)
-- Name: module_idmodule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.module_idmodule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.module_idmodule_seq OWNER TO postgres;

--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 222
-- Name: module_idmodule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.module_idmodule_seq OWNED BY public.module.idmodule;


--
-- TOC entry 227 (class 1259 OID 16636)
-- Name: paiement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paiement (
    idpaiement integer NOT NULL,
    idformation integer,
    datetransaction date,
    montantpaye numeric(10,2)
);


ALTER TABLE public.paiement OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16635)
-- Name: paiement_idpaiement_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paiement_idpaiement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paiement_idpaiement_seq OWNER TO postgres;

--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 226
-- Name: paiement_idpaiement_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paiement_idpaiement_seq OWNED BY public.paiement.idpaiement;


--
-- TOC entry 234 (class 1259 OID 16691)
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    idsession integer NOT NULL,
    idutilisateur integer,
    starttime timestamp without time zone,
    endtime timestamp without time zone
);


ALTER TABLE public.session OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16690)
-- Name: session_idsession_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.session_idsession_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.session_idsession_seq OWNER TO postgres;

--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 233
-- Name: session_idsession_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.session_idsession_seq OWNED BY public.session.idsession;


--
-- TOC entry 216 (class 1259 OID 16551)
-- Name: utilisateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateur (
    id integer NOT NULL,
    login character varying(255) NOT NULL,
    passwd character varying(255) NOT NULL,
    adresse character varying(255),
    pays character varying(100),
    age integer,
    sexe character varying(10),
    photo bytea
);


ALTER TABLE public.utilisateur OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16550)
-- Name: utilisateur_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateur_id_seq OWNER TO postgres;

--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utilisateur_id_seq OWNED BY public.utilisateur.id;


--
-- TOC entry 4757 (class 2604 OID 16680)
-- Name: article idarticle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article ALTER COLUMN idarticle SET DEFAULT nextval('public.article_idarticle_seq'::regclass);


--
-- TOC entry 4756 (class 2604 OID 16651)
-- Name: certification idcertification; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certification ALTER COLUMN idcertification SET DEFAULT nextval('public.certification_idcertification_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 16595)
-- Name: cours idcours; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cours ALTER COLUMN idcours SET DEFAULT nextval('public.cours_idcours_seq'::regclass);


--
-- TOC entry 4754 (class 2604 OID 16617)
-- Name: formation idformation; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation ALTER COLUMN idformation SET DEFAULT nextval('public.formation_idformation_seq'::regclass);


--
-- TOC entry 4753 (class 2604 OID 16605)
-- Name: module idmodule; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module ALTER COLUMN idmodule SET DEFAULT nextval('public.module_idmodule_seq'::regclass);


--
-- TOC entry 4755 (class 2604 OID 16639)
-- Name: paiement idpaiement; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement ALTER COLUMN idpaiement SET DEFAULT nextval('public.paiement_idpaiement_seq'::regclass);


--
-- TOC entry 4758 (class 2604 OID 16694)
-- Name: session idsession; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session ALTER COLUMN idsession SET DEFAULT nextval('public.session_idsession_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 16554)
-- Name: utilisateur id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur ALTER COLUMN id SET DEFAULT nextval('public.utilisateur_id_seq'::regclass);


--
-- TOC entry 4964 (class 0 OID 16581)
-- Dependencies: 219
-- Data for Name: administrateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.administrateur (id) FROM stdin;
 


--
-- TOC entry 4962 (class 0 OID 16559)
-- Dependencies: 217
-- Data for Name: apprenant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.apprenant (id, datederniereinscription) FROM stdin;
 


--
-- TOC entry 4977 (class 0 OID 16677)
-- Dependencies: 232
-- Data for Name: article; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.article (idarticle, idediteur, titre, contenu) FROM stdin;
 


--
-- TOC entry 4974 (class 0 OID 16648)
-- Dependencies: 229
-- Data for Name: certification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.certification (idcertification, idformation, idformateur, datedelivrance) FROM stdin;
 


--
-- TOC entry 4966 (class 0 OID 16592)
-- Dependencies: 221
-- Data for Name: cours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cours (idcours, niveau, format, domaine, prix) FROM stdin;
 


--
-- TOC entry 4975 (class 0 OID 16664)
-- Dependencies: 230
-- Data for Name: editeur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editeur (idediteur, nom, prenom) FROM stdin;
 


--
-- TOC entry 4963 (class 0 OID 16569)
-- Dependencies: 218
-- Data for Name: formateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formateur (id, nom, prenom, cv) FROM stdin;
 


--
-- TOC entry 4970 (class 0 OID 16614)
-- Dependencies: 225
-- Data for Name: formation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formation (idformation, idapprenant, idformateur, idcours, datedebut, datefin, montantpaye) FROM stdin;
 


--
-- TOC entry 4968 (class 0 OID 16602)
-- Dependencies: 223
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.module (idmodule, idcours, nommodule) FROM stdin;
 


--
-- TOC entry 4972 (class 0 OID 16636)
-- Dependencies: 227
-- Data for Name: paiement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paiement (idpaiement, idformation, datetransaction, montantpaye) FROM stdin;
 


--
-- TOC entry 4979 (class 0 OID 16691)
-- Dependencies: 234
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session (idsession, idutilisateur, starttime, endtime) FROM stdin;
 


--
-- TOC entry 4961 (class 0 OID 16551)
-- Dependencies: 216
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilisateur (id, login, passwd, adresse, pays, age, sexe, photo) FROM stdin;
1	mostafa	$2b$10$.PJkgRgUiwocoRIJAxQ6J.FEjQspKdGOxc3aR21s/zCvAbTS1als2	Sale	Morocco	22	M	\\x706174682f70686f746f2e6a706567
 


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 231
-- Name: article_idarticle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.article_idarticle_seq', 1, false);


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 228
-- Name: certification_idcertification_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.certification_idcertification_seq', 1, false);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 220
-- Name: cours_idcours_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cours_idcours_seq', 1, false);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 224
-- Name: formation_idformation_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formation_idformation_seq', 1, false);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 222
-- Name: module_idmodule_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.module_idmodule_seq', 1, false);


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 226
-- Name: paiement_idpaiement_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paiement_idpaiement_seq', 1, false);


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 233
-- Name: session_idsession_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.session_idsession_seq', 1, false);


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilisateur_id_seq', 9, true);


--
-- TOC entry 4769 (class 2606 OID 16585)
-- Name: administrateur administrateur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrateur
    ADD CONSTRAINT administrateur_pkey PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 16563)
-- Name: apprenant apprenant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apprenant
    ADD CONSTRAINT apprenant_pkey PRIMARY KEY (id);


--
-- TOC entry 4790 (class 2606 OID 16684)
-- Name: article article_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (idarticle);


--
-- TOC entry 4784 (class 2606 OID 16653)
-- Name: certification certification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_pkey PRIMARY KEY (idcertification);


--
-- TOC entry 4771 (class 2606 OID 16600)
-- Name: cours cours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_pkey PRIMARY KEY (idcours);


--
-- TOC entry 4788 (class 2606 OID 16670)
-- Name: editeur editeur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_pkey PRIMARY KEY (idediteur);


--
-- TOC entry 4767 (class 2606 OID 16575)
-- Name: formateur formateur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formateur
    ADD CONSTRAINT formateur_pkey PRIMARY KEY (id);


--
-- TOC entry 4776 (class 2606 OID 16619)
-- Name: formation formation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_pkey PRIMARY KEY (idformation);


--
-- TOC entry 4774 (class 2606 OID 16607)
-- Name: module module_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_pkey PRIMARY KEY (idmodule);


--
-- TOC entry 4782 (class 2606 OID 16641)
-- Name: paiement paiement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_pkey PRIMARY KEY (idpaiement);


--
-- TOC entry 4794 (class 2606 OID 16696)
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (idsession);


--
-- TOC entry 4763 (class 2606 OID 16558)
-- Name: utilisateur utilisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id);


--
-- TOC entry 4791 (class 1259 OID 16753)
-- Name: idx_article_idediteur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_article_idediteur ON public.article USING btree (idediteur);


--
-- TOC entry 4785 (class 1259 OID 16749)
-- Name: idx_certification_idformateur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_certification_idformateur ON public.certification USING btree (idformateur);


--
-- TOC entry 4786 (class 1259 OID 16748)
-- Name: idx_certification_idformation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_certification_idformation ON public.certification USING btree (idformation);


--
-- TOC entry 4777 (class 1259 OID 16746)
-- Name: idx_formation_idapprenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_formation_idapprenant ON public.formation USING btree (idapprenant);


--
-- TOC entry 4778 (class 1259 OID 16745)
-- Name: idx_formation_idcours; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_formation_idcours ON public.formation USING btree (idcours);


--
-- TOC entry 4779 (class 1259 OID 16747)
-- Name: idx_formation_idformateur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_formation_idformateur ON public.formation USING btree (idformateur);


--
-- TOC entry 4772 (class 1259 OID 16750)
-- Name: idx_module_idcours; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_module_idcours ON public.module USING btree (idcours);


--
-- TOC entry 4780 (class 1259 OID 16751)
-- Name: idx_paiement_idformation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_paiement_idformation ON public.paiement USING btree (idformation);


--
-- TOC entry 4792 (class 1259 OID 16752)
-- Name: idx_session_idutilisateur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_session_idutilisateur ON public.session USING btree (idutilisateur);


--
-- TOC entry 4797 (class 2606 OID 16586)
-- Name: administrateur administrateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrateur
    ADD CONSTRAINT administrateur_id_fkey FOREIGN KEY (id) REFERENCES public.utilisateur(id);


--
-- TOC entry 4795 (class 2606 OID 16564)
-- Name: apprenant apprenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apprenant
    ADD CONSTRAINT apprenant_id_fkey FOREIGN KEY (id) REFERENCES public.utilisateur(id);


--
-- TOC entry 4813 (class 2606 OID 16685)
-- Name: article article_idediteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_idediteur_fkey FOREIGN KEY (idediteur) REFERENCES public.editeur(idediteur);


--
-- TOC entry 4808 (class 2606 OID 16659)
-- Name: certification certification_idformateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_idformateur_fkey FOREIGN KEY (idformateur) REFERENCES public.formateur(id);


--
-- TOC entry 4809 (class 2606 OID 16654)
-- Name: certification certification_idformation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_idformation_fkey FOREIGN KEY (idformation) REFERENCES public.formation(idformation);


--
-- TOC entry 4812 (class 2606 OID 16671)
-- Name: editeur editeur_idediteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_idediteur_fkey FOREIGN KEY (idediteur) REFERENCES public.utilisateur(id);


--
-- TOC entry 4814 (class 2606 OID 16794)
-- Name: article fk_article_editeur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT fk_article_editeur FOREIGN KEY (idediteur) REFERENCES public.editeur(idediteur) ON DELETE SET NULL;


--
-- TOC entry 4810 (class 2606 OID 16774)
-- Name: certification fk_certification_formateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT fk_certification_formateur FOREIGN KEY (idformateur) REFERENCES public.formateur(id) ON DELETE SET NULL;


--
-- TOC entry 4811 (class 2606 OID 16769)
-- Name: certification fk_certification_formation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT fk_certification_formation FOREIGN KEY (idformation) REFERENCES public.formation(idformation) ON DELETE CASCADE;


--
-- TOC entry 4800 (class 2606 OID 16759)
-- Name: formation fk_formation_apprenant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT fk_formation_apprenant FOREIGN KEY (idapprenant) REFERENCES public.apprenant(id) ON DELETE CASCADE;


--
-- TOC entry 4801 (class 2606 OID 16754)
-- Name: formation fk_formation_cours; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT fk_formation_cours FOREIGN KEY (idcours) REFERENCES public.cours(idcours) ON DELETE CASCADE;


--
-- TOC entry 4802 (class 2606 OID 16764)
-- Name: formation fk_formation_formateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT fk_formation_formateur FOREIGN KEY (idformateur) REFERENCES public.formateur(id) ON DELETE SET NULL;


--
-- TOC entry 4798 (class 2606 OID 16779)
-- Name: module fk_module_cours; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT fk_module_cours FOREIGN KEY (idcours) REFERENCES public.cours(idcours) ON DELETE CASCADE;


--
-- TOC entry 4806 (class 2606 OID 16784)
-- Name: paiement fk_paiement_formation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT fk_paiement_formation FOREIGN KEY (idformation) REFERENCES public.formation(idformation) ON DELETE CASCADE;


--
-- TOC entry 4815 (class 2606 OID 16789)
-- Name: session fk_session_utilisateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT fk_session_utilisateur FOREIGN KEY (idutilisateur) REFERENCES public.utilisateur(id) ON DELETE CASCADE;


--
-- TOC entry 4796 (class 2606 OID 16576)
-- Name: formateur formateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formateur
    ADD CONSTRAINT formateur_id_fkey FOREIGN KEY (id) REFERENCES public.utilisateur(id);


--
-- TOC entry 4803 (class 2606 OID 16620)
-- Name: formation formation_idapprenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_idapprenant_fkey FOREIGN KEY (idapprenant) REFERENCES public.apprenant(id);


--
-- TOC entry 4804 (class 2606 OID 16630)
-- Name: formation formation_idcours_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_idcours_fkey FOREIGN KEY (idcours) REFERENCES public.cours(idcours);


--
-- TOC entry 4805 (class 2606 OID 16625)
-- Name: formation formation_idformateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_idformateur_fkey FOREIGN KEY (idformateur) REFERENCES public.formateur(id);


--
-- TOC entry 4799 (class 2606 OID 16608)
-- Name: module module_idcours_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_idcours_fkey FOREIGN KEY (idcours) REFERENCES public.cours(idcours);


--
-- TOC entry 4807 (class 2606 OID 16642)
-- Name: paiement paiement_idformation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_idformation_fkey FOREIGN KEY (idformation) REFERENCES public.formation(idformation);


--
-- TOC entry 4816 (class 2606 OID 16697)
-- Name: session session_idutilisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_idutilisateur_fkey FOREIGN KEY (idutilisateur) REFERENCES public.utilisateur(id);


-- Completed on 2024-08-21 02:54:08

--
-- PostgreSQL database dump complete
--

