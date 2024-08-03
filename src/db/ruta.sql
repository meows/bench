-- Add up migration script here
BEGIN;

CREATE SCHEMA IF NOT EXISTS nebula;

CREATE TABLE IF NOT EXISTS nebula.users (
    user_id BIGSERIAL,
    account_id BIGSERIAL NOT NULL,
    role_id BIGSERIAL NOT NULL,
    email VARCHAR (255) NOT NULL UNIQUE,
    encrypted_pwd TEXT NOT NULL,
    is_approved BOOLEAN NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    UNIQUE (email),
    PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS nebula.accounts (
    account_id BIGSERIAL,
    username TEXT NOT NULL,
    preferred_name VARCHAR (255),
    description TEXT,
    avatar_url TEXT,
    actor_type VARCHAR (255) NOT NULL,
    inbox_url TEXT NOT NULL,
    outbox_url TEXT NOT NULL,
    is_suspended BOOLEAN NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    UNIQUE (username),
    PRIMARY KEY(account_id)
);

CREATE TABLE IF NOT EXISTS nebula.account_warehouses (
    account_warehouse_id BIGSERIAL,
    account_id BIGSERIAL NOT NULL,
    warehouse_id BIGSERIAL NOT NULL,
    permission INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    UNIQUE (account_id, warehouse_id),
    PRIMARY KEY(account_warehouse_id)
);

CREATE TABLE IF NOT EXISTS nebula.instance (
    instance_id BIGSERIAL,
    title TEXT,
    description TEXT,
    email VARCHAR (255),
    server_fee SMALLINT NOT NULL DEFAULT 0,
    logo TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(instance_id)
);

CREATE TABLE IF NOT EXISTS nebula.languages (
    language_id BIGSERIAL,
    code VARCHAR (7),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    UNIQUE (code),
    PRIMARY KEY(language_id)
);

CREATE TABLE IF NOT EXISTS nebula.peers (
    peer_id BIGSERIAL,
    url TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    UNIQUE (url),
    PRIMARY KEY(peer_id)
);

CREATE TABLE IF NOT EXISTS nebula.privacy_policy (
    privacy_policy_id BIGSERIAL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(privacy_policy_id)
);

CREATE TABLE IF NOT EXISTS nebula.products (
    product_id BIGSERIAL,
    warehouse_id BIGSERIAL NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    sku TEXT,
    price BIGINT,
    currency VARCHAR (255) NOT NULL,
    color VARCHAR (255),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(product_id)
);

CREATE TABLE IF NOT EXISTS nebula.roles (
    role_id BIGSERIAL,
    name VARCHAR (255) NOT NULL,
    permission BIGINT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(role_id)
);

CREATE TABLE IF NOT EXISTS nebula.rules (
    rule_id BIGSERIAL,
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(rule_id)
);

CREATE TABLE IF NOT EXISTS nebula.sessions (
    session_id BIGSERIAL,
    subject TEXT,
    issuer TEXT,
    account_id BIGSERIAL NOT NULL,
    device_id TEXT NOT NULL,
    expired_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(session_id)
);

CREATE TABLE IF NOT EXISTS nebula.warehouses (
    warehouse_id BIGSERIAL,
    account_id BIGSERIAL NOT NULL,
    name VARCHAR (255) NOT NULL UNIQUE,
    preferred_name TEXT,
    description TEXT NOT NULL,
    banner_url TEXT,
    is_suspended BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    UNIQUE (name),
    PRIMARY KEY(warehouse_id)
);

CREATE TABLE IF NOT EXISTS nebula.registration_requests (
    registration_request_id BIGSERIAL,
    account_id BIGSERIAL NOT NULL,
    user_id BIGSERIAL NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY(registration_request_id)
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_accounts_username
ON nebula.accounts(username);

CREATE INDEX IF NOT EXISTS idx_users_account_id
ON nebula.users(account_id);

CREATE INDEX IF NOT EXISTS idx_users_email
ON nebula.users(email);

CREATE INDEX IF NOT EXISTS idx_user_role_id
ON nebula.users(role_id);

CREATE INDEX IF NOT EXISTS idx_account_warehouses_account_id_warehouse_id
ON nebula.account_warehouses(account_id, warehouse_id);

CREATE INDEX IF NOT EXISTS idx_products_warehouse_id
ON nebula.products(warehouse_id);

CREATE INDEX IF NOT EXISTS idx_warehouses_name
ON nebula.warehouses(name);

-- Foreign keys
ALTER TABLE nebula.warehouses
ADD CONSTRAINT fk_accounts
FOREIGN KEY (account_id)
REFERENCES nebula.accounts (account_id);

ALTER TABLE nebula.products
ADD CONSTRAINT fk_warehouses
FOREIGN KEY (warehouse_id)
REFERENCES nebula.warehouses (warehouse_id)
ON DELETE CASCADE;

ALTER TABLE nebula.sessions
ADD CONSTRAINT fk_accounts
FOREIGN KEY (account_id)
REFERENCES nebula.accounts (account_id)
ON DELETE CASCADE;

COMMIT;
