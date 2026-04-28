-- Create takedown_status enum if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'takedown_status') THEN
        CREATE TYPE takedown_status AS ENUM (
            'drafted', 'pending_review', 'submitted', 
            'acknowledged', 'taken_down', 'expired', 'rejected'
        );
    END IF;
END$$;

-- Create rights_holders table
CREATE TABLE IF NOT EXISTS rights_holders (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    legal_email VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    authorized_agent VARCHAR(255) NOT NULL,
    default_language VARCHAR(10) NOT NULL DEFAULT 'en',
    signature_block TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create takedown_cases table
CREATE TABLE IF NOT EXISTS takedown_cases (
    id UUID PRIMARY KEY,
    verification_result_id UUID NOT NULL UNIQUE REFERENCES verification_results(id) ON DELETE CASCADE,
    candidate_id UUID NOT NULL REFERENCES candidate_streams(id) ON DELETE CASCADE,
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    rights_holder_id UUID REFERENCES rights_holders(id) ON DELETE SET NULL,
    platform VARCHAR(64) NOT NULL,
    status takedown_status NOT NULL DEFAULT 'drafted',
    draft_subject VARCHAR(500) NOT NULL,
    draft_body TEXT NOT NULL,
    draft_language VARCHAR(10) NOT NULL DEFAULT 'en',
    recipient VARCHAR(255) NOT NULL,
    gemini_polish_applied BOOLEAN NOT NULL DEFAULT FALSE,
    drafted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_status_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    submitted_at TIMESTAMP WITH TIME ZONE,
    resolved_at TIMESTAMP WITH TIME ZONE,
    notes TEXT
);

-- Create indexes
CREATE INDEX IF NOT EXISTS ix_takedown_cases_status_drafted ON takedown_cases(status, drafted_at);
CREATE INDEX IF NOT EXISTS ix_takedown_cases_verification_result ON takedown_cases(verification_result_id);

-- Create takedown_events table
CREATE TABLE IF NOT EXISTS takedown_events (
    id UUID PRIMARY KEY,
    case_id UUID NOT NULL REFERENCES takedown_cases(id) ON DELETE CASCADE,
    from_status takedown_status,
    to_status takedown_status NOT NULL,
    actor VARCHAR(255) NOT NULL DEFAULT 'system',
    payload JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create index
CREATE INDEX IF NOT EXISTS ix_takedown_events_case_created ON takedown_events(case_id, created_at);

-- Update alembic version
INSERT INTO alembic_version (version_num) VALUES ('20260428_0004') ON CONFLICT DO NOTHING;
