CREATE TABLE schema_migrations (version text primary key)
CREATE TABLE todo (
  id integer primary key,
  name text not null,
  completed_at integer,
  created_at integer not null default(strftime('%s', 'now')),
  updated_at integer
)