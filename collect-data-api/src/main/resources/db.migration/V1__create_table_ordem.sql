CREATE TABLE IF NOT EXISTS TWEET(
  ID_TWEET        BIGSERIAL PRIMARY KEY,
  DS_TWEET        VARCHAR(280)    NOT NULL,
  FISIOLOGICO     INT DEFAULT 0 ,
  PSIQUICO     INT DEFAULT 0,
  COMPORTAMENTAL     INT DEFAULT 0,
  DH_TWEET          TIMESTAMP,
  USUARIO VARCHAR(400)
);
