-- 8. Sessions (Timetable) Table
create table sessions (
    id uuid default uuid_generate_v4() primary key,
    teacher_id uuid references profiles(id) not null,
    class_name text not null, -- e.g., '4م1'
    room text not null,       -- e.g., '12'
    subject text not null,    -- e.g., 'Mathematics'
    start_time time not null, -- e.g., '08:00:00'
    end_time time not null,   -- e.g., '09:00:00'
    day_of_week int not null, -- 1=Monday, ..., 7=Sunday
    created_at timestamptz default now()
);

-- RLS for Sessions
alter table sessions enable row level security;
create policy "Sessions are viewable by everyone" on sessions for select using (true);
