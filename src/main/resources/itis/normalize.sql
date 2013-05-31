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

# do the ranames up front to reducing ordering constraints
ALTER TABLE geographic_div RENAME TO geographic_region_to_taxon;
ALTER TABLE jurisdiction RENAME TO taxon_to_area;
ALTER TABLE nodc_ids RENAME TO nodc;
ALTER TABLE other_sources RENAME TO sources;
ALTER TABLE reference_links RENAME TO citations;
ALTER TABLE strippedauthor RENAME TO authors_stripped;
ALTER TABLE synonym_links RENAME TO synonyms;
ALTER TABLE taxon_authors_lkp RENAME TO authors;
ALTER TABLE taxonomic_units RENAME TO taxa;
ALTER TABLE taxon_unit_types RENAME TO taxonomic_ranks;
ALTER TABLE tu_comments_links RENAME TO comment_to_taxon;
ALTER TABLE vern_ref_links RENAME TO vernacular_to_taxon;

# comments
ALTER TABLE comments DROP COLUMN update_date;
ALTER TABLE comments CHANGE COLUMN commentator expert varchar(100) NOT NULL;
ALTER TABLE comments CHANGE COLUMN comment_detail comment text NOT NULL;
ALTER TABLE comments CHANGE COLUMN comment_id id int(11) NOT NULL;
ALTER TABLE comments CHANGE COLUMN comment_time_stamp time datetime NOT NULL;
DROP INDEX comments_index ON comments;
ALTER TABLE comments DROP PRIMARY KEY;
ALTER TABLE comments ADD PRIMARY KEY (id);
DELETE FROM comments WHERE expert LIKE "%?%";
UPDATE comments SET expert = 'Amanda Treher, ITIS Data Development Technician' WHERE expert LIKE '%Treher%';
UPDATE comments SET expert = 'Andrew K. Townesmith, ITIS Data Development Technician' WHERE expert LIKE '%Townesmith%';
UPDATE comments SET expert = 'Avid F. Mitchell, ITIS Data Development Technician' WHERE expert LIKE '%F. Mitch%';
UPDATE comments SET expert = 'Daniel Perez-Gelabert, ITIS Data Development Technician' WHERE expert LIKE '%Gelaber%';
UPDATE comments SET expert = 'David Nicolson, ITIS Data Development Technician' WHERE expert LIKE '%Nicolson%';
UPDATE comments SET expert = 'Elizabeth Eubanks, ITIS Data Development Technician' WHERE expert LIKE '%eubanks%';
UPDATE comments SET expert = 'Estelle Yoo, ITIS Data Development Technician' WHERE expert LIKE '%le yoo%';
UPDATE comments SET expert = 'F. Christian Thomson' WHERE expert LIKE 'F. Christian Thom%';
UPDATE comments SET expert = 'G. M. Nishida, 1994' WHERE expert LIKE '%ishida%';
UPDATE comments SET expert = 'H. Banford, NMFS-NEFSC, ITIS Data Development Technician' WHERE expert LIKE '%banfo%';
UPDATE comments SET expert = 'Herrick Brown, ITIS Data Development Technician' WHERE expert LIKE 'Herrick%Brown%';
UPDATE comments SET expert = 'Jenny K. Archibald' WHERE expert LIKE 'Jenny K. Ar%';
UPDATE comments SET expert = 'Jerry D. Hardy, ITIS Data Development Technician' WHERE expert LIKE 'J%Hardy%';
UPDATE comments SET expert = 'John C. Morse' WHERE expert LIKE 'John C. Morse%';
UPDATE comments SET expert = 'Michael J. Sweeney' WHERE expert LIKE 'Michael J. Swee%';
UPDATE comments SET expert = 'Natapot Warrit, ITIS Data Development Technician' WHERE expert LIKE '%Natapot Warri%';
UPDATE comments SET expert = 'Norman F. Johnson' WHERE expert LIKE 'norman%john%';
UPDATE comments SET expert = 'Payal Dharia, ITIS Data Development Technician' WHERE expert LIKE '%dhar%';
UPDATE comments SET expert = 'Quintin Gravatt, ITIS Data Development Technician' WHERE expert LIKE '%quint%';
UPDATE comments SET expert = 'Richard C. Banks' WHERE expert LIKE '%C. Banks%';
UPDATE comments SET expert = 'S. A. Slipinski' WHERE expert LIKE '%Slipinski%';
UPDATE comments SET expert = 'Scott Redhead' WHERE expert LIKE '%Redhead%';
UPDATE comments SET expert = 'Shabnam Mohammadi, ITIS Data Development Technician' WHERE expert LIKE '%Mohammadi%';
UPDATE comments SET expert = 'S.N. Alexander, ITIS Data Development Technician' WHERE expert LIKE '%Alexander%';
UPDATE comments SET expert = 'Thomas Orrell, ITIS Data Development Technician' WHERE expert LIKE '%Orrell%';
UPDATE comments SET expert = 'Todd C. McConchie, ITIS Data Development Technician' WHERE expert LIKE 'Todd%McConch%';
UPDATE comments SET expert = 'Wilson & Reeder, eds. (2005)' WHERE expert LIKE '%Reeder%';
UPDATE comments SET expert = 'Zoonomen website' WHERE expert LIKE 'Zoonomen%';

# experts
ALTER TABLE experts DROP COLUMN expert_id_prefix;
ALTER TABLE experts DROP COLUMN update_date;
ALTER TABLE experts CHANGE COLUMN exp_comment description varchar(500) NOT NULL;
ALTER TABLE experts CHANGE COLUMN expert_id id int(11) NOT NULL;
DROP INDEX experts_index ON experts;
ALTER TABLE experts DROP PRIMARY KEY;
ALTER TABLE experts ADD PRIMARY KEY (id);

# geographic_region_to_taxon
ALTER TABLE geographic_region_to_taxon DROP COLUMN update_date;
ALTER TABLE geographic_region_to_taxon CHANGE COLUMN geographic_value geographic_region_name varchar(45) NOT NULL;
ALTER TABLE geographic_region_to_taxon CHANGE COLUMN tsn taxon int(11) NOT NULL;
ALTER TABLE geographic_region_to_taxon ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
DROP INDEX geographic_index ON geographic_region_to_taxon;
ALTER TABLE geographic_region_to_taxon DROP PRIMARY KEY;
ALTER TABLE geographic_region_to_taxon ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
UPDATE geographic_region_to_taxon SET geographic_region_name = 'Europe & Northern Asia (excluding China)' WHERE geographic_region_name LIKE 'Europe and%';

# geographic_regions
CREATE TABLE geographic_regions ( id tinyint auto_increment NOT NULL, name varchar(45) NOT NULL, PRIMARY KEY (id));
INSERT INTO geographic_regions (name) SELECT DISTINCT geographic_region_name FROM geographic_region_to_taxon ORDER BY geographic_region_name;
ALTER TABLE geographic_region_to_taxon ADD COLUMN geographic_region tinyint NOT NULL;
ALTER TABLE geographic_region_to_taxon ADD FOREIGN KEY (geographic_region) REFERENCES geographic_region (id);
UPDATE geographic_region_to_taxon JOIN geographic_regions ON geographic_region_to_taxon.geographic_region_name = geographic_regions.name SET geographic_region_to_taxon.geographic_region = geographic_regions.id;
ALTER TABLE geographic_region_to_taxon DROP COLUMN geographic_region_name;

# taxon to area
ALTER TABLE taxon_to_area DROP COLUMN update_date;
ALTER TABLE taxon_to_area CHANGE COLUMN jurisdiction_value area varchar(30) NOT NULL;
ALTER TABLE taxon_to_area CHANGE COLUMN tsn taxon int(11) NOT NULL;
ALTER TABLE taxon_to_area CHANGE COLUMN area area varchar(30) NOT NULL;
ALTER TABLE taxon_to_area DROP PRIMARY KEY;
ALTER TABLE taxon_to_area ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
DROP INDEX jurisdiction_index ON taxon_to_area;
UPDATE taxon_to_area SET origin = 'Y' WHERE origin = 'Native';
UPDATE taxon_to_area SET origin = 'N' WHERE origin = 'Introduced';
ALTER TABLE taxon_to_area CHANGE COLUMN origin is_native varchar(1) NOT NULL;
# todo normalize area

# kingdoms
ALTER TABLE kingdoms DROP COLUMN update_date;
ALTER TABLE kingdoms CHANGE COLUMN kingdom_id id tinyint NOT NULL;
ALTER TABLE kingdoms CHANGE COLUMN kingdom_name kingdom char(10) NOT NULL;
DROP INDEX kingdoms_index ON kingdoms;

# sources
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
DROP INDEX other_sources_index ON sources;
ALTER TABLE experts DROP PRIMARY KEY;
ALTER TABLE experts ADD PRIMARY KEY (id);

# publications
ALTER TABLE publications DROP COLUMN pub_id_prefix;
ALTER TABLE publications DROP COLUMN update_date;
ALTER TABLE publications CHANGE COLUMN actual_pub_date date_actual date NOT NULL;
ALTER TABLE publications CHANGE COLUMN listed_pub_date date_listed date NOT NULL;
ALTER TABLE publications CHANGE COLUMN pub_comment comment varchar(500);
ALTER TABLE publications CHANGE COLUMN publication_id id int(11) NOT NULL;
ALTER TABLE publications CHANGE COLUMN publication_name name varchar(255) NOT NULL;
ALTER TABLE publications CHANGE COLUMN pub_place place varchar(40);
UPDATE publications SET publisher = NULL WHERE publisher = ''; 
UPDATE publications SET place = NULL WHERE place = ''; 
UPDATE publications SET comment = NULL WHERE comment = ''; 
ALTER TABLE publications DROP PRIMARY KEY;
ALTER TABLE publications ADD PRIMARY KEY (id);
DROP INDEX publication_inde ON publications;

# synonyms
ALTER TABLE synonyms DROP COLUMN update_date ;
ALTER TABLE synonyms CHANGE COLUMN tsn_accepted taxon_accepted int(11);
ALTER TABLE synonyms CHANGE COLUMN tsn taxon int(11);
DROP INDEX synonyms_link_index ON synonyms;
ALTER TABLE synonyms DROP PRIMARY KEY;
ALTER TABLE synonyms ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
ALTER TABLE synonyms ADD FOREIGN KEY (taxon_accepted) REFERENCES taxa (id);

# authors stripped
ALTER TABLE authors_stripped CHANGE COLUMN taxon_author_id id int(11) NOT NULL;
ALTER TABLE authors_stripped CHANGE COLUMN shortauthor author varchar(100) NOT NULL;

# authors
ALTER TABLE authors DROP COLUMN update_date;
ALTER TABLE authors CHANGE COLUMN taxon_author_id id int(11) NOT NULL;
ALTER TABLE authors CHANGE COLUMN kingdom_id kingdom tinyint NOT NULL;
ALTER TABLE authors CHANGE COLUMN taxon_author author varchar(100) NOT NULL;
ALTER TABLE authors ADD COLUMN stripped varchar(100) NOT NULL;
UPDATE authors INNER JOIN authors_stripped SET stripped=authors_stripped.author WHERE authors.id = authors_stripped.id;
DROP TABLE authors_stripped;
DROP INDEX taxon_authors_id_index ON authors;
ALTER TABLE authors DROP PRIMARY KEY;
ALTER TABLE authors ADD PRIMARY KEY (id);
ALTER TABLE authors ADD FOREIGN KEY (kingdom) REFERENCES kingdoms (id);

# vernaculars 
ALTER TABLE vernaculars DROP COLUMN approved_ind ;
ALTER TABLE vernaculars DROP COLUMN update_date;
ALTER TABLE vernaculars CHANGE COLUMN tsn taxon int(11) NOT NULL;
ALTER TABLE vernaculars CHANGE COLUMN vern_id id int(11) NOT NULL;
ALTER TABLE vernaculars CHANGE COLUMN vernacular_name vernacular varchar(80) NOT NULL;
ALTER TABLE vernaculars DROP PRIMARY KEY;
ALTER TABLE vernaculars ADD PRIMARY KEY (id);
ALTER TABLE vernaculars ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
UPDATE vernaculars SET language = 'English' WHERE language = 'unspecified';
DROP INDEX vernaculars_index1 ON vernaculars;
DROP INDEX vernaculars_index2 ON vernaculars;

# vernacular to taxon
ALTER TABLE vernacular_to_taxon DROP COLUMN update_date;
ALTER TABLE vernacular_to_taxon CHANGE COLUMN tsn taxon int(11) NOT NULL;
ALTER TABLE vernacular_to_taxon CHANGE COLUMN vern_id vernacular int(11) NOT NULL;
ALTER TABLE vernacular_to_taxon CHANGE COLUMN doc_id_prefix reference_type char(3) NOT NULL;
ALTER TABLE vernacular_to_taxon CHANGE COLUMN documentation_id reference int(11) NOT NULL;
ALTER TABLE vernacular_to_taxon DROP PRIMARY KEY;
DROP INDEX vern_rl_index1 ON vernacular_to_taxon;
DROP INDEX vern_rl_index2 ON vernacular_to_taxon;
ALTER TABLE vernacular_to_taxon ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
ALTER TABLE vernacular_to_taxon ADD FOREIGN KEY (vernacular) REFERENCES vernaculars (id);
ALTER TABLE vernacular_to_taxon ADD FOREIGN KEY (reference) REFERENCES reference_links (id);

# citations
ALTER TABLE citations DROP COLUMN change_track_id;
ALTER TABLE citations DROP COLUMN init_itis_desc_ind;
ALTER TABLE citations DROP COLUMN original_desc_ind ;
ALTER TABLE citations DROP COLUMN update_date;
ALTER TABLE citations DROP COLUMN vernacular_name;
ALTER TABLE citations CHANGE COLUMN doc_id_prefix citation_type char(3) NOT NULL;
ALTER TABLE citations CHANGE COLUMN documentation_id citation_id int(11) NOT NULL;
ALTER TABLE citations CHANGE COLUMN tsn taxon int(11) NOT NULL;
DROP INDEX reference_links_index ON citations;
ALTER TABLE authors DROP PRIMARY KEY;
ALTER TABLE authors ADD FOREIGN KEY (taxon) REFERENCES taxa (id);

# comment to taxon
ALTER TABLE comment_to_taxon DROP COLUMN update_date;
ALTER TABLE comment_to_taxon CHANGE COLUMN tsn taxon int(11) NOT NULL;
ALTER TABLE comment_to_taxon CHANGE COLUMN comment_id comment int(11) NOT NULL;
ALTER TABLE comment_to_taxon DROP PRIMARY KEY;
DROP INDEX tu_comments_links_index ON comment_to_taxon;
ALTER TABLE comment_to_taxon ADD FOREIGN KEY (taxon) REFERENCES taxa (id);
ALTER TABLE comment_to_taxon ADD FOREIGN KEY (comment) REFERENCES comments (id);

# taxonomic ranks 
ALTER TABLE taxonomic_ranks DROP COLUMN update_date;
ALTER TABLE taxonomic_ranks CHANGE COLUMN rank_id id smallint(6) NOT NULL;
ALTER TABLE taxonomic_ranks CHANGE COLUMN kingdom_id kingdom tinyint NOT NULL;
ALTER TABLE taxonomic_ranks CHANGE COLUMN rank_name name char(15) NOT NULL;
ALTER TABLE taxonomic_ranks CHANGE COLUMN dir_parent_rank_id parent_direct smallint(6) NOT NULL;
ALTER TABLE taxonomic_ranks CHANGE COLUMN req_parent_rank_id parent_required smallint(6) NOT NULL;
ALTER TABLE taxonomic_ranks ADD FOREIGN KEY (parent_direct) REFERENCES taxonomic_ranks (id);
ALTER TABLE taxonomic_ranks ADD FOREIGN KEY (parent_required) REFERENCES taxonomic_ranks (id);
DROP INDEX taxon_ut_index ON taxonomic_ranks;

# invalidity reasons
CREATE TABLE invalidity_reasons ( id tinyint auto_increment NOT NULL, invalidity_reason varchar(50) NOT NULL, PRIMARY KEY (id));
INSERT INTO invalidity_reasons (invalidity_reason) SELECT DISTINCT unaccept_reason FROM taxa WHERE unaccept_reason is NOT NULL AND unaccept_reason != '' ORDER BY unaccept_reason;
ALTER TABLE taxa ADD COLUMN invalidity_reason tinyint NOT NULL;
UPDATE taxa LEFT JOIN invalidity_reasons ON taxa.unaccept_reason = invalidity_reasons.invalidity_reason SET taxa.invalidity_reason = invalidity_reasons.id;
ALTER TABLE taxa DROP COLUMN unaccept_reason;

# reviews
CREATE TABLE reviews ( id tinyint auto_increment NOT NULL, review varchar(40) NOT NULL, PRIMARY KEY (id));
INSERT INTO reviews (review) SELECT DISTINCT credibility_rtng as credibility FROM taxa ORDER BY credibility;
ALTER TABLE taxa ADD COLUMN review tinyint NOT NULL;
UPDATE taxa LEFT JOIN reviews ON taxa.credibility_rtng = reviews.review SET taxa.review = reviews.id;
ALTER TABLE taxa DROP COLUMN credibility_rtng;

# taxa
UPDATE taxa SET unit_name3 = unit_name4 WHERE unit_name4 is NOT NULL;
UPDATE taxa SET unit_name2 = unit_name3 WHERE unit_name3 is NOT NULL;
UPDATE taxa SET unit_name1 = unit_name2 WHERE unit_name2 is NOT NULL;
ALTER TABLE taxa DROP COLUMN hybrid_author_id;
ALTER TABLE taxa DROP COLUMN initial_time_stamp ;
ALTER TABLE taxa DROP COLUMN unit_name2 ;
ALTER TABLE taxa DROP COLUMN unit_name3 ;
ALTER TABLE taxa DROP COLUMN unit_name4 ;
ALTER TABLE taxa DROP COLUMN phylo_sort_seq ;
ALTER TABLE taxa DROP COLUMN unit_ind1;
ALTER TABLE taxa DROP COLUMN unit_ind2;
ALTER TABLE taxa DROP COLUMN unit_ind3;
ALTER TABLE taxa DROP COLUMN unit_ind4;
ALTER TABLE taxa DROP COLUMN update_date;
DROP INDEX taxaindex ON taxa;
DROP INDEX taxon_unit_index1 ON taxa;
DROP INDEX taxon_unit_index2 ON taxa;
DROP INDEX taxon_unit_index3 ON taxa;
DROP INDEX taxon_unit_index4 ON taxa;
ALTER TABLE taxa CHANGE COLUMN taxon_author_id author int(11) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN currency_rating currency char(7) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN completeness_rtng completeness char(10) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN invalidity_reason invalidity_reason tinyint NOT NULL;
ALTER TABLE taxa CHANGE COLUMN kingdom_id kingdom tinyint NOT NULL;
ALTER TABLE taxa CHANGE COLUMN name_usage valid char(12) NOT NULL;  
ALTER TABLE taxa CHANGE COLUMN parent_tsn parent int(11) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN rank_id taxonomic_rank smallint(6) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN review review tinyint(4) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN tsn id int(11) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN uncertain_prnt_ind uncertain_print char(1) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN unit_name1 name varchar(35) NOT NULL;
ALTER TABLE taxa CHANGE COLUMN unnamed_taxon_ind is_unnamed char(1) NOT NULL;
CREATE UNIQUE INDEX taxaindex ON taxa (id);
UPDATE taxa SET currency = NULL WHERE currency = '';
UPDATE taxa SET currency = NULL WHERE currency = 'unknown';
UPDATE taxa SET completeness = NULL WHERE completeness = '';
UPDATE taxa SET completeness = NULL WHERE completeness = 'unknown';
UPDATE taxa SET invalidity_reason = NULL WHERE name = '';
UPDATE taxa SET is_unamed = 'Y' WHERE is_unnamed = '';
UPDATE taxa SET valid = 'N' WHERE valid = 'invalid';
UPDATE taxa SET valid = 'Y' WHERE valid = 'valid';
UPDATE taxa SET valid = 'N' WHERE valid = 'not accepted';
UPDATE taxa SET valid = 'Y' WHERE valid = 'accepted';
ALTER TABLE taxa CHANGE COLUMN valid valid char(1) NOT NULL;
ALTER TABLE taxa ADD FOREIGN KEY (author) REFERENCES authors (id);
ALTER TABLE taxa ADD FOREIGN KEY (kingdom) REFERENCES kingdoms (id);
ALTER TABLE taxa ADD FOREIGN KEY (parent) REFERENCES taxa (id);
ALTER TABLE taxa ADD FOREIGN KEY (taxonomic_rank) REFERENCES taxonomic_ranks (id);
ALTER TABLE taxa ADD FOREIGN KEY (review) REFERENCES reviews (id);

# nodc
ALTER TABLE nodc CHANGE COLUMN tsn taxon int(11);
ALTER TABLE nodc CHANGE COLUMN nodc_id id char(12);
ALTER TABLE taxa ADD COLUMN nodc char(12) NOT NULL;
UPDATE taxa INNER JOIN nodc SET taxa.nodc=nodc.id WHERE nodc.taxon = taxa.id;
DROP TABLE nodc;

# divide taxonomic_ranks by 5...
# UPDATE taxonomic_ranks SET id = id div 5; # Duplicate entry '3-50' for key 'PRIMARY'
# UPDATE taxonomic_ranks SET parent_direct = parent_direct div 5;
# UPDATE taxonomic_ranks SET parent_required = parent_required div 5;
# UPDATE taxa SET taxonomic_rank = taxonomic_rank div 5;
