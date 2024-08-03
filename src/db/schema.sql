DROP TABLE IF EXISTS Law;
CREATE TABLE Law (
  code        TEXT,
  section     TEXT,
  verified    INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated     INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP,
  hash        TEXT UNIQUE NOT NULL,
  title       TEXT,
  subtitle    TEXT,
  body        TEXT,
  raw         TEXT NOT NULL,

  PRIMARY KEY (code, section)
) strict;

CREATE INDEX idx_updated ON Law (updated);
CREATE INDEX idx_verified ON Law (verified);
CREATE UNIQUE INDEX idx_hash ON Law (code, section);