PGDMP  
                    |        	   elearning    16.4    16.4 k    v           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            w           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            x           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            y           1262    16397 	   elearning    DATABASE     �   CREATE DATABASE elearning WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE elearning;
                postgres    false            �           1247    16724    domaine_type    TYPE     v   CREATE TYPE public.domaine_type AS ENUM (
    'Informatique',
    'Math‚matiques',
    'Langues',
    'Sciences'
);
    DROP TYPE public.domaine_type;
       public          postgres    false            �           1247    16716    format_type    TYPE     S   CREATE TYPE public.format_type AS ENUM (
    'Vid‚o',
    'Texte',
    'Quiz'
);
    DROP TYPE public.format_type;
       public          postgres    false            �           1247    16708    niveau_type    TYPE     d   CREATE TYPE public.niveau_type AS ENUM (
    'D‚butant',
    'Interm‚diaire',
    'Avanc‚'
);
    DROP TYPE public.niveau_type;
       public          postgres    false                       1247    16703 	   sexe_type    TYPE     ;   CREATE TYPE public.sexe_type AS ENUM (
    'M',
    'F'
);
    DROP TYPE public.sexe_type;
       public          postgres    false            �            1259    16581    administrateur    TABLE     @   CREATE TABLE public.administrateur (
    id integer NOT NULL
);
 "   DROP TABLE public.administrateur;
       public         heap    postgres    false            �            1259    16559 	   apprenant    TABLE     ]   CREATE TABLE public.apprenant (
    id integer NOT NULL,
    datederniereinscription date
);
    DROP TABLE public.apprenant;
       public         heap    postgres    false            �            1259    16677    article    TABLE     �   CREATE TABLE public.article (
    idarticle integer NOT NULL,
    idediteur integer,
    titre character varying(255) NOT NULL,
    contenu text
);
    DROP TABLE public.article;
       public         heap    postgres    false            �            1259    16676    article_idarticle_seq    SEQUENCE     �   CREATE SEQUENCE public.article_idarticle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.article_idarticle_seq;
       public          postgres    false    232            z           0    0    article_idarticle_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.article_idarticle_seq OWNED BY public.article.idarticle;
          public          postgres    false    231            �            1259    16648    certification    TABLE     �   CREATE TABLE public.certification (
    idcertification integer NOT NULL,
    idformation integer,
    idformateur integer,
    datedelivrance date
);
 !   DROP TABLE public.certification;
       public         heap    postgres    false            �            1259    16647 !   certification_idcertification_seq    SEQUENCE     �   CREATE SEQUENCE public.certification_idcertification_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.certification_idcertification_seq;
       public          postgres    false    229            {           0    0 !   certification_idcertification_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.certification_idcertification_seq OWNED BY public.certification.idcertification;
          public          postgres    false    228            �            1259    16592    cours    TABLE     �  CREATE TABLE public.cours (
    idcours integer NOT NULL,
    niveau character varying(50),
    format character varying(50),
    domaine character varying(50),
    prix numeric(10,2),
    CONSTRAINT cours_domaine_check CHECK (((domaine)::text = ANY ((ARRAY['IA'::character varying, 'Donn‚es'::character varying])::text[]))),
    CONSTRAINT cours_format_check CHECK (((format)::text = ANY ((ARRAY['En ligne'::character varying, 'Pr‚sentiel'::character varying])::text[]))),
    CONSTRAINT cours_niveau_check CHECK (((niveau)::text = ANY ((ARRAY['D‚butant'::character varying, 'Interm‚diaire'::character varying, 'Avanc‚'::character varying])::text[])))
);
    DROP TABLE public.cours;
       public         heap    postgres    false            �            1259    16591    cours_idcours_seq    SEQUENCE     �   CREATE SEQUENCE public.cours_idcours_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cours_idcours_seq;
       public          postgres    false    221            |           0    0    cours_idcours_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cours_idcours_seq OWNED BY public.cours.idcours;
          public          postgres    false    220            �            1259    16664    editeur    TABLE     �   CREATE TABLE public.editeur (
    idediteur integer NOT NULL,
    nom character varying(255),
    prenom character varying(255)
);
    DROP TABLE public.editeur;
       public         heap    postgres    false            �            1259    16569 	   formateur    TABLE     �   CREATE TABLE public.formateur (
    id integer NOT NULL,
    nom character varying(255) NOT NULL,
    prenom character varying(255) NOT NULL,
    cv text
);
    DROP TABLE public.formateur;
       public         heap    postgres    false            �            1259    16614 	   formation    TABLE     �   CREATE TABLE public.formation (
    idformation integer NOT NULL,
    idapprenant integer,
    idformateur integer,
    idcours integer,
    datedebut date,
    datefin date,
    montantpaye numeric(10,2)
);
    DROP TABLE public.formation;
       public         heap    postgres    false            �            1259    16613    formation_idformation_seq    SEQUENCE     �   CREATE SEQUENCE public.formation_idformation_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.formation_idformation_seq;
       public          postgres    false    225            }           0    0    formation_idformation_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.formation_idformation_seq OWNED BY public.formation.idformation;
          public          postgres    false    224            �            1259    16602    module    TABLE     �   CREATE TABLE public.module (
    idmodule integer NOT NULL,
    idcours integer,
    nommodule character varying(255) NOT NULL
);
    DROP TABLE public.module;
       public         heap    postgres    false            �            1259    16601    module_idmodule_seq    SEQUENCE     �   CREATE SEQUENCE public.module_idmodule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.module_idmodule_seq;
       public          postgres    false    223            ~           0    0    module_idmodule_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.module_idmodule_seq OWNED BY public.module.idmodule;
          public          postgres    false    222            �            1259    16636    paiement    TABLE     �   CREATE TABLE public.paiement (
    idpaiement integer NOT NULL,
    idformation integer,
    datetransaction date,
    montantpaye numeric(10,2)
);
    DROP TABLE public.paiement;
       public         heap    postgres    false            �            1259    16635    paiement_idpaiement_seq    SEQUENCE     �   CREATE SEQUENCE public.paiement_idpaiement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.paiement_idpaiement_seq;
       public          postgres    false    227                       0    0    paiement_idpaiement_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.paiement_idpaiement_seq OWNED BY public.paiement.idpaiement;
          public          postgres    false    226            �            1259    16691    session    TABLE     �   CREATE TABLE public.session (
    idsession integer NOT NULL,
    idutilisateur integer,
    starttime timestamp without time zone,
    endtime timestamp without time zone
);
    DROP TABLE public.session;
       public         heap    postgres    false            �            1259    16690    session_idsession_seq    SEQUENCE     �   CREATE SEQUENCE public.session_idsession_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.session_idsession_seq;
       public          postgres    false    234            �           0    0    session_idsession_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.session_idsession_seq OWNED BY public.session.idsession;
          public          postgres    false    233            �            1259    16551    utilisateur    TABLE       CREATE TABLE public.utilisateur (
    id integer NOT NULL,
    login character varying(255) NOT NULL,
    passwd character varying(255) NOT NULL,
    adresse character varying(255),
    pays character varying(100),
    age integer,
    sexe character varying(10),
    photo bytea
);
    DROP TABLE public.utilisateur;
       public         heap    postgres    false            �            1259    16550    utilisateur_id_seq    SEQUENCE     �   CREATE SEQUENCE public.utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.utilisateur_id_seq;
       public          postgres    false    216            �           0    0    utilisateur_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.utilisateur_id_seq OWNED BY public.utilisateur.id;
          public          postgres    false    215            �           2604    16680    article idarticle    DEFAULT     v   ALTER TABLE ONLY public.article ALTER COLUMN idarticle SET DEFAULT nextval('public.article_idarticle_seq'::regclass);
 @   ALTER TABLE public.article ALTER COLUMN idarticle DROP DEFAULT;
       public          postgres    false    231    232    232            �           2604    16651    certification idcertification    DEFAULT     �   ALTER TABLE ONLY public.certification ALTER COLUMN idcertification SET DEFAULT nextval('public.certification_idcertification_seq'::regclass);
 L   ALTER TABLE public.certification ALTER COLUMN idcertification DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    16595    cours idcours    DEFAULT     n   ALTER TABLE ONLY public.cours ALTER COLUMN idcours SET DEFAULT nextval('public.cours_idcours_seq'::regclass);
 <   ALTER TABLE public.cours ALTER COLUMN idcours DROP DEFAULT;
       public          postgres    false    220    221    221            �           2604    16617    formation idformation    DEFAULT     ~   ALTER TABLE ONLY public.formation ALTER COLUMN idformation SET DEFAULT nextval('public.formation_idformation_seq'::regclass);
 D   ALTER TABLE public.formation ALTER COLUMN idformation DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    16605    module idmodule    DEFAULT     r   ALTER TABLE ONLY public.module ALTER COLUMN idmodule SET DEFAULT nextval('public.module_idmodule_seq'::regclass);
 >   ALTER TABLE public.module ALTER COLUMN idmodule DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    16639    paiement idpaiement    DEFAULT     z   ALTER TABLE ONLY public.paiement ALTER COLUMN idpaiement SET DEFAULT nextval('public.paiement_idpaiement_seq'::regclass);
 B   ALTER TABLE public.paiement ALTER COLUMN idpaiement DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    16694    session idsession    DEFAULT     v   ALTER TABLE ONLY public.session ALTER COLUMN idsession SET DEFAULT nextval('public.session_idsession_seq'::regclass);
 @   ALTER TABLE public.session ALTER COLUMN idsession DROP DEFAULT;
       public          postgres    false    233    234    234            �           2604    16554    utilisateur id    DEFAULT     p   ALTER TABLE ONLY public.utilisateur ALTER COLUMN id SET DEFAULT nextval('public.utilisateur_id_seq'::regclass);
 =   ALTER TABLE public.utilisateur ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216            d          0    16581    administrateur 
   TABLE DATA           ,   COPY public.administrateur (id) FROM stdin;
    public          postgres    false    219   ȁ       b          0    16559 	   apprenant 
   TABLE DATA           @   COPY public.apprenant (id, datederniereinscription) FROM stdin;
    public          postgres    false    217   �       q          0    16677    article 
   TABLE DATA           G   COPY public.article (idarticle, idediteur, titre, contenu) FROM stdin;
    public          postgres    false    232   �       n          0    16648    certification 
   TABLE DATA           b   COPY public.certification (idcertification, idformation, idformateur, datedelivrance) FROM stdin;
    public          postgres    false    229   �       f          0    16592    cours 
   TABLE DATA           G   COPY public.cours (idcours, niveau, format, domaine, prix) FROM stdin;
    public          postgres    false    221   <�       o          0    16664    editeur 
   TABLE DATA           9   COPY public.editeur (idediteur, nom, prenom) FROM stdin;
    public          postgres    false    230   Y�       c          0    16569 	   formateur 
   TABLE DATA           8   COPY public.formateur (id, nom, prenom, cv) FROM stdin;
    public          postgres    false    218   v�       j          0    16614 	   formation 
   TABLE DATA           t   COPY public.formation (idformation, idapprenant, idformateur, idcours, datedebut, datefin, montantpaye) FROM stdin;
    public          postgres    false    225   ��       h          0    16602    module 
   TABLE DATA           >   COPY public.module (idmodule, idcours, nommodule) FROM stdin;
    public          postgres    false    223   ��       l          0    16636    paiement 
   TABLE DATA           Y   COPY public.paiement (idpaiement, idformation, datetransaction, montantpaye) FROM stdin;
    public          postgres    false    227   ͂       s          0    16691    session 
   TABLE DATA           O   COPY public.session (idsession, idutilisateur, starttime, endtime) FROM stdin;
    public          postgres    false    234   �       a          0    16551    utilisateur 
   TABLE DATA           Y   COPY public.utilisateur (id, login, passwd, adresse, pays, age, sexe, photo) FROM stdin;
    public          postgres    false    216   �       �           0    0    article_idarticle_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.article_idarticle_seq', 1, false);
          public          postgres    false    231            �           0    0 !   certification_idcertification_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.certification_idcertification_seq', 1, false);
          public          postgres    false    228            �           0    0    cours_idcours_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.cours_idcours_seq', 1, false);
          public          postgres    false    220            �           0    0    formation_idformation_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.formation_idformation_seq', 1, false);
          public          postgres    false    224            �           0    0    module_idmodule_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.module_idmodule_seq', 1, false);
          public          postgres    false    222            �           0    0    paiement_idpaiement_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.paiement_idpaiement_seq', 1, false);
          public          postgres    false    226            �           0    0    session_idsession_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.session_idsession_seq', 1, false);
          public          postgres    false    233            �           0    0    utilisateur_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.utilisateur_id_seq', 9, true);
          public          postgres    false    215            �           2606    16585 "   administrateur administrateur_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.administrateur
    ADD CONSTRAINT administrateur_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.administrateur DROP CONSTRAINT administrateur_pkey;
       public            postgres    false    219            �           2606    16563    apprenant apprenant_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.apprenant
    ADD CONSTRAINT apprenant_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.apprenant DROP CONSTRAINT apprenant_pkey;
       public            postgres    false    217            �           2606    16684    article article_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (idarticle);
 >   ALTER TABLE ONLY public.article DROP CONSTRAINT article_pkey;
       public            postgres    false    232            �           2606    16653     certification certification_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_pkey PRIMARY KEY (idcertification);
 J   ALTER TABLE ONLY public.certification DROP CONSTRAINT certification_pkey;
       public            postgres    false    229            �           2606    16600    cours cours_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_pkey PRIMARY KEY (idcours);
 :   ALTER TABLE ONLY public.cours DROP CONSTRAINT cours_pkey;
       public            postgres    false    221            �           2606    16670    editeur editeur_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_pkey PRIMARY KEY (idediteur);
 >   ALTER TABLE ONLY public.editeur DROP CONSTRAINT editeur_pkey;
       public            postgres    false    230            �           2606    16575    formateur formateur_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.formateur
    ADD CONSTRAINT formateur_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.formateur DROP CONSTRAINT formateur_pkey;
       public            postgres    false    218            �           2606    16619    formation formation_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_pkey PRIMARY KEY (idformation);
 B   ALTER TABLE ONLY public.formation DROP CONSTRAINT formation_pkey;
       public            postgres    false    225            �           2606    16607    module module_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_pkey PRIMARY KEY (idmodule);
 <   ALTER TABLE ONLY public.module DROP CONSTRAINT module_pkey;
       public            postgres    false    223            �           2606    16641    paiement paiement_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_pkey PRIMARY KEY (idpaiement);
 @   ALTER TABLE ONLY public.paiement DROP CONSTRAINT paiement_pkey;
       public            postgres    false    227            �           2606    16696    session session_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (idsession);
 >   ALTER TABLE ONLY public.session DROP CONSTRAINT session_pkey;
       public            postgres    false    234            �           2606    16558    utilisateur utilisateur_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.utilisateur DROP CONSTRAINT utilisateur_pkey;
       public            postgres    false    216            �           1259    16753    idx_article_idediteur    INDEX     N   CREATE INDEX idx_article_idediteur ON public.article USING btree (idediteur);
 )   DROP INDEX public.idx_article_idediteur;
       public            postgres    false    232            �           1259    16749    idx_certification_idformateur    INDEX     ^   CREATE INDEX idx_certification_idformateur ON public.certification USING btree (idformateur);
 1   DROP INDEX public.idx_certification_idformateur;
       public            postgres    false    229            �           1259    16748    idx_certification_idformation    INDEX     ^   CREATE INDEX idx_certification_idformation ON public.certification USING btree (idformation);
 1   DROP INDEX public.idx_certification_idformation;
       public            postgres    false    229            �           1259    16746    idx_formation_idapprenant    INDEX     V   CREATE INDEX idx_formation_idapprenant ON public.formation USING btree (idapprenant);
 -   DROP INDEX public.idx_formation_idapprenant;
       public            postgres    false    225            �           1259    16745    idx_formation_idcours    INDEX     N   CREATE INDEX idx_formation_idcours ON public.formation USING btree (idcours);
 )   DROP INDEX public.idx_formation_idcours;
       public            postgres    false    225            �           1259    16747    idx_formation_idformateur    INDEX     V   CREATE INDEX idx_formation_idformateur ON public.formation USING btree (idformateur);
 -   DROP INDEX public.idx_formation_idformateur;
       public            postgres    false    225            �           1259    16750    idx_module_idcours    INDEX     H   CREATE INDEX idx_module_idcours ON public.module USING btree (idcours);
 &   DROP INDEX public.idx_module_idcours;
       public            postgres    false    223            �           1259    16751    idx_paiement_idformation    INDEX     T   CREATE INDEX idx_paiement_idformation ON public.paiement USING btree (idformation);
 ,   DROP INDEX public.idx_paiement_idformation;
       public            postgres    false    227            �           1259    16752    idx_session_idutilisateur    INDEX     V   CREATE INDEX idx_session_idutilisateur ON public.session USING btree (idutilisateur);
 -   DROP INDEX public.idx_session_idutilisateur;
       public            postgres    false    234            �           2606    16586 %   administrateur administrateur_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.administrateur
    ADD CONSTRAINT administrateur_id_fkey FOREIGN KEY (id) REFERENCES public.utilisateur(id);
 O   ALTER TABLE ONLY public.administrateur DROP CONSTRAINT administrateur_id_fkey;
       public          postgres    false    219    216    4763            �           2606    16564    apprenant apprenant_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.apprenant
    ADD CONSTRAINT apprenant_id_fkey FOREIGN KEY (id) REFERENCES public.utilisateur(id);
 E   ALTER TABLE ONLY public.apprenant DROP CONSTRAINT apprenant_id_fkey;
       public          postgres    false    4763    217    216            �           2606    16685    article article_idediteur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_idediteur_fkey FOREIGN KEY (idediteur) REFERENCES public.editeur(idediteur);
 H   ALTER TABLE ONLY public.article DROP CONSTRAINT article_idediteur_fkey;
       public          postgres    false    4788    230    232            �           2606    16659 ,   certification certification_idformateur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_idformateur_fkey FOREIGN KEY (idformateur) REFERENCES public.formateur(id);
 V   ALTER TABLE ONLY public.certification DROP CONSTRAINT certification_idformateur_fkey;
       public          postgres    false    229    218    4767            �           2606    16654 ,   certification certification_idformation_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_idformation_fkey FOREIGN KEY (idformation) REFERENCES public.formation(idformation);
 V   ALTER TABLE ONLY public.certification DROP CONSTRAINT certification_idformation_fkey;
       public          postgres    false    229    225    4776            �           2606    16671    editeur editeur_idediteur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.editeur
    ADD CONSTRAINT editeur_idediteur_fkey FOREIGN KEY (idediteur) REFERENCES public.utilisateur(id);
 H   ALTER TABLE ONLY public.editeur DROP CONSTRAINT editeur_idediteur_fkey;
       public          postgres    false    216    4763    230            �           2606    16794    article fk_article_editeur    FK CONSTRAINT     �   ALTER TABLE ONLY public.article
    ADD CONSTRAINT fk_article_editeur FOREIGN KEY (idediteur) REFERENCES public.editeur(idediteur) ON DELETE SET NULL;
 D   ALTER TABLE ONLY public.article DROP CONSTRAINT fk_article_editeur;
       public          postgres    false    230    4788    232            �           2606    16774 (   certification fk_certification_formateur    FK CONSTRAINT     �   ALTER TABLE ONLY public.certification
    ADD CONSTRAINT fk_certification_formateur FOREIGN KEY (idformateur) REFERENCES public.formateur(id) ON DELETE SET NULL;
 R   ALTER TABLE ONLY public.certification DROP CONSTRAINT fk_certification_formateur;
       public          postgres    false    218    229    4767            �           2606    16769 (   certification fk_certification_formation    FK CONSTRAINT     �   ALTER TABLE ONLY public.certification
    ADD CONSTRAINT fk_certification_formation FOREIGN KEY (idformation) REFERENCES public.formation(idformation) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.certification DROP CONSTRAINT fk_certification_formation;
       public          postgres    false    229    225    4776            �           2606    16759     formation fk_formation_apprenant    FK CONSTRAINT     �   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT fk_formation_apprenant FOREIGN KEY (idapprenant) REFERENCES public.apprenant(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.formation DROP CONSTRAINT fk_formation_apprenant;
       public          postgres    false    4765    225    217            �           2606    16754    formation fk_formation_cours    FK CONSTRAINT     �   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT fk_formation_cours FOREIGN KEY (idcours) REFERENCES public.cours(idcours) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.formation DROP CONSTRAINT fk_formation_cours;
       public          postgres    false    225    4771    221            �           2606    16764     formation fk_formation_formateur    FK CONSTRAINT     �   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT fk_formation_formateur FOREIGN KEY (idformateur) REFERENCES public.formateur(id) ON DELETE SET NULL;
 J   ALTER TABLE ONLY public.formation DROP CONSTRAINT fk_formation_formateur;
       public          postgres    false    218    225    4767            �           2606    16779    module fk_module_cours    FK CONSTRAINT     �   ALTER TABLE ONLY public.module
    ADD CONSTRAINT fk_module_cours FOREIGN KEY (idcours) REFERENCES public.cours(idcours) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.module DROP CONSTRAINT fk_module_cours;
       public          postgres    false    4771    223    221            �           2606    16784    paiement fk_paiement_formation    FK CONSTRAINT     �   ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT fk_paiement_formation FOREIGN KEY (idformation) REFERENCES public.formation(idformation) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.paiement DROP CONSTRAINT fk_paiement_formation;
       public          postgres    false    225    4776    227            �           2606    16789    session fk_session_utilisateur    FK CONSTRAINT     �   ALTER TABLE ONLY public.session
    ADD CONSTRAINT fk_session_utilisateur FOREIGN KEY (idutilisateur) REFERENCES public.utilisateur(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.session DROP CONSTRAINT fk_session_utilisateur;
       public          postgres    false    216    234    4763            �           2606    16576    formateur formateur_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.formateur
    ADD CONSTRAINT formateur_id_fkey FOREIGN KEY (id) REFERENCES public.utilisateur(id);
 E   ALTER TABLE ONLY public.formateur DROP CONSTRAINT formateur_id_fkey;
       public          postgres    false    216    218    4763            �           2606    16620 $   formation formation_idapprenant_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_idapprenant_fkey FOREIGN KEY (idapprenant) REFERENCES public.apprenant(id);
 N   ALTER TABLE ONLY public.formation DROP CONSTRAINT formation_idapprenant_fkey;
       public          postgres    false    4765    225    217            �           2606    16630     formation formation_idcours_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_idcours_fkey FOREIGN KEY (idcours) REFERENCES public.cours(idcours);
 J   ALTER TABLE ONLY public.formation DROP CONSTRAINT formation_idcours_fkey;
       public          postgres    false    4771    221    225            �           2606    16625 $   formation formation_idformateur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.formation
    ADD CONSTRAINT formation_idformateur_fkey FOREIGN KEY (idformateur) REFERENCES public.formateur(id);
 N   ALTER TABLE ONLY public.formation DROP CONSTRAINT formation_idformateur_fkey;
       public          postgres    false    218    225    4767            �           2606    16608    module module_idcours_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_idcours_fkey FOREIGN KEY (idcours) REFERENCES public.cours(idcours);
 D   ALTER TABLE ONLY public.module DROP CONSTRAINT module_idcours_fkey;
       public          postgres    false    223    4771    221            �           2606    16642 "   paiement paiement_idformation_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.paiement
    ADD CONSTRAINT paiement_idformation_fkey FOREIGN KEY (idformation) REFERENCES public.formation(idformation);
 L   ALTER TABLE ONLY public.paiement DROP CONSTRAINT paiement_idformation_fkey;
       public          postgres    false    227    4776    225            �           2606    16697 "   session session_idutilisateur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_idutilisateur_fkey FOREIGN KEY (idutilisateur) REFERENCES public.utilisateur(id);
 L   ALTER TABLE ONLY public.session DROP CONSTRAINT session_idutilisateur_fkey;
       public          postgres    false    234    216    4763            d      x������ � �      b      x������ � �      q      x������ � �      n      x������ � �      f      x������ � �      o      x������ � �      c      x������ � �      j      x������ � �      h      x������ � �      l      x������ � �      s      x������ � �      a   �   x��ͻ�0@�<3҂�� b�Z51��o��%E�yzY|��L��;t �M��];�ir3���5������w�v���sq��_o)�m�̠�k����
�ꩄP��������!�g���]���\KXuJ������e��5��QB�u�{�9I|��~S��Qx�֋i5D�x� 5�k]8�e}��I�     