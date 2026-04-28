"""phase5_dmca

Revision ID: 20260428_0004
Revises: 20260428_0003
Create Date: 2026-04-28

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '20260428_0004'
down_revision = '20260428_0003'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create rights_holders table
    op.create_table(
        'rights_holders',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('legal_email', sa.String(length=255), nullable=False),
        sa.Column('address', sa.Text(), nullable=False),
        sa.Column('authorized_agent', sa.String(length=255), nullable=False),
        sa.Column('default_language', sa.String(length=10), nullable=False, server_default='en'),
        sa.Column('signature_block', sa.Text(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.PrimaryKeyConstraint('id')
    )

    # Create takedown_status enum (if not exists)
    op.execute("""
        DO $$ BEGIN
            CREATE TYPE takedown_status AS ENUM (
                'drafted', 'pending_review', 'submitted', 
                'acknowledged', 'taken_down', 'expired', 'rejected'
            );
        EXCEPTION
            WHEN duplicate_object THEN null;
        END $$;
    """)

    # Create takedown_cases table
    op.create_table(
        'takedown_cases',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('verification_result_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('candidate_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('match_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('rights_holder_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column('platform', sa.String(length=64), nullable=False),
        sa.Column('status', sa.Enum('drafted', 'pending_review', 'submitted', 'acknowledged', 'taken_down', 'expired', 'rejected', name='takedown_status'), nullable=False, server_default='drafted'),
        sa.Column('draft_subject', sa.String(length=500), nullable=False),
        sa.Column('draft_body', sa.Text(), nullable=False),
        sa.Column('draft_language', sa.String(length=10), nullable=False, server_default='en'),
        sa.Column('recipient', sa.String(length=255), nullable=False),
        sa.Column('gemini_polish_applied', sa.Boolean(), nullable=False, server_default='false'),
        sa.Column('drafted_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('last_status_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('submitted_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('resolved_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('notes', sa.Text(), nullable=True),
        sa.ForeignKeyConstraint(['verification_result_id'], ['verification_results.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['candidate_id'], ['candidate_streams.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['match_id'], ['matches.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['rights_holder_id'], ['rights_holders.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('verification_result_id')
    )
    op.create_index('ix_takedown_cases_status_drafted', 'takedown_cases', ['status', 'drafted_at'])
    op.create_index('ix_takedown_cases_verification_result', 'takedown_cases', ['verification_result_id'])

    # Create takedown_events table
    op.create_table(
        'takedown_events',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('case_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('from_status', sa.Enum('drafted', 'pending_review', 'submitted', 'acknowledged', 'taken_down', 'expired', 'rejected', name='takedown_status'), nullable=True),
        sa.Column('to_status', sa.Enum('drafted', 'pending_review', 'submitted', 'acknowledged', 'taken_down', 'expired', 'rejected', name='takedown_status'), nullable=False),
        sa.Column('actor', sa.String(length=255), nullable=False, server_default='system'),
        sa.Column('payload', postgresql.JSONB(astext_type=sa.Text()), nullable=False, server_default='{}'),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.ForeignKeyConstraint(['case_id'], ['takedown_cases.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index('ix_takedown_events_case_created', 'takedown_events', ['case_id', 'created_at'])


def downgrade() -> None:
    op.drop_index('ix_takedown_events_case_created', table_name='takedown_events')
    op.drop_table('takedown_events')
    op.drop_index('ix_takedown_cases_verification_result', table_name='takedown_cases')
    op.drop_index('ix_takedown_cases_status_drafted', table_name='takedown_cases')
    op.drop_table('takedown_cases')
    op.execute('DROP TYPE takedown_status')
    op.drop_table('rights_holders')
