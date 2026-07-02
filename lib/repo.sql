create table profiles (
    id uuid primary key references auth.users(id) on delete cascade,
--    email text, 
    phone text,
    username text not null,
    role text not null default 'client'
        check (role in ('client', 'operator', 'admin')),  
    created_at timestamp default now() not null
);

create table operator_profile (
    id uuid primary key default gen_random_uuid() not null,
    user_id uuid not null references profiles(id),
    bio text not null,
    years_of_experience integer not null,
    total_trips_led integer not null,
    cancellation_policy text not null,--can be modified later 
    refund_policy text not null,
    is_founding_operator boolean default false not null,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null   
);

create table operator_certifications (
    id uuid primary key default gen_random_uuid() not null,
    operator_id uuid not null references operator_profile(id),
    cert_name text not null,
    issued_by text not null,
    expires_at timestamp not null,
    document_url text not null,
    verified_by_admin boolean,
    created_at timestamp default now() not null   
);

create table operator_insurance (
    id uuid primary key default gen_random_uuid() not null,
    operator_id uuid not null references operator_profile(id),
    cert_name text not null,
    issued_by text not null,
    expires_at timestamp not null,
    document_url text not null,
    verified_by_admin boolean,
    created_at timestamp default now() not null   
);

create table operator_equipment (
    id uuid primary key default gen_random_uuid() not null,
    operator_id uuid not null references operator_profile(id),
    item_name text not null,
    brand text not null,
    quantity integer default 0 not null,
    last_serviced_at timestamp not null
);

create table health_form_templates (
    id uuid primary key default gen_random_uuid(),
    created_by uuid not null references profiles(id),
    name text not null,
    created_at timestamp default now() not null
);

create table health_form_fields (
    id uuid primary key default gen_random_uuid(),
    template_id uuid not null references health_form_templates(id),
    question text not null,
    field_type text not null, --idk how would tha work 
    is_required boolean not null default true
);

create table offers (
    id uuid primary key default gen_random_uuid() not null,
    operator_id uuid not null references operator_profile(id),
    title text not null,
    description text not null,
    location text not null,
    latitude numeric,
    longitude numeric,
    price_adult numeric(10,2) not null,
    price_child numeric(10,2),      
    difficulty text not null check (difficulty in ('easy', 'moderate', 'hard', 'expert')),  
    status text not null check (status in ('draft', 'active', 'paused', 'archived')),  
    requires_health_form boolean,
    health_form_template_id uuid references health_form_templates(id),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table operator_languages (
    id uuid primary key default gen_random_uuid(),
    operator_id uuid not null references operator_profile(id),
    language text not null
);

create table offer_includes (
    id uuid primary key default gen_random_uuid(),
    offer_id uuid not null references offers(id),
    item text not null,--this has an icon plus text maube it's own table
    icon_url text
);

create table offer_schedule (
    id uuid primary key default gen_random_uuid(),
    offer_id uuid not null references offers(id),
    title text not null,
    description text,
    image_url text,
    duration_minutes integer,
    sort_order integer not null
); -- can have many activities and each activity has an image and a small des and a small title and in the title there's title and duration 
    --duration_minutes
    --sort_order

create table slots (
    id uuid primary key default gen_random_uuid(),
    offer_id uuid not null references offers(id), 
    starts_at timestamp not null,
    capacity integer not null, 
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table bookings (
    id uuid primary key default gen_random_uuid(),
    slot_id uuid not null references slots(id),
    client_id uuid not null references profiles(id), 
    status text not null check (status in ('pending', 'confirmed', 'cancelled', 'completed')),
    adults_count integer not null default 1,
    children_count integer not null default 0,
    total_amount numeric(10,2) not null,
    currency text not null default 'MAD',
    updated_at timestamp default now() not null,    
    created_at timestamp default now() not null
);

create table reviews (
    id uuid primary key default gen_random_uuid(),
    booking_id uuid not null references bookings(id),
    operator_id uuid not null references operator_profile(id),
    client_id uuid not null references profiles(id),--users default to client
    rating integer not null check (rating >= 1 and rating <= 5),
    comment text not null,
    created_at timestamp default now() not null
);

create unique index idx_reviews_booking_client on reviews(booking_id, client_id);

create table payments (
    id uuid primary key default gen_random_uuid(),
    booking_id uuid not null references bookings(id),
    amount numeric(10,2) not null,
    currency text not null,
    status text not null check (status in ('pending', 'paid', 'failed', 'refunded')),     
    gateway_reference text not null,
    platform_fee numeric not null,
    operator_payout numeric(10,2) not null,
    payout_status text not null check (payout_status in ('pending', 'processing', 'paid', 'failed')),
    paid_at timestamp,            
    received_at timestamp,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null   
);

create table health_form_submissions (
    id uuid primary key default gen_random_uuid(),
    booking_id uuid not null references bookings(id),
    emergency_contact_name text not null,
    secondary_emergency_contact_name text,
    emergency_contact_phone text not null,
    secondary_emergency_contact_phone text,
    understands_risks boolean default false not null,
    submitted_at timestamp not null
);

create table health_form_answers (
    id uuid primary key default gen_random_uuid(),
    submission_id uuid not null references health_form_submissions(id),
    field_id uuid not null references health_form_fields(id),
    answer text not null
);
    --question --it's a bit nuanced since there could be many questions and multple answers 
    --answer

create table conversations (
    id uuid primary key default gen_random_uuid(),
    client_id uuid not null references profiles(id),
    operator_id uuid not null references operator_profile(id),
    offer_id uuid not null references offers(id),
    created_at timestamp default now() not null,
    last_message_at timestamp,     
    updated_at timestamp default now() not null   
);

create unique index idx_conversations_unique on conversations(client_id, operator_id, offer_id);

create table messages (
    id uuid primary key default gen_random_uuid(),
    conversation_id uuid not null references conversations(id),
    sender_id uuid not null references profiles(id),
    content text not null,
    read_at timestamp,
    created_at timestamp default now() not null
);

create table likes (
    id uuid primary key default gen_random_uuid(),
    client_id uuid not null references profiles(id),
    offer_id uuid not null references offers(id),  
    created_at timestamp default now() not null
);

create unique index idx_likes_unique on likes(client_id, offer_id);

create table shares (
    id uuid primary key default gen_random_uuid(),
    client_id uuid not null references profiles(id),
    offer_id uuid not null references offers(id),  
    channel text not null, -- 'whatsapp' / 'instagram' / 'link'
    created_at timestamp default now() not null
);

create index idx_operator_profile_user_id on operator_profile(user_id);

create index idx_operator_certifications_operator_id on operator_certifications(operator_id);
create index idx_operator_insurance_operator_id on operator_insurance(operator_id);
create index idx_operator_equipment_operator_id on operator_equipment(operator_id);

create index idx_health_form_templates_created_by on health_form_templates(created_by);
create index idx_health_form_fields_template_id on health_form_fields(template_id);

create index idx_offers_operator_id on offers(operator_id);
create index idx_offers_status on offers(status);

create index idx_operator_languages_operator_id on operator_languages(operator_id);
create index idx_offer_includes_offer_id on offer_includes(offer_id);
create index idx_offer_schedule_offer_id on offer_schedule(offer_id);

create index idx_slots_offer_id on slots(offer_id);

create index idx_bookings_slot_id on bookings(slot_id);
create index idx_bookings_client_id on bookings(client_id);
create index idx_bookings_status on bookings(status);

create index idx_reviews_booking_id on reviews(booking_id);
create index idx_reviews_operator_id on reviews(operator_id);
create index idx_reviews_client_id on reviews(client_id);

create index idx_payments_booking_id on payments(booking_id);

create index idx_health_form_submissions_booking_id on health_form_submissions(booking_id);
create index idx_health_form_answers_submission_id on health_form_answers(submission_id);
create index idx_health_form_answers_field_id on health_form_answers(field_id);

create index idx_conversations_client_id on conversations(client_id);
create index idx_conversations_operator_id on conversations(operator_id);
create index idx_messages_conversation_id on messages(conversation_id);
create index idx_messages_sender_id on messages(sender_id);
create index idx_messages_created_at on messages(created_at);

create index idx_likes_client_id on likes(client_id);
create index idx_likes_offer_id on likes(offer_id);
create index idx_shares_client_id on shares(client_id);
create index idx_shares_offer_id on shares(offer_id);

create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_updated_at before update on operator_profile for each row execute function update_updated_at();
create trigger set_updated_at before update on offers for each row execute function update_updated_at();
create trigger set_updated_at before update on slots for each row execute function update_updated_at();
create trigger set_updated_at before update on bookings for each row execute function update_updated_at();
create trigger set_updated_at before update on payments for each row execute function update_updated_at();
create trigger set_updated_at before update on conversations for each row execute function update_updated_at();


alter table profiles                  enable row level security;
alter table operator_profile          enable row level security;
alter table operator_certifications   enable row level security;
alter table operator_insurance        enable row level security;
alter table operator_equipment        enable row level security;
alter table operator_languages        enable row level security;
alter table health_form_templates     enable row level security;
alter table health_form_fields        enable row level security;
alter table offers                    enable row level security;
alter table offer_includes            enable row level security;
alter table offer_schedule            enable row level security;
alter table slots                     enable row level security;
alter table bookings                  enable row level security;
alter table reviews                   enable row level security;
alter table payments                  enable row level security;
alter table health_form_submissions   enable row level security;
alter table health_form_answers       enable row level security;
alter table conversations             enable row level security;
alter table messages                  enable row level security;
alter table likes                     enable row level security;
alter table shares                    enable row level security;

create policy "profiles: select"
  on profiles for select
  to authenticated
  using (
    role = 'operator'
    or auth.uid() = id
    or exists (
      select 1 from bookings b
      join slots s on s.id = b.slot_id
      join offers o on o.id = s.offer_id
      join operator_profile op on op.id = o.operator_id
      where b.client_id = profiles.id
      and op.user_id = auth.uid()
    )
  );
create policy "profiles: insert own"
    on profiles for insert
    to authenticated
    with check (auth.uid() = id);

create policy "profiles: update own"
    on profiles for update
    to authenticated
    using (auth.uid() = id) 
    with check (auth.uid() = id);

create policy "operator_profile: authenticated can read all"
  on operator_profile for select
  to authenticated
  using (true);

create policy "operator_profile: insert own"
  on operator_profile for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "operator_profile: update own"
  on operator_profile for update
  to authenticated
  using (auth.uid() = user_id);
create policy "operator_certifications: insert own"
  on operator_certifications for insert
  to authenticated
  with check (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_certifications: update own"
  on operator_certifications for update
  to authenticated
  using (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_certifications: authenticated can read all"
  on operator_certifications for select
  to authenticated
  using (true);

  create policy "operator_insurance: authenticated can read all"
  on operator_insurance for select
  to authenticated
  using (true);

create policy "operator_insurance: insert own"
  on operator_insurance for insert
  to authenticated
  with check (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_insurance: update own"
  on operator_insurance for update
  to authenticated
  using (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_equipment: authenticated can read all"
  on operator_equipment for select
  to authenticated
  using (true);

create policy "operator_equipment: insert own"
  on operator_equipment for insert
  to authenticated
  with check (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_equipment: update own"
  on operator_equipment for update
  to authenticated
  using (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );



create policy "operator_languages: authenticated can read all"
  on operator_languages for select
  to authenticated
  using (true);

create policy "operator_languages: insert own"
  on operator_languages for insert
  to authenticated
  with check (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_languages: update own"
  on operator_languages for update
  to authenticated
  using (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "operator_languages: delete own"
  on operator_languages for delete
  to authenticated
  using (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "health_form_templates: authenticated can read all"
  on health_form_templates for select
  to authenticated
  using (true);

create policy "health_form_templates: insert own"
  on health_form_templates for insert
  to authenticated
  with check (auth.uid() = created_by);

create policy "health_form_templates: update own"
  on health_form_templates for update
  to authenticated
  using (auth.uid() = created_by);

create policy "health_form_fields: authenticated can read all"
  on health_form_fields for select
  to authenticated
  using (true);

create policy "health_form_fields: insert own"
  on health_form_fields for insert
  to authenticated
  with check (
    auth.uid() = (
      select created_by from health_form_templates
      where id = template_id
    )
  );

create policy "health_form_fields: update own"
  on health_form_fields for update
  to authenticated
  using (
    auth.uid() = (
      select created_by from health_form_templates
      where id = template_id
    )
  );
create policy "offers: clients see active, operators see own"
  on offers for select
  to authenticated
  using (
    status = 'active'
    or auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );
create policy "offers: insert own"
  on offers for insert
  to authenticated
  with check (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );

create policy "offers: update own"
  on offers for update
  to authenticated
  using (
    auth.uid() = (
      select user_id from operator_profile
      where id = operator_id
    )
  );
create policy "offer_includes: authenticated can read all"
  on offer_includes for select
  to authenticated
  using (true);

create policy "offer_includes: only op can add own"
  on offer_includes for insert
  to authenticated
  with check (
    auth.uid() = (
      select op.user_id 
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id

    )
  );
create policy "offer_includes: delete own"
  on offer_includes for delete
  to authenticated
  using (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "offer_includes: update own"
  on offer_includes for update
  to authenticated
  using (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "offer_schedule: authenticated can read all"
  on offer_schedule for select
  to authenticated
  using (true);

create policy "offer_schedule: insert own"
  on offer_schedule for insert
  to authenticated
  with check (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "offer_schedule: update own"
  on offer_schedule for update
  to authenticated
  using (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "offer_schedule: delete own"
  on offer_schedule for delete
  to authenticated
  using (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "slots: authenticated can read all"
  on slots for select
  to authenticated
  using (true);

create policy "slots: insert own"
  on slots for insert
  to authenticated
  with check (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "slots: update own"
  on slots for update
  to authenticated
  using (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "slots: delete own"
  on slots for delete
  to authenticated
  using (
    auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      where o.id = offer_id
    )
  );

create policy "bookings: client sees own, operator sees for their offers"
  on bookings for select
  to authenticated
  using (
    auth.uid() = client_id
    or auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      join slots s on s.offer_id = o.id
      where s.id = slot_id
    )
  );
create policy "bookings: client inserts own"
  on bookings for insert
  to authenticated
  with check (auth.uid() = client_id);
create policy "bookings: client and operator can update"
  on bookings for update
  to authenticated
  using (
    auth.uid() = client_id
    or auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      join slots s on s.offer_id = o.id
      where s.id = slot_id
    )
  );

create policy "reviews: authenticated can read all"
  on reviews for select
  to authenticated
  using (true);

create policy "reviews: client inserts own on completed booking"
  on reviews for insert
  to authenticated
  with check (
    auth.uid() = client_id
    and auth.uid() = (
      select client_id from bookings
      where id = booking_id
      and status = 'completed'
    )
  );
----really must be careful with reviews double check, and test later
create policy "reviews: client updates own"
  on reviews for update
  to authenticated
  using (auth.uid() = client_id);

-- no need for insert can be done by third partie prov

create policy "payments: client sees own, operator sees for their offers"
  on payments for select
  to authenticated
  using (
    auth.uid() = (
      select client_id from bookings where id = booking_id
    )
    or auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      join slots s on s.offer_id = o.id
      join bookings b on b.slot_id = s.id
      where b.id = booking_id
    )
  );

--client sees own, operator sees for their bookings
create policy "health_form_submissions: client and operator can read"
  on health_form_submissions for select
  to authenticated
  using (
    auth.uid() = (
      select client_id from bookings where id = booking_id
    )
    or auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      join slots s on s.offer_id = o.id
      join bookings b on b.slot_id = s.id
      where b.id = booking_id
    )
  );

--only the client who made the booking
create policy "health_form_submissions: client inserts own"
  on health_form_submissions for insert
  to authenticated
  with check (
    auth.uid() = (
      select client_id from bookings where id = booking_id
    )
  );

create policy "health_form_answers: client and operator can read"
  on health_form_answers for select
  to authenticated
  using (
    auth.uid() = (
      select b.client_id
      from bookings b
      join health_form_submissions hfs on hfs.booking_id = b.id
      where hfs.id = submission_id
    )
    or auth.uid() = (
      select op.user_id
      from operator_profile op
      join offers o on o.operator_id = op.id
      join slots s on s.offer_id = o.id
      join bookings b on b.slot_id = s.id
      join health_form_submissions hfs on hfs.booking_id = b.id
      where hfs.id = submission_id
    )
  );

create policy "health_form_answers: client inserts own"
  on health_form_answers for insert
  to authenticated
  with check (
    auth.uid() = (
      select b.client_id
      from bookings b
      join health_form_submissions hfs on hfs.booking_id = b.id
      where hfs.id = submission_id
    )
  );


-- careful here one breach and i'm genuinly cooocked 

create policy "conversations: participants can read"
  on conversations for select
  to authenticated
  using (
    auth.uid() = client_id
    or auth.uid() = (
      select user_id from operator_profile where id = operator_id
    )
  );

create policy "conversations: client or operator of booking can create"
  on conversations for insert
  to authenticated
  with check (
    -- client can start convo with any operator (not other clients)
    (auth.uid() = client_id and exists (
      select 1 from operator_profile where id = operator_id
    ))
    -- operator can start convo only with clients who booked them
    or (auth.uid() = (
      select user_id from operator_profile where id = operator_id
    ) and exists (
      select 1 from bookings b
      join slots s on s.id = b.slot_id
      join offers o on o.id = s.offer_id
      where o.operator_id = conversations.operator_id
      and b.client_id = conversations.client_id
    ))
  );

create policy "conversations: participants can update"
  on conversations for update
  to authenticated
  using (
    auth.uid() = client_id
    or auth.uid() = (
      select user_id from operator_profile where id = operator_id
    )
  );

create policy "messages: only participants of the conversation"
  on messages for select
  to authenticated
  using (
    auth.uid() = (
      select client_id from conversations where id = conversation_id
    )
    or auth.uid() = (
      select op.user_id
      from operator_profile op
      join conversations c on c.operator_id = op.id
      where c.id = conversation_id
    )
  );

create policy "messages: only participants of the conversation can insert"
  on messages for insert
  to authenticated
  with check (
    auth.uid() = sender_id
    and (
      auth.uid() = (
        select client_id from conversations where id = conversation_id
      )
      or auth.uid() = (
        select op.user_id
        from operator_profile op
        join conversations c on c.operator_id = op.id
        where c.id = conversation_id
      )
    )
  );

create policy "likes: client sees own"
  on likes for select
  to authenticated
  using (auth.uid() = client_id);

create policy "likes: client inserts own"
  on likes for insert
  to authenticated
  with check (auth.uid() = client_id);

create policy "likes: client deletes own"
  on likes for delete
  to authenticated
  using (auth.uid() = client_id);

create policy "shares: client sees own"
  on shares for select
  to authenticated
  using (auth.uid() = client_id);

create policy "shares: client inserts own"
  on shares for insert
  to authenticated
  with check (auth.uid() = client_id);
