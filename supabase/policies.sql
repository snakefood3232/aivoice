-- Enable RLS on all tables
alter table orgs enable row level security;
alter table org_members enable row level security;
alter table agents enable row level security;
alter table sessions_calls enable row level security;
alter table sessions_chats enable row level security;
alter table knowledge_items enable row level security;
alter table billing_customers enable row level security;
alter table subscriptions enable row level security;
alter table usage_minute_events enable row level security;
alter table price_catalog enable row level security;

-- NOTE: These initial policies are permissive to allow development.
-- In production, refine to check org membership via JWT claims.

-- orgs
create policy orgs_select on orgs for select using (true);
create policy orgs_insert on orgs for insert with check (true);

-- org_members
create policy org_members_select on org_members for select using (true);
create policy org_members_ins on org_members for insert with check (true);

-- agents
create policy agents_select on agents for select using (true);
create policy agents_ins on agents for insert with check (true);
create policy agents_upd on agents for update using (true);
create policy agents_del on agents for delete using (true);

-- calls
create policy calls_select on sessions_calls for select using (true);
create policy calls_ins on sessions_calls for insert with check (true);
create policy calls_upd on sessions_calls for update using (true);

-- chats
create policy chats_select on sessions_chats for select using (true);
create policy chats_ins on sessions_chats for insert with check (true);

-- knowledge base
create policy kb_select on knowledge_items for select using (true);
create policy kb_ins on knowledge_items for insert with check (true);

-- billing
create policy billing_select on billing_customers for select using (true);
create policy billing_ins on billing_customers for insert with check (true);

-- subscriptions
create policy subs_select on subscriptions for select using (true);
create policy subs_ins on subscriptions for insert with check (true);
create policy subs_upd on subscriptions for update using (true);

-- usage events
create policy usage_select on usage_minute_events for select using (true);
create policy usage_ins on usage_minute_events for insert with check (true);

-- price catalog
create policy catalog_select on price_catalog for select using (true);
create policy catalog_ins on price_catalog for insert with check (true);
