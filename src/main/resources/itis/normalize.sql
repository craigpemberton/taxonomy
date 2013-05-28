# do main import
DROP DATABASE IF EXISTS ITIS;
CREATE DATABASE IF NOT EXISTS ITIS CHARACTER SET latin1 collate = latin1_bin;
USE ITIS;
SOURCE ITIS.sql

# drop unneeded tables
DROP TABLE change_comments;
DROP TABLE change_operations;
DROP TABLE change_tracks;
DROP TABLE chg_operation_lkp;
DROP TABLE hierarchy;
DROP TABLE longnames;
DROP TABLE reviews;

# comments
ALTER TABLE comments DROP COLUMN update_date;
ALTER TABLE comments CHANGE COLUMN commentator expert varchar(100);
ALTER TABLE comments CHANGE COLUMN comment_detail comment text;
ALTER TABLE comments CHANGE COLUMN comment_id id int(11);
ALTER TABLE comments CHANGE COLUMN comment_time_stamp time datetime;
ALTER TABLE comments MODIFY comment text NOT NULL;
ALTER TABLE comments MODIFY expert varchar(100) NOT NULL;
ALTER TABLE comments MODIFY time datetime NOT NULL;
CREATE UNIQUE INDEX i ON comments (id);
DELETE FROM comments WHERE expert LIKE  "%?%";
UPDATE comments SET expert = 'Amanda Treher, ITIS Data Development Technician' WHERE expert LIKE  '%Treher%';
UPDATE comments SET expert = 'Andrew K. Townesmith, ITIS Data Development Technician' WHERE expert LIKE  '%Townesmith%';
UPDATE comments SET expert = 'Avid F. Mitchell, ITIS Data Development Technician' WHERE expert LIKE  '%F. Mitch%';
UPDATE comments SET expert = 'Daniel Perez-Gelabert, ITIS Data Development Technician' WHERE expert LIKE  '%Gelaber%';
UPDATE comments SET expert = 'David Nicolson, ITIS Data Development Technician' WHERE expert LIKE  '%Nicolson%';
UPDATE comments SET expert = 'Elizabeth Eubanks, ITIS Data Development Technician' WHERE expert LIKE  '%eubanks%';
UPDATE comments SET expert = 'Estelle Yoo, ITIS Data Development Technician' WHERE expert LIKE  '%le yoo%';
UPDATE comments SET expert = 'F. Christian Thomson' WHERE expert LIKE  'F. Christian Thom%';
UPDATE comments SET expert = 'G. M. Nishida, 1994' WHERE expert LIKE  '%Nishida%';
UPDATE comments SET expert = 'H. Banford, NMFS-NEFSC, ITIS Data Development Technician' WHERE expert LIKE  '%banfo%';
UPDATE comments SET expert = 'Herrick Brown, ITIS Data Development Technician' WHERE expert LIKE  'Herrick%Brown%';
UPDATE comments SET expert = 'Jenny K. Archibald' WHERE expert LIKE  'Jenny K. Ar%';
UPDATE comments SET expert = 'Jerry D. Hardy' WHERE expert LIKE  'Jerry D. Hardy%';
UPDATE comments SET expert = 'Jerry Hardy, ITIS Data Development Technician' WHERE expert LIKE  'J%Hardy%';
UPDATE comments SET expert = 'John C. Morse' WHERE expert LIKE  'John C. Morse%';
UPDATE comments SET expert = 'Michael J. Sweeney' WHERE expert LIKE  'Michael J. Swee%';
UPDATE comments SET expert = 'Natapot Warrit, ITIS Data Development Technician' WHERE expert LIKE  '%Natapot Warri%';
UPDATE comments SET expert = ' Nishida, G. M., 1994' WHERE expert LIKE  'nishida%';
UPDATE comments SET expert = 'Norman F. Johnson' WHERE expert LIKE  'norman%john%';
UPDATE comments SET expert = 'Payal Dharia, ITIS Data Development Technician' WHERE expert LIKE  '%dhar%';
UPDATE comments SET expert = 'Quintin Gravatt, ITIS Data Development Technician' WHERE expert LIKE  '%quint%';
UPDATE comments SET expert = 'Richard C. Banks' WHERE expert LIKE  '%C. Banks%';
UPDATE comments SET expert = 'S. A. Slipinski' WHERE expert LIKE  '%Slipinski%';
UPDATE comments SET expert = 'Scott Redhead' WHERE expert LIKE  '%Redhead%';
UPDATE comments SET expert = 'Shabnam Mohammadi, ITIS Data Development Technician' WHERE expert LIKE  '%Mohammadi%';
UPDATE comments SET expert = 'S.N. Alexander, ITIS Data Development Technician' WHERE expert LIKE  '%Alexander%';
UPDATE comments SET expert = 'Thomas Orrell, ITIS Data Development Technician' WHERE expert LIKE  '%Orrell%';
UPDATE comments SET expert = 'Todd C. McConchie, ITIS Data Development Technician' WHERE expert LIKE  'Todd%McConch%';
UPDATE comments SET expert = 'Todd C. McConchie, ITIS Data Development Technician' WHERE expert LIKE  'Todd McConchie%';
UPDATE comments SET expert = 'Todd McConchie, ITIS Data Development Technician' WHERE expert LIKE  'Todd McConchei%';
UPDATE comments SET expert = 'Todd McConchie, ITIS Data Development Technician' WHERE expert LIKE  'Todd McConchie%';
UPDATE comments SET expert = 'Wilson & Reeder, eds. (2005)' WHERE expert LIKE  '%Reeder%';
UPDATE comments SET expert = 'Zoonomen website' WHERE expert LIKE  'Zoonomen%';

# experts
ALTER TABLE experts DROP COLUMN expert_id_prefix;
ALTER TABLE experts DROP COLUMN update_date;
ALTER TABLE experts CHANGE COLUMN exp_comment area varchar(500);
ALTER TABLE experts CHANGE COLUMN expert_id id int(11);
CREATE UNIQUE INDEX i ON experts (id);

# regions
ALTER TABLE geographic_div RENAME TO regions;
ALTER TABLE regions DROP COLUMN update_date;
ALTER TABLE regions CHANGE COLUMN geographic_value region varchar(45);
ALTER TABLE regions CHANGE COLUMN tsn taxon int(11);
UPDATE regions SET region = 'Europe & Northern Asia (excluding China)' WHERE region LIKE  'Europe and%';

# taxon to area
ALTER TABLE jurisdiction RENAME TO taxon_to_area;
ALTER TABLE taxon_to_area DROP COLUMN update_date;
ALTER TABLE taxon_to_area CHANGE COLUMN jurisdiction_value area varchar(30);
ALTER TABLE taxon_to_area CHANGE COLUMN tsn taxon int(11);
ALTER TABLE taxon_to_area MODIFY area varchar(30) NOT NULL;

# kingdoms
ALTER TABLE kingdoms DROP COLUMN update_date;
ALTER TABLE kingdoms CHANGE COLUMN kingdom_id id int(11);
ALTER TABLE kingdoms CHANGE COLUMN kingdom_name kingdom char(10);
ALTER TABLE kingdoms CHANGE COLUMN id id tinyint;

# nodc
ALTER TABLE nodc_ids RENAME TO NODC;
ALTER TABLE NODC DROP COLUMN update_date;
ALTER TABLE NODC CHANGE COLUMN tsn taxon int(11);
ALTER TABLE NODC CHANGE COLUMN nodc_id id char(12);
CREATE UNIQUE INDEX NODCindex ON NODC (taxon);
CREATE UNIQUE INDEX i ON NODC (taxon);

# sources
ALTER TABLE other_sources RENAME TO sources;
ALTER TABLE sources DROP COLUMN source_id_prefix;
ALTER TABLE sources DROP COLUMN acquisition_date;
ALTER TABLE sources DROP COLUMN update_date;
ALTER TABLE sources CHANGE COLUMN source_id id int(11);
ALTER TABLE sources CHANGE COLUMN source_type type char(10);
ALTER TABLE sources CHANGE COLUMN source_comment comment varchar(500);
UPDATE sources SET type = 'website' WHERE type = '2011';
UPDATE sources SET type = 'PDF' WHERE type = 'pdf file';
UPDATE sources SET type = 'CD-ROM' WHERE type = 'CD ROM';
UPDATE sources SET type = 'CD-ROM' WHERE type = 'disk file';
CREATE UNIQUE INDEX i ON sources (id);

# publications
ALTER TABLE publications DROP COLUMN pub_id_prefix;
ALTER TABLE publications DROP COLUMN update_date;
ALTER TABLE publications CHANGE COLUMN actual_pub_date date_actual date;
ALTER TABLE publications CHANGE COLUMN listed_pub_date date_listed date;
ALTER TABLE publications CHANGE COLUMN pub_comment comment varchar(500);
ALTER TABLE publications CHANGE COLUMN publication_id id int(11);
ALTER TABLE publications CHANGE COLUMN publication_name name varchar(255);
ALTER TABLE publications CHANGE COLUMN pub_place place varchar(40);
CREATE UNIQUE INDEX i ON publications (id);

# synonyms
ALTER TABLE synonym_links RENAME TO synonyms;
ALTER TABLE synonyms DROP COLUMN update_date ;
ALTER TABLE synonyms CHANGE COLUMN tsn_accepted taxon_accepted int(11);
ALTER TABLE synonyms CHANGE COLUMN tsn taxon int(11);

# authors stripped
ALTER TABLE strippedauthor RENAME TO authors_stripped;
ALTER TABLE authors_stripped CHANGE COLUMN taxon_author_id author_taxon int(11);
ALTER TABLE authors_stripped CHANGE COLUMN shortauthor value varchar(100);
ALTER TABLE authors_stripped CHANGE COLUMN author_taxon author int(11);
ALTER TABLE authors_stripped CHANGE COLUMN author id int(11);
ALTER TABLE authors_stripped CHANGE COLUMN value author varchar(100);

# authors
ALTER TABLE taxon_authors_lkp RENAME TO authors;
ALTER TABLE authors DROP COLUMN update_date;
ALTER TABLE authors CHANGE COLUMN taxon_author_id author_taxon int(11);
ALTER TABLE authors CHANGE COLUMN kingdom_id kingdom smallint(6);
ALTER TABLE authors CHANGE COLUMN taxon_author value varchar(100);
ALTER TABLE authors CHANGE COLUMN author_taxon author int(11);
ALTER TABLE authors CHANGE COLUMN author id int(11);
ALTER TABLE authors CHANGE COLUMN value author varchar(100);
ALTER TABLE authors MODIFY author varchar(100) NOT NULL;
ALTER TABLE authors MODIFY kingdom tinyint NOT NULL;
ALTER TABLE authors ADD COLUMN stripped varchar(100);
UPDATE authors INNER JOIN authors_stripped SET stripped=authors_stripped.author WHERE authors.id = authors_stripped.id;

# vernaculars 
ALTER TABLE vernaculars DROP COLUMN approved_ind ;
ALTER TABLE vernaculars DROP COLUMN update_date;
ALTER TABLE vernaculars CHANGE COLUMN tsn taxon int(11);
ALTER TABLE vernaculars CHANGE COLUMN vern_id id int(11);
ALTER TABLE vernaculars CHANGE COLUMN vernacular_name vernacular varchar(80);
UPDATE vernaculars SET language = 'English' WHERE language = 'unspecified';

# vernacular to taxon
ALTER TABLE vern_ref_links RENAME TO vernacular_to_taxon;
ALTER TABLE vernacular_to_taxon DROP COLUMN update_date;
ALTER TABLE vernacular_to_taxon CHANGE COLUMN tsn taxon int(11);
ALTER TABLE vernacular_to_taxon CHANGE COLUMN vern_id vernacular int(11);
ALTER TABLE vernacular_to_taxon CHANGE COLUMN doc_id_prefix reference_type char(3);
ALTER TABLE vernacular_to_taxon CHANGE COLUMN documentation_id reference int(11);

# references
ALTER TABLE reference_links RENAME TO references_;
ALTER TABLE references_ DROP COLUMN change_track_id;
ALTER TABLE references_ DROP COLUMN init_itis_desc_ind;
ALTER TABLE references_ DROP COLUMN original_desc_ind ;
ALTER TABLE references_ DROP COLUMN update_date;
ALTER TABLE references_ DROP COLUMN vernacular_name;
ALTER TABLE references_ CHANGE COLUMN doc_id_prefix reference_type char(3);
ALTER TABLE references_ CHANGE COLUMN documentation_id reference int(11);
ALTER TABLE references_ CHANGE COLUMN reference_type type char(3);
ALTER TABLE references_ CHANGE COLUMN tsn taxon int(11);

# comment to taxon
ALTER TABLE tu_comments_links RENAME TO comment_to_taxon;
ALTER TABLE comment_to_taxon DROP COLUMN update_date;
ALTER TABLE comment_to_taxon CHANGE COLUMN tsn taxon int(11);
ALTER TABLE comment_to_taxon CHANGE COLUMN comment_id comment int(11);

# taxonomic units 
ALTER TABLE taxonomic_units RENAME to taxa;
ALTER TABLE taxon_unit_types RENAME TO taxonomic_units;
ALTER TABLE taxonomic_units DROP COLUMN update_date;
ALTER TABLE taxonomic_units CHANGE COLUMN rank_id id smallint(6);
ALTER TABLE taxonomic_units CHANGE COLUMN kingdom_id kingdom int(11);
ALTER TABLE taxonomic_units CHANGE COLUMN rank_name name char(15);
ALTER TABLE taxonomic_units CHANGE COLUMN dir_parent_rank_id parent_direct smallint(6);
ALTER TABLE taxonomic_units CHANGE COLUMN req_parent_rank_id parent_required smallint(6);
#UPDATE taxonomic_units SET id = id div 5; # Duplicate entry '3-50' for key 'PRIMARY'
UPDATE taxonomic_units SET parent_direct = parent_direct div 5;
UPDATE taxonomic_units SET parent_required = parent_required div 5;

# invalidity reasons
CREATE TABLE invalidity_reasons ( id tinyint auto_increment NOT NULL, invalidity_reason varchar(50), PRIMARY KEY (id));
INSERT INTO invalidity_reasons (invalidity_reason) SELECT DISTINCT unaccept_reason FROM taxa WHERE unaccept_reason is NOT NULL ORDER BY unaccept_reason;
ALTER TABLE taxa ADD COLUMN invalidity_reason tinyint;
UPDATE taxa LEFT JOIN invalidity_reasons ON taxa.unaccept_reason = invalidity_reasons.invalidity_reason SET invalidity_reason = invalidity_reasons.id;
ALTER TABLE taxa DROP COLUMN unaccept_reason;

# reviews
CREATE TABLE reviews ( id tinyint auto_increment NOT NULL, review varchar(40), PRIMARY KEY (id));
INSERT INTO reviews (review) SELECT DISTINCT credibility FROM taxa ORDER BY credibility;
ALTER TABLE taxa ADD COLUMN review tinyint;
UPDATE taxa LEFT JOIN reviews ON taxa.credibility = reviews.review SET taxa.review = reviews.id;
ALTER TABLE temp DROP COLUMN credibility;

# taxa
UPDATE taxa SET name_3 = name_4 WHERE name_4 is NOT NULL;
UPDATE taxa SET name_2 = name_3 WHERE name_3 is NOT NULL;
UPDATE taxa SET name_1 = name_2 WHERE name_2 is NOT NULL;
ALTER TABLE taxa DROP COLUMN author_hybrid;
ALTER TABLE taxa DROP COLUMN initial_time_stamp ;
ALTER TABLE taxa DROP COLUMN name_2 ;
ALTER TABLE taxa DROP COLUMN name_3 ;
ALTER TABLE taxa DROP COLUMN name_4 ;
ALTER TABLE taxa DROP COLUMN phylo_sort_seq ;
ALTER TABLE taxa DROP COLUMN unit_ind1;
ALTER TABLE taxa DROP COLUMN unit_ind2;
ALTER TABLE taxa DROP COLUMN unit_ind3;
ALTER TABLE taxa DROP COLUMN unit_ind4;
ALTER TABLE taxa DROP COLUMN update_date;
ALTER TABLE taxa ADD COLUMN nodc char(12);
UPDATE taxa INNER JOIN NODC SET taxa.nodc=nodc.id WHERE NODC.taxon = taxa.id;
ALTER TABLE taxa CHANGE COLUMN author author int(11);
ALTER TABLE taxa CHANGE COLUMN author_taxon author int(11);
ALTER TABLE taxa CHANGE COLUMN completeness_rtng completeness char(10);
ALTER TABLE taxa CHANGE COLUMN credibility_rtng credibility varchar(40);
ALTER TABLE taxa CHANGE COLUMN currency_rating currency char(7);
ALTER TABLE taxa CHANGE COLUMN hybrid_author_id author_hybrid int(11);
ALTER TABLE taxa CHANGE COLUMN invalidity_reason invalidity_reason tinyint;
ALTER TABLE taxa CHANGE COLUMN kingdom_id kingdom smallint(6);
ALTER TABLE taxa CHANGE COLUMN kingdom kingdom tinyint;
ALTER TABLE taxa CHANGE COLUMN name_1 name varchar(35);
ALTER TABLE taxa CHANGE COLUMN name_usage valid varchar(12);
ALTER TABLE taxa CHANGE COLUMN parent_tsn parent int(11);
ALTER TABLE taxa CHANGE COLUMN rank_id taxonomic_rank smallint(6);
ALTER TABLE taxa CHANGE COLUMN review review tinyint;
ALTER TABLE taxa CHANGE COLUMN taxon_author_id author_taxon int(11);
ALTER TABLE taxa CHANGE COLUMN tsn id int(11);
ALTER TABLE taxa CHANGE COLUMN uncertain_prnt_ind uncertain_print char(1);
ALTER TABLE taxa CHANGE COLUMN unit_name1 name_1 varchar(35);
ALTER TABLE taxa CHANGE COLUMN unit_name2 name_2 varchar(35);
ALTER TABLE taxa CHANGE COLUMN unit_name3 name_3 varchar(35);
ALTER TABLE taxa CHANGE COLUMN unit_name4 name_4 varchar(35);
ALTER TABLE taxa CHANGE COLUMN unnamed_taxon_ind unnamed char(1);
ALTER TABLE taxa CHANGE COLUMN valid valid char(1);
CREATE UNIQUE INDEX taxaindex ON taxa (id);
UPDATE taxa SET currency = NULL WHERE currency = '';
UPDATE taxa SET currency = NULL WHERE currency = 'unknown';
UPDATE taxa SET name_usage = 'invalid' WHERE name_usage = 'not accepted';
UPDATE taxa SET name_usage = 'valid' WHERE name_usage = 'accepted';
UPDATE taxa SET taxonomic_rank = taxonomic_rank div 5;
UPDATE taxa SET unaccept_reason = NULL WHERE name = '';
UPDATE taxa SET valid = 'N' WHERE valid = 'invalid';
UPDATE taxa SET valid = 'Y' WHERE valid = 'valid';