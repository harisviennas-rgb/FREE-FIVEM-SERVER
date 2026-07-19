-- SQL schema for scaffold

CREATE TABLE IF NOT EXISTS ff_server_players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  steam_id VARCHAR(128) NOT NULL,
  identifier VARCHAR(255),
  money BIGINT DEFAULT 0,
  black_money BIGINT DEFAULT 0,
  job VARCHAR(64) DEFAULT 'unemployed',
  job_grade INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ff_server_bans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  steam_id VARCHAR(255),
  reason TEXT,
  banned_by VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS ff_server_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type VARCHAR(64),
  actor VARCHAR(255),
  target VARCHAR(255),
  details TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
