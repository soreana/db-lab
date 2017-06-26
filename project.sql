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
  type       VARCHAR(20) CHECK (type IN ('dealer', 'tactic_trainer', 'body_trainer', 'goalkeeper_trainer')) NOT NULL,
  name VARCHAR(20) NOT NULL ,
  percent    INT         NOT NULL
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
  stadium_pk VARCHAR(20) PRIMARY KEY NOT NULL,
  capacity   INT     DEFAULT 0,
  seat       INT     DEFAULT 0,
  field      INT     DEFAULT 0,
  name       VARCHAR(20),
  coast      INTEGER DEFAULT 0,
  toilet     INTEGER DEFAULT 0
);


CREATE TABLE team
(
  name       VARCHAR(20),
  team_pk    SERIAL PRIMARY KEY NOT NULL,
  stadium_fk VARCHAR(20),
  CONSTRAINT stadium_fk FOREIGN KEY (stadium_fk) REFERENCES stadium (stadium_pk) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE public.contract
(
  id SERIAL PRIMARY KEY NOT NULL,
  price INT NOT NULL,
  employee__fk VARCHAR(10),
  team_fk VARCHAR(20),
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
  (100, 100, 100, 100, 100, 100, 100, 1),
  (100, 100, 100, 100, 100, 100, 100, 2),
  (100, 100, 100, 100, 100, 100, 100, 3),
  (100, 100, 100, 100, 100, 100, 100, 4),
  (100, 100, 100, 100, 100, 100, 100, 5),
  (100, 100, 100, 100, 100, 100, 100, 6),
  (100, 100, 100, 100, 100, 100, 100, 7),
  (100, 100, 100, 100, 100, 100, 100, 8);

INSERT INTO player
(player_pk, Name, Specialty, fitness_fk) VALUES
  ('1', 'asghar', 'goalkeeper', 1),
  ('2', 'akbar', 'attacker', 2),
  ('3', 'shangul', 'attacker', 3),
  ('4', 'mangul', 'attacker', 4),
  ('5', 'sina', 'defender', 5),
  ('6', 'moli', 'defender', 6),
  ('7', 'gholi', 'defender', 7),
  ('8', 'sinsin', 'midfielder', 8);

INSERT INTO stadium
(stadium_pk, capacity, seat, field, name, toilet) VALUES
  ('1', 81044, 81044, 1000, 'Santiago Bernabéu', 100),
  ('2', 99354, 99354, 1000, 'Camp Nou', 100);

INSERT INTO team
(name, stadium_fk) VALUES
  ('real', '1'),
  ('barsa', '2');

INSERT INTO play
(play_pk, player_fk, team_fk) VALUES
  ('1', '1', '1'),
  ('2', '2', '1'),
  ('3', '3', '1'),
  ('4', '4', '1'),
  ('5', '5', '2'),
  ('6', '6', '2'),
  ('7', '7', '2'),
  ('8', '8', '2');

INSERT INTO employee (type, name, percent) VALUES
  ('dealer','sina',10),
  ('dealer','sina2',10),
  ('tactic_trainer','sina',10),
  ('tactic_trainer','sina2',10),
  ('body_trainer','sina',10),
  ('body_trainer','sina2',10),
  ('goalkeeper_trainer','sina',10),
  ('goalkeeper_trainer','sina2',10);

INSERT INTO contract (price, employee__fk, team_fk) VALUES
  (10000,'1','1'),
  (10000,'3','1'),
  (10000,'5','1'),
  (10000,'7','1'),
  (10000,'2','2'),
  (10000,'4','2'),
  (10000,'6','2'),
  (10000,'8','2')
;


/* views */


/* stored procedures */
CREATE OR REPLACE FUNCTION add_team(name VARCHAR(20), stadium_fk CHAR(2))
  RETURNS VOID AS $$
BEGIN
  INSERT INTO team (name, stadium_fk) VALUES (name, stadium_fk);
END;
$$ LANGUAGE plpgsql;

/* when stadium used */
CREATE OR REPLACE FUNCTION merge_stadium()
  RETURNS VOID AS $$
BEGIN
  /*
    coast = coast + toilet * 0.15 * 100 = coast + toilet * 15;
    100 = coast of toilet repair
    0.15 = destroyed toilets
  */
  UPDATE stadium
  SET coast = coast + toilet * 15, toilet = toilet * 0.85;
  UPDATE stadium
  SET coast = coast + field * 15, field = field * 0.85;
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

SELECT player_tired(2);


SELECT
  fitness.*,
  player.Name
FROM fitness, player, play
WHERE fitness_fk = fitness.fitness_pk AND player_pk = play.player_fk AND team_fk = 1;
