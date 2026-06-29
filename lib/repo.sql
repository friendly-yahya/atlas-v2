
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
    name text not null,                            -- added not null
    created_at timestamp default now() not null
);

create table health_form_fields (
    id uuid primary key default gen_random_uuid(),
    template_id uuid not null references health_form_templates(id),
    question text not null,
    field_type text not null, --idk how would tha work 
    is_required boolean
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
    difficulty text check (difficulty in ('easy', 'moderate', 'hard', 'expert')),  
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
    booked_count integer default 0 not null,
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
    updated_at timestamp default now() not null,    
    created_at timestamp default now() not null
);

create table reviews (
    id uuid primary key default gen_random_uuid(),
    booking_id uuid not null references bookings(id),
    operator_id uuid not null references operator_profile(id),
    client_id uuid not null references profiles(id),--users default to client
    rating integer not null,
    comment text not null,
    created_at timestamp default now() not null
);

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
create index idx_offers_status on offers(status);   -- for filtering 

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
