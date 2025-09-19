-- Realtalk AI initial schema
-- Enable pgcrypto if not enabled (for gen_random_uuid)
-- create extension if not exists pgcrypto;

-- orgs and membership
create table if not exists orgs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz default now()
);

create table if not exists org_members (
  org_id uuid references orgs(id) on delete cascade,
  user_id uuid not null, -- matches auth.users.id
  role text not null check (role in ('owner','admin','member')),
  created_at timestamptz default now(),
  primary key (org_id, user_id)
);

-- agents
create table if not exists agents (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references orgs(id) on delete cascade,
  name text not null,
  retell_agent_id text not null,
  voice text,
  model text,
  settings jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

-- calls
create table if not exists sessions_calls (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references orgs(id) on delete cascade,
  agent_id uuid references agents(id) on delete set null,
  retell_session_id text,
  started_at timestamptz,
  ended_at timestamptz,
  duration_sec int,
  cost_retail_cents int,
  cost_cogs_cents int,
  transcript_url text,
  recording_url text,
  metadata jsonb default '{}'::jsonb
);

-- chats
create table if not exists sessions_chats (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references orgs(id) on delete cascade,
  agent_id uuid references agents(id) on delete set null,
  started_at timestamptz,
  ended_at timestamptz,
  message_count int default 0,
  transcript jsonb,
  metadata jsonb default '{}'::jsonb
);

-- knowledge base
create table if not exists knowledge_items (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references orgs(id) on delete cascade,
  type text check (type in ('url','file','text')) not null,
  title text,
  source_url text,
  storage_path text,
  content text,
  created_at timestamptz default now()
);

-- billing linkage
create table if not exists billing_customers (
  org_id uuid primary key references orgs(id) on delete cascade,
  stripe_customer_id text not null
);

-- subscriptions and bundles
create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references orgs(id) on delete cascade,
  stripe_subscription_id text not null,
  plan_type text not null check (plan_type in ('weekly','monthly','payg')),
  included_minutes int default 0,
  minutes_used int default 0,
  period_start timestamptz not null,
  period_end timestamptz not null,
  active boolean default true
);

-- usage events for PAYG/metered billing aggregation
create table if not exists usage_minute_events (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references orgs(id) on delete cascade,
  call_id uuid references sessions_calls(id) on delete cascade,
  seconds int not null,
  occurred_at timestamptz default now(),
  posted_to_stripe boolean default false
);

-- catalog of Stripe price IDs to use in Checkout
create table if not exists price_catalog (
  key text primary key, -- e.g., 'PAYG', 'WEEKLY_STARTER', ...
  stripe_price_id text not null,
  included_minutes int default 0
);
