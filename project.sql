DROP TABLE IF EXISTS match;
DROP TABLE IF EXISTS play_in_match;
DROP TABLE IF EXISTS play;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS fitness;
DROP TABLE IF EXISTS contract;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS stadium;
DROP TABLE IF EXISTS dealer;
DROP TABLE IF EXISTS trainer;
DROP TABLE IF EXISTS employee;

/* tables */
CREATE TABLE fitness
(
  body_strength DOUBLE PRECISION,
  passing       DOUBLE PRECISION,
  ball_making   DOUBLE PRECISION,
  goal_making   DOUBLE PRECISION,
  shoot_making  DOUBLE PRECISION,
  speed         DOUBLE PRECISION,
  goal_keeping  DOUBLE PRECISION,
  fitness_pk    SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE public.employee
(
  employee_pk SERIAL PRIMARY KEY,
  type        VARCHAR(20) CHECK (type IN ('dealer', 'tactic_trainer', 'body_trainer', 'goalkeeper_trainer')) NOT NULL,
  name        VARCHAR(20)                                                                                    NOT NULL,
  percent     INT                                                                                            NOT NULL
);


CREATE TABLE player
(
  player_pk  SERIAL PRIMARY KEY NOT NULL,
  Name       VARCHAR(20)        NOT NULL,
  specialty  VARCHAR(20) CHECK (specialty IN ('goalkeeper', 'attacker', 'defender', 'midfielder')),
  fitness_fk INTEGER            NOT NULL,
  CONSTRAINT fitness_fk FOREIGN KEY (fitness_fk) REFERENCES fitness (fitness_pk)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE stadium
(
  stadium_pk VARCHAR(40) PRIMARY KEY NOT NULL,
  capacity   INT     DEFAULT 0,
  seat       INT     DEFAULT 0,
  field      INT     DEFAULT 0,
  name       VARCHAR(30),
  coast      INTEGER DEFAULT 0,
  toilet     INTEGER DEFAULT 0
);


CREATE TABLE team
(
  name       VARCHAR(20),
  team_pk    SERIAL PRIMARY KEY NOT NULL,
  stadium_fk VARCHAR(40),
  CONSTRAINT stadium_fk FOREIGN KEY (stadium_fk) REFERENCES stadium (stadium_pk) INITIALLY DEFERRED
);

CREATE TABLE public.contract
(
  id           SERIAL PRIMARY KEY NOT NULL,
  price        INT                NOT NULL,
  employee__fk INTEGER            NOT NULL,
  team_fk      INTEGER            NOT NULL,
  CONSTRAINT team___fk FOREIGN KEY (team_fk) REFERENCES team (team_pk)
  ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT employee___fk FOREIGN KEY (employee__fk) REFERENCES employee (employee_pk)
  ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE play
(
  play_pk   VARCHAR(20) PRIMARY KEY NOT NULL,
  player_fk INTEGER                 NOT NULL,
  team_fk   INTEGER                 NOT NULL,
  CONSTRAINT player_fk FOREIGN KEY (player_fk)
  REFERENCES player (player_pk) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT team_fk FOREIGN KEY (team_fk)
  REFERENCES team (team_pk) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE match
(
  time     DATE,
  host     INTEGER,
  guest    INTEGER,
  match_pk SERIAL PRIMARY KEY NOT NULL,
  /* when host lost the game result is lost */
  result   VARCHAR(20) CHECK (result IN ('lost', 'win', 'equal')),
  CONSTRAINT host_constraint FOREIGN KEY (host) REFERENCES team (team_pk),
  CONSTRAINT guest_constraint FOREIGN KEY (guest) REFERENCES team (team_pk)
);


CREATE TABLE play_in_match
(
  player_fk        INTEGER,
  number           INTEGER,
  play_in_match_pk SERIAL PRIMARY KEY NOT NULL,
  post             VARCHAR(20) CHECK (post IN ('goalkeeper', 'attacker', 'defender', 'midfielder')),
  CONSTRAINT player_constrain FOREIGN KEY (player_fk) REFERENCES player (player_pk)
);


/* inserts */
INSERT INTO fitness
(body_strength, passing, ball_making, goal_making, shoot_making, speed, goal_keeping, fitness_pk) VALUES
  (91, 85, 67, 92, 80, 85, 90, 1),
  (89, 83, 87, 88, 89, 90, 91, 2),
  (90, 91, 77, 77, 88, 93, 88, 3),
  (86, 93, 79, 81, 91, 90, 80, 4),
  (88, 89, 80, 79, 78, 88, 75, 5),
  (93, 86, 76, 80, 79, 87, 77, 6),
  (95, 79, 82, 83, 84, 79, 79, 7),
  (69, 84, 91, 94, 93, 82, 90, 8),
  (91, 85, 67, 92, 80, 85, 90, 9),
  (89, 83, 87, 88, 89, 90, 91, 10),
  (90, 91, 77, 77, 88, 93, 88, 11),
  (86, 93, 79, 81, 91, 90, 80, 12),
  (88, 89, 80, 79, 78, 88, 75, 13),
  (93, 86, 76, 80, 79, 87, 77, 14),
  (95, 79, 82, 83, 84, 79, 79, 15),
  (69, 84, 91, 94, 93, 82, 90, 16),
  (91, 85, 67, 92, 80, 85, 90, 17),
  (89, 83, 87, 88, 89, 90, 91, 18),
  (90, 91, 77, 77, 88, 93, 88, 19),
  (86, 93, 79, 81, 91, 90, 80, 20),
  (88, 89, 80, 79, 78, 88, 75, 21),
  (93, 86, 76, 80, 79, 87, 77, 22),
  (95, 79, 82, 83, 84, 79, 79, 23),
  (69, 84, 91, 94, 93, 82, 90, 24),
  (91, 85, 67, 92, 80, 85, 90, 25),
  (89, 83, 87, 88, 89, 90, 91, 26),
  (90, 91, 77, 77, 88, 93, 88, 27),
  (86, 93, 79, 81, 91, 90, 80, 28),
  (88, 89, 80, 79, 78, 88, 75, 29),
  (93, 86, 76, 80, 79, 87, 77, 30),
  (95, 79, 82, 83, 84, 79, 79, 31),
  (69, 84, 91, 94, 93, 82, 90, 32),
  (91, 85, 67, 92, 80, 85, 90, 33),
  (89, 83, 87, 88, 89, 90, 91, 34),
  (90, 91, 77, 77, 88, 93, 88, 35),
  (86, 93, 79, 81, 91, 90, 80, 36),
  (88, 89, 80, 79, 78, 88, 75, 37),
  (93, 86, 76, 80, 79, 87, 77, 38),
  (95, 79, 82, 83, 84, 79, 79, 39),
  (69, 84, 91, 94, 93, 82, 90, 40),
  (91, 85, 67, 92, 80, 85, 90, 41),
  (89, 83, 87, 88, 89, 90, 91, 42),
  (90, 91, 77, 77, 88, 93, 88, 43),
  (86, 93, 79, 81, 91, 90, 80, 44),
  (88, 89, 80, 79, 78, 88, 75, 45),
  (93, 86, 76, 80, 79, 87, 77, 46),
  (95, 79, 82, 83, 84, 79, 79, 47),
  (69, 84, 91, 94, 93, 82, 90, 48),
  (91, 85, 67, 92, 80, 85, 90, 49),
  (89, 83, 87, 88, 89, 90, 91, 50),
  (90, 91, 77, 77, 88, 93, 88, 51),
  (86, 93, 79, 81, 91, 90, 80, 52),
  (88, 89, 80, 79, 78, 88, 75, 53),
  (93, 86, 76, 80, 79, 87, 77, 54),
  (95, 79, 82, 83, 84, 79, 79, 55),
  (69, 84, 91, 94, 93, 82, 90, 56),
  (91, 85, 67, 92, 80, 85, 90, 57),
  (89, 83, 87, 88, 89, 90, 91, 58),
  (90, 91, 77, 77, 88, 93, 88, 59),
  (86, 93, 79, 81, 91, 90, 80, 60),
  (88, 89, 80, 79, 78, 88, 75, 61),
  (93, 86, 76, 80, 79, 87, 77, 62),
  (95, 79, 82, 83, 84, 79, 79, 63),
  (69, 84, 91, 94, 93, 82, 90, 64),
  (91, 85, 67, 92, 80, 85, 90, 65),
  (89, 83, 87, 88, 89, 90, 91, 66),
  (90, 91, 77, 77, 88, 93, 88, 67),
  (86, 93, 79, 81, 91, 90, 80, 68),
  (88, 89, 80, 79, 78, 88, 75, 69),
  (93, 86, 76, 80, 79, 87, 77, 70),
  (95, 79, 82, 83, 84, 79, 79, 71),
  (69, 84, 91, 94, 93, 82, 90, 72),
  (91, 85, 67, 92, 80, 85, 90, 73),
  (89, 83, 87, 88, 89, 90, 91, 74),
  (90, 91, 77, 77, 88, 93, 88, 75),
  (86, 93, 79, 81, 91, 90, 80, 76),
  (88, 89, 80, 79, 78, 88, 75, 77),
  (93, 86, 76, 80, 79, 87, 77, 78),
  (95, 79, 82, 83, 84, 79, 79, 79),
  (69, 84, 91, 94, 93, 82, 90, 80),
  (91, 85, 67, 92, 80, 85, 90, 81),
  (89, 83, 87, 88, 89, 90, 91, 82),
  (90, 91, 77, 77, 88, 93, 88, 83),
  (86, 93, 79, 81, 91, 90, 80, 84),
  (88, 89, 80, 79, 78, 88, 75, 85),
  (93, 86, 76, 80, 79, 87, 77, 86),
  (95, 79, 82, 83, 84, 79, 79, 87),
  (69, 84, 91, 94, 93, 82, 90, 88),
  (91, 85, 67, 92, 80, 85, 90, 89),
  (89, 83, 87, 88, 89, 90, 91, 90),
  (90, 91, 77, 77, 88, 93, 88, 91),
  (86, 93, 79, 81, 91, 90, 80, 92),
  (88, 89, 80, 79, 78, 88, 75, 93),
  (93, 86, 76, 80, 79, 87, 77, 94),
  (95, 79, 82, 83, 84, 79, 79, 95),
  (69, 84, 91, 94, 93, 82, 90, 96),
  (91, 85, 67, 92, 80, 85, 90, 97),
  (89, 83, 87, 88, 89, 90, 91, 98),
  (90, 91, 77, 77, 88, 93, 88, 99),
  (86, 93, 79, 81, 91, 90, 80, 100),
  (88, 89, 80, 79, 78, 88, 75, 101),
  (93, 86, 76, 80, 79, 87, 77, 102),
  (95, 79, 82, 83, 84, 79, 79, 103),
  (69, 84, 91, 94, 93, 82, 90, 104),
  (91, 85, 67, 92, 80, 85, 90, 105),
  (89, 83, 87, 88, 89, 90, 91, 106),
  (90, 91, 77, 77, 88, 93, 88, 107),
  (86, 93, 79, 81, 91, 90, 80, 108),
  (88, 89, 80, 79, 78, 88, 75, 109),
  (93, 86, 76, 80, 79, 87, 77, 110),
  (95, 79, 82, 83, 84, 79, 79, 111),
  (69, 84, 91, 94, 93, 82, 90, 112),
  (91, 85, 67, 92, 80, 85, 90, 113),
  (89, 83, 87, 88, 89, 90, 91, 114),
  (90, 91, 77, 77, 88, 93, 88, 115),
  (86, 93, 79, 81, 91, 90, 80, 116),
  (88, 89, 80, 79, 78, 88, 75, 117),
  (93, 86, 76, 80, 79, 87, 77, 118),
  (95, 79, 82, 83, 84, 79, 79, 119),
  (69, 84, 91, 94, 93, 82, 90, 120),
  (91, 85, 67, 92, 80, 85, 90, 121),
  (89, 83, 87, 88, 89, 90, 91, 122),
  (90, 91, 77, 77, 88, 93, 88, 123),
  (86, 93, 79, 81, 91, 90, 80, 124),
  (88, 89, 80, 79, 78, 88, 75, 125),
  (93, 86, 76, 80, 79, 87, 77, 126),
  (95, 79, 82, 83, 84, 79, 79, 127),
  (69, 84, 91, 94, 93, 82, 90, 128),
  (91, 85, 67, 92, 80, 85, 90, 129),
  (89, 83, 87, 88, 89, 90, 91, 130),
  (90, 91, 77, 77, 88, 93, 88, 131),
  (86, 93, 79, 81, 91, 90, 80, 132),
  (88, 89, 80, 79, 78, 88, 75, 133),
  (93, 86, 76, 80, 79, 87, 77, 134),
  (95, 79, 82, 83, 84, 79, 79, 135),
  (69, 84, 91, 94, 93, 82, 90, 136),
  (91, 85, 67, 92, 80, 85, 90, 137),
  (89, 83, 87, 88, 89, 90, 91, 138),
  (90, 91, 77, 77, 88, 93, 88, 139),
  (86, 93, 79, 81, 91, 90, 80, 140),
  (88, 89, 80, 79, 78, 88, 75, 141),
  (93, 86, 76, 80, 79, 87, 77, 142),
  (95, 79, 82, 83, 84, 79, 79, 143),
  (69, 84, 91, 94, 93, 82, 90, 144),
  (91, 85, 67, 92, 80, 85, 90, 145),
  (89, 83, 87, 88, 89, 90, 91, 146),
  (90, 91, 77, 77, 88, 93, 88, 147),
  (86, 93, 79, 81, 91, 90, 80, 148),
  (88, 89, 80, 79, 78, 88, 75, 149),
  (93, 86, 76, 80, 79, 87, 77, 150),
  (95, 79, 82, 83, 84, 79, 79, 151),
  (69, 84, 91, 94, 93, 82, 90, 152),
  (95, 92, 91, 94, 93, 91, 90, 153);

INSERT INTO player
(player_pk, Name, Specialty, fitness_fk) VALUES
  ('1', 'asghar', 'goalkeeper', 1),
  ('2', 'akbar', 'attacker', 2),
  ('3', 'shangul', 'attacker', 3),
  ('4', 'mangul', 'attacker', 4),
  ('5', 'sina', 'defender', 5),
  ('6', 'moli', 'defender', 6),
  ('7', 'gholi', 'defender', 7),
  ('8', 'sinsin', 'midfielder', 9),
  ('9', 'LeoMessi', 'attacker', 10),
  ('10', 'CristianoRonaldo', 'attacker', 11),
  ('11', 'Xavi', 'midfielder', 12),
  ('12', 'Andres Iniesta', 'midfielder', 13),
  ('13', 'Zlatan Ibrahimovic', 'attacker', 14),
  ('14', 'Radamel Falcao', 'attacker', 15),
  ('15', 'Robin van Persie', 'attacker', 16),
  ('16', 'Andrea Pirlo', 'midfielder', 17),
  ('17', 'Yaya Toure', 'midfielder', 18),
  ('18', 'Edinson Cavani', 'attacker', 19),
  ('19', 'Sergio Aguero', 'attacker', 20),
  ('20', 'Iker Casillas', 'goalkeeper', 21),
  ('21', 'Neymar', 'attacker', 22),
  ('22', 'Xabi Alonso', 'midfielder', 23),
  ('24', 'Sergio Ramos', 'defender', 24),
  ('25', 'Willian', 'midfielder', 25),
  ('26', 'Marco Reus', 'attacker', 26),
  ('27', 'Franck Ribery', 'midfielder', 27),
  ('28', 'Ashley Cole', 'defender', 28),
  ('29', 'Wayne Rooney', 'attacker', 29),
  ('30', 'Juan Mata', 'midfielder', 30),
  ('31', 'Thomas Muller', 'attacker', 31),
  ('32', 'Juan Mata', 'midfielder', 32),
  ('33', 'Mario Götze', 'midfielder', 33),
  ('34', 'Karim Benzema', 'attacker', 34),
  ('35', 'Gareth Bale', 'defender', 35),
  ('36', 'Javier Zanetti', 'defender', 36),
  ('37', 'Daniele De Rossi', 'midfielder', 37),
  ('38', 'Dani Alves', 'defender', 38),
  ('39', 'Joe Hart', 'goalkeeper', 39),
  ('40', 'Arjen Robben', 'midfielder', 40),
  ('41', 'Hernanes', 'midfielder', 41),
  ('42', 'Manuel Neuer', 'goalkeeper', 42),
  ('43', 'Pedro', 'attacker', 43),
  ('44', 'Joao Moutinho', 'midfielder', 44),
  ('45', 'Patrice Evra', 'defender', 45),
  ('46', 'asghar1', 'goalkeeper', 46),
  ('47', 'akbar1', 'attacker', 47),
  ('48', 'shangul1', 'attacker', 48),
  ('49', 'mangul1', 'attacker', 49),
  ('50', 'sina1', 'defender', 50),
  ('51', 'moli1', 'defender', 51),
  ('52', 'gholi1', 'defender', 52),
  ('53', 'sinsin1', 'midfielder', 53),
  ('54', 'LeoMessi1', 'attacker', 54),
  ('55', 'CristianoRonaldo1', 'attacker', 55),
  ('56', 'Xavi1', 'midfielder', 56),
  ('57', 'Andres Iniesta1', 'midfielder', 57),
  ('58', 'Zlatan Ibrahimovic1', 'attacker', 58),
  ('59', 'Radamel Falcao1', 'attacker', 59),
  ('60', 'Robin van Persie1', 'attacker', 60),
  ('61', 'Andrea Pirlo1', 'midfielder', 61),
  ('62', 'Yaya Toure1', 'midfielder', 62),
  ('63', 'Edinson Cavani1', 'attacker', 63),
  ('64', 'Sergio Aguero1', 'attacker', 64),
  ('65', 'Iker Casillas1', 'goalkeeper', 65),
  ('66', 'Neymar1', 'attacker', 66),
  ('67', 'Xabi Alonso1', 'midfielder', 67),
  ('68', 'Sergio Ramos1', 'defender', 68),
  ('69', 'Willian1', 'midfielder', 69),
  ('70', 'Marco Reus1', 'attacker', 70),
  ('71', 'Franck Ribery1', 'midfielder', 71),
  ('72', 'Ashley Cole1', 'defender', 72),
  ('73', 'Wayne Rooney1', 'attacker', 73),
  ('74', 'Juan Mata1', 'midfielder', 74),
  ('75', 'Thomas Muller1', 'attacker', 75),
  ('76', 'Juan Mata1', 'midfielder', 76),
  ('77', 'Mario Götze1', 'midfielder', 77),
  ('78', 'Karim Benzema1', 'attacker', 78),
  ('79', 'Gareth Bale1', 'defender', 79),
  ('80', 'Javier Zanetti1', 'defender', 80),
  ('81', 'Daniele De Rossi1', 'midfielder', 81),
  ('82', 'Dani Alves1', 'defender', 82),
  ('83', 'Joe Hart1', 'goalkeeper', 83),
  ('84', 'Arjen Robben1', 'midfielder', 84),
  ('85', 'Hernanes1', 'midfielder', 85),
  ('86', 'Manuel Neuer1', 'goalkeeper', 86),
  ('87', 'Pedro1', 'attacker', 87),
  ('88', 'Joao Moutinho1', 'midfielder', 88),
  ('89', 'Patrice Evra1', 'defender', 89),
  ('90', 'asghar2', 'goalkeeper', 90),
  ('91', 'akbar2', 'attacker', 91),
  ('92', 'shangul2', 'attacker', 92),
  ('93', 'mangul2', 'attacker', 93),
  ('94', 'sina2', 'defender', 94),
  ('95', 'moli2', 'defender', 95),
  ('96', 'gholi2', 'defender', 96),
  ('97', 'sinsin2', 'midfielder', 97),
  ('98', 'LeoMessi2', 'attacker', 98),
  ('99', 'CristianoRonaldo2', 'attacker', 99),
  ('100', 'Xavi2', 'midfielder', 100),
  ('101', 'Andres Iniesta2', 'midfielder', 101),
  ('102', 'Zlatan Ibrahimovic2', 'attacker', 102),
  ('103', 'Radamel Falcao2', 'attacker', 103),
  ('104', 'Robin van Persie2', 'attacker', 104),
  ('105', 'Andrea Pirlo2', 'midfielder', 105),
  ('106', 'Yaya Toure2', 'midfielder', 106),
  ('107', 'Edinson Cavani2', 'attacker', 107),
  ('108', 'Sergio Aguero2', 'attacker', 108),
  ('109', 'Iker Casillas2', 'goalkeeper', 109),
  ('110', 'Neymar2', 'attacker', 110),
  ('111', 'Xabi Alonso2', 'midfielder', 11),
  ('112', 'Sergio Ramos2', 'defender', 112),
  ('113', 'Willian2', 'midfielder', 113),
  ('114', 'Marco Reus2', 'attacker', 114),
  ('115', 'Franck Ribery2', 'midfielder', 115),
  ('116', 'Ashley Cole2', 'defender', 116),
  ('117', 'Wayne Rooney2', 'attacker', 117),
  ('118', 'Juan Mata2', 'midfielder', 118),
  ('119', 'Thomas Muller2', 'attacker', 119),
  ('120', 'Juan Mata2', 'midfielder', 120),
  ('121', 'Mario Götze2', 'midfielder', 121),
  ('122', 'Karim Benzema2', 'attacker', 122),
  ('123', 'Gareth Bale2', 'defender', 123),
  ('124', 'Javier Zanetti2', 'defender', 124),
  ('125', 'Daniele De Rossi2', 'midfielder', 125),
  ('126', 'Dani Alves2', 'defender', 126),
  ('127', 'Joe Hart2', 'goalkeeper', 127),
  ('128', 'Arjen Robben2', 'midfielder', 128),
  ('129', 'Hernanes2', 'midfielder', 129),
  ('130', 'Manuel Neuer2', 'goalkeeper', 130),
  ('131', 'Pedro2', 'attacker', 131),
  ('132', 'Joao Moutinho2', 'midfielder', 132),
  ('133', 'Patrice Evra2', 'defender', 133),
  ('134', 'asghar3', 'goalkeeper', 134),
  ('135', 'akbar3', 'attacker', 135),
  ('136', 'shangul3', 'attacker', 136),
  ('137', 'mangul3', 'attacker', 137),
  ('138', 'sina3', 'defender', 138),
  ('139', 'moli3', 'defender', 139),
  ('140', 'gholi3', 'defender', 140),
  ('141', 'sinsin3', 'midfielder', 141),
  ('142', 'LeoMessi3', 'attacker', 142),
  ('143', 'CristianoRonaldo3', 'attacker', 143),
  ('144', 'Xavi3', 'midfielder', 144),
  ('145', 'Andres Iniesta3', 'midfielder', 145),
  ('146', 'Zlatan Ibrahimovic3', 'attacker', 146),
  ('147', 'Radamel Falcao3', 'attacker', 147),
  ('148', 'Robin van Persie3', 'attacker', 148),
  ('149', 'Andrea Pirlo3', 'midfielder', 149),
  ('150', 'Yaya Toure3', 'midfielder', 150),
  ('151', 'Edinson Cavani3', 'attacker', 151),
  ('152', 'Sergio Aguero3', 'attacker', 152),
  ('153', 'Ali', 'attacker', 153);

INSERT INTO stadium
(stadium_pk, capacity, seat, field, name, toilet) VALUES
  ('1', 92500, 92500, 1000, 'Camp Nou', 100),
  ('2', 81000, 81000, 1000, 'Santiago Bernabéu', 100),
  ('3', 75000, 75000, 1000, 'Adelaide Arena', 100),
  ('4', 92500, 92500, 1000, 'Allianz Stadium', 100),
  ('5', 93000, 93000, 1000, 'Allphones Arena', 100),
  ('6', 100000, 100000, 1000, 'ANZ Stadium', 100),
  ('7', 60000, 60000, 1000, 'Aurora Stadium', 100),
  ('8', 50000, 50000, 1000, 'Bendigo Bank Stadium', 100),
  ('9', 65000, 65000, 1000, 'Blundstone Arena', 100),
  ('10', 30000, 30000, 1000, 'Brownes Stadium', 100),
  ('11', 80000, 80000, 1000, 'Cbus Super Stadium', 100),
  ('12', 50000, 50000, 1000, 'City Mazda Stadium', 100),
  ('13', 92500, 92500, 1000, 'Dairy Farmers Stadium', 100),
  ('14', 100000, 100000, 1000, 'Domain Stadium', 100),
  ('15', 25000, 25000, 1000, 'Etihad Stadium', 100),
  ('16', 36000, 36000, 1000, 'Hisense Arena', 100),
  ('17', 56000, 56000, 1000, 'Holden Centre', 100),
  ('18', 120000, 120000, 1000, 'Hunter Stadium', 100),
  ('19', 60000, 60000, 1000, 'Medibank Stadium', 100),
  ('20', 50000, 50000, 1000, 'nib Stadium', 100),
  ('21', 65000, 65000, 1000, 'Pepper Stadium', 100),
  ('22', 30000, 30000, 1000, 'Simonds Stadium', 100),
  ('23', 80000, 80000, 1000, 'Steel Blue Oval', 100),
  ('24', 50000, 50000, 1000, 'Suncorp Stadium', 100),
  ('25', 92500, 92500, 1000, 'TIO Stadium', 100),
  ('26', 100000, 100000, 1000, 'WIN Entertainment Centre', 100),
  ('27', 25000, 25000, 1000, 'Cashpoint Arena', 100),
  ('28', 36000, 36000, 1000, 'Red Bull Arena', 100),
  ('29', 56000, 56000, 1000, 'Red Bull Ring', 100),
  ('30', 120000, 120000, 1000, 'UPC-Arena', 100),
  ('31', 79000, 79000, 1000, 'Generali Arena', 100),
  ('32', 80000, 80000, 1000, 'Allianz Stadion', 100),
  ('33', 50000, 50000, 1000, 'Cristal Arena', 100),
  ('34', 92500, 92500, 1000, 'Ghelamco Arena', 100),
  ('35', 100000, 100000, 1000, 'Allianz Parque', 100),
  ('36', 25000, 25000, 1000, 'ENMAX Centre', 100),
  ('37', 36000, 36000, 1000, 'MTS Centre', 100),
  ('38', 56000, 56000, 1000, 'Mosaic Stadium', 100),
  ('39', 120000, 120000, 1000, 'Azadi', 100),
  ('40', 60000, 60000, 1000, 'SINA & ALI', 100);

INSERT INTO team
(name, stadium_fk) VALUES
  ('Barcelona', '1'),
  ('RealMadrid', '2'),
  ('bayern', '3'),
  ('ACMilan', '4'),
  ('zaragoza', '5'),
  ('liverpool', '6'),
  ('arsenal', '7'),
  ('atletico', '8'),
  ('chelsea', '9'),
  ('ManchesterCity', '10'),
  ('Burnley', '11'),
  ('StokeCity', '12'),
  ('Watford', '13'),
  ('NewcastleUnited', '14'),
  ('Southampton', '15'),
  ('TottenhamHotspur', '16'),
  ('LeicesterCity', '17'),
  ('Everton', '18'),
  ('HuddersfieldTown', '19'),
  ('ManchesterUnited', '20');

INSERT INTO play
(play_pk, player_fk, team_fk) VALUES
  ('1', '1', '1'),
  ('2', '2', '1'),
  ('3', '3', '1'),
  ('4', '4', '1'),
  ('5', '5', '2'),
  ('6', '6', '2'),
  ('7', '7', '2'),
  ('8', '8', '2'),
  ('9', '9', '3'),
  ('10', '10', '3'),
  ('11', '11', '3'),
  ('12', '12', '3'),
  ('13', '13', '4'),
  ('14', '14', '4'),
  ('15', '15', '4'),
  ('16', '16', '4'),
  ('17', '17', '5'),
  ('18', '18', '5'),
  ('19', '19', '5'),
  ('20', '20', '5'),
  ('21', '21', '6'),
  ('22', '22', '6'),
  ('23', '23', '6'),
  ('24', '24', '6'),
  ('25', '25', '7'),
  ('26', '26', '7'),
  ('27', '27', '7'),
  ('28', '28', '7'),
  ('29', '29', '8'),
  ('30', '30', '8'),
  ('31', '31', '8'),
  ('32', '32', '8'),
  ('33', '33', '9'),
  ('34', '34', '9'),
  ('35', '35', '9'),
  ('36', '36', '9'),
  ('37', '37', '10'),
  ('38', '38', '10'),
  ('39', '39', '10'),
  ('40', '40', '10'),
  ('41', '41', '11'),
  ('42', '42', '11'),
  ('43', '43', '11'),
  ('44', '44', '11'),
  ('45', '45', '12'),
  ('46', '46', '12'),
  ('47', '47', '12'),
  ('48', '48', '12'),
  ('49', '49', '13'),
  ('50', '50', '13'),
  ('51', '51', '13'),
  ('52', '52', '13'),
  ('53', '53', '14'),
  ('54', '54', '14'),
  ('55', '55', '14'),
  ('56', '56', '14'),
  ('57', '57', '15'),
  ('58', '58', '15'),
  ('59', '59', '15'),
  ('60', '60', '15'),
  ('61', '61', '16'),
  ('62', '62', '16'),
  ('63', '63', '16'),
  ('64', '64', '16'),
  ('65', '65', '17'),
  ('66', '66', '17'),
  ('67', '67', '17'),
  ('68', '68', '17'),
  ('69', '69', '18'),
  ('70', '70', '18'),
  ('71', '71', '18'),
  ('72', '72', '18'),
  ('73', '73', '19'),
  ('74', '74', '19'),
  ('75', '75', '19'),
  ('76', '76', '19'),
  ('77', '77', '20'),
  ('78', '78', '20'),
  ('79', '79', '20'),
  ('80', '80', '20');

INSERT INTO employee (type, name, percent) VALUES
  ('dealer','sina',10),
  ('dealer','sina2',10),
  ('tactic_trainer','sina',10),
  ('tactic_trainer','sina2',10),
  ('body_trainer','sina',10),
  ('body_trainer','sina2',10),
  ('goalkeeper_trainer','sina',10),
  ('goalkeeper_trainer','sina2',10),
  ('dealer','asghar',10),
  ('dealer','asghar2',10),
  ('tactic_trainer','asghar3',10),
  ('tactic_trainer','akbar',10),
  ('body_trainer','akbar2',10),
  ('body_trainer','akbar3',10),
  ('goalkeeper_trainer','saeed',10),
  ('goalkeeper_trainer','saeed2',10),
  ('tactic_trainer','saeed3',10),
  ('tactic_trainer','saman',10),
  ('body_trainer','saman1',10),
  ('body_trainer','saman2',10),
  ('goalkeeper_trainer','saman3',10),
  ('goalkeeper_trainer','soroosh',10),
  ('dealer','soroosh2',10),
  ('dealer','soroosh3',10),
  ('tactic_trainer','arash',10),
  ('tactic_trainer','arash1',10),
  ('body_trainer','arash2',10),
  ('body_trainer','arash3',10),
  ('goalkeeper_trainer','kamran',10),
  ('goalkeeper_trainer','kamran2',10),
  ('body_trainer','kamran3',10);

INSERT INTO contract (price, employee__fk, team_fk) VALUES
  (10000, '1', '1'),
  (10000, '3', '1'),
  (10000, '5', '1'),
  (10000, '7', '1'),
  (10000, '2', '2'),
  (10000, '4', '2'),
  (10000, '6', '2'),
  (10000, '8', '2');


/* views */


/* stored procedures */
CREATE OR REPLACE FUNCTION add_team(name VARCHAR(20), stadium_fk CHAR(2))
  RETURNS VOID AS $$
BEGIN
  INSERT INTO team (name, stadium_fk) VALUES (name, stadium_fk);
END;
$$ LANGUAGE plpgsql;

/* when stadium used */
CREATE OR REPLACE FUNCTION merge_stadium(stadium_pk_arg VARCHAR(40))
  RETURNS VOID AS $$
BEGIN
  /*
    coast = coast + toilet * 0.15 * 100 = coast + toilet * 15;
    100 = coast of toilet repair
    0.15 = destroyed toilets
  */
  UPDATE stadium
  SET coast = coast + toilet * 15, toilet = toilet * 0.85
  WHERE stadium_pk = stadium_pk_arg;

  UPDATE stadium
  SET coast = coast + field * 15, field = field * 0.85
  WHERE stadium_pk = stadium_pk_arg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_fitness(update_degree DOUBLE PRECISION, fitness_pk_arg INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE fitness
  SET
    body_strength = update_degree * body_strength + body_strength,
    passing       = update_degree * passing + passing,
    ball_making   = update_degree * ball_making + ball_making,
    goal_making   = update_degree * goal_making + goal_making,
    shoot_making  = update_degree * shoot_making + shoot_making,
    speed         = update_degree * speed + speed,
    goal_keeping  = update_degree * goal_keeping + goal_keeping
  WHERE fitness_pk = fitness_pk_arg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_tactic(update_degree DOUBLE PRECISION, fitness_pk_arg INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE fitness
  SET
    ball_making = update_degree * ball_making + ball_making,
    passing     = update_degree * passing + passing,
    goal_making = update_degree * goal_making + goal_making
  WHERE fitness_pk = fitness_pk_arg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_body(update_degree DOUBLE PRECISION, fitness_pk_arg INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE fitness
  SET
    body_strength = update_degree * body_strength + body_strength,
    shoot_making  = update_degree * shoot_making + shoot_making
  WHERE fitness_pk = fitness_pk_arg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_goalkeeper(update_degree DOUBLE PRECISION, fitness_pk_arg INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE fitness
  SET
    goal_making   = update_degree * goal_making + goal_making,
    body_strength = update_degree * body_strength + body_strength,
    goal_keeping  = update_degree * goal_keeping + goal_keeping

  WHERE fitness_pk = fitness_pk_arg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION player_get_tired(player_pk_arg INTEGER)
  RETURNS VOID AS $$
DECLARE temp_var INTEGER;
BEGIN
  SELECT INTO temp_var player.fitness_fk
  FROM player
  WHERE player_pk = player_pk_arg;

  PERFORM update_fitness(0.05, temp_var);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION player_tired(player_pk_arg INTEGER)
  RETURNS VOID AS $$
DECLARE temp_var INTEGER;
BEGIN
  SELECT INTO temp_var player.fitness_fk
  FROM player
  WHERE player_pk = player_pk_arg;

  PERFORM update_fitness(-0.05, temp_var);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION play_game(host_team_pk INTEGER, guest_team_pk INTEGER)
  RETURNS VOID AS $$
DECLARE   host_team_power  DOUBLE PRECISION;
  DECLARE guest_team_power DOUBLE PRECISION;
  DECLARE stadium_pk_temp  VARCHAR(40);
  DECLARE __player         RECORD;
BEGIN
  SELECT INTO host_team_power sum(fitness.body_strength) + sum(fitness.ball_making)
                              + sum(fitness.speed) + sum(fitness.goal_keeping) + sum(fitness.shoot_making) +
                              sum(fitness.passing)
                              + sum(fitness.goal_making)
  FROM fitness, team, player, play
  WHERE team_pk = host_team_pk AND team_pk = play.team_fk AND player_pk = play.player_fk and fitness_fk = fitness.fitness_pk ;

  SELECT INTO guest_team_power sum(fitness.body_strength) + sum(fitness.ball_making)
                               + sum(fitness.speed) + sum(fitness.goal_keeping) + sum(fitness.shoot_making) +
                               sum(fitness.passing)
                               + sum(fitness.goal_making)
  FROM fitness, team, player, play
  WHERE team_pk = guest_team_pk AND team_pk = play.team_fk AND player_pk = play.player_fk and fitness_fk = fitness.fitness_pk;

  SELECT INTO stadium_pk_temp stadium_pk
  FROM team, stadium
  WHERE stadium_pk = team.stadium_fk AND team_pk = host_team_pk;

  PERFORM merge_stadium(stadium_pk_temp);

  FOR __player IN SELECT player.*
                  FROM player, play
                  WHERE player.player_pk = play.player_fk AND (team_fk = host_team_pk OR team_fk = guest_team_pk) LOOP
    PERFORM player_tired(__player.player_pk);
  END LOOP;

  RAISE NOTICE 'Value: h: %, g: %', host_team_power, guest_team_power;
  IF host_team_power < guest_team_power
  THEN
    UPDATE stadium
    SET
      seat = seat - seat * 0.2 -- todo ضرب در رضایت تماشاچی
    FROM team
    WHERE stadium.stadium_pk = team.stadium_fk;
  END IF;

END;
$$ LANGUAGE plpgsql;

-- SELECT player_tired(1);
-- SELECT player_tired(2);
-- SELECT player_tired(3);
-- SELECT player_tired(4);
-- SELECT play_game(1, 2);
