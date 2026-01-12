--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO ghii;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_attachments_id_seq OWNER TO ghii;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO ghii;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_blobs_id_seq OWNER TO ghii;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO ghii;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_variant_records_id_seq OWNER TO ghii;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: affiliations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.affiliations (
    affliation_id bigint NOT NULL,
    employee_id integer NOT NULL,
    department_id integer NOT NULL,
    started_on date NOT NULL,
    ended_on date,
    is_terminated boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.affiliations OWNER TO root;

--
-- Name: affiliations_affliation_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.affiliations_affliation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.affiliations_affliation_id_seq OWNER TO root;

--
-- Name: affiliations_affliation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.affiliations_affliation_id_seq OWNED BY public.affiliations.affliation_id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO root;

--
-- Name: asset_categories; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.asset_categories (
    id bigint NOT NULL,
    category character varying NOT NULL,
    description text,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.asset_categories OWNER TO root;

--
-- Name: asset_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.asset_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_categories_id_seq OWNER TO root;

--
-- Name: asset_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.asset_categories_id_seq OWNED BY public.asset_categories.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.assets (
    asset_id bigint NOT NULL,
    asset_category_id integer NOT NULL,
    tag_id character varying NOT NULL,
    description character varying NOT NULL,
    make character varying,
    model character varying,
    serial_number character varying,
    location character varying NOT NULL,
    value double precision NOT NULL,
    status character varying NOT NULL,
    disposal_reason character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    requisition_id integer
);


ALTER TABLE public.assets OWNER TO root;

--
-- Name: assets_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.assets_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assets_asset_id_seq OWNER TO root;

--
-- Name: assets_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.assets_asset_id_seq OWNED BY public.assets.asset_id;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.branches (
    branch_id bigint NOT NULL,
    branch_name character varying NOT NULL,
    country character varying NOT NULL,
    city character varying NOT NULL,
    location character varying NOT NULL,
    created_by integer,
    closed_by integer,
    is_open boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.branches OWNER TO root;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.branches_branch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branches_branch_id_seq OWNER TO root;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.branches_branch_id_seq OWNED BY public.branches.branch_id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.departments (
    department_id bigint NOT NULL,
    branch_id integer NOT NULL,
    department_name character varying NOT NULL,
    is_active boolean DEFAULT true,
    created_by integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.departments OWNER TO root;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.departments_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_department_id_seq OWNER TO root;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- Name: designation_workflow_state_actions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.designation_workflow_state_actions (
    id bigint NOT NULL,
    workflow_state_id integer NOT NULL,
    designation_id integer NOT NULL,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.designation_workflow_state_actions OWNER TO root;

--
-- Name: designation_workflow_state_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.designation_workflow_state_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designation_workflow_state_actions_id_seq OWNER TO root;

--
-- Name: designation_workflow_state_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.designation_workflow_state_actions_id_seq OWNED BY public.designation_workflow_state_actions.id;


--
-- Name: designations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.designations (
    designation_id bigint NOT NULL,
    department_id integer NOT NULL,
    designated_role character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.designations OWNER TO root;

--
-- Name: designations_designation_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.designations_designation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designations_designation_id_seq OWNER TO root;

--
-- Name: designations_designation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.designations_designation_id_seq OWNED BY public.designations.designation_id;


--
-- Name: employee_designations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.employee_designations (
    employee_designation_id bigint NOT NULL,
    employee_id integer NOT NULL,
    designation_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.employee_designations OWNER TO root;

--
-- Name: employee_designations_employee_designation_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.employee_designations_employee_designation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_designations_employee_designation_id_seq OWNER TO root;

--
-- Name: employee_designations_employee_designation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.employee_designations_employee_designation_id_seq OWNED BY public.employee_designations.employee_designation_id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.employees (
    employee_id bigint NOT NULL,
    person_id integer NOT NULL,
    employment_date date NOT NULL,
    still_employed boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    departure_date date,
    "#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition" date
);


ALTER TABLE public.employees OWNER TO root;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.employees_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_employee_id_seq OWNER TO root;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: global_properties; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.global_properties (
    property_id bigint NOT NULL,
    property character varying,
    property_value character varying,
    description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.global_properties OWNER TO root;

--
-- Name: global_properties_property_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.global_properties_property_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.global_properties_property_id_seq OWNER TO root;

--
-- Name: global_properties_property_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.global_properties_property_id_seq OWNED BY public.global_properties.property_id;


--
-- Name: initial_states; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.initial_states (
    initial_state_id bigint NOT NULL,
    workflow_process_id integer,
    workflow_state_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.initial_states OWNER TO root;

--
-- Name: initial_states_initial_state_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.initial_states_initial_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.initial_states_initial_state_id_seq OWNER TO root;

--
-- Name: initial_states_initial_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.initial_states_initial_state_id_seq OWNED BY public.initial_states.initial_state_id;


--
-- Name: inventory_item_categories; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.inventory_item_categories (
    inventory_item_category_id bigint NOT NULL,
    category character varying NOT NULL,
    voided boolean DEFAULT false NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.inventory_item_categories OWNER TO root;

--
-- Name: inventory_item_categories_inventory_item_category_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.inventory_item_categories_inventory_item_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_item_categories_inventory_item_category_id_seq OWNER TO root;

--
-- Name: inventory_item_categories_inventory_item_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.inventory_item_categories_inventory_item_category_id_seq OWNED BY public.inventory_item_categories.inventory_item_category_id;


--
-- Name: inventory_item_issues; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.inventory_item_issues (
    id bigint NOT NULL,
    requisition_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity_issued numeric DEFAULT 0.0 NOT NULL,
    issue_date date NOT NULL,
    issued_by integer NOT NULL,
    issued_to integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.inventory_item_issues OWNER TO root;

--
-- Name: inventory_item_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.inventory_item_issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_item_issues_id_seq OWNER TO root;

--
-- Name: inventory_item_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.inventory_item_issues_id_seq OWNED BY public.inventory_item_issues.id;


--
-- Name: inventory_item_thresholds; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.inventory_item_thresholds (
    inventory_item_threshold_id bigint NOT NULL,
    inventory_item_id integer NOT NULL,
    minimum_quantity numeric DEFAULT 0.0,
    maximum_quantity numeric DEFAULT 0.0,
    voided boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.inventory_item_thresholds OWNER TO root;

--
-- Name: inventory_item_thresholds_inventory_item_threshold_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.inventory_item_thresholds_inventory_item_threshold_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_item_thresholds_inventory_item_threshold_id_seq OWNER TO root;

--
-- Name: inventory_item_thresholds_inventory_item_threshold_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.inventory_item_thresholds_inventory_item_threshold_id_seq OWNED BY public.inventory_item_thresholds.inventory_item_threshold_id;


--
-- Name: inventory_item_types; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.inventory_item_types (
    inventory_item_type_id bigint NOT NULL,
    inventory_item_category_id integer NOT NULL,
    item_name character varying NOT NULL,
    manufacturer character varying NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.inventory_item_types OWNER TO root;

--
-- Name: inventory_item_types_inventory_item_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.inventory_item_types_inventory_item_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_item_types_inventory_item_type_id_seq OWNER TO root;

--
-- Name: inventory_item_types_inventory_item_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.inventory_item_types_inventory_item_type_id_seq OWNED BY public.inventory_item_types.inventory_item_type_id;


--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.inventory_items (
    inventory_item_id bigint NOT NULL,
    item_type_id integer NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    quantity_used integer DEFAULT 0 NOT NULL,
    supplier character varying NOT NULL,
    unit_price numeric(10,2),
    storage_location character varying,
    created_by integer NOT NULL,
    voided_by integer,
    voided boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.inventory_items OWNER TO root;

--
-- Name: inventory_items_inventory_item_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.inventory_items_inventory_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_items_inventory_item_id_seq OWNER TO root;

--
-- Name: inventory_items_inventory_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.inventory_items_inventory_item_id_seq OWNED BY public.inventory_items.inventory_item_id;


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.leave_requests (
    leave_request_id bigint NOT NULL,
    leave_type character varying NOT NULL,
    employee_id integer NOT NULL,
    start_on timestamp(6) without time zone NOT NULL,
    end_on timestamp(6) without time zone NOT NULL,
    stand_in integer NOT NULL,
    reviewed_by integer,
    reviewed_on boolean,
    approved_by integer,
    approved_on boolean,
    status integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.leave_requests OWNER TO root;

--
-- Name: leave_requests_leave_request_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.leave_requests_leave_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leave_requests_leave_request_id_seq OWNER TO root;

--
-- Name: leave_requests_leave_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.leave_requests_leave_request_id_seq OWNED BY public.leave_requests.leave_request_id;


--
-- Name: leave_summaries; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.leave_summaries (
    leave_summary_id bigint NOT NULL,
    leave_type character varying NOT NULL,
    employee_id integer NOT NULL,
    leave_days_total double precision NOT NULL,
    leave_days_balance double precision NOT NULL,
    financial_year integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.leave_summaries OWNER TO root;

--
-- Name: leave_summaries_leave_summary_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.leave_summaries_leave_summary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leave_summaries_leave_summary_id_seq OWNER TO root;

--
-- Name: leave_summaries_leave_summary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.leave_summaries_leave_summary_id_seq OWNED BY public.leave_summaries.leave_summary_id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.logs (
    id bigint NOT NULL,
    loggable_type character varying NOT NULL,
    loggable_id bigint NOT NULL,
    prev_state integer,
    next_state integer,
    transition integer,
    transition_by integer,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.logs OWNER TO ghii;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_id_seq OWNER TO ghii;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.people (
    person_id bigint NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    birth_date date NOT NULL,
    gender character varying NOT NULL,
    marital_status character varying NOT NULL,
    primary_phone character varying,
    alt_phone character varying,
    email_address character varying,
    official_email character varying,
    postal_address character varying,
    residential_address character varying,
    landmark character varying,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.people OWNER TO root;

--
-- Name: people_person_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.people_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.people_person_id_seq OWNER TO root;

--
-- Name: people_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.people_person_id_seq OWNED BY public.people.person_id;


--
-- Name: petty_cash_comments; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.petty_cash_comments (
    id bigint NOT NULL,
    comment text,
    used_amount numeric(10,2),
    requisition_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.petty_cash_comments OWNER TO root;

--
-- Name: petty_cash_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.petty_cash_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.petty_cash_comments_id_seq OWNER TO root;

--
-- Name: petty_cash_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.petty_cash_comments_id_seq OWNED BY public.petty_cash_comments.id;


--
-- Name: project_task_assignments; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.project_task_assignments (
    project_task_assignment_id bigint NOT NULL,
    project_task_id integer NOT NULL,
    assigned_to integer NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.project_task_assignments OWNER TO root;

--
-- Name: project_task_assignments_project_task_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.project_task_assignments_project_task_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_task_assignments_project_task_assignment_id_seq OWNER TO root;

--
-- Name: project_task_assignments_project_task_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.project_task_assignments_project_task_assignment_id_seq OWNED BY public.project_task_assignments.project_task_assignment_id;


--
-- Name: project_tasks; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.project_tasks (
    project_task_id bigint NOT NULL,
    project_id integer NOT NULL,
    task_description character varying NOT NULL,
    estimated_duration numeric,
    deadline timestamp(6) without time zone,
    task_status character varying,
    performed_by integer,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.project_tasks OWNER TO root;

--
-- Name: project_tasks_project_task_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.project_tasks_project_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_tasks_project_task_id_seq OWNER TO root;

--
-- Name: project_tasks_project_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.project_tasks_project_task_id_seq OWNED BY public.project_tasks.project_task_id;


--
-- Name: project_teams; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.project_teams (
    project_team_id bigint NOT NULL,
    project_id integer NOT NULL,
    employee_id integer NOT NULL,
    allocated_effort double precision DEFAULT 0.0,
    start_date date NOT NULL,
    end_date date,
    voided boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.project_teams OWNER TO root;

--
-- Name: project_teams_project_team_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.project_teams_project_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_teams_project_team_id_seq OWNER TO root;

--
-- Name: project_teams_project_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.project_teams_project_team_id_seq OWNED BY public.project_teams.project_team_id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.projects (
    project_id bigint NOT NULL,
    project_name character varying NOT NULL,
    short_name character varying,
    project_description character varying NOT NULL,
    manager integer NOT NULL,
    created_by integer,
    closed_by integer,
    is_active boolean DEFAULT true NOT NULL,
    completed_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.projects OWNER TO root;

--
-- Name: projects_project_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.projects_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_project_id_seq OWNER TO root;

--
-- Name: projects_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.projects_project_id_seq OWNED BY public.projects.project_id;


--
-- Name: purchase_request_attachments; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.purchase_request_attachments (
    id bigint NOT NULL,
    requisition_id bigint NOT NULL,
    voided boolean,
    comments text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    stakeholder_id integer,
    supplier character varying,
    item_requested character varying,
    requires_ipc boolean DEFAULT false
);


ALTER TABLE public.purchase_request_attachments OWNER TO ghii;

--
-- Name: purchase_request_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.purchase_request_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_request_attachments_id_seq OWNER TO ghii;

--
-- Name: purchase_request_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.purchase_request_attachments_id_seq OWNED BY public.purchase_request_attachments.id;


--
-- Name: report_statistics; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.report_statistics (
    statistic_id bigint NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    period_label character varying NOT NULL,
    statistic_description character varying NOT NULL,
    statistic_value numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.report_statistics OWNER TO root;

--
-- Name: report_statistics_statistic_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.report_statistics_statistic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_statistics_statistic_id_seq OWNER TO root;

--
-- Name: report_statistics_statistic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.report_statistics_statistic_id_seq OWNED BY public.report_statistics.statistic_id;


--
-- Name: requisition_items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.requisition_items (
    requisition_item_id bigint NOT NULL,
    requisition_id integer NOT NULL,
    quantity numeric,
    value numeric,
    item_description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.requisition_items OWNER TO root;

--
-- Name: requisition_items_requisition_item_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.requisition_items_requisition_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requisition_items_requisition_item_id_seq OWNER TO root;

--
-- Name: requisition_items_requisition_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.requisition_items_requisition_item_id_seq OWNED BY public.requisition_items.requisition_item_id;


--
-- Name: requisition_notes; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.requisition_notes (
    id bigint NOT NULL,
    requisition_id integer NOT NULL,
    user_id integer NOT NULL,
    note text,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.requisition_notes OWNER TO root;

--
-- Name: requisition_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.requisition_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requisition_notes_id_seq OWNER TO root;

--
-- Name: requisition_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.requisition_notes_id_seq OWNED BY public.requisition_notes.id;


--
-- Name: requisitions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.requisitions (
    requisition_id bigint NOT NULL,
    purpose character varying NOT NULL,
    initiated_by integer NOT NULL,
    initiated_on timestamp(6) without time zone NOT NULL,
    requisition_type character varying NOT NULL,
    reviewed_by integer,
    approved_by integer,
    workflow_state_id integer NOT NULL,
    voided boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    project_id integer,
    department_id integer
);


ALTER TABLE public.requisitions OWNER TO root;

--
-- Name: requisitions_requisition_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.requisitions_requisition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requisitions_requisition_id_seq OWNER TO root;

--
-- Name: requisitions_requisition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.requisitions_requisition_id_seq OWNED BY public.requisitions.requisition_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO root;

--
-- Name: stakeholders; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.stakeholders (
    stakeholder_id bigint NOT NULL,
    stakeholder_name character varying NOT NULL,
    contact_email character varying,
    is_partner boolean DEFAULT false,
    is_donor boolean DEFAULT false,
    donation_frequency character varying,
    partnership_tier character varying,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.stakeholders OWNER TO ghii;

--
-- Name: stakeholders_stakeholder_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.stakeholders_stakeholder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stakeholders_stakeholder_id_seq OWNER TO ghii;

--
-- Name: stakeholders_stakeholder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.stakeholders_stakeholder_id_seq OWNED BY public.stakeholders.stakeholder_id;


--
-- Name: supervisions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.supervisions (
    supervision_id bigint NOT NULL,
    supervisor integer NOT NULL,
    supervisee integer NOT NULL,
    started_on date,
    ended_on date,
    is_terminated boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.supervisions OWNER TO root;

--
-- Name: supervisions_supervision_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.supervisions_supervision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supervisions_supervision_id_seq OWNER TO root;

--
-- Name: supervisions_supervision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.supervisions_supervision_id_seq OWNED BY public.supervisions.supervision_id;


--
-- Name: timesheet_tasks; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.timesheet_tasks (
    id bigint NOT NULL,
    timesheet_id integer NOT NULL,
    project_id integer NOT NULL,
    task_date date NOT NULL,
    description character varying,
    duration numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.timesheet_tasks OWNER TO root;

--
-- Name: timesheet_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.timesheet_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timesheet_tasks_id_seq OWNER TO root;

--
-- Name: timesheet_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.timesheet_tasks_id_seq OWNED BY public.timesheet_tasks.id;


--
-- Name: timesheets; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.timesheets (
    timesheet_id bigint NOT NULL,
    employee_id integer NOT NULL,
    timesheet_week date NOT NULL,
    submitted_on timestamp(6) without time zone,
    approved_by integer,
    approved_on timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state integer
);


ALTER TABLE public.timesheets OWNER TO root;

--
-- Name: timesheets_timesheet_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.timesheets_timesheet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timesheets_timesheet_id_seq OWNER TO root;

--
-- Name: timesheets_timesheet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.timesheets_timesheet_id_seq OWNED BY public.timesheets.timesheet_id;


--
-- Name: token_logs; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.token_logs (
    token_id bigint NOT NULL,
    token character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.token_logs OWNER TO root;

--
-- Name: token_logs_token_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.token_logs_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_logs_token_id_seq OWNER TO root;

--
-- Name: token_logs_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.token_logs_token_id_seq OWNED BY public.token_logs.token_id;


--
-- Name: travel_requests; Type: TABLE; Schema: public; Owner: ghii
--

CREATE TABLE public.travel_requests (
    id bigint NOT NULL,
    requisition_id bigint NOT NULL,
    distance integer,
    voided boolean DEFAULT false,
    traveler_names text,
    departure_date timestamp without time zone,
    return_date timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    destination character varying,
    asset_id integer
);


ALTER TABLE public.travel_requests OWNER TO ghii;

--
-- Name: travel_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: ghii
--

CREATE SEQUENCE public.travel_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.travel_requests_id_seq OWNER TO ghii;

--
-- Name: travel_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ghii
--

ALTER SEQUENCE public.travel_requests_id_seq OWNED BY public.travel_requests.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    employee_id integer NOT NULL,
    username character varying NOT NULL,
    password_digest character varying,
    password_confirmation character varying,
    activated_at timestamp without time zone,
    deactivated_at timestamp without time zone,
    reset_needed boolean DEFAULT false NOT NULL,
    activated boolean DEFAULT false,
    last_login timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO root;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO root;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: workflow_processes; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workflow_processes (
    workflow_process_id bigint NOT NULL,
    workflow character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active boolean DEFAULT true
);


ALTER TABLE public.workflow_processes OWNER TO root;

--
-- Name: workflow_processes_workflow_process_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.workflow_processes_workflow_process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_processes_workflow_process_id_seq OWNER TO root;

--
-- Name: workflow_processes_workflow_process_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.workflow_processes_workflow_process_id_seq OWNED BY public.workflow_processes.workflow_process_id;


--
-- Name: workflow_state_actions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workflow_state_actions (
    id bigint NOT NULL,
    workflow_state_id integer NOT NULL,
    state_action character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.workflow_state_actions OWNER TO root;

--
-- Name: workflow_state_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.workflow_state_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_state_actions_id_seq OWNER TO root;

--
-- Name: workflow_state_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.workflow_state_actions_id_seq OWNED BY public.workflow_state_actions.id;


--
-- Name: workflow_state_actors; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workflow_state_actors (
    id bigint NOT NULL,
    workflow_state_id integer NOT NULL,
    employee_designation_id integer NOT NULL,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.workflow_state_actors OWNER TO root;

--
-- Name: workflow_state_actors_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.workflow_state_actors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_state_actors_id_seq OWNER TO root;

--
-- Name: workflow_state_actors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.workflow_state_actors_id_seq OWNED BY public.workflow_state_actors.id;


--
-- Name: workflow_state_transitioners; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workflow_state_transitioners (
    id bigint NOT NULL,
    workflow_state_transition integer,
    stakeholder integer,
    start_date date,
    end_date date,
    voided boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.workflow_state_transitioners OWNER TO root;

--
-- Name: workflow_state_transitioners_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.workflow_state_transitioners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_state_transitioners_id_seq OWNER TO root;

--
-- Name: workflow_state_transitioners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.workflow_state_transitioners_id_seq OWNED BY public.workflow_state_transitioners.id;


--
-- Name: workflow_state_transitions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workflow_state_transitions (
    id bigint NOT NULL,
    workflow_state_id integer NOT NULL,
    next_state integer NOT NULL,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    action character varying NOT NULL,
    by_owner boolean DEFAULT false,
    by_supervisor boolean DEFAULT false
);


ALTER TABLE public.workflow_state_transitions OWNER TO root;

--
-- Name: workflow_state_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.workflow_state_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_state_transitions_id_seq OWNER TO root;

--
-- Name: workflow_state_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.workflow_state_transitions_id_seq OWNED BY public.workflow_state_transitions.id;


--
-- Name: workflow_states; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workflow_states (
    workflow_state_id bigint NOT NULL,
    workflow_process_id integer,
    state character varying NOT NULL,
    description character varying,
    voided boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.workflow_states OWNER TO root;

--
-- Name: workflow_states_workflow_state_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.workflow_states_workflow_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_states_workflow_state_id_seq OWNER TO root;

--
-- Name: workflow_states_workflow_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.workflow_states_workflow_state_id_seq OWNED BY public.workflow_states.workflow_state_id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: affiliations affliation_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.affiliations ALTER COLUMN affliation_id SET DEFAULT nextval('public.affiliations_affliation_id_seq'::regclass);


--
-- Name: asset_categories id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.asset_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_categories_id_seq'::regclass);


--
-- Name: assets asset_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.assets ALTER COLUMN asset_id SET DEFAULT nextval('public.assets_asset_id_seq'::regclass);


--
-- Name: branches branch_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.branches ALTER COLUMN branch_id SET DEFAULT nextval('public.branches_branch_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- Name: designation_workflow_state_actions id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.designation_workflow_state_actions ALTER COLUMN id SET DEFAULT nextval('public.designation_workflow_state_actions_id_seq'::regclass);


--
-- Name: designations designation_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.designations ALTER COLUMN designation_id SET DEFAULT nextval('public.designations_designation_id_seq'::regclass);


--
-- Name: employee_designations employee_designation_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.employee_designations ALTER COLUMN employee_designation_id SET DEFAULT nextval('public.employee_designations_employee_designation_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: global_properties property_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.global_properties ALTER COLUMN property_id SET DEFAULT nextval('public.global_properties_property_id_seq'::regclass);


--
-- Name: initial_states initial_state_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.initial_states ALTER COLUMN initial_state_id SET DEFAULT nextval('public.initial_states_initial_state_id_seq'::regclass);


--
-- Name: inventory_item_categories inventory_item_category_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_categories ALTER COLUMN inventory_item_category_id SET DEFAULT nextval('public.inventory_item_categories_inventory_item_category_id_seq'::regclass);


--
-- Name: inventory_item_issues id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_issues ALTER COLUMN id SET DEFAULT nextval('public.inventory_item_issues_id_seq'::regclass);


--
-- Name: inventory_item_thresholds inventory_item_threshold_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_thresholds ALTER COLUMN inventory_item_threshold_id SET DEFAULT nextval('public.inventory_item_thresholds_inventory_item_threshold_id_seq'::regclass);


--
-- Name: inventory_item_types inventory_item_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_types ALTER COLUMN inventory_item_type_id SET DEFAULT nextval('public.inventory_item_types_inventory_item_type_id_seq'::regclass);


--
-- Name: inventory_items inventory_item_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_items ALTER COLUMN inventory_item_id SET DEFAULT nextval('public.inventory_items_inventory_item_id_seq'::regclass);


--
-- Name: leave_requests leave_request_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN leave_request_id SET DEFAULT nextval('public.leave_requests_leave_request_id_seq'::regclass);


--
-- Name: leave_summaries leave_summary_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.leave_summaries ALTER COLUMN leave_summary_id SET DEFAULT nextval('public.leave_summaries_leave_summary_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: people person_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.people ALTER COLUMN person_id SET DEFAULT nextval('public.people_person_id_seq'::regclass);


--
-- Name: petty_cash_comments id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.petty_cash_comments ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_comments_id_seq'::regclass);


--
-- Name: project_task_assignments project_task_assignment_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.project_task_assignments ALTER COLUMN project_task_assignment_id SET DEFAULT nextval('public.project_task_assignments_project_task_assignment_id_seq'::regclass);


--
-- Name: project_tasks project_task_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.project_tasks ALTER COLUMN project_task_id SET DEFAULT nextval('public.project_tasks_project_task_id_seq'::regclass);


--
-- Name: project_teams project_team_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.project_teams ALTER COLUMN project_team_id SET DEFAULT nextval('public.project_teams_project_team_id_seq'::regclass);


--
-- Name: projects project_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.projects ALTER COLUMN project_id SET DEFAULT nextval('public.projects_project_id_seq'::regclass);


--
-- Name: purchase_request_attachments id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.purchase_request_attachments ALTER COLUMN id SET DEFAULT nextval('public.purchase_request_attachments_id_seq'::regclass);


--
-- Name: report_statistics statistic_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.report_statistics ALTER COLUMN statistic_id SET DEFAULT nextval('public.report_statistics_statistic_id_seq'::regclass);


--
-- Name: requisition_items requisition_item_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisition_items ALTER COLUMN requisition_item_id SET DEFAULT nextval('public.requisition_items_requisition_item_id_seq'::regclass);


--
-- Name: requisition_notes id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisition_notes ALTER COLUMN id SET DEFAULT nextval('public.requisition_notes_id_seq'::regclass);


--
-- Name: requisitions requisition_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisitions ALTER COLUMN requisition_id SET DEFAULT nextval('public.requisitions_requisition_id_seq'::regclass);


--
-- Name: stakeholders stakeholder_id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.stakeholders ALTER COLUMN stakeholder_id SET DEFAULT nextval('public.stakeholders_stakeholder_id_seq'::regclass);


--
-- Name: supervisions supervision_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.supervisions ALTER COLUMN supervision_id SET DEFAULT nextval('public.supervisions_supervision_id_seq'::regclass);


--
-- Name: timesheet_tasks id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.timesheet_tasks ALTER COLUMN id SET DEFAULT nextval('public.timesheet_tasks_id_seq'::regclass);


--
-- Name: timesheets timesheet_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.timesheets ALTER COLUMN timesheet_id SET DEFAULT nextval('public.timesheets_timesheet_id_seq'::regclass);


--
-- Name: token_logs token_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.token_logs ALTER COLUMN token_id SET DEFAULT nextval('public.token_logs_token_id_seq'::regclass);


--
-- Name: travel_requests id; Type: DEFAULT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.travel_requests ALTER COLUMN id SET DEFAULT nextval('public.travel_requests_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: workflow_processes workflow_process_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_processes ALTER COLUMN workflow_process_id SET DEFAULT nextval('public.workflow_processes_workflow_process_id_seq'::regclass);


--
-- Name: workflow_state_actions id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_actions ALTER COLUMN id SET DEFAULT nextval('public.workflow_state_actions_id_seq'::regclass);


--
-- Name: workflow_state_actors id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_actors ALTER COLUMN id SET DEFAULT nextval('public.workflow_state_actors_id_seq'::regclass);


--
-- Name: workflow_state_transitioners id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_transitioners ALTER COLUMN id SET DEFAULT nextval('public.workflow_state_transitioners_id_seq'::regclass);


--
-- Name: workflow_state_transitions id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_transitions ALTER COLUMN id SET DEFAULT nextval('public.workflow_state_transitions_id_seq'::regclass);


--
-- Name: workflow_states workflow_state_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_states ALTER COLUMN workflow_state_id SET DEFAULT nextval('public.workflow_states_workflow_state_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: affiliations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.affiliations (affliation_id, employee_id, department_id, started_on, ended_on, is_terminated, created_at, updated_at) FROM stdin;
1	7	1	2021-10-29	\N	f	2024-04-24 14:18:18.001931	2024-04-24 14:18:18.001931
2	10	1	2022-09-26	\N	f	2024-04-24 14:18:18.00759	2024-04-24 14:18:18.00759
3	34	1	2023-01-03	2024-02-27	t	2024-04-24 14:18:18.012513	2024-04-24 14:18:18.012513
4	39	1	2022-03-28	\N	f	2024-04-24 14:18:18.01842	2024-04-24 14:18:18.01842
5	62	1	2024-01-29	\N	f	2024-04-24 14:18:18.023073	2024-04-24 14:18:18.023073
6	63	1	2024-01-29	2024-01-31	t	2024-04-24 14:18:18.026982	2024-04-24 14:18:18.026982
7	69	1	2024-02-08	\N	f	2024-04-24 14:18:18.034156	2024-04-24 14:18:18.034156
8	72	1	2024-02-21	2024-03-21	t	2024-04-24 14:18:18.038157	2024-04-24 14:18:18.038157
9	73	1	2024-03-06	\N	f	2024-04-24 14:18:18.042133	2024-04-24 14:18:18.042133
10	75	1	2024-04-02	\N	f	2024-04-24 14:18:18.04572	2024-04-24 14:18:18.04572
11	11	1	2022-01-26	\N	f	2024-04-24 14:23:34.810086	2024-04-24 14:23:34.810086
12	23	4	2023-02-20	2023-05-22	t	2024-04-24 14:27:54.74399	2024-04-24 14:27:54.74399
13	46	4	2023-06-06	\N	f	2024-04-24 14:27:54.748594	2024-04-24 14:27:54.748594
14	22	1	2021-11-01	\N	f	2024-04-24 14:29:46.146808	2024-04-24 14:29:46.146808
15	1	1	2023-01-03	2023-11-04	t	2024-04-25 06:29:45.612041	2024-04-25 06:29:45.612041
16	65	1	2024-01-30	\N	f	2024-04-25 06:29:45.616813	2024-04-25 06:29:45.616813
17	68	1	2022-04-28	2023-12-31	t	2024-04-25 06:29:45.620053	2024-04-25 06:29:45.620053
18	2	2	2021-10-01	\N	f	2024-04-25 06:32:15.099418	2024-04-25 06:32:15.099418
19	3	2	2022-11-28	2023-12-25	t	2024-04-25 06:32:15.102681	2024-04-25 06:32:15.102681
20	4	2	2022-11-28	2023-09-06	t	2024-04-25 06:32:15.105446	2024-04-25 06:32:15.105446
21	5	2	2023-04-03	2023-10-02	t	2024-04-25 06:32:15.108403	2024-04-25 06:32:15.108403
22	6	2	2023-03-01	\N	f	2024-04-25 06:32:15.110973	2024-04-25 06:32:15.110973
23	8	2	2022-10-01	\N	f	2024-04-25 06:32:15.113581	2024-04-25 06:32:15.113581
24	9	2	2022-11-28	\N	f	2024-04-25 06:32:15.116411	2024-04-25 06:32:15.116411
25	12	2	2023-04-11	\N	f	2024-04-25 06:32:15.118904	2024-04-25 06:32:15.118904
26	13	2	2023-04-03	2023-08-25	t	2024-04-25 06:32:15.121591	2024-04-25 06:32:15.121591
27	14	2	2022-10-10	2023-04-28	t	2024-04-25 06:32:15.124309	2024-04-25 06:32:15.124309
28	15	2	2022-01-10	2023-01-31	t	2024-04-25 06:32:15.126795	2024-04-25 06:32:15.126795
29	16	2	2022-08-29	2023-03-10	t	2024-04-25 06:32:15.129354	2024-04-25 06:32:15.129354
30	17	2	2021-10-01	2023-01-15	t	2024-04-25 06:32:15.132448	2024-04-25 06:32:15.132448
31	18	2	2023-04-11	2023-10-09	t	2024-04-25 06:32:15.135448	2024-04-25 06:32:15.135448
32	19	2	2023-04-11	2023-08-25	t	2024-04-25 06:32:15.138323	2024-04-25 06:32:15.138323
33	20	2	2022-11-22	\N	f	2024-04-25 06:32:15.141499	2024-04-25 06:32:15.141499
34	21	2	2023-06-19	2023-08-25	t	2024-04-25 06:32:15.144559	2024-04-25 06:32:15.144559
35	24	2	2022-11-28	\N	f	2024-04-25 06:32:15.147518	2024-04-25 06:32:15.147518
36	25	2	2023-03-02	2023-09-06	t	2024-04-25 06:32:15.150576	2024-04-25 06:32:15.150576
37	26	2	2023-03-08	\N	f	2024-04-25 06:32:15.15339	2024-04-25 06:32:15.15339
38	27	2	2022-11-28	\N	f	2024-04-25 06:32:15.15641	2024-04-25 06:32:15.15641
39	28	2	2021-07-06	\N	f	2024-04-25 06:32:15.159719	2024-04-25 06:32:15.159719
40	29	2	2021-07-06	\N	f	2024-04-25 06:32:15.162653	2024-04-25 06:32:15.162653
41	30	2	2022-10-10	2023-04-28	t	2024-04-25 06:32:15.165784	2024-04-25 06:32:15.165784
42	31	2	2022-06-06	\N	f	2024-04-25 06:32:15.168924	2024-04-25 06:32:15.168924
43	32	2	2021-10-29	\N	f	2024-04-25 06:32:15.171722	2024-04-25 06:32:15.171722
44	33	2	2022-10-01	\N	f	2024-04-25 06:32:15.174886	2024-04-25 06:32:15.174886
45	35	2	2022-11-28	\N	f	2024-04-25 06:32:15.177558	2024-04-25 06:32:15.177558
46	36	2	2022-05-26	\N	f	2024-04-25 06:32:15.180704	2024-04-25 06:32:15.180704
47	37	2	2021-10-01	\N	f	2024-04-25 06:32:15.183505	2024-04-25 06:32:15.183505
48	38	2	2022-09-05	\N	f	2024-04-25 06:32:15.186166	2024-04-25 06:32:15.186166
49	40	2	2022-11-28	\N	f	2024-04-25 06:32:15.189051	2024-04-25 06:32:15.189051
50	41	2	2021-10-29	\N	f	2024-04-25 06:32:15.191739	2024-04-25 06:32:15.191739
51	42	2	2023-03-07	\N	f	2024-04-25 06:32:15.194519	2024-04-25 06:32:15.194519
52	43	2	2022-08-01	\N	f	2024-04-25 06:32:15.197562	2024-04-25 06:32:15.197562
53	44	2	2023-07-03	\N	f	2024-04-25 06:32:15.200368	2024-04-25 06:32:15.200368
54	45	2	2023-08-21	\N	f	2024-04-25 06:32:15.20309	2024-04-25 06:32:15.20309
55	47	2	2023-07-03	2023-11-03	t	2024-04-25 06:32:15.206082	2024-04-25 06:32:15.206082
56	48	2	2023-01-18	2023-10-31	t	2024-04-25 06:32:15.208663	2024-04-25 06:32:15.208663
57	50	2	2023-09-25	\N	f	2024-04-25 06:32:15.238252	2024-04-25 06:32:15.238252
58	51	2	2023-10-17	\N	f	2024-04-25 06:32:15.242302	2024-04-25 06:32:15.242302
59	52	2	2023-10-17	\N	f	2024-04-25 06:32:15.245777	2024-04-25 06:32:15.245777
60	53	2	2023-10-17	\N	f	2024-04-25 06:32:15.249185	2024-04-25 06:32:15.249185
61	54	2	2023-10-17	\N	f	2024-04-25 06:32:15.252736	2024-04-25 06:32:15.252736
62	55	2	2023-11-27	\N	f	2024-04-25 06:32:15.256144	2024-04-25 06:32:15.256144
63	56	2	2023-11-27	\N	f	2024-04-25 06:32:15.259548	2024-04-25 06:32:15.259548
64	57	2	2023-11-27	\N	f	2024-04-25 06:32:15.262874	2024-04-25 06:32:15.262874
65	58	2	2023-12-18	\N	f	2024-04-25 06:32:15.26639	2024-04-25 06:32:15.26639
66	59	2	2023-12-11	\N	f	2024-04-25 06:32:15.269388	2024-04-25 06:32:15.269388
67	60	2	2024-01-02	\N	f	2024-04-25 06:32:15.272359	2024-04-25 06:32:15.272359
68	61	2	2024-01-08	\N	f	2024-04-25 06:32:15.275479	2024-04-25 06:32:15.275479
69	66	2	2024-01-22	\N	f	2024-04-25 06:32:15.278365	2024-04-25 06:32:15.278365
70	67	2	2021-10-01	2022-09-02	t	2024-04-25 06:32:15.281509	2024-04-25 06:32:15.281509
71	70	2	2024-02-20	\N	f	2024-04-25 06:32:15.284461	2024-04-25 06:32:15.284461
72	71	2	2024-02-20	\N	f	2024-04-25 06:32:15.288199	2024-04-25 06:32:15.288199
73	74	2	2024-04-02	\N	f	2024-04-25 06:32:15.291578	2024-04-25 06:32:15.291578
74	64	2	2024-02-07	2024-03-29	t	2024-04-25 06:32:15.29461	2024-04-25 06:32:15.29461
75	49	2	2023-09-11	2024-03-29	t	2024-04-25 06:32:15.297428	2024-04-25 06:32:15.297428
76	76	2	2024-04-15	\N	f	2024-04-25 06:32:15.300633	2024-04-25 06:32:15.300633
77	77	2	2024-04-17	\N	f	2024-04-25 06:32:15.338315	2024-04-25 06:32:15.338315
78	78	2	2024-04-17	\N	f	2024-04-25 06:32:15.341982	2024-04-25 06:32:15.341982
79	79	2	2024-04-22	\N	f	2024-04-25 08:14:11.583082	2024-04-25 08:14:11.583082
80	80	2	2024-05-13	\N	f	2024-05-21 06:21:37.569687	2024-05-21 06:21:37.569687
81	81	2	2023-02-01	\N	f	2024-06-14 08:42:34.978883	2024-06-14 08:42:34.978883
82	83	2	2024-06-17	\N	f	2024-06-24 11:06:09.640347	2024-06-24 11:06:09.640347
83	82	2	2024-06-17	\N	f	2024-06-24 11:06:28.017323	2024-06-24 11:06:28.017323
84	84	2	2024-07-01	\N	f	2024-07-02 12:58:14.593447	2024-07-02 12:58:14.593447
85	87	4	2024-09-30	\N	f	2025-01-08 07:19:47.049944	2025-01-08 07:19:47.049944
86	100	1	2025-01-06	\N	f	2025-01-08 07:21:05.962233	2025-01-08 07:21:05.962233
87	95	1	2024-12-02	\N	f	2025-01-08 07:22:22.265461	2025-01-08 07:22:22.265461
88	88	1	2024-09-30	\N	f	2025-01-08 07:23:22.332633	2025-01-08 07:23:22.332633
89	85	2	2024-08-19	\N	f	2025-01-08 07:24:48.963068	2025-01-08 07:24:48.963068
90	99	2	2025-01-06	\N	f	2025-01-08 07:25:28.58435	2025-01-08 07:25:28.58435
91	98	2	2024-12-09	\N	f	2025-01-08 07:27:07.453066	2025-01-08 07:27:07.453066
92	97	2	2024-12-02	\N	f	2025-01-08 07:27:38.229856	2025-01-08 07:27:38.229856
93	96	2	2024-11-29	\N	f	2025-01-08 07:28:21.564639	2025-01-08 07:28:21.564639
94	94	2	2024-11-25	\N	f	2025-01-08 07:29:14.478834	2025-01-08 07:29:14.478834
95	93	2	2024-11-04	\N	f	2025-01-08 07:29:42.770055	2025-01-08 07:29:42.770055
96	92	2	2024-11-04	\N	f	2025-01-08 07:30:19.942737	2025-01-08 07:30:19.942737
97	91	2	2024-10-22	\N	f	2025-01-08 07:30:52.859367	2025-01-08 07:30:52.859367
98	90	2	2024-10-22	\N	f	2025-01-08 07:31:31.637806	2025-01-08 07:31:31.637806
99	89	2	2024-10-22	\N	f	2025-01-08 07:32:11.308209	2025-01-08 07:32:11.308209
100	86	2	2024-08-21	\N	f	2025-01-08 07:32:54.269085	2025-01-08 07:32:54.269085
101	102	2	2025-02-10	\N	f	2025-02-17 06:12:53.944593	2025-02-17 06:12:53.944593
102	104	2	2025-02-24	\N	f	2025-03-19 08:45:23.236405	2025-03-19 08:45:23.239871
103	105	2	2025-03-26	\N	f	2025-03-19 09:15:48.777937	2025-03-19 09:15:48.780556
104	106	2	2025-02-26	\N	f	2025-03-19 09:22:24.282622	2025-03-19 09:22:24.285162
105	107	2	2025-02-24	\N	f	2025-03-19 09:36:12.100689	2025-03-19 09:36:12.103712
106	108	2	2025-03-04	\N	f	2025-03-19 09:41:51.612729	2025-03-19 09:41:51.616053
107	109	2	2025-02-24	\N	f	2025-03-19 09:44:37.977692	2025-03-19 09:44:37.98137
108	110	2	2025-05-05	\N	f	2025-05-02 13:14:05.44621	2025-05-02 13:14:05.449503
109	111	2	2025-05-15	\N	f	2025-05-19 13:48:06.48924	2025-05-19 13:48:06.492181
110	112	2	2025-05-15	\N	f	2025-05-19 13:51:13.216257	2025-05-19 13:51:13.218659
111	113	2	2025-05-15	\N	f	2025-05-19 13:54:58.594964	2025-05-19 13:54:58.598456
112	114	2	2025-05-15	\N	f	2025-05-19 13:58:35.22687	2025-05-19 13:58:35.229105
113	115	2	2025-05-26	\N	f	2025-05-23 10:46:56.39452	2025-05-23 10:46:56.397959
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2024-02-27 11:12:44.485205	2024-02-27 11:12:44.485205
\.


--
-- Data for Name: asset_categories; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.asset_categories (id, category, description, voided, created_at, updated_at) FROM stdin;
1	Vehicles	Motor vehicles	f	2024-02-27 11:16:32.619571	2024-02-27 11:16:32.619571
2	Furniture	Office and other furniture	f	2024-02-27 11:16:32.634278	2024-02-27 11:16:32.634278
3	Electronic Device	All types of electronic devices	f	2024-02-27 11:16:32.640295	2024-02-27 11:16:32.640295
4	Tools	Tools used in the work place	f	2024-02-27 11:16:32.645804	2024-02-27 11:16:32.645804
5	Heavy Machinery	Any fixed machinery	f	2024-02-27 11:16:32.651636	2024-02-27 11:16:32.651636
6	Art	Any art pieces	f	2024-02-27 11:16:32.657025	2024-02-27 11:16:32.657025
7	Antiques	Any antiques	f	2024-02-27 11:16:32.662414	2024-02-27 11:16:32.662414
8	Real Estate	Any pieces of land owned by the firm	f	2024-02-27 11:16:32.667237	2024-02-27 11:16:32.667237
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.assets (asset_id, asset_category_id, tag_id, description, make, model, serial_number, location, value, status, disposal_reason, created_at, updated_at, requisition_id) FROM stdin;
1	3	GHII-ED-0001	Vizio 32 inch screen	Vizio	E320VP	LAUKJAAL5006282	TC- Conference Room	350	In Use	\N	2024-02-27 11:16:32.686523	2024-02-27 11:16:32.686523	\N
2	3	GHII-ED-0002	Vizio 32 inch screen	Vizio	E320VP	LAUKJAEM4500805	TC- Conference Room	350	In Use	\N	2024-02-27 11:16:32.69234	2024-02-27 11:16:32.69234	\N
3	3	GHII-ED-0003	Vizio 32 inch screen	Vizio	E320VP	LAUKJAAM2903124	TC- Conference Room	350	In Use	\N	2024-02-27 11:16:32.696696	2024-02-27 11:16:32.696696	\N
4	3	GHII-ED-0004	Vizio 32 inch screen	Vizio	E320VP	LAUKJAAM1000583	TC- Conference Room	350	In Use	\N	2024-02-27 11:16:32.703261	2024-02-27 11:16:32.703261	\N
5	3	GHII-ED-0005	Vizio 32 inch screen	Vizio	E320VP	LAUKJAAL3002876	TC- Conference Room	350	In Use	\N	2024-02-27 11:16:32.707977	2024-02-27 11:16:32.707977	\N
6	3	GHII-ED-0006	Vizio 32 inch screen	Vizio	E320VP	\N	Emory Team Office (Android Development)	350	In Use	\N	2024-02-27 11:16:32.712382	2024-02-27 11:16:32.712382	\N
7	3	GHII-ED-0007	Acer 24 inch screen	Acer	S241HL	MMLWVAA00142202AE98558	Coding Room	150	In Use	\N	2024-02-27 11:16:32.716669	2024-02-27 11:16:32.716669	\N
8	3	GHII-ED-0008	Acer 24 inch screen	Acer	S241HL	MMLWVAA0015090323C8558	Workshop	150	In Use	\N	2024-02-27 11:16:32.720663	2024-02-27 11:16:32.720663	\N
9	3	GHII-ED-0009	Acer 24 inch screen	Acer	S241HL	MMLWVAA001847048E5855B	Coding Room	150	In Use	\N	2024-02-27 11:16:32.725031	2024-02-27 11:16:32.725031	\N
10	3	GHII-ED-0010	Acer 24 inch screen	Acer	S241HL	MMLWB8800140504F968558	TC- Conference Room	150	In Use	\N	2024-02-27 11:16:32.736641	2024-02-27 11:16:32.736641	\N
11	3	GHII-ED-0011	Acer 24 inch screen	Acer	S241HL	MMLWVAA00151214488558	Director's Office	150	In Use	\N	2024-02-27 11:16:32.74211	2024-02-27 11:16:32.74211	\N
12	3	GHII-ED-0012	Acer 24 inch screen	Acer	S241HL	MMLWVAA00015411683348557	TC- Conference Room	150	In Use	\N	2024-02-27 11:16:32.747242	2024-02-27 11:16:32.747242	\N
13	3	GHII-ED-0013	Acer 24 inch screen	Acer	S241HL	MMLWVAA00150903209C858557	Jerry's Conference Room	150	In Use	\N	2024-02-27 11:16:32.752117	2024-02-27 11:16:32.752117	\N
14	3	GHII-ED-0014	10 inch Raspberry Pi screen	\N	\N	N/A	GHII CNC room	90	In Use	\N	2024-02-27 11:16:32.756839	2024-02-27 11:16:32.756839	\N
15	3	GHII-ED-0015	10 inch Raspberry Pi screen	\N	\N	N/A	GHII CNC room	90	In Use	\N	2024-02-27 11:16:32.762426	2024-02-27 11:16:32.762426	\N
16	1	GHII-HM-0016	Mitsubishi Rosa	Mitsubishi	Rosa	BE63DG700625	Training Center	8000	In Use	\N	2024-02-27 11:16:32.770305	2024-02-27 11:16:32.770305	\N
17	1	GHII-HM-0017	Toyota Coaster	Toyota	Coaster	XZB500051080	Training Center	7500	In Use	\N	2024-02-27 11:16:32.776608	2024-02-27 11:16:32.776608	\N
18	3	GHII-ED-0016	Dell Latitude E7250 13" Laptop	Dell	E7250	2L18T32	Coding Room	250	In Use	\N	2024-02-27 11:16:32.782343	2024-02-27 11:16:32.782343	\N
19	3	GHII-ED-0046	Dell Latitude E7250 13" Laptop	Dell	E7250	\N	Director's Office	250	In Use	\N	2024-02-27 11:16:32.787232	2024-02-27 11:16:32.787232	\N
20	3	GHII-ED-0017	Dell Latitude E7250 13" Laptop	Dell	E7250	\N	Admin Office	250	In Use	\N	2024-02-27 11:16:32.79139	2024-02-27 11:16:32.79139	\N
21	3	GHII-ED-0018	HP Chromebook	HP	11-G5	\N	Pool	70	Available	\N	2024-02-27 11:16:32.796036	2024-02-27 11:16:32.796036	\N
22	3	GHII-ED-0019	Dell Latitude E7250 13" Laptop	Dell	E7250	N/A	Store room	250	Available	\N	2024-02-27 11:16:32.800341	2024-02-27 11:16:32.800341	\N
23	3	GHII-ED-0020	Dell Latitude E7250 13" Laptop	Dell	E7250	\N	Director's Drawer	250	Available	\N	2024-02-27 11:16:32.804818	2024-02-27 11:16:32.804818	\N
24	3	GHII-ED-0021	HP Chromebook	HP	11-G5	\N	Electronics Room	70	In Use	\N	2024-02-27 11:16:32.809167	2024-02-27 11:16:32.809167	\N
25	3	GHII-ED-0022	HP Chromebook	HP	11-G5	\N	Director's Office	70	In Use	\N	2024-02-27 11:16:32.813385	2024-02-27 11:16:32.813385	\N
26	3	GHII-ED-0049	HP Chromebook	HP	11-G5	\N	Tobias Bendabenda	70	In Use	\N	2024-02-27 11:16:32.81765	2024-02-27 11:16:32.81765	\N
27	3	GHII-ED-0050	HP Chromebook	HP	11-G5	\N	Effa Solomon	70	In Use	\N	2024-02-27 11:16:32.82209	2024-02-27 11:16:32.82209	\N
28	3	GHII-ED-0023	HP Chromebook	HP	11-G5	\N	Neverson Nkhata	70	In Use	\N	2024-02-27 11:16:32.82765	2024-02-27 11:16:32.82765	\N
29	3	GHII-ED-0055	MacBook Pro	Apple	M2 Chip	Y5CX1HH9DK	Foster Sentala	2040	In Use	\N	2024-02-27 11:16:32.836081	2024-02-27 11:16:32.836081	\N
30	3	EMORY-ED-003	MacBook Air	Apple	M1 Chip	FVFHR0L9Q72X	Innocent Kumwenda	1200	In Use	\N	2024-02-27 11:16:32.841806	2024-02-27 11:16:32.841806	\N
31	3	EMORY-ED-004	MacBook Air	Apple	M1 Chip	FVFHN07JQ72X	Naomi Nyama	1200	In Use	\N	2024-02-27 11:16:32.847759	2024-02-27 11:16:32.847759	\N
32	3	EMORY-ED-005	MacBook Air	Apple	M1 Chip	FVFG558VQ6LT	Store Room	1200	In Use	\N	2024-02-27 11:16:32.852861	2024-02-27 11:16:32.852861	\N
33	3	EMORY-ED-001	Google Phone (White)	Google	Pixel 6a	(IME) 52061659177840	Store Room	600	Available	\N	2024-02-27 11:16:32.85822	2024-02-27 11:16:32.85822	\N
34	3	EMORY-ED-002	Google Phone (Black)	Google	Pixel 6a	(IME) 52061659177840	Store Room	600	Available	\N	2024-02-27 11:16:32.86339	2024-02-27 11:16:32.86339	\N
35	3	NEOTREE-ED-001	Tablet	Amazon	Amazon fire 7	GCC1 WE04 2295 0BSK	Store Room	76.6	Available	\N	2024-02-27 11:16:32.868693	2024-02-27 11:16:32.868693	\N
36	3	NEOTREE-ED-002	Tablet	Amazon	Amazon fire 7	GCC1 WE04 2295 0EQ2	Store Room	76.6	Available	\N	2024-02-27 11:16:32.874194	2024-02-27 11:16:32.874194	\N
37	3	NEOTREE-ED-003	Tablet	Amazon	Amazon fire 7	GCC1 WE04 2295 0CCB	Store Room	76.6	Available	\N	2024-02-27 11:16:32.879957	2024-02-27 11:16:32.879957	\N
38	3	NEOTREE-ED-004	Tablet	Amazon	Amazon fire 7	GCC0 X908 0414 00B1	Store Room	76.6	Available	\N	2024-02-27 11:16:32.885143	2024-02-27 11:16:32.885143	\N
39	3	NEOTREE-ED-005	Tablet	Amazon	Amazon fire 7	GCC0 X908 0435 00XV	Store Room	76.6	Available	\N	2024-02-27 11:16:32.890329	2024-02-27 11:16:32.890329	\N
40	3	GHII-ED-0024	HP Color Printer	HP	M254DW	VNC4226827	Director's Office	300	In Use	\N	2024-02-27 11:16:32.895968	2024-02-27 11:16:32.895968	\N
41	3	GHII-ED-0025	HP Laserjet Printer	HP	1018	VNC3B09910	Common Area	150	In Use	\N	2024-02-27 11:16:32.90048	2024-02-27 11:16:32.90048	\N
42	3	GHII-ED-0026	TIKO 3D Printer	TIKO	1	TKKS-X1216-1D8C	TC- Conference Room	180	In Use	\N	2024-02-27 11:16:32.9048	2024-02-27 11:16:32.9048	\N
43	3	GHII-ED-0045	Blue 3D printer	\N	\N	N/A	Dark Room	100	In Use	\N	2024-02-27 11:16:32.908602	2024-02-27 11:16:32.908602	\N
44	3	GHII-ED-0048	HP Deskjet printer	\N	2050	\N	TC- Conference Room	113.7	In Use	\N	2024-02-27 11:16:32.912988	2024-02-27 11:16:32.912988	\N
45	3	GHII-ED-0054	Brother label printer	\N	PT-85	\N	Store Room	30	Available	\N	2024-02-27 11:16:32.917173	2024-02-27 11:16:32.917173	\N
46	3	NEOTREE-ED-006	Printer	HP	HP LaserJet M110we	VNCZ186808	Store Room	123.58	Available	\N	2024-02-27 11:16:32.921835	2024-02-27 11:16:32.921835	\N
47	3	NEOTREE-ED-007	Printer	HP	HP LaserJet M15w	VNC3351487	Common Area	168.49	In Use	\N	2024-02-27 11:16:32.937163	2024-02-27 11:16:32.937163	\N
48	2	GHII-FR-0001	Double-Drawer Cabinet	Wood	\N	N/A	Coding Room	49.29	In Use	\N	2024-02-27 11:16:32.942742	2024-02-27 11:16:32.942742	\N
49	2	GHII-FR-0002	Wooden Podium	Wood	\N	N/A	TC- Conference Room	123.23	In Use	\N	2024-02-27 11:16:32.947766	2024-02-27 11:16:32.947766	\N
50	2	GHII-FR-0003	Wooden Conference Table	Wood	\N	N/A	TC- Conference Room	308.07	In Use	\N	2024-02-27 11:16:32.952936	2024-02-27 11:16:32.952936	\N
51	2	GHII-FR-0004	Wooden Shelf 1	Wood	\N	N/A	Electronics Room	123.23	In Use	\N	2024-02-27 11:16:32.958736	2024-02-27 11:16:32.958736	\N
52	2	GHII-FR-0005	Wooden Shelf 2	Wood	\N	N/A	Electronics Room	123.23	In Use	\N	2024-02-27 11:16:32.966294	2024-02-27 11:16:32.966294	\N
53	2	GHII-FR-0006	Wooden Shelf 3	Wood	\N	N/A	Electronics	123.23	In Use	\N	2024-02-27 11:16:32.97243	2024-02-27 11:16:32.97243	\N
54	2	GHII-FR-0007	Wood Shelf 4	Wood	\N	N/A	Open O2 Room	50	In Use	\N	2024-02-27 11:16:32.978744	2024-02-27 11:16:32.978744	\N
55	2	GHII-FR-0008	Triple-Drawer Office Cabinet	Wood	\N	N/A	Admin Office	98.58	In Use	\N	2024-02-27 11:16:32.983591	2024-02-27 11:16:32.983591	\N
56	2	GHII-FR-0009	Double-Drawer Cabinet	Wood	\N	N/A	Director’s Office	49.29	In Use	\N	2024-02-27 11:16:32.988717	2024-02-27 11:16:32.988717	\N
57	2	GHII-FR-0012	Metal Filing Cabinet	\N	\N	N/A	Wood Workshop	65	In Use	\N	2024-02-27 11:16:32.993257	2024-02-27 11:16:32.993257	\N
58	2	GHII-FR-0013	Metal Fiing Cabinet	\N	\N	N/A	Wood Workshop	65	In Use	\N	2024-02-27 11:16:32.997548	2024-02-27 11:16:32.997548	\N
59	2	GHII-FR-0010	Metal Filing Cabinet	\N	\N	N/A	Director's Office	110.91	In Use	\N	2024-02-27 11:16:33.00191	2024-02-27 11:16:33.00191	\N
60	2	GHII-FR-0011	Wooden table (large)	\N	\N	N/A	Dining Room	260	In Use	\N	2024-02-27 11:16:33.00612	2024-02-27 11:16:33.00612	\N
61	2	GHII-FR-0015	Small table	wooden	\N	N/A	Android Dev Room	70	In Use	\N	2024-02-27 11:16:33.010375	2024-02-27 11:16:33.010375	\N
62	5	GHII-HM-0018	Large CNC Milling Machine	\N	\N	N/A	GHII CNC room	1500	In Use	\N	2024-02-27 11:16:33.01453	2024-02-27 11:16:33.01453	\N
63	5	GHII-HM-0019	Medium CNC Milling Machine	\N	\N	N/A	GHII CNC room	700	In Use	\N	2024-02-27 11:16:33.018573	2024-02-27 11:16:33.018573	\N
64	5	GHII-HM-0020	Wire feed welding machine	Eastwood	MIG175	12100000000000	GHII CNC room	537.41	In Use	\N	2024-02-27 11:16:33.023903	2024-02-27 11:16:33.023903	\N
65	5	GHII-HM-0021	Medium CNC Engraving Machine	\N	\N	N/A	GHII CNC room	379.99	In Use	\N	2024-02-27 11:16:33.028271	2024-02-27 11:16:33.028271	\N
66	5	GHII-HM-0022	Small CNC Engraving Machine	Woodpecker	\N	N/A	GHII CNC room	119.59	In Use	\N	2024-02-27 11:16:33.036704	2024-02-27 11:16:33.036704	\N
67	5	GHII-HM-0023	Disk sanding machine	Wardkin bursgreen	\N	BGY.3.68966	Wood workshop	500	In Use	\N	2024-02-27 11:16:33.04124	2024-02-27 11:16:33.04124	\N
68	5	GHII-HM-0024	Mortising Machine	Central machinery	SQU#S35570	4027572	Wood workshop	80	In Use	\N	2024-02-27 11:16:33.047104	2024-02-27 11:16:33.047104	\N
69	4	GHII-TL-0001	Biscket machine	Porter cable	555	53436	Wood workshop	80	In Use	\N	2024-02-27 11:16:33.052821	2024-02-27 11:16:33.052821	\N
70	4	GHII-TL-0002	Drill machine	Dewalt	DCD970	880326	wood workshop	80	In Use	\N	2024-02-27 11:16:33.058071	2024-02-27 11:16:33.058071	\N
71	4	GHII-TL-0003	Drill machine	Dewalt	DCD925	3215	wood workshop	80	In Use	\N	2024-02-27 11:16:33.063967	2024-02-27 11:16:33.063967	\N
72	4	GHII-TL-0004	Drill machine	Dewalt	DCD970	N/A	wood workshop	80	In Use	\N	2024-02-27 11:16:33.069894	2024-02-27 11:16:33.069894	\N
73	4	GHII-TL-0005	Drill machine	Dewalt	DCD970	880326	wood workshop	80	In Use	\N	2024-02-27 11:16:33.075883	2024-02-27 11:16:33.075883	\N
74	4	GHII-TL-0006	Drill machine	Dewalt	D25113K	PA6-GF33	wood workshop	80	In Use	\N	2024-02-27 11:16:33.081595	2024-02-27 11:16:33.081595	\N
75	4	GHII-TL-0007	Drill machine	Ridgid	R81030	G062437107	wood workshop	35	In Use	\N	2024-02-27 11:16:33.08658	2024-02-27 11:16:33.08658	\N
76	4	GHII-TL-0008	Drill machine	Ridgid	R81030	G053606889	wood workshop	35	In Use	\N	2024-02-27 11:16:33.092155	2024-02-27 11:16:33.092155	\N
77	4	GHII-TL-0009	Drill machine	Ridgid	R81030	G054926780	wood workshop	35	In Use	\N	2024-02-27 11:16:33.096983	2024-02-27 11:16:33.096983	\N
78	4	GHII-TL-0010	Drill machine	Ridgid	R81030	G053606889	wood workshop	35	In Use	\N	2024-02-27 11:16:33.101321	2024-02-27 11:16:33.101321	\N
79	4	GHII-TL-0011	Drill machine	Ridgid	R81030	BD062538534	wood workshop	35	In Use	\N	2024-02-27 11:16:33.105245	2024-02-27 11:16:33.105245	\N
80	4	GHII-TL-0012	Drill machine	Ridgid	R81030	G06253834	wood workshop	35	In Use	\N	2024-02-27 11:16:33.109662	2024-02-27 11:16:33.109662	\N
81	4	GHII-TL-0014	Drill machine	Ingco	CDLI228180	1704878	Wood workshop	40	In Use	\N	2024-02-27 11:16:33.113846	2024-02-27 11:16:33.113846	\N
82	4	GHII-TL-0013	Drill machine	Ridgid	R81030	G062437107	wood workshop	35	In Use	\N	2024-02-27 11:16:33.118045	2024-02-27 11:16:33.118045	\N
83	4	GHII-TL-0015	Drill machine Charger	Rigid	EA11456D010082	EA11456D0100082	wood workshop	40	In Use	\N	2024-02-27 11:16:33.136857	2024-02-27 11:16:33.136857	\N
84	4	GHII-TL-0016	Drill machine	Dewalt	\N	567029	wood workshop	80	In Use	\N	2024-02-27 11:16:33.14378	2024-02-27 11:16:33.14378	\N
85	5	GHII-HM-0025	Welding machine	\N	ZX7-200	GB15579.1-2013	Wood workshop	800	In Use	\N	2024-02-27 11:16:33.148873	2024-02-27 11:16:33.148873	\N
86	3	GHII-ED-0027	Hitachi Oscilloscope	HITACHI	V-422	106663	Electronics Room	190	In Use	\N	2024-02-27 11:16:33.153959	2024-02-27 11:16:33.153959	\N
87	3	GHII-ED-0028	Hitachi Oscilloscope	HITACHI	V-422	7013214	Electronics Room	190	In Use	\N	2024-02-27 11:16:33.159829	2024-02-27 11:16:33.159829	\N
88	3	GHII-ED-0037	Rack Server	Logic	BHT-MC600	U667232	Common Area	1100	In Use	\N	2024-02-27 11:16:33.164477	2024-02-27 11:16:33.164477	\N
89	4	GHII-TL-0018	Indistrial router	ingco	RT22001	RT22001	wood Workshop	100	In Use	\N	2024-02-27 11:16:33.17137	2024-02-27 11:16:33.17137	\N
90	4	GHII-TL-0019	Indistrial router	Dewalt	DW624	7963	wood Workshop	300	In Use	\N	2024-02-27 11:16:33.177303	2024-02-27 11:16:33.177303	\N
91	4	GHII-TL-0020	Indistrial plunge router	Skil	1835	18358001	Wood workshop	80	In Use	\N	2024-02-27 11:16:33.183184	2024-02-27 11:16:33.183184	\N
92	2	GHII-FR-0014	Router table	\N	\N	N/A	Wood workshop	40	In Use	\N	2024-02-27 11:16:33.188159	2024-02-27 11:16:33.188159	\N
93	5	GHII-HM-0025	Plasma cutter	Lotos	LTP5500D	ASPC100002337	GHII CNC room	489	In Use	\N	2024-02-27 11:16:33.19314	2024-02-27 11:16:33.19314	\N
94	5	GHII-HM-0026	Plasma cutter	Simadre	CUT50DP	EN60974-1:2005	GHII CNC room	399	In Use	\N	2024-02-27 11:16:33.197687	2024-02-27 11:16:33.197687	\N
95	5	GHII-HM-0027	CNC Plasma cutter	\N	\N	N/A	GHII CNC room	500	In Use	\N	2024-02-27 11:16:33.202156	2024-02-27 11:16:33.202156	\N
96	4	GHII-TL-0022	Bench circular saw	Black and decker	CD602	201429-CU	Wood Workshop	81	In Use	\N	2024-02-27 11:16:33.206535	2024-02-27 11:16:33.206535	\N
97	5	GHII-HM-0002	3 Phase Table saw	Darra - James	WT212148	N/A	Wood Workshop	2000	In Use	\N	2024-02-27 11:16:33.210678	2024-02-27 11:16:33.210678	\N
98	4	GHII-TL-0023	Mitre saw	Ryobi	CMS-210A	141200590	wood Workshop	80	In Use	\N	2024-02-27 11:16:33.214382	2024-02-27 11:16:33.214382	\N
99	5	GHII-HM-0001	Dado Saw	Wardkin bursgreen	\N	AGS58216	wood Workshop	369.69	In Use	\N	2024-02-27 11:16:33.21907	2024-02-27 11:16:33.21907	\N
100	5	GHII-HM-0003	Arm saw	Wardkin bursgreen	WS8/24	L637257	wood Workshop	350	In Use	\N	2024-02-27 11:16:33.223058	2024-02-27 11:16:33.223058	\N
101	4	GHII-TL-0025	Reciprocating saw	Dewalt	DW938	748352	wood Workshop	112.99	In Use	\N	2024-02-27 11:16:33.228485	2024-02-27 11:16:33.228485	\N
102	4	GHII-TL-0026	Jigsaw	Dewalt	DW331K-QS	N044919	wood Workshop	159	In Use	\N	2024-02-27 11:16:33.237231	2024-02-27 11:16:33.237231	\N
103	4	GHII-TL-0027	Jigsaw	Dewalt	DC330	865216	Wood workshop	165	In Use	\N	2024-02-27 11:16:33.242638	2024-02-27 11:16:33.242638	\N
104	4	GHII-TL-0028	Circular saw	Lyobi	HCS-1250	135103006	Wood workshop	80	In Use	\N	2024-02-27 11:16:33.24772	2024-02-27 11:16:33.24772	\N
105	4	GHII-TL-0029	Heat gun	skil	FO158003078	F015800307	GHII CNC room	41.99	In Use	\N	2024-02-27 11:16:33.252982	2024-02-27 11:16:33.252982	\N
106	4	GHII-TL-0030	Heat gun	SONGSHAN	\N	N/A	GHII CNC room	41.99	In Use	\N	2024-02-27 11:16:33.258243	2024-02-27 11:16:33.258243	\N
107	4	GHII-TL-0031	Heat gun	Bosh	PHG500-2	060329A003	GHII CNC room	91.14	In Use	\N	2024-02-27 11:16:33.263262	2024-02-27 11:16:33.263262	\N
108	4	GHII-TL-0021	Heat gun	skil	\N	\N	wood Workshop	41.99	In Use	\N	2024-02-27 11:16:33.268459	2024-02-27 11:16:33.268459	\N
109	4	GHII-TL-0032	Nail gun	Porter cable	BN200C	16060420DBJBN200C	Wood workshop	90	In Use	\N	2024-02-27 11:16:33.27348	2024-02-27 11:16:33.27348	\N
110	4	GHII-TL-0033	Nail gun	Porter cable	BN200C	14022002KBJBN200C	Wood workshop	90	In Use	\N	2024-02-27 11:16:33.278743	2024-02-27 11:16:33.278743	\N
111	3	GHII-ED-0029	LED lens bench light	Fix point	\N	45273	GHII CNC room	56.99	In Use	\N	2024-02-27 11:16:33.284196	2024-02-27 11:16:33.284196	\N
112	3	GHII-ED-0030	LED lens bench light	Fix point	\N	45271	Electronics Room	56.99	In Use	\N	2024-02-27 11:16:33.288622	2024-02-27 11:16:33.288622	\N
113	3	GHII-ED-0031	Battery charger	Kipoint	WP-2048A	WT1703290008	GHII CNC room	78.34	In Use	\N	2024-02-27 11:16:33.294627	2024-02-27 11:16:33.294627	\N
114	3	GHII-ED-0032	Bench power supply	Uniroi	UC3010	\N	GHII CNC room	50.99	In Use	\N	2024-02-27 11:16:33.299212	2024-02-27 11:16:33.299212	\N
115	5	GHII-HM-0004	Diesel generator	Koop	KDF6700Q	N/A	In a Blue bus [Rosa]	1000	In Use	\N	2024-02-27 11:16:33.303675	2024-02-27 11:16:33.303675	\N
116	5	GHII-HM-0005	Diesel generator	Koop	KDF400X(E)	N/A	In a White Bus [Coaster]	800	In Use	\N	2024-02-27 11:16:33.308189	2024-02-27 11:16:33.308189	\N
117	4	GHII-TL-0024	Torch	Dewalt	DW908	1626367	wood workshop	25	In Use	\N	2024-02-27 11:16:33.312412	2024-02-27 11:16:33.312412	\N
118	4	GHII-TL-0034	Torch	Dewalt	DW908	1626329	wood workshop	25	In Use	\N	2024-02-27 11:16:33.316693	2024-02-27 11:16:33.316693	\N
119	4	GHII-TL-0035	Torch	Dewalt	DW908	1626250	wood workshop	25	In Use	\N	2024-02-27 11:16:33.32085	2024-02-27 11:16:33.32085	\N
120	3	GHII-ED-0038	Pure sinewave Invertor	Flamezum	\N	\N	Open O2 Room	50	In Use	\N	2024-02-27 11:16:33.335538	2024-02-27 11:16:33.335538	\N
121	5	GHII-HM-0006	Big Air compressor	Jari	DN 350	00:20:00	GHII CNC room	330	In Use	\N	2024-02-27 11:16:33.341893	2024-02-27 11:16:33.341893	\N
122	3	GHII-ED-0041	PCB Board Material	\N	\N	N/A	GHII CNC room	680	In Use	\N	2024-02-27 11:16:33.348493	2024-02-27 11:16:33.348493	\N
123	5	GHII-HM-0007	Vacuum pump	WELCH	1399Z-05	24163	GHII CNC room	800	In Use	\N	2024-02-27 11:16:33.356378	2024-02-27 11:16:33.356378	\N
124	5	GHII-HM-0008	3 Phase motor	Crompton parkson	158OR170	N/A	GHII CNC room	50	In Use	\N	2024-02-27 11:16:33.361726	2024-02-27 11:16:33.361726	\N
125	5	GHII-HM-0009	Mobile Air Conditioner	Dragor	LTH-14	JAA0AD3105184000259	GHII CNC room	100	In Use	\N	2024-02-27 11:16:33.370768	2024-02-27 11:16:33.370768	\N
126	4	GHII-TL-0036	Bubble Level	Cen-tech	\N	N/A	wood Workshop	75	In Use	\N	2024-02-27 11:16:33.377072	2024-02-27 11:16:33.377072	\N
127	4	GHII-TL-0037	Pipe Thread kit and clamper	\N	\N	N/A	wood Workshop	99.99	In Use	\N	2024-02-27 11:16:33.383319	2024-02-27 11:16:33.383319	\N
128	4	GHII-TL-0038	Concrete Hammer	Hitach	\N	N/A	wood Workshop	289.99	In Use	\N	2024-02-27 11:16:33.388976	2024-02-27 11:16:33.388976	\N
129	4	GHII-TL-0039	Powder fastening systems	Ramset	COBRA	N/A	wood Workshop	129	In Use	\N	2024-02-27 11:16:33.393903	2024-02-27 11:16:33.393903	\N
130	5	GHII-HM-0015	Drill press	ingco	DP165001	IN106	wood Workshop	358.94	In Use	\N	2024-02-27 11:16:33.398555	2024-02-27 11:16:33.398555	\N
131	5	GHII-HM-0014	Spindal Molder	Wood tech	\N	1021079	wood Workshop	50	In Use	\N	2024-02-27 11:16:33.40344	2024-02-27 11:16:33.40344	\N
132	5	GHII-HM-0010	Air compressor	Ingco	AC25508	201708001	wood Workshop	200	In Use	\N	2024-02-27 11:16:33.408049	2024-02-27 11:16:33.408049	\N
133	5	GHII-HM-0011	Jointer planner	Craftsman	113.20693300000001	6151R114	wood Workshop	300	In Use	\N	2024-02-27 11:16:33.412218	2024-02-27 11:16:33.412218	\N
134	5	GHII-HM-0012	15" Planner	Enco	150-4100	90762	wood Workshop	800	In Use	\N	2024-02-27 11:16:33.415981	2024-02-27 11:16:33.415981	\N
135	3	GHII-ED-0039	Step down transformer	Hammond	MT1000MLY	LR32216	wood Workshop	40	In Use	\N	2024-02-27 11:16:33.420752	2024-02-27 11:16:33.420752	\N
136	4	GHII-TL-0041	Trimmer	\N	M1P-3701	N/A	wood Workshop	50	In Use	\N	2024-02-27 11:16:33.424497	2024-02-27 11:16:33.424497	\N
137	4	GHII-TL-0042	Wet polisher glinder	Fixtech	\N	N/A	wood Workshop	70	In Use	\N	2024-02-27 11:16:33.43018	2024-02-27 11:16:33.43018	\N
138	4	GHII-TL-0043	Oscilating tool	\N	FMT30001	AD010063	wood Workshop	30	In Use	\N	2024-02-27 11:16:33.439016	2024-02-27 11:16:33.439016	\N
139	4	GHII-TL-0044	Orbital sander	Bosh	PEX220A	3603C78071	wood Workshop	50	In Use	\N	2024-02-27 11:16:33.44478	2024-02-27 11:16:33.44478	\N
140	4	GHII-TL-0045	Orbital sander	Blach & decker	KA300	201736-58	wood Workshop	50	In Use	\N	2024-02-27 11:16:33.452555	2024-02-27 11:16:33.452555	\N
141	4	GHII-TL-0046	Orbital sander	Makita	BO3700	13755231	wood Workshop	50	In Use	\N	2024-02-27 11:16:33.460525	2024-02-27 11:16:33.460525	\N
142	4	GHII-TL-0047	Belt sander	Ryobi	EBS-810	182702095	wood Workshop	80	In Use	\N	2024-02-27 11:16:33.468973	2024-02-27 11:16:33.468973	\N
143	4	GHII-TL-0048	Tool box	Epica	\N	N/A	wood Workshop	15	In Use	\N	2024-02-27 11:16:33.476814	2024-02-27 11:16:33.476814	\N
144	4	GHII-TL-0049	Tool box	Craftsman	\N	N/A	wood Workshop	15	In Use	\N	2024-02-27 11:16:33.482827	2024-02-27 11:16:33.482827	\N
145	4	GHII-TL-0050	Grinder	Ingco	AG75018	19027990876	wood Workshop	60	In Use	\N	2024-02-27 11:16:33.487793	2024-02-27 11:16:33.487793	\N
146	4	GHII-TL-0017	Metal Grinder	Blach & decker	\N	N/A	wood Workshop	150	In Use	\N	2024-02-27 11:16:33.492052	2024-02-27 11:16:33.492052	\N
147	5	GHII-HM-0013	Air compressor	Outstanding	OTS-550	N/A	wood Workshop	80	In Use	\N	2024-02-27 11:16:33.496981	2024-02-27 11:16:33.496981	\N
148	5	GHII-HM-0052	Air Compressor	Outstanding	OTS-550	N/A	open o2 bus	80	In Use	\N	2024-02-27 11:16:33.500831	2024-02-27 11:16:33.500831	\N
149	3	GHII-ED-0040	Fan	Changli crown	USS-1819	\N	wood Workshop	58.5	In Use	\N	2024-02-27 11:16:33.506806	2024-02-27 11:16:33.506806	\N
150	3	GHII-ED-0042	fan	Power King Premium Fan	PK 18786	N/A	Director's Office	45	In Use	\N	2024-02-27 11:16:33.511343	2024-02-27 11:16:33.511343	\N
151	3	GHII-ED-0033	Fan	Logik	LT-40P01	\N	Admin Office	25	In Use	\N	2024-02-27 11:16:33.515795	2024-02-27 11:16:33.515795	\N
152	3	GHII-ED-0034	Fan	Logik	LT-40P01	\N	Coding Room	25	In Use	\N	2024-02-27 11:16:33.520376	2024-02-27 11:16:33.520376	\N
153	3	GHII-ED-0035	Fan	Logik	LT-40P01	\N	Android Dev Room	25	In Use	\N	2024-02-27 11:16:33.524681	2024-02-27 11:16:33.524681	\N
154	3	GHII-ED-0035	Fan	Logik	LT-40P01	\N	Common Area	25	In Use	\N	2024-02-27 11:16:33.536512	2024-02-27 11:16:33.536512	\N
155	3	GHII-ED-0052	Fan	Changli crown	USS-1819	\N	Open O2 Room	58.5	In Use	\N	2024-02-27 11:16:33.546053	2024-02-27 11:16:33.546053	\N
156	3	GHII-ED-0043	E-mart umbrella light	\N	\N	\N	O2 Alliance Room	35.69	In Use	\N	2024-02-27 11:16:33.554178	2024-02-27 11:16:33.554178	\N
157	3	GHII-ED-0044	E-mart umbrella light	\N	\N	\N	O2 Alliance Room	35.69	In Use	\N	2024-02-27 11:16:33.562369	2024-02-27 11:16:33.562369	\N
158	3	GHII-ED-0047	Intertek Lamp	\N	3061837	\N	Electronics Room	20	In Use	\N	2024-02-27 11:16:33.570663	2024-02-27 11:16:33.570663	\N
159	4	GHII-TL-0051	tripod stand	Ubeesize	TR50	\N	O2 Room	21.99	In Use	\N	2024-02-27 11:16:33.580693	2024-02-27 11:16:33.580693	\N
160	4	GHII-TL-0053	Drill machine	Ingco	CDLI228180	\N	O2 Room	40	In Use	\N	2024-02-27 11:16:33.5865	2024-02-27 11:16:33.5865	\N
161	3	GHII-ED-0051	Charger	Uniroi	\N	\N	Electronics Room	51.93	In Use	\N	2024-02-27 11:16:33.592687	2024-02-27 11:16:33.592687	\N
162	2	GHII-FR-0016	New wooden Desk	Wood	\N	\N	F&A Lead Office	144.79	In Use	\N	2024-02-27 11:16:33.597332	2024-02-27 11:16:33.597332	\N
163	2	GHll-FR-0017	New Wooden Desk 	wood	\N	\N	DA Lead Office 	144.79	In Use	\N	2024-02-27 11:16:33.602157	2024-02-27 11:16:33.602157	\N
164	2	GHII -FR-0018	New wooden Desk 	Wood 	\N	\N	SA Lead Office 	144.79	In Use	\N	2024-02-27 11:16:33.606945	2024-02-27 11:16:33.606945	\N
165	2	GHll-FR-0019	Second Hand Executive Chair 	Leather	\N	\N	DA Lead Office 	147.74	In Use	\N	2024-02-27 11:16:33.611885	2024-02-27 11:16:33.611885	\N
166	2	GHII-FR-0020	Second Hand Executive Chair 	Leather 	\N	\N	SA Lead Office 	147.74	In Use	\N	2024-02-27 11:16:33.616668	2024-02-27 11:16:33.616668	\N
167	2	GHII -FR-0021	Second Hand Executive Chair 	Leather 	\N	\N	Mwabi Lungu Office 	147.74	In Use	\N	2024-02-27 11:16:33.621491	2024-02-27 11:16:33.621491	\N
168	2	GHII -FR-0022	Second Hand Executive Chair 	Leather 	\N	\N	Mthetho Sinjani Office 	147.74	In Use	\N	2024-02-27 11:16:33.626158	2024-02-27 11:16:33.626158	\N
169	2	GHII -FR-0023	Second Hand Executive Chair 	Fabric /Mesh	\N	\N	F&A Lead Office 	154.44	In Use	\N	2024-02-27 11:16:33.632188	2024-02-27 11:16:33.632188	\N
170	2	GHII-FR-0024	Second Hand Standard Chair 	Fabric	\N	\N	Mwabi & Mthetho Office 	77.22	In Use	\N	2024-02-27 11:16:33.638923	2024-02-27 11:16:33.638923	\N
171	2	GHII -FR-0025	Second Hand Standard Chair 	Fabric 	\N	\N	Software Dev interns Opp FA Lead Office 	77.22	In Use	\N	2024-02-27 11:16:33.647021	2024-02-27 11:16:33.647021	\N
172	2	GHII-FR-0026	Second Hand Standard Chair 	Fabric 	\N	\N	Software Dev Interns Opp FA Lead Office 	77.22	In Use	\N	2024-02-27 11:16:33.652304	2024-02-27 11:16:33.652304	\N
173	2	GHII -FR-0027	Second Hand Standard Chair 	Fabric 	\N	\N	Software Dev App Hatchery Office 	77.22	In Use	\N	2024-02-27 11:16:33.659815	2024-02-27 11:16:33.659815	\N
174	2	GHII -FR-0028	Second Hand Standard Chair 	Fabric 	\N	\N	Software Dev App Hatchery Office 	77.22	In Use	\N	2024-02-27 11:16:33.665347	2024-02-27 11:16:33.665347	\N
175	2	GHII -FR-0029	Second Hand Visitor c Chair	Fabric /Mesh	\N	\N	Director's Office 	41.02	In Use	\N	2024-02-27 11:16:33.670985	2024-02-27 11:16:33.670985	\N
176	2	GHII -FR-0030	Second Hand Visitor c Chair 	Fabric/Mesh	\N	\N	Director's Office 	41.02	In Use	\N	2024-02-27 11:16:33.676659	2024-02-27 11:16:33.676659	\N
177	2	GHII -FR-0031	Second Hand Visitor c chair	Fabric /Mesh	\N	\N	F&A Lead Office 	41.02	In Use	\N	2024-02-27 11:16:33.681774	2024-02-27 11:16:33.681774	\N
178	2	GHII -FR-0032	Second Hand visitor cChair	Fabric /Mesh	\N	\N	Mwabi & Mthetho's Office 	41.02	In Use	\N	2024-02-27 11:16:33.686704	2024-02-27 11:16:33.686704	\N
179	2	GHII -FR-0033	Second Hand Visitor c Chair 	Fabric /Mesh	\N	\N	DA&SA Lead Office 	41.02	In Use	\N	2024-02-27 11:16:33.691208	2024-02-27 11:16:33.691208	\N
180	2	GHII -FR-0034	Second Hand Visitor c Chair 	Fabric /Mesh	\N	\N	Admin Office 	0	In Use	\N	2024-02-27 11:16:33.695489	2024-02-27 11:16:33.695489	\N
181	2	GHII -FR-0035	Second Hand Wooden Desk 	Wood 	\N	\N	Sharon& Aubrey's Office 	0	In Use	\N	2024-02-27 11:16:33.699689	2024-02-27 11:16:33.699689	\N
182	2	GHIl-FR-0036	Second Hand Wooden Desk 	Wood 	\N	\N	Sharon& Aubrey's Office 	0	In Use	\N	2024-02-27 11:16:33.703623	2024-02-27 11:16:33.703623	\N
183	2	GHII-FR-0037	New visitor's fabric black chair	Fabric/Mesh	\N	\N	HR/Admin/Fin Office	136.32	In Use	\N	2024-02-27 11:16:33.708486	2024-02-27 11:16:33.708486	\N
184	2	GHII-FR-0038	New visitor's fabric black chair	Fabric/Mesh	\N	\N	HR/Admin/Fin Office 	136.32	In Use	\N	2024-02-27 11:16:33.71222	2024-02-27 11:16:33.71222	\N
185	2	GHII-FR-0039	New visitor's fabric black chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	136.32	In Use	\N	2024-02-27 11:16:33.717659	2024-02-27 11:16:33.717659	\N
186	2	GHII-FR-0040	New visitor's fabric black chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	136.32	In Use	\N	2024-02-27 11:16:33.721976	2024-02-27 11:16:33.721976	\N
187	2	GHII-FR-0041	New visitor's fabric black chair	Fabric/Mesh	\N	\N	Open Area data analysts	136.32	In Use	\N	2024-02-27 11:16:33.726206	2024-02-27 11:16:33.726206	\N
188	2	GHII-FR-0042	New visitor's fabric black chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	136.32	In Use	\N	2024-02-27 11:16:33.736688	2024-02-27 11:16:33.736688	\N
189	2	GHII-FR-0043	New visitor's fabric black chair	Fabric/Mesh	\N	\N	Open area data analysts	136.32	In Use	\N	2024-02-27 11:16:33.742119	2024-02-27 11:16:33.742119	\N
190	2	GHII-FR-0044	New visitor's fabric black chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	136.32	In Use	\N	2024-02-27 11:16:33.748166	2024-02-27 11:16:33.748166	\N
191	2	GHII-FR-0045	New visitor's fabric black chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	136.32	In Use	\N	2024-02-27 11:16:33.753755	2024-02-27 11:16:33.753755	\N
192	2	GHII-FR-0046	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	Open area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.761406	2024-02-27 11:16:33.761406	\N
193	2	GHII-FR-0047	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	Open area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.769048	2024-02-27 11:16:33.769048	\N
194	2	GHII-FR-0048	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	Open Area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.77565	2024-02-27 11:16:33.77565	\N
195	2	GHII-FR-0049	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	OPen Area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.783533	2024-02-27 11:16:33.783533	\N
196	2	GHII-FR-0050	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	Open Area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.789862	2024-02-27 11:16:33.789862	\N
197	2	GHII-FR-0051	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	Open Area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.796212	2024-02-27 11:16:33.796212	\N
198	2	GHII-FR-0052	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	Open area data analysts	160.75	In Use	\N	2024-02-27 11:16:33.800624	2024-02-27 11:16:33.800624	\N
199	2	GHII-FR-0053	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	160.75	In Use	\N	2024-02-27 11:16:33.805117	2024-02-27 11:16:33.805117	\N
200	2	GHII-FR-0054	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	HR/Admin/Fin Office - Angela	160.75	In Use	\N	2024-02-27 11:16:33.809512	2024-02-27 11:16:33.809512	\N
201	2	GHII-FR-0055	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	HR/Admin/Fin Office - Angela	160.75	In Use	\N	2024-02-27 11:16:33.813579	2024-02-27 11:16:33.813579	\N
202	2	GHII-FR-0056	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	160.75	Available	\N	2024-02-27 11:16:33.817989	2024-02-27 11:16:33.817989	\N
203	2	GHII-FR-0057	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	160.75	Available	\N	2024-02-27 11:16:33.822291	2024-02-27 11:16:33.822291	\N
204	2	GHII-FR-0058	New Standard Mesh Black Office Chair	Fabric/Mesh	\N	\N	GHII Office - not allocated yet	160.75	Available	\N	2024-02-27 11:16:33.826417	2024-02-27 11:16:33.826417	\N
205	2	GHII-FR-0059	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.834598	2024-02-27 11:16:33.834598	\N
206	2	GHII-FR-0060	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.839658	2024-02-27 11:16:33.839658	\N
207	2	GHII-FR-0061	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.863341	2024-02-27 11:16:33.863341	\N
208	2	GHII-FR-0062	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.92355	2024-02-27 11:16:33.92355	\N
209	2	GHII-FR-0063	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.928262	2024-02-27 11:16:33.928262	\N
210	2	GHII-FR-0064	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.940426	2024-02-27 11:16:33.940426	\N
211	2	GHII-FR-0065	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.948058	2024-02-27 11:16:33.948058	\N
212	2	GHII-FR-0066	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.955504	2024-02-27 11:16:33.955504	\N
213	2	GHII-FR-0067	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.96219	2024-02-27 11:16:33.96219	\N
214	2	GHII-FR-0068	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.969002	2024-02-27 11:16:33.969002	\N
215	2	GHII-FR-0069	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.975339	2024-02-27 11:16:33.975339	\N
216	2	GHII-FR-0070	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.98171	2024-02-27 11:16:33.98171	\N
217	2	GHII-FR-0071	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.986529	2024-02-27 11:16:33.986529	\N
218	2	GHII-FR-0072	New Desk for Project Staff	Wood	\N	\N	GHII Office - not allocated yet	287.4	Available	\N	2024-02-27 11:16:33.991173	2024-02-27 11:16:33.991173	\N
223	3	GHII 71	screen 32 inch	Acer	S241HR	j422	informatics	400000	in use	\N	2025-07-22 08:19:34.422409	2025-07-22 08:19:34.422409	80
224	2	GHII 71	screen 32 inch	Acer	S241HR	j422	informatics	50000	in use	\N	2025-08-01 07:09:17.424279	2025-08-01 07:09:17.424279	62
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.branches (branch_id, branch_name, country, city, location, created_by, closed_by, is_open, created_at, updated_at) FROM stdin;
1	Training center	Malawi	Lilongwe	Area 3	\N	\N	t	2024-02-27 11:12:44.814765	2024-02-27 11:12:44.814765
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.departments (department_id, branch_id, department_name, is_active, created_by, created_at, updated_at) FROM stdin;
1	1	Finance and Administration	t	\N	2024-02-27 11:12:44.864773	2024-02-27 11:12:44.864773
2	1	Programs	t	\N	2024-02-27 11:12:44.871606	2024-02-27 11:12:44.871606
3	1	Training Program	t	\N	2024-02-27 11:12:44.877613	2024-02-27 11:12:44.877613
4	1	Research, Development & Evaluation	t	\N	2024-02-27 11:12:44.883882	2024-02-27 11:12:44.883882
5	1	Resource Mobilization	t	\N	2024-02-27 11:12:44.889357	2024-02-27 11:12:44.889357
\.


--
-- Data for Name: designation_workflow_state_actions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.designation_workflow_state_actions (id, workflow_state_id, designation_id, voided, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: designations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.designations (designation_id, department_id, designated_role, is_active, created_at, updated_at) FROM stdin;
1	1	Director	t	2024-02-27 11:12:45.002561	2024-02-27 11:12:45.002561
2	1	Director of Finance and Administration	t	2024-02-27 11:12:45.010167	2024-02-27 11:12:45.010167
3	1	Administraton & HR Officer	t	2024-02-27 11:12:45.016376	2024-02-27 11:12:45.016376
4	1	Finance & Administration Lead	t	2024-02-27 11:12:45.022805	2024-02-27 11:12:45.022805
5	1	Finance Lead	t	2024-02-27 11:12:45.036859	2024-02-27 11:12:45.036859
6	1	Administration Lead	t	2024-02-27 11:12:45.043035	2024-02-27 11:12:45.043035
7	1	Operations Lead	t	2024-02-27 11:12:45.049957	2024-02-27 11:12:45.049957
8	1	Human Resources Lead	t	2024-02-27 11:12:45.056088	2024-02-27 11:12:45.056088
9	1	Finance Officer	t	2024-02-27 11:12:45.065245	2024-02-27 11:12:45.065245
10	1	Finance Intern	t	2024-02-27 11:12:45.072818	2024-02-27 11:12:45.072818
11	1	Finance Volunteer	t	2024-02-27 11:12:45.080046	2024-02-27 11:12:45.080046
13	1	Administrative Intern	t	2024-02-27 11:12:45.092105	2024-02-27 11:12:45.092105
14	1	Administrative Volunteer	t	2024-02-27 11:12:45.098145	2024-02-27 11:12:45.098145
15	1	Human Resources Officer	t	2024-02-27 11:12:45.104151	2024-02-27 11:12:45.104151
16	1	Human Resources Intern	t	2024-02-27 11:12:45.109943	2024-02-27 11:12:45.109943
17	1	Human Resources Volunteer	t	2024-02-27 11:12:45.115937	2024-02-27 11:12:45.115937
18	1	Operations Officer	t	2024-02-27 11:12:45.122226	2024-02-27 11:12:45.122226
19	1	Finance and Administrative Intern	t	2024-02-27 11:12:45.13919	2024-02-27 11:12:45.13919
20	1	Driver	t	2024-02-27 11:12:45.146194	2024-02-27 11:12:45.146194
21	1	Artisan	t	2024-02-27 11:12:45.153405	2024-02-27 11:12:45.153405
22	1	Operations Intern	t	2024-02-27 11:12:45.160251	2024-02-27 11:12:45.160251
23	1	Operations Volunteer	t	2024-02-27 11:12:45.167605	2024-02-27 11:12:45.167605
24	2	Programs Lead	t	2024-02-27 11:12:45.175039	2024-02-27 11:12:45.175039
25	2	Program Manager	t	2024-02-27 11:12:45.182447	2024-02-27 11:12:45.182447
26	2	Program Officer	t	2024-02-27 11:12:45.19011	2024-02-27 11:12:45.19011
27	2	Program Specialist	t	2024-02-27 11:12:45.197127	2024-02-27 11:12:45.197127
28	2	Program Intern	t	2024-02-27 11:12:45.204062	2024-02-27 11:12:45.204062
29	2	Program Volunteer	t	2024-02-27 11:12:45.210317	2024-02-27 11:12:45.210317
30	2	OpenO2 Product Developer	t	2024-02-27 11:12:45.216097	2024-02-27 11:12:45.216097
31	2	Industrial Attache	t	2024-02-27 11:12:45.234548	2024-02-27 11:12:45.234548
32	2	Informatics Product Developer	t	2024-02-27 11:12:45.241341	2024-02-27 11:12:45.241341
33	2	Technician	t	2024-02-27 11:12:45.247733	2024-02-27 11:12:45.247733
34	3	Deparment Head	t	2024-02-27 11:12:45.253988	2024-02-27 11:12:45.253988
35	3	Training Program Coordinator	t	2024-02-27 11:12:45.260644	2024-02-27 11:12:45.260644
36	3	Faculty	t	2024-02-27 11:12:45.269955	2024-02-27 11:12:45.269955
37	4	Research Assistant	t	2024-02-27 11:12:45.279164	2024-02-27 11:12:45.279164
38	4	Product Development Manager	t	2024-02-27 11:12:45.287518	2024-02-27 11:12:45.287518
39	4	Monitoring and Evaluation Manager	t	2024-02-27 11:12:45.295919	2024-02-27 11:12:45.295919
40	4	Product Developer	t	2024-02-27 11:12:45.303372	2024-02-27 11:12:45.303372
41	4	CAD/CAM Engineer	t	2024-02-27 11:12:45.31117	2024-02-27 11:12:45.31117
42	4	Monitoring and Evaluation Officer	t	2024-02-27 11:12:45.318791	2024-02-27 11:12:45.318791
43	4	Monitoring and Evaluation Intern	t	2024-02-27 11:12:45.326896	2024-02-27 11:12:45.326896
44	4	Monitoring and Evaluation Volunteer	t	2024-02-27 11:12:45.341391	2024-02-27 11:12:45.341391
45	4	CAD/CAM Engineering Intern	t	2024-02-27 11:12:45.35115	2024-02-27 11:12:45.35115
46	4	CAD/CAM Engineering Volunteer	t	2024-02-27 11:12:45.359547	2024-02-27 11:12:45.359547
47	4	Product Development Intern	t	2024-02-27 11:12:45.36873	2024-02-27 11:12:45.36873
48	4	Product Development Volunteer	t	2024-02-27 11:12:45.376953	2024-02-27 11:12:45.376953
49	5	Resource Mobilization Lead	t	2024-02-27 11:12:45.385563	2024-02-27 11:12:45.385563
50	5	Resource Mobilization Manager	t	2024-02-27 11:12:45.393881	2024-02-27 11:12:45.393881
51	5	Resource Mobilization Officer	t	2024-02-27 11:12:45.401965	2024-02-27 11:12:45.401965
52	5	Resource Mobilization Intern	t	2024-02-27 11:12:45.409904	2024-02-27 11:12:45.409904
53	5	Resource Mobilization Volunteer	t	2024-02-27 11:12:45.419267	2024-02-27 11:12:45.419267
54	5	Resource Mobilization Analyst	t	2024-02-27 11:12:45.426284	2024-02-27 11:12:45.426284
55	2	Program Director	t	2024-06-14 08:39:46.128892	2024-06-14 08:39:46.128892
12	1	Administration Officer	t	2024-02-27 11:12:45.086244	2024-02-27 11:12:45.086244
\.


--
-- Data for Name: employee_designations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.employee_designations (employee_designation_id, employee_id, designation_id, start_date, end_date, created_at, updated_at) FROM stdin;
1	1	3	2023-01-03	2023-11-04	2024-02-27 11:13:05.189694	2024-02-27 11:13:05.189694
2	2	28	2021-03-14	2021-10-01	2024-02-27 11:13:05.202407	2024-02-27 11:13:05.202407
3	2	40	2021-10-01	2022-10-25	2024-02-27 11:13:05.21415	2024-02-27 11:13:05.21415
4	2	26	2022-10-25	\N	2024-02-27 11:13:05.225014	2024-02-27 11:13:05.225014
5	3	27	2022-11-28	2023-12-25	2024-02-27 11:13:05.249233	2024-02-27 11:13:05.249233
6	4	27	2022-11-28	2023-09-06	2024-02-27 11:13:05.275056	2024-02-27 11:13:05.275056
7	5	28	2023-04-03	2023-10-02	2024-02-27 11:13:05.292763	2024-02-27 11:13:05.292763
8	6	47	2022-10-03	2023-02-28	2024-02-27 11:13:05.304678	2024-02-27 11:13:05.304678
10	7	18	2021-10-29	\N	2024-02-27 11:13:05.337365	2024-02-27 11:13:05.337365
11	8	27	2022-10-01	\N	2024-02-27 11:13:05.357923	2024-02-27 11:13:05.357923
12	9	27	2022-11-28	\N	2024-02-27 11:13:05.3775	2024-02-27 11:13:05.3775
14	11	1	2020-05-01	\N	2024-02-27 11:13:05.411024	2024-02-27 11:13:05.411024
15	12	28	2023-04-11	2023-10-11	2024-02-27 11:13:05.429696	2024-02-27 11:13:05.429696
16	12	29	2023-10-12	2023-12-31	2024-02-27 11:13:05.456152	2024-02-27 11:13:05.456152
17	12	47	2024-01-02	\N	2024-02-27 11:13:05.480174	2024-02-27 11:13:05.480174
18	13	26	2023-04-03	2023-08-25	2024-02-27 11:13:05.500424	2024-02-27 11:13:05.500424
19	14	28	2022-10-10	2023-04-28	2024-02-27 11:13:05.519436	2024-02-27 11:13:05.519436
20	15	28	2022-01-10	2022-06-26	2024-02-27 11:13:05.544561	2024-02-27 11:13:05.544561
21	15	26	2022-06-27	2023-01-31	2024-02-27 11:13:05.566912	2024-02-27 11:13:05.566912
22	16	28	2022-08-29	2023-03-10	2024-02-27 11:13:05.586968	2024-02-27 11:13:05.586968
23	17	28	2021-03-29	2021-09-30	2024-02-27 11:13:05.605253	2024-02-27 11:13:05.605253
24	17	26	2021-10-01	2023-01-15	2024-02-27 11:13:05.622619	2024-02-27 11:13:05.622619
25	18	28	2023-04-11	2023-10-09	2024-02-27 11:13:05.644794	2024-02-27 11:13:05.644794
26	19	28	2023-04-11	2023-08-25	2024-02-27 11:13:05.663014	2024-02-27 11:13:05.663014
27	20	26	2022-11-16	\N	2024-02-27 11:13:05.68412	2024-02-27 11:13:05.68412
28	21	28	2023-06-19	2023-08-25	2024-02-27 11:13:05.702974	2024-02-27 11:13:05.702974
30	23	42	2023-02-20	2023-05-22	2024-02-27 11:13:05.738884	2024-02-27 11:13:05.738884
31	24	27	2022-11-28	\N	2024-02-27 11:13:05.756732	2024-02-27 11:13:05.756732
32	25	28	2023-03-02	2023-09-06	2024-02-27 11:13:05.778225	2024-02-27 11:13:05.778225
33	26	28	2023-03-08	2023-05-24	2024-02-27 11:13:05.794417	2024-02-27 11:13:05.794417
34	26	26	2023-05-25	\N	2024-02-27 11:13:05.809428	2024-02-27 11:13:05.809428
35	27	27	2022-11-28	\N	2024-02-27 11:13:05.824599	2024-02-27 11:13:05.824599
36	28	38	2021-07-06	2022-10-24	2024-02-27 11:13:05.852782	2024-02-27 11:13:05.852782
37	28	25	2022-10-25	\N	2024-02-27 11:13:05.87482	2024-02-27 11:13:05.87482
38	29	38	2021-07-06	2022-10-24	2024-02-27 11:13:05.888679	2024-02-27 11:13:05.888679
39	29	25	2022-10-25	\N	2024-02-27 11:13:05.900395	2024-02-27 11:13:05.900395
40	30	28	2022-10-10	2023-04-28	2024-02-27 11:13:05.912614	2024-02-27 11:13:05.912614
41	31	28	2022-06-06	2022-08-26	2024-02-27 11:13:05.92439	2024-02-27 11:13:05.92439
42	31	26	2022-08-26	\N	2024-02-27 11:13:05.948223	2024-02-27 11:13:05.948223
43	32	33	2021-10-29	\N	2024-02-27 11:13:05.963995	2024-02-27 11:13:05.963995
44	33	27	2022-10-01	\N	2024-02-27 11:13:05.979185	2024-02-27 11:13:05.979185
45	34	9	2023-01-03	2024-02-25	2024-02-27 11:13:05.992559	2024-02-27 11:13:05.992559
46	35	27	2022-11-28	\N	2024-02-27 11:13:06.004224	2024-02-27 11:13:06.004224
47	36	26	2022-05-25	\N	2024-02-27 11:13:06.014704	2024-02-27 11:13:06.014704
48	37	28	2021-03-22	2021-09-30	2024-02-27 11:13:06.025192	2024-02-27 11:13:06.025192
49	37	26	2021-10-01	\N	2024-02-27 11:13:06.042551	2024-02-27 11:13:06.042551
50	38	28	2022-09-05	2022-11-25	2024-02-27 11:13:06.062734	2024-02-27 11:13:06.062734
51	38	32	2022-11-28	\N	2024-02-27 11:13:06.084426	2024-02-27 11:13:06.084426
53	40	27	2022-11-28	\N	2024-02-27 11:13:06.11472	2024-02-27 11:13:06.11472
54	41	33	2021-10-29	\N	2024-02-27 11:13:06.124487	2024-02-27 11:13:06.124487
55	42	28	2023-03-07	2023-05-25	2024-02-27 11:13:06.147359	2024-02-27 11:13:06.147359
56	42	26	2023-05-25	\N	2024-02-27 11:13:06.163166	2024-02-27 11:13:06.163166
57	43	28	2022-08-01	2023-03-25	2024-02-27 11:13:06.176982	2024-02-27 11:13:06.176982
58	43	41	2023-03-25	\N	2024-02-27 11:13:06.189463	2024-02-27 11:13:06.189463
59	44	26	2023-07-03	\N	2024-02-27 11:13:06.200346	2024-02-27 11:13:06.200346
60	45	26	2023-08-21	\N	2024-02-27 11:13:06.211671	2024-02-27 11:13:06.211671
61	46	42	2023-06-06	\N	2024-02-27 11:13:06.222279	2024-02-27 11:13:06.222279
62	47	31	2023-07-03	2023-11-03	2024-02-27 11:13:06.232298	2024-02-27 11:13:06.232298
63	48	31	2023-01-18	2023-10-31	2024-02-27 11:13:06.244413	2024-02-27 11:13:06.244413
64	49	28	2023-09-11	\N	2024-02-27 11:13:06.25907	2024-02-27 11:13:06.25907
65	50	28	2023-09-25	2023-12-25	2024-02-27 11:13:06.275772	2024-02-27 11:13:06.275772
66	50	32	2024-01-02	\N	2024-02-27 11:13:06.289874	2024-02-27 11:13:06.289874
67	51	28	2023-10-17	\N	2024-02-27 11:13:06.300421	2024-02-27 11:13:06.300421
68	52	28	2023-10-17	\N	2024-02-27 11:13:06.310489	2024-02-27 11:13:06.310489
69	53	28	2023-10-17	\N	2024-02-27 11:13:06.32093	2024-02-27 11:13:06.32093
70	54	28	2023-10-17	\N	2024-02-27 11:13:06.340345	2024-02-27 11:13:06.340345
71	55	27	2023-11-27	\N	2024-02-27 11:13:06.358576	2024-02-27 11:13:06.358576
72	56	27	2023-11-27	\N	2024-02-27 11:13:06.374473	2024-02-27 11:13:06.374473
73	57	29	2023-11-27	\N	2024-02-27 11:13:06.388435	2024-02-27 11:13:06.388435
74	58	27	2023-12-18	\N	2024-02-27 11:13:06.401004	2024-02-27 11:13:06.401004
75	59	27	2023-12-11	\N	2024-02-27 11:13:06.41458	2024-02-27 11:13:06.41458
76	60	27	2024-01-02	\N	2024-02-27 11:13:06.425845	2024-02-27 11:13:06.425845
78	62	12	2024-01-29	\N	2024-02-27 11:13:06.468851	2024-02-27 11:13:06.468851
79	63	20	2024-01-29	\N	2024-02-27 11:13:06.486276	2024-02-27 11:13:06.486276
80	64	26	2024-02-07	\N	2024-02-27 11:13:06.498595	2024-02-27 11:13:06.498595
81	65	15	2024-01-30	\N	2024-02-27 11:13:06.510059	2024-02-27 11:13:06.510059
82	66	26	2024-01-22	\N	2024-02-27 11:13:06.520179	2024-02-27 11:13:06.520179
83	67	26	2021-10-01	\N	2024-02-27 11:13:06.533729	2024-02-27 11:13:06.533729
84	68	19	2022-04-28	\N	2024-02-27 11:13:06.553088	2024-02-27 11:13:06.553088
85	69	10	2024-02-08	\N	2024-02-27 11:13:06.577231	2024-02-27 11:13:06.577231
86	70	28	2024-02-20	\N	2024-02-27 11:13:06.591885	2024-02-27 11:13:06.591885
87	71	28	2024-02-20	\N	2024-02-27 11:13:06.603132	2024-02-27 11:13:06.603132
88	72	19	2024-02-21	\N	2024-02-27 11:13:06.613405	2024-02-27 11:13:06.613405
89	73	17	2024-03-06	\N	2024-03-15 10:20:01.937961	2024-03-15 10:20:01.937961
29	22	20	2021-11-01	\N	2024-02-27 11:13:05.719572	2024-03-19 12:00:34.528347
9	6	40	2023-03-01	2024-03-05	2024-02-27 11:13:05.316361	2024-03-26 05:52:02.138135
90	6	25	2024-03-06	\N	2024-03-26 05:54:23.959155	2024-03-26 05:54:23.959155
91	74	25	2024-04-02	\N	2024-04-02 11:32:36.334126	2024-04-02 11:32:36.334126
92	75	9	2024-04-02	\N	2024-04-02 12:06:01.112276	2024-04-02 12:06:01.112276
93	76	28	2024-04-15	\N	2024-04-17 12:53:21.973073	2024-04-17 12:53:21.973073
94	77	28	2024-04-17	\N	2024-04-17 13:30:45.913895	2024-04-17 13:30:45.913895
118	39	5	2025-01-06	\N	2025-01-08 07:59:36.908755	2025-01-08 07:59:36.908755
96	79	28	2024-04-22	\N	2024-04-25 08:11:11.308391	2024-04-25 08:11:11.308391
98	81	55	2023-02-01	\N	2024-06-14 08:41:36.764817	2024-06-14 08:41:36.764817
99	84	27	2024-07-01	\N	2024-07-02 13:01:47.53972	2024-07-02 13:01:47.53972
100	85	28	2024-08-19	\N	2024-08-22 06:44:30.133735	2024-08-22 06:44:30.133735
101	86	28	2024-08-21	\N	2024-08-22 08:08:35.451663	2024-08-22 08:08:35.451663
97	80	28	2024-05-13	2024-08-12	2024-05-21 06:19:54.618632	2024-08-29 07:31:16.432596
77	61	47	2024-01-08	2024-05-14	2024-02-27 11:13:06.446693	2024-08-29 07:48:44.390469
102	80	32	2024-08-12	\N	2024-08-29 07:28:10.885211	2024-08-29 07:29:54.708251
106	89	28	2024-10-22	\N	2024-11-11 06:40:49.204572	2024-11-11 06:40:49.204572
103	61	40	2024-05-15	\N	2024-08-29 07:50:05.108589	2024-08-29 07:50:05.108589
104	87	39	2024-09-30	\N	2024-09-30 07:43:34.286176	2024-09-30 07:43:34.286176
13	10	20	2022-09-26	\N	2024-02-27 11:13:05.397674	2024-10-30 13:28:36.288047
95	78	28	2024-04-17	2024-10-24	2024-04-17 13:38:33.24912	2024-11-07 07:03:32.299151
105	78	26	2024-10-25	\N	2024-11-07 07:05:08.690106	2024-11-07 07:05:08.690106
107	90	28	2024-10-22	\N	2024-11-11 07:00:56.254344	2024-11-11 07:00:56.254344
108	91	28	2024-10-22	\N	2024-11-11 07:05:41.325175	2024-11-11 07:05:41.325175
109	92	27	2024-11-04	\N	2024-11-11 07:19:46.754819	2024-11-11 07:19:46.754819
110	93	27	2024-11-04	\N	2024-11-11 07:22:01.17013	2024-11-11 07:22:01.17013
111	94	27	2024-11-25	\N	2024-11-25 14:02:48.964293	2024-11-25 14:02:48.964293
112	95	9	2024-12-02	\N	2024-12-02 09:48:56.638337	2024-12-02 09:48:56.638337
113	96	27	2024-11-29	\N	2024-12-02 09:54:25.132134	2024-12-02 09:54:25.132134
114	97	27	2024-12-02	\N	2024-12-02 10:06:15.247026	2024-12-02 10:06:15.247026
115	98	27	2024-12-09	\N	2024-12-14 09:34:05.314781	2024-12-14 09:34:05.314781
116	99	27	2025-01-06	\N	2024-12-14 09:39:36.773134	2024-12-14 09:39:36.773134
117	100	2	2025-01-06	\N	2025-01-07 11:48:08.198456	2025-01-07 11:48:08.198456
52	39	4	2022-03-28	2025-01-05	2024-02-27 11:13:06.101761	2025-01-08 07:56:16.056489
119	83	26	2024-11-01	\N	2025-01-08 08:44:30.223841	2025-01-08 08:44:30.223841
120	82	26	2024-11-01	\N	2025-01-08 08:48:49.245029	2025-01-08 08:48:49.245029
121	101	37	2025-01-01	\N	2025-02-07 07:05:07.607402	2025-02-07 07:05:07.607402
122	102	27	2025-02-10	\N	2025-02-17 06:11:39.40562	2025-02-17 06:11:39.40562
123	103	27	2025-01-22	\N	2025-02-17 06:22:37.644348	2025-02-17 06:22:37.644348
124	104	28	2025-02-24	\N	2025-03-19 08:45:23.24604	2025-03-19 08:45:23.24604
125	105	28	2025-02-26	\N	2025-03-19 09:15:48.785269	2025-03-19 09:15:48.785269
126	106	28	2025-02-26	\N	2025-03-19 09:22:24.289313	2025-03-19 09:22:24.289313
127	107	28	2025-02-24	\N	2025-03-19 09:36:12.109349	2025-03-19 09:36:12.109349
128	108	28	2025-03-03	\N	2025-03-19 09:41:51.620446	2025-03-19 09:41:51.620446
129	109	28	2025-02-24	\N	2025-03-19 09:44:37.987902	2025-03-19 09:44:37.987902
130	110	28	2025-05-05	\N	2025-05-02 13:14:05.455007	2025-05-02 13:14:05.455007
131	111	28	2025-05-15	\N	2025-05-19 13:48:06.497439	2025-05-19 13:48:06.497439
132	112	28	2025-05-15	\N	2025-05-19 13:51:13.223092	2025-05-19 13:51:13.223092
133	113	28	2025-05-15	\N	2025-05-19 13:54:58.603539	2025-05-19 13:54:58.603539
134	114	28	2025-05-15	\N	2025-05-19 13:58:35.233014	2025-05-19 13:58:35.233014
135	115	28	2025-05-26	\N	2025-05-23 10:46:56.40366	2025-05-23 10:46:56.40366
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.employees (employee_id, person_id, employment_date, still_employed, created_at, updated_at, departure_date, "#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition") FROM stdin;
1	1	2023-01-03	f	2024-02-27 11:12:45.475494	2024-02-27 11:12:45.475494	2023-11-04	\N
2	2	2021-10-01	t	2024-02-27 11:12:45.757378	2024-02-27 11:12:45.757378	\N	\N
3	3	2022-11-28	f	2024-02-27 11:12:46.024093	2024-02-27 11:12:46.024093	2023-12-25	\N
4	4	2022-11-28	f	2024-02-27 11:12:46.305229	2024-02-27 11:12:46.305229	2023-09-06	\N
5	5	2023-04-03	f	2024-02-27 11:12:46.592322	2024-02-27 11:12:46.592322	2023-10-02	\N
6	6	2023-03-01	t	2024-02-27 11:12:46.857357	2024-02-27 11:12:46.857357	\N	\N
7	7	2021-10-29	t	2024-02-27 11:12:47.12916	2024-02-27 11:12:47.12916	\N	\N
8	8	2022-10-01	t	2024-02-27 11:12:47.395594	2024-02-27 11:12:47.395594	\N	\N
9	9	2022-11-28	t	2024-02-27 11:12:47.680198	2024-02-27 11:12:47.680198	\N	\N
10	10	2022-09-26	t	2024-02-27 11:12:47.952524	2024-02-27 11:12:47.952524	\N	\N
11	11	2022-01-26	t	2024-02-27 11:12:48.216302	2024-02-27 11:12:48.216302	\N	\N
13	13	2023-04-03	f	2024-02-27 11:12:48.773977	2024-02-27 11:12:48.773977	2023-08-25	\N
14	14	2022-10-10	f	2024-02-27 11:12:49.036397	2024-02-27 11:12:49.036397	2023-04-28	\N
15	15	2022-01-10	f	2024-02-27 11:12:49.295624	2024-02-27 11:12:49.295624	2023-01-31	\N
16	16	2022-08-29	f	2024-02-27 11:12:49.561946	2024-02-27 11:12:49.561946	2023-03-10	\N
17	17	2021-10-01	f	2024-02-27 11:12:49.827665	2024-02-27 11:12:49.827665	2023-01-15	\N
18	18	2023-04-11	f	2024-02-27 11:12:50.097219	2024-02-27 11:12:50.097219	2023-10-09	\N
19	19	2023-04-11	f	2024-02-27 11:12:50.364388	2024-02-27 11:12:50.364388	2023-08-25	\N
21	21	2023-06-19	f	2024-02-27 11:12:50.886676	2024-02-27 11:12:50.886676	2023-08-25	\N
22	22	2021-11-01	t	2024-02-27 11:12:51.161303	2024-02-27 11:12:51.161303	\N	\N
23	23	2023-02-20	f	2024-02-27 11:12:51.441387	2024-02-27 11:12:51.441387	2023-05-22	\N
24	24	2022-11-28	t	2024-02-27 11:12:51.702089	2024-02-27 11:12:51.702089	\N	\N
25	25	2023-03-02	f	2024-02-27 11:12:51.971618	2024-02-27 11:12:51.971618	2023-09-06	\N
26	26	2023-03-08	t	2024-02-27 11:12:52.254728	2024-02-27 11:12:52.254728	\N	\N
27	27	2022-11-28	t	2024-02-27 11:12:52.51345	2024-02-27 11:12:52.51345	\N	\N
28	28	2021-07-06	t	2024-02-27 11:12:52.790231	2024-02-27 11:12:52.790231	\N	\N
30	30	2022-10-10	f	2024-02-27 11:12:53.355807	2024-02-27 11:12:53.355807	2023-04-28	\N
31	31	2022-06-06	t	2024-02-27 11:12:53.655505	2024-02-27 11:12:53.655505	\N	\N
32	32	2021-10-29	t	2024-02-27 11:12:53.917929	2024-02-27 11:12:53.917929	\N	\N
33	33	2022-10-01	t	2024-02-27 11:12:54.185245	2024-02-27 11:12:54.185245	\N	\N
35	35	2022-11-28	t	2024-02-27 11:12:54.722068	2024-02-27 11:12:54.722068	\N	\N
36	36	2022-05-26	t	2024-02-27 11:12:55.032967	2024-02-27 11:12:55.032967	\N	\N
39	39	2022-03-28	t	2024-02-27 11:12:55.854813	2024-02-27 11:12:55.854813	\N	\N
40	40	2022-11-28	t	2024-02-27 11:12:56.116837	2024-02-27 11:12:56.116837	\N	\N
41	41	2021-10-29	t	2024-02-27 11:12:56.377533	2024-02-27 11:12:56.377533	\N	\N
42	42	2023-03-07	t	2024-02-27 11:12:56.639938	2024-02-27 11:12:56.639938	\N	\N
43	43	2022-08-01	t	2024-02-27 11:12:56.896142	2024-02-27 11:12:56.896142	\N	\N
45	45	2023-08-21	t	2024-02-27 11:12:57.461356	2024-02-27 11:12:57.461356	\N	\N
47	47	2023-07-03	f	2024-02-27 11:12:57.992623	2024-02-27 11:12:57.992623	2023-11-03	\N
48	48	2023-01-18	f	2024-02-27 11:12:58.258795	2024-02-27 11:12:58.258795	2023-10-31	\N
55	55	2023-11-27	t	2024-02-27 11:13:00.118974	2024-02-27 11:13:00.118974	\N	\N
56	56	2023-11-27	t	2024-02-27 11:13:00.390788	2024-02-27 11:13:00.390788	\N	\N
58	58	2023-12-18	t	2024-02-27 11:13:00.944824	2024-02-27 11:13:00.944824	\N	\N
60	60	2024-01-02	t	2024-02-27 11:13:01.503293	2024-02-27 11:13:01.503293	\N	\N
62	62	2024-01-29	t	2024-02-27 11:13:02.101776	2024-02-27 11:13:02.101776	\N	\N
66	66	2024-01-22	t	2024-02-27 11:13:03.241956	2024-02-27 11:13:03.241956	\N	\N
67	67	2021-10-01	f	2024-02-27 11:13:03.516109	2024-02-27 11:13:03.516109	2022-09-02	\N
68	68	2022-04-28	f	2024-02-27 11:13:03.787171	2024-02-27 11:13:03.787171	2023-12-31	\N
70	70	2024-02-20	t	2024-02-27 11:13:04.327667	2024-02-27 11:13:04.327667	\N	\N
71	71	2024-02-20	t	2024-02-27 11:13:04.59516	2024-02-27 11:13:04.59516	\N	\N
34	34	2023-01-03	f	2024-02-27 11:12:54.457491	2024-03-07 09:16:26.501411	2024-02-27	\N
73	73	2024-03-06	t	2024-03-15 10:13:11.781927	2024-03-15 10:13:11.781927	\N	\N
72	72	2024-02-21	f	2024-02-27 11:13:04.873397	2024-03-26 05:45:56.18587	2024-03-21	\N
63	63	2024-01-29	f	2024-02-27 11:13:02.397854	2024-03-27 09:27:07.840408	2024-01-31	\N
12	12	2023-04-11	f	2024-02-27 11:12:48.494102	2024-10-18 06:25:55.736785	2024-05-13	\N
51	51	2023-10-17	f	2024-02-27 11:12:59.047976	2024-10-18 06:41:57.633374	2024-04-17	\N
74	74	2024-04-02	t	2024-04-02 11:26:13.876332	2024-04-02 11:26:13.876332	\N	\N
75	75	2024-04-02	t	2024-04-02 12:04:38.331388	2024-04-02 12:04:38.331388	\N	\N
64	64	2024-02-07	f	2024-02-27 11:13:02.683174	2024-04-17 12:32:34.354777	2024-03-29	\N
49	49	2023-09-11	f	2024-02-27 11:12:58.523264	2024-04-17 12:33:22.473457	2024-03-29	\N
77	77	2024-04-17	t	2024-04-17 13:30:28.792559	2024-04-17 13:30:28.792559	\N	\N
78	78	2024-04-17	t	2024-04-17 13:38:15.590207	2024-04-17 13:38:15.590207	\N	\N
80	80	2024-05-13	t	2024-05-21 06:10:05.559433	2024-05-21 06:10:05.559433	\N	\N
46	46	2023-06-06	f	2024-02-27 11:12:57.729011	2024-05-30 07:46:04.248984	2024-04-21	\N
81	81	2023-02-01	t	2024-06-14 06:34:09.433696	2024-06-14 06:34:09.433696	\N	\N
82	82	2024-06-17	t	2024-06-24 07:40:13.367164	2024-06-24 07:40:13.367164	\N	\N
83	83	2024-06-17	t	2024-06-24 11:00:13.443599	2024-06-24 11:00:13.443599	\N	\N
84	84	2024-07-01	t	2024-07-02 12:39:11.47053	2024-07-02 12:39:11.47053	\N	\N
20	20	2022-11-22	f	2024-02-27 11:12:50.621506	2024-07-23 11:27:19.817192	2024-05-28	\N
69	69	2024-02-08	f	2024-02-27 11:13:04.059396	2024-07-24 12:38:28.450741	2024-05-03	\N
50	50	2023-09-25	f	2024-02-27 11:12:58.786704	2024-08-07 07:29:17.93107	2024-07-05	\N
57	57	2023-11-27	f	2024-02-27 11:13:00.679568	2024-08-07 07:38:21.664374	2024-07-26	\N
87	87	2024-09-30	t	2024-09-30 07:30:27.899009	2024-09-30 07:30:27.899009	\N	\N
37	37	2021-10-01	f	2024-02-27 11:12:55.310136	2024-10-17 14:15:21.538066	2024-08-29	\N
86	86	2024-08-21	f	2024-08-22 08:00:14.001124	2024-10-17 14:18:39.627038	2024-10-14	\N
54	54	2023-10-17	f	2024-02-27 11:12:59.852652	2024-10-18 06:43:16.704341	2024-04-17	\N
100	100	2025-01-06	t	2025-01-07 11:47:50.863262	2025-01-07 11:47:50.863262	\N	\N
52	52	2023-10-17	f	2024-02-27 11:12:59.310623	2024-10-18 06:25:18.27964	2024-04-17	\N
53	53	2023-10-17	f	2024-02-27 11:12:59.579942	2024-10-18 06:44:20.637691	2024-04-25	\N
89	89	2024-10-22	t	2024-11-11 06:27:11.844153	2024-11-11 06:27:11.844153	\N	\N
92	92	2024-11-04	t	2024-11-11 07:19:35.417279	2024-11-11 07:19:35.417279	\N	\N
93	93	2024-11-04	t	2024-11-11 07:21:45.044899	2024-11-11 07:21:45.044899	\N	\N
94	94	2024-11-25	t	2024-11-25 14:02:16.481467	2024-11-25 14:02:16.481467	\N	\N
95	95	2024-12-02	t	2024-12-02 09:48:36.240888	2024-12-02 09:48:36.240888	\N	\N
96	96	2024-11-29	t	2024-12-02 09:54:06.829046	2024-12-02 09:54:06.829046	\N	\N
97	97	2024-12-02	t	2024-12-02 10:05:55.63617	2024-12-02 10:05:55.63617	\N	\N
98	98	2024-12-09	t	2024-12-14 09:33:41.564735	2024-12-14 09:33:41.564735	\N	\N
99	99	2025-01-06	t	2024-12-14 09:38:43.656371	2024-12-14 09:38:43.656371	\N	\N
29	29	2021-07-06	f	2024-02-27 11:12:53.082113	2025-01-08 06:37:34.441597	2024-12-25	\N
38	38	2022-09-05	f	2024-02-27 11:12:55.587189	2025-01-08 06:43:09.307212	2024-12-25	\N
44	44	2023-07-03	f	2024-02-27 11:12:57.179076	2025-01-08 06:46:30.297493	2024-12-25	\N
59	59	2023-12-11	f	2024-02-27 11:13:01.218791	2025-01-08 06:47:50.990606	2024-12-25	\N
85	85	2024-08-19	f	2024-08-22 06:28:14.33673	2025-01-08 06:49:30.561979	2024-10-31	\N
79	79	2024-04-22	f	2024-04-25 08:08:44.941971	2025-01-08 08:02:50.687794	2024-10-25	\N
101	101	2025-01-01	t	2025-02-07 07:04:47.450554	2025-02-07 07:04:47.450554	\N	\N
102	102	2025-02-10	t	2025-02-17 06:11:23.197309	2025-02-17 06:11:23.197309	\N	\N
103	103	2025-01-22	t	2025-02-17 06:22:22.085376	2025-02-17 06:22:22.085376	\N	\N
104	104	2025-02-24	t	2025-03-19 08:45:22.983873	2025-03-19 08:45:22.983873	\N	\N
105	105	2025-03-26	t	2025-03-19 09:15:48.530965	2025-03-19 09:15:48.530965	\N	\N
106	106	2025-02-26	t	2025-03-19 09:22:24.035639	2025-03-19 09:22:24.035639	\N	\N
107	107	2025-02-24	t	2025-03-19 09:36:11.844981	2025-03-19 09:36:11.844981	\N	\N
108	108	2025-03-04	t	2025-03-19 09:41:51.364115	2025-03-19 09:41:51.364115	\N	\N
109	109	2025-02-24	t	2025-03-19 09:44:37.726226	2025-03-19 09:44:37.726226	\N	\N
110	110	2025-05-05	t	2025-05-02 13:14:05.197735	2025-05-02 13:14:05.197735	\N	\N
111	111	2025-05-15	t	2025-05-19 13:48:06.235328	2025-05-19 13:48:06.235328	\N	\N
112	112	2025-05-15	t	2025-05-19 13:51:12.970352	2025-05-19 13:51:12.970352	\N	\N
113	113	2025-05-15	t	2025-05-19 13:54:58.348836	2025-05-19 13:54:58.348836	\N	\N
88	88	2024-09-30	f	2024-10-21 06:55:19.03658	2025-06-17 10:45:28.043984	2025-04-30	\N
65	65	2024-01-30	f	2024-02-27 11:13:02.958991	2025-06-17 10:47:01.029403	2025-05-23	\N
90	90	2024-10-22	f	2024-11-11 07:00:22.260714	2025-06-17 10:50:37.638606	2025-06-06	\N
91	91	2024-10-22	f	2024-11-11 07:05:27.77737	2025-06-17 10:51:27.967422	2025-06-06	\N
114	114	2025-05-15	t	2025-05-19 13:58:34.980694	2025-05-19 13:58:34.980694	\N	\N
115	115	2025-05-26	t	2025-05-23 10:46:56.146172	2025-05-23 10:46:56.146172	\N	\N
61	61	2024-01-08	f	2024-02-27 11:13:01.798184	2025-06-17 10:44:22.533551	2025-05-02	\N
76	76	2024-04-15	f	2024-04-17 12:47:32.342024	2025-06-17 10:52:48.762292	2025-03-14	\N
\.


--
-- Data for Name: global_properties; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.global_properties (property_id, property, property_value, description, created_at, updated_at) FROM stdin;
1	number.of.hours	7.5	Number of hours 	2024-03-08 13:00:34.993073	2024-03-08 13:00:34.993073
2	month.start.date	25	Number of hours 	2024-03-08 13:00:34.998573	2024-03-08 13:00:34.998573
3	full.time.annual.leave	1.75	Number of leave days per month	2024-03-08 13:00:35.002829	2024-03-08 13:00:35.002829
4	part.time.annual.leave	1.25	leave days for part time employee	2024-03-08 13:00:35.008698	2024-03-08 13:00:35.008698
5	petty.cash.limit	40000	Amount that can be transacted using petty cash	2024-03-08 13:00:35.038098	2024-03-08 13:00:35.038098
6	per.diem.lunch	6000	Allocated amount for lunch allowance	2024-03-08 13:00:35.041486	2024-03-08 13:00:35.041486
7	per.diem.dinner	8000	Allocated amount for dinner allowance	2024-03-08 13:00:35.044042	2024-03-08 13:00:35.044042
8	per.diem.incidental	1.25	Allocated amount for incidental allowance	2024-03-08 13:00:35.046423	2024-03-08 13:00:35.046423
9	per.diem.accommodation	30000	Allocated amount for accommodation	2024-03-08 13:00:35.048828	2024-03-08 13:00:35.048828
10	dashboard.metadata	GHII,ghii-logo.png	Metadata for the Dashboard, including organization shortname and logo; metadata is customizable and depend on logic to extract from the database	2025-05-30 09:03:21.551509	2025-05-30 09:03:21.551509
11	unit.fuel.cost	2500	Allocated cost per litre of fuel for vehicles	2025-07-01 11:40:45.748734	2025-07-01 11:40:45.748734
12	fuel.consumption.mitsubishi_rosa	0.125	Fuel consumption per 1km for Mitsubishi Rosa	2025-07-01 11:40:45.748734	2025-07-01 11:40:45.748734
13	fuel.consumption.toyota_coaster	0.143	Fuel consumption per 1km for Toyota Coaster	2025-07-01 11:40:45.748734	2025-07-01 11:40:45.748734
14	purchase.request.threshold	3000000	Allocated threshold for purchase request that trigger internal procurement committee review	2025-07-09 08:19:05.876419	2025-07-09 08:19:05.876419
\.


--
-- Data for Name: initial_states; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.initial_states (initial_state_id, workflow_process_id, workflow_state_id, created_at, updated_at) FROM stdin;
1	1	1	2024-09-27 13:26:38.29765	2024-09-27 13:26:38.29765
2	2	6	2024-09-27 13:26:38.345574	2024-09-27 13:26:38.345574
3	3	14	2024-09-27 13:26:38.409792	2024-09-27 13:26:38.409792
4	4	22	2024-09-27 13:26:38.480474	2024-09-27 13:26:38.480474
5	5	30	2024-09-27 13:26:38.55209	2024-09-27 13:26:38.55209
6	1	1	2024-09-27 13:36:30.758093	2024-09-27 13:36:30.758093
7	2	6	2024-09-27 13:36:30.780747	2024-09-27 13:36:30.780747
8	3	14	2024-09-27 13:36:30.799745	2024-09-27 13:36:30.799745
9	4	22	2024-09-27 13:36:30.835418	2024-09-27 13:36:30.835418
10	5	30	2024-09-27 13:36:30.864994	2024-09-27 13:36:30.864994
11	6	37	2025-07-09 13:33:59.578695	2025-07-09 13:33:59.578695
\.


--
-- Data for Name: inventory_item_categories; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.inventory_item_categories (inventory_item_category_id, category, voided, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_item_issues; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.inventory_item_issues (id, requisition_id, inventory_item_id, quantity_issued, issue_date, issued_by, issued_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_item_thresholds; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.inventory_item_thresholds (inventory_item_threshold_id, inventory_item_id, minimum_quantity, maximum_quantity, voided, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_item_types; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.inventory_item_types (inventory_item_type_id, inventory_item_category_id, item_name, manufacturer, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.inventory_items (inventory_item_id, item_type_id, quantity, quantity_used, supplier, unit_price, storage_location, created_by, voided_by, voided, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.leave_requests (leave_request_id, leave_type, employee_id, start_on, end_on, stand_in, reviewed_by, reviewed_on, approved_by, approved_on, status, created_at, updated_at) FROM stdin;
2	Annual Leave	42	2024-09-30 08:56:00	2024-09-30 08:56:00	31	\N	\N	\N	\N	33	2024-09-30 08:58:10.350693	2024-09-30 08:58:24.31337
3	Annual Leave	28	2024-10-03 08:00:00	2024-10-04 16:30:00	11	1	t	1	t	31	2024-09-30 09:04:29.645111	2024-09-30 09:06:51.852476
4	Annual Leave	38	2024-09-30 13:00:00	2024-09-30 16:30:00	85	1	t	1	t	31	2024-09-30 10:16:26.251632	2024-09-30 10:19:47.336274
5	Annual Leave	59	2024-10-09 08:00:00	2024-10-11 16:30:00	35	1	t	1	t	31	2024-10-03 13:54:14.044707	2024-10-04 08:40:05.098454
10	Annual Leave	35	2024-10-17 10:00:00	2024-10-18 04:30:00	33	\N	\N	\N	\N	33	2024-10-09 08:58:23.17486	2024-10-09 09:39:33.072104
12	Annual Leave	31	2024-10-16 08:00:00	2024-10-09 16:30:00	26	28	t	28	t	31	2024-10-09 13:12:24.260839	2024-10-10 06:12:15.834384
7	Annual Leave	45	2024-10-16 08:00:00	2024-10-18 16:30:00	44	29	t	29	t	31	2024-10-08 11:52:35.930356	2024-10-10 06:12:29.221316
8	Annual Leave	43	2024-10-09 14:00:00	2024-10-09 16:30:00	28	28	t	28	t	31	2024-10-09 08:32:37.130303	2024-10-10 06:12:39.680883
11	Annual Leave	35	2024-10-17 10:00:00	2024-10-18 16:30:00	33	\N	\N	\N	\N	33	2024-10-09 09:40:10.921897	2024-10-10 08:01:37.658637
1	Annual Leave	27	2024-11-06 08:00:00	2024-11-11 16:30:00	55	8	t	8	t	31	2024-09-30 08:13:49.251302	2024-10-10 13:18:34.551234
9	Annual Leave	27	2024-10-14 08:00:00	2024-10-14 16:30:00	55	8	t	8	t	31	2024-10-09 08:48:03.301132	2024-10-10 13:18:48.215719
15	Annual Leave	24	2024-10-14 08:00:00	2024-10-14 16:30:00	56	8	t	8	t	31	2024-10-11 07:30:19.866654	2024-10-11 08:42:04.776102
14	Annual Leave	35	2024-10-17 10:00:00	2024-10-18 16:30:00	59	33	t	33	t	31	2024-10-10 08:02:30.514508	2024-10-11 10:24:50.371615
17	Annual Leave	35	2024-10-11 10:25:00	2024-10-11 10:25:00	2	\N	\N	\N	\N	33	2024-10-11 10:25:42.025888	2024-10-11 10:26:11.056474
18	Annual Leave	35	2024-10-11 10:26:00	2024-10-11 10:26:00	2	\N	\N	\N	\N	33	2024-10-11 10:26:29.865314	2024-10-11 10:26:34.307366
19	Annual Leave	9	2024-10-14 08:00:00	2024-10-14 16:30:00	58	8	t	8	t	31	2024-10-11 12:16:45.66804	2024-10-11 13:30:06.972627
20	Annual Leave	84	2024-10-28 08:00:00	2024-10-28 16:30:00	74	11	t	11	t	31	2024-10-14 06:25:28.839494	2024-10-14 09:29:03.553468
24	Annual Leave	44	2024-10-18 09:30:00	2024-10-18 16:30:00	45	\N	\N	\N	\N	33	2024-10-17 09:15:03.076255	2024-10-17 09:15:14.375747
21	Compassionate Leave	83	2024-10-07 11:26:00	2024-10-09 11:26:00	44	29	t	29	t	31	2024-10-14 11:29:54.32784	2024-10-17 12:37:26.45616
23	Annual Leave	33	2024-10-22 08:00:00	2024-10-25 16:30:00	8	11	t	11	t	31	2024-10-16 01:25:59.186509	2024-10-18 07:39:32.155123
28	Annual Leave	73	2024-10-21 08:00:00	2024-10-21 13:00:00	2	\N	\N	\N	\N	33	2024-10-18 13:44:14.720369	2024-10-18 13:44:50.364377
26	Annual Leave	80	2024-10-16 08:00:00	2024-10-17 16:30:00	28	28	t	28	t	31	2024-10-18 07:16:52.775885	2024-10-21 09:33:05.95217
13	Annual Leave	26	2024-10-10 06:36:00	2024-10-10 06:36:00	2	28	t	28	t	31	2024-10-10 06:36:48.374016	2024-10-21 09:33:38.387982
22	Annual Leave	43	2024-10-16 08:00:00	2024-10-16 16:30:00	28	28	t	28	t	31	2024-10-15 18:47:43.810111	2024-10-22 07:13:44.958321
29	Annual Leave	85	2024-10-23 08:00:00	2024-10-23 12:00:00	38	28	t	28	t	31	2024-10-22 06:38:51.513187	2024-10-22 07:14:03.490078
25	Annual Leave	44	2024-10-18 09:30:00	2024-10-18 16:30:00	82	29	t	29	t	31	2024-10-17 09:17:17.692716	2024-10-23 06:11:18.71262
16	Sick Leave	61	2024-10-10 08:00:00	2024-10-10 15:00:00	2	6	t	6	t	31	2024-10-11 08:24:09.395486	2024-10-27 13:11:25.226002
30	Annual Leave	76	2024-10-23 08:00:00	2024-10-23 04:30:00	61	6	t	6	t	31	2024-10-22 11:10:38.205184	2024-10-27 13:12:00.107013
27	Annual Leave	79	2024-10-09 14:23:00	2024-10-11 16:29:00	76	6	t	6	t	31	2024-10-18 12:26:45.512801	2024-10-27 13:12:25.003715
32	Annual Leave	82	2024-10-28 08:00:00	2024-10-28 16:30:00	83	\N	\N	\N	\N	33	2024-10-24 14:26:23.961308	2024-10-28 06:15:08.48854
33	Annual Leave	39	2024-10-28 08:00:00	2024-11-01 16:30:00	75	11	t	11	t	31	2024-10-25 10:16:02.266593	2024-10-28 06:40:09.598753
31	Annual Leave	28	2024-11-18 08:00:00	2024-11-22 16:30:00	11	11	t	11	t	31	2024-10-22 11:50:28.432108	2024-10-28 06:40:22.552198
6	Annual Leave	62	2024-10-14 08:00:00	2024-10-14 16:30:00	65	\N	\N	\N	\N	33	2024-10-07 08:55:35.673842	2024-10-29 12:48:41.352033
35	Annual Leave	82	2024-10-29 15:00:00	2024-10-29 16:30:00	45	\N	\N	\N	\N	33	2024-10-29 08:03:33.248376	2024-10-30 07:24:47.143859
34	Annual Leave	60	2024-11-04 08:00:00	2024-11-04 16:30:00	55	8	t	8	t	31	2024-10-28 14:11:47.27927	2024-10-30 16:17:27.67942
36	Annual Leave	74	2024-10-31 08:00:00	2024-11-01 17:00:00	84	11	t	11	t	31	2024-10-29 08:41:16.505004	2024-10-31 06:41:38.753518
39	Annual Leave	38	2024-11-01 14:30:00	2024-11-01 16:30:00	80	28	t	28	t	31	2024-11-01 06:58:38.19556	2024-11-04 14:02:20.02702
45	Annual Leave	74	2024-11-08 13:00:00	2024-11-08 16:30:00	84	11	t	11	t	31	2024-11-05 06:17:38.195256	2024-11-07 07:28:18.160627
44	Annual Leave	66	2024-11-07 08:00:00	2024-11-07 16:30:00	45	29	t	29	t	31	2024-11-04 09:29:28.88036	2024-11-07 08:36:25.825758
43	Annual Leave	44	2024-11-08 13:00:00	2024-11-08 16:30:00	83	29	t	29	t	31	2024-11-04 09:25:28.997961	2024-11-07 08:38:21.291049
46	Annual Leave	38	2024-11-06 08:00:00	2024-11-07 16:30:00	80	28	t	28	t	31	2024-11-05 16:39:00.858891	2024-11-07 09:04:26.588934
48	Annual Leave	73	2024-11-11 08:00:00	2024-11-15 16:30:00	62	\N	\N	\N	\N	30	2024-11-08 14:09:46.611358	2024-11-08 14:09:46.611358
50	Annual Leave	71	2024-11-15 08:00:00	2024-11-18 16:30:00	31	28	t	28	t	31	2024-11-11 05:46:38.182871	2024-11-11 10:04:50.125014
51	Annual Leave	38	2024-11-08 08:00:00	2024-11-08 16:30:00	80	28	t	28	t	31	2024-11-11 06:47:07.613004	2024-11-11 10:05:27.580791
49	Sick Leave	80	2024-11-04 08:00:00	2024-11-04 16:30:00	28	28	t	28	t	31	2024-11-08 14:17:11.543698	2024-11-11 10:06:02.644273
52	Annual Leave	28	2024-11-08 11:30:00	2024-11-08 16:30:00	11	11	t	11	t	31	2024-11-11 10:04:24.636261	2024-11-12 06:25:34.532374
47	Annual Leave	26	2024-11-08 08:00:00	2024-11-08 16:30:00	70	28	t	28	t	31	2024-11-07 14:19:17.742989	2024-11-12 10:06:14.450281
53	Annual Leave	36	2024-11-14 08:00:00	2024-11-15 16:30:00	28	11	t	11	t	31	2024-11-12 19:04:07.956337	2024-11-13 12:42:45.998356
55	Annual Leave	38	2024-11-15 06:50:00	2024-11-15 06:50:00	80	\N	\N	\N	\N	33	2024-11-15 06:50:43.973506	2024-11-15 06:54:10.922217
57	Annual Leave	38	2024-11-18 08:39:00	2024-11-21 16:30:00	80	28	t	28	t	31	2024-11-15 06:54:55.585742	2024-11-15 06:55:24.901671
42	Annual Leave	55	2024-12-05 08:20:00	2024-12-10 08:20:00	60	8	t	8	t	31	2024-11-04 09:22:36.689121	2024-11-15 07:23:50.675574
56	Annual Leave	28	2024-11-18 08:00:00	2024-11-20 12:00:00	11	11	t	11	t	31	2024-11-15 06:53:20.552259	2024-11-18 08:40:48.489128
65	Sick Leave	24	2024-10-28 08:00:00	2024-10-28 16:30:00	60	8	t	8	t	31	2024-11-25 18:21:41.131739	2024-11-25 20:05:26.198633
64	Annual Leave	24	2024-11-21 08:00:00	2024-11-21 16:30:00	56	8	t	8	t	31	2024-11-25 18:19:54.03639	2024-11-25 20:05:51.59573
41	Annual Leave	61	2024-11-04 08:00:00	2024-11-04 16:30:00	2	6	t	6	t	31	2024-11-01 09:58:41.227123	2024-11-26 05:35:02.090849
40	Annual Leave	61	2024-11-01 13:00:00	2024-11-01 16:30:00	2	6	t	6	t	31	2024-11-01 09:55:44.034895	2024-11-26 05:35:28.488603
62	Annual Leave	91	2024-11-26 08:00:00	2024-11-28 04:30:00	61	\N	\N	\N	\N	33	2024-11-25 11:48:38.544045	2024-11-26 14:25:39.981715
66	Annual Leave	91	2024-11-26 08:00:00	2024-11-28 16:30:00	61	61	t	61	t	31	2024-11-26 14:30:46.838209	2024-11-27 09:30:39.066136
59	Annual Leave	44	2024-11-22 13:00:00	2024-11-22 16:30:00	83	\N	\N	\N	\N	33	2024-11-21 13:24:54.792326	2024-11-27 12:40:15.76649
68	Annual Leave	44	2024-11-29 13:00:00	2024-11-29 16:30:00	83	29	t	29	t	31	2024-11-27 14:02:08.162037	2024-11-28 11:20:34.87908
38	Annual Leave	75	2024-11-01 08:00:00	2024-11-01 16:30:00	62	\N	\N	\N	\N	33	2024-10-30 11:20:11.114081	2025-02-28 10:39:17.341164
69	Annual Leave	36	2024-11-29 08:00:00	2024-11-29 16:30:00	28	11	t	11	t	31	2024-11-27 14:48:36.643564	2024-12-02 05:14:16.322369
67	Study Leave	24	2024-11-28 08:00:00	2024-12-02 16:30:00	9	8	t	8	t	31	2024-11-27 09:12:45.718319	2024-12-03 13:26:06.823563
63	Annual Leave	43	2024-11-26 08:00:00	2024-11-28 16:30:00	28	28	t	28	t	31	2024-11-25 15:44:05.651032	2024-12-05 07:22:24.206004
61	Annual Leave	65	2024-11-20 08:00:00	2024-11-22 14:30:00	62	\N	\N	\N	\N	33	2024-11-25 07:37:04.28477	2024-12-16 06:01:21.489443
70	Compassionate Leave	84	2024-12-05 08:00:00	2024-12-06 16:30:00	74	96	t	96	t	31	2024-11-28 07:16:40.789268	2025-01-22 15:22:52.111289
54	Annual Leave	75	2024-11-15 14:20:00	2024-11-15 14:20:00	39	\N	\N	\N	\N	33	2024-11-14 14:23:32.918485	2025-02-28 10:39:57.464356
37	Annual Leave	62	2024-10-31 13:00:00	2024-10-31 16:30:00	65	\N	\N	\N	\N	33	2024-10-29 13:15:07.531006	2025-04-14 12:57:14.339622
58	Annual Leave	66	2024-11-19 13:00:00	2024-11-20 16:30:00	29	29	t	29	t	31	2024-11-19 09:27:07.625716	2024-11-28 11:19:41.844688
73	Annual Leave	89	2024-11-29 11:09:00	2024-11-29 11:09:00	2	\N	\N	\N	\N	33	2024-11-29 11:09:36.52922	2024-11-29 11:10:14.223585
72	Annual Leave	89	2024-12-02 08:00:00	2024-12-02 16:30:00	61	61	t	61	t	31	2024-11-29 11:08:01.690837	2024-12-02 12:54:57.736055
79	Annual Leave	66	2024-12-09 08:00:00	2024-12-11 16:30:00	45	\N	\N	\N	\N	33	2024-12-04 09:06:59.689414	2024-12-04 09:41:05.081211
76	Annual Leave	76	2024-12-04 08:00:00	2024-12-04 16:30:00	43	\N	\N	\N	\N	33	2024-12-03 11:51:59.757036	2024-12-04 12:07:24.539553
78	Annual Leave	82	2024-12-03 08:00:00	2024-12-03 16:30:00	83	29	t	29	t	31	2024-12-04 06:57:09.22531	2024-12-05 08:57:47.626091
74	Annual Leave	45	2024-12-02 13:00:00	2024-12-02 16:30:00	66	29	t	29	t	31	2024-12-02 10:12:30.439525	2024-12-05 08:58:18.332668
75	Annual Leave	84	2024-12-16 08:00:00	2024-12-20 16:30:00	74	11	t	11	t	31	2024-12-03 06:47:02.348576	2024-12-07 08:13:58.658412
77	Annual Leave	36	2024-12-06 08:00:00	2024-12-06 16:30:00	80	11	t	11	t	31	2024-12-04 03:43:46.299663	2024-12-07 08:15:11.184723
81	Study Leave	24	2024-12-05 08:00:00	2024-12-09 16:30:00	9	8	t	8	t	31	2024-12-04 11:33:24.969373	2024-12-09 06:31:27.145019
86	Annual Leave	82	2024-12-16 08:00:00	2024-12-18 16:30:00	83	\N	\N	\N	\N	33	2024-12-11 06:52:00.100235	2024-12-11 07:00:15.7663
87	Annual Leave	9	2024-12-12 08:00:00	2024-12-13 16:30:00	58	8	t	8	t	31	2024-12-11 07:24:31.349433	2024-12-11 11:12:15.527018
88	Annual Leave	82	2024-12-16 08:00:00	2024-12-18 16:30:00	45	\N	\N	\N	\N	33	2024-12-11 07:30:55.373677	2024-12-12 06:06:08.585701
94	Annual Leave	65	2024-12-13 08:00:00	2024-12-13 12:00:00	73	\N	\N	\N	\N	30	2024-12-12 14:35:19.175514	2024-12-12 14:35:19.175514
95	Annual Leave	35	2024-12-16 08:00:00	2024-12-16 16:30:00	40	33	t	33	t	31	2024-12-15 12:27:14.97182	2024-12-16 06:30:09.45554
84	Annual Leave	40	2024-12-12 08:00:00	2024-12-13 16:30:00	33	33	t	33	t	31	2024-12-10 11:18:15.228146	2024-12-16 06:30:39.981147
85	Annual Leave	36	2024-12-13 08:00:00	2024-12-13 16:30:00	28	11	t	11	t	31	2024-12-11 03:27:53.51581	2024-12-16 07:03:11.822878
60	Annual Leave	26	2024-11-22 08:00:00	2024-11-22 16:30:00	70	28	t	28	t	31	2024-11-21 14:04:55.969273	2024-12-17 04:03:28.040844
117	Annual Leave	66	2025-02-13 08:21:00	2025-02-14 16:30:00	45	45	t	45	t	31	2025-02-10 06:22:13.571178	2025-04-16 11:45:39.765074
91	Annual Leave	82	2024-12-16 08:00:00	2024-12-17 16:30:00	45	45	t	45	t	31	2024-12-12 06:08:25.040107	2025-04-16 11:37:29.145724
99	Annual Leave	31	2025-01-06 08:00:00	2025-01-10 16:30:00	42	28	t	28	t	31	2024-12-18 11:38:46.075749	2024-12-18 19:53:13.45908
98	Annual Leave	26	2025-01-06 08:00:00	2025-01-10 16:30:00	70	28	t	28	t	31	2024-12-18 09:33:14.097536	2024-12-18 19:53:27.36552
121	Annual Leave	62	2025-02-28 08:00:00	2025-02-28 16:30:00	65	\N	\N	\N	\N	33	2025-02-17 14:08:21.644686	2025-04-14 12:57:41.007201
97	Annual Leave	61	2025-01-06 08:00:00	2025-01-08 16:30:00	78	6	t	6	t	31	2024-12-17 09:53:07.520173	2025-01-06 01:06:36.855291
83	Annual Leave	61	2024-12-03 08:00:00	2024-12-03 10:00:00	2	6	t	6	t	31	2024-12-06 09:41:55.831724	2025-01-06 01:09:44.605822
82	Annual Leave	61	2024-12-06 13:00:00	2024-12-06 16:30:00	2	6	t	6	t	31	2024-12-06 09:40:10.830863	2025-01-06 01:10:11.509496
71	Sick Leave	32	2024-11-25 08:00:00	2024-11-27 16:30:00	6	6	t	6	t	31	2024-11-29 07:41:25.197577	2025-01-06 01:19:06.171728
89	Sick Leave	32	2024-12-02 08:00:00	2024-12-06 16:30:00	2	6	t	6	t	31	2024-12-11 12:22:57.216498	2025-01-06 01:19:59.958774
102	Annual Leave	95	2025-01-08 07:57:00	2025-01-08 00:00:00	75	\N	\N	\N	\N	30	2025-01-07 08:19:47.480052	2025-01-07 08:19:47.480052
101	Sick Leave	90	2024-12-17 11:00:00	2024-12-18 16:30:00	61	61	t	61	t	31	2025-01-06 08:16:45.99728	2025-01-09 06:25:29.668619
80	Annual Leave	66	2024-12-09 08:00:00	2024-12-12 16:30:00	45	\N	\N	\N	\N	33	2024-12-04 09:41:50.918323	2025-01-14 11:20:59.294213
104	Annual Leave	58	2025-01-16 08:00:00	2025-01-16 16:30:00	9	8	t	8	t	31	2025-01-17 08:34:46.252091	2025-01-17 08:38:53.57802
106	Annual Leave	74	2025-01-27 08:00:00	2025-01-27 17:00:00	96	96	t	96	t	31	2025-01-24 12:11:27.179564	2025-01-27 06:34:29.176298
107	Annual Leave	9	2025-01-30 08:00:00	2025-01-31 16:30:00	27	8	t	8	t	31	2025-01-27 10:51:26.253938	2025-01-27 11:14:37.436649
108	Annual Leave	60	2025-01-30 08:00:00	2025-01-31 12:00:00	56	8	t	8	t	31	2025-01-28 09:56:33.557422	2025-01-28 11:24:36.036386
109	Annual Leave	27	2025-01-31 07:17:00	2025-02-03 07:17:00	24	\N	\N	\N	\N	33	2025-01-29 07:19:17.195894	2025-01-29 07:19:43.835033
110	Annual Leave	27	2025-01-31 07:22:00	2025-02-03 07:22:00	24	8	t	8	t	31	2025-01-29 07:23:53.630619	2025-01-29 14:28:25.043685
105	Annual Leave	28	2025-01-20 08:00:00	2025-01-20 16:30:00	6	\N	\N	\N	\N	33	2025-01-17 09:39:05.809333	2025-01-31 13:39:21.415114
112	Annual Leave	90	2025-02-07 08:00:00	2025-02-12 12:00:00	77	\N	\N	\N	\N	33	2025-02-06 06:37:14.543397	2025-02-06 08:45:20.45596
114	Annual Leave	89	2025-02-07 08:00:00	2025-02-07 16:30:00	91	61	t	61	t	31	2025-02-06 13:17:15.260888	2025-02-06 13:26:02.639597
113	Annual Leave	90	2025-02-07 08:00:00	2025-02-12 08:00:00	77	\N	\N	\N	\N	33	2025-02-06 08:47:51.095662	2025-02-06 14:32:00.052697
115	Annual Leave	61	2025-02-07 13:00:00	2025-02-07 16:30:00	78	6	t	6	t	31	2025-02-06 13:23:51.419611	2025-02-07 10:16:03.63067
116	Annual Leave	90	2025-02-07 08:00:00	2025-02-11 16:30:00	77	61	t	61	t	31	2025-02-06 14:33:46.234935	2025-02-11 14:11:49.030806
118	Annual Leave	43	2025-02-11 08:00:00	2025-02-11 16:30:00	28	28	t	28	t	31	2025-02-10 17:50:04.209348	2025-02-13 13:52:01.393383
119	Annual Leave	43	2025-02-13 08:00:00	2025-02-14 16:30:00	28	28	t	28	t	31	2025-02-13 08:41:52.972694	2025-02-13 13:52:16.07399
111	Sick Leave	24	2025-01-29 08:00:00	2025-01-29 16:30:00	55	8	t	8	t	31	2025-02-02 13:12:04.32345	2025-02-18 07:11:06.245171
124	Annual Leave	8	2025-02-20 07:17:00	2025-02-21 07:17:00	33	\N	\N	\N	\N	33	2025-02-18 07:19:16.017965	2025-02-18 09:41:24.147941
125	Sick Leave	90	2025-02-17 08:30:00	2025-02-17 16:30:00	77	61	t	61	t	31	2025-02-18 13:39:26.869644	2025-02-19 11:44:53.613914
120	Annual Leave	89	2025-02-12 08:00:00	2025-02-13 12:00:00	61	61	t	61	t	31	2025-02-17 13:25:08.364332	2025-02-19 11:45:51.218411
103	Annual Leave	76	2025-01-10 08:00:00	2025-01-10 16:30:00	43	6	t	6	t	31	2025-01-09 11:54:11.800662	2025-02-19 12:21:49.190935
123	Annual Leave	74	2025-03-04 08:00:00	2025-03-04 17:00:00	96	96	t	96	t	31	2025-02-17 14:48:38.241042	2025-02-19 13:11:26.426552
122	Annual Leave	74	2025-02-20 08:00:00	2025-02-21 17:00:00	96	96	t	96	t	31	2025-02-17 14:46:58.441502	2025-02-19 13:11:53.271435
127	Sick Leave	76	2025-02-17 08:00:00	2025-02-17 16:30:00	43	\N	\N	\N	\N	30	2025-02-20 07:01:09.413631	2025-02-20 07:01:09.413631
128	Annual Leave	27	2025-02-27 08:00:00	2025-02-28 16:30:00	9	\N	\N	\N	\N	33	2025-02-20 11:21:48.355863	2025-02-23 06:51:09.750859
130	Annual Leave	73	2025-02-28 08:00:00	2025-02-28 16:30:00	75	\N	\N	\N	\N	30	2025-02-26 08:50:03.305344	2025-02-26 08:50:03.305344
133	Annual Leave	32	2025-01-06 08:00:00	2025-01-06 16:00:00	2	\N	\N	\N	\N	30	2025-02-27 06:18:27.243625	2025-02-27 06:18:27.243625
134	Sick Leave	32	2025-01-20 08:00:00	2025-01-20 16:30:00	2	\N	\N	\N	\N	30	2025-02-27 06:26:12.657181	2025-02-27 06:26:12.657181
135	Annual Leave	32	2025-02-10 08:00:00	2025-02-10 16:30:00	2	\N	\N	\N	\N	30	2025-02-27 06:29:23.637157	2025-02-27 06:29:23.637157
136	Annual Leave	32	2025-02-24 08:00:00	2025-02-24 16:30:00	2	\N	\N	\N	\N	30	2025-02-27 06:32:37.868146	2025-02-27 06:32:37.868146
138	Annual Leave	75	2025-03-04 08:00:00	2025-03-04 04:30:00	62	\N	\N	\N	\N	33	2025-02-28 10:37:17.223962	2025-02-28 10:37:48.938046
93	Annual Leave	75	2024-12-12 06:51:00	2024-12-20 06:51:00	39	\N	\N	\N	\N	33	2024-12-12 06:52:26.721344	2025-02-28 10:40:26.6395
139	Annual Leave	75	2025-03-04 08:00:00	2025-03-04 16:30:00	2	\N	\N	\N	\N	30	2025-02-28 10:42:27.267215	2025-02-28 10:42:27.267215
131	Annual Leave	99	2025-02-28 08:00:00	2025-02-28 16:30:00	9	8	t	8	t	31	2025-02-26 10:58:35.404286	2025-03-17 08:03:10.178335
129	Annual Leave	27	2025-02-26 08:00:00	2025-02-28 16:30:00	9	8	t	8	t	31	2025-02-23 06:52:59.529734	2025-03-17 08:03:24.928365
90	Compassionate Leave	26	2024-12-13 08:00:00	2024-12-13 16:30:00	70	\N	\N	\N	\N	33	2024-12-11 14:15:37.005641	2025-04-14 08:33:07.963992
92	Annual Leave	82	2025-01-06 08:00:00	2025-01-08 16:30:00	45	45	t	45	t	31	2024-12-12 06:11:18.314382	2025-04-16 11:36:24.800711
126	Annual Leave	6	2025-02-03 08:00:00	2025-02-03 00:00:00	2	11	t	11	t	31	2025-02-19 11:05:38.298146	2025-05-06 13:15:55.354872
132	Annual Leave	61	2025-02-24 08:00:00	2025-02-24 16:30:00	78	6	t	6	t	31	2025-02-26 13:11:13.032272	2025-05-16 07:10:43.637874
142	Sick Leave	80	2025-03-07 13:00:00	2025-03-07 14:00:00	28	28	t	28	t	31	2025-03-07 07:12:28.158055	2025-03-07 09:40:41.14458
143	Annual Leave	80	2025-03-07 14:00:00	2025-03-07 04:00:00	28	28	t	28	t	31	2025-03-07 07:13:51.559569	2025-03-07 09:44:29.870465
141	Sick Leave	90	2025-02-28 09:00:00	2025-03-04 16:30:00	77	61	t	61	t	31	2025-03-05 14:28:57.92328	2025-03-10 08:18:58.523044
145	Annual Leave	61	2025-03-10 14:00:00	2025-03-10 16:30:00	2	\N	\N	\N	\N	33	2025-03-10 07:34:36.875828	2025-03-10 09:23:50.660333
100	Sick Leave	6	2024-11-19 08:00:00	2024-11-22 16:30:00	2	11	t	11	t	31	2025-01-06 01:33:33.439243	2025-03-10 11:17:13.172294
148	Annual Leave	48	2025-03-12 07:25:00	2025-03-12 16:30:00	61	\N	\N	\N	\N	30	2025-03-11 07:26:55.782851	2025-03-11 07:26:55.782851
150	Annual Leave	45	2025-03-20 08:30:00	2025-03-25 16:30:00	83	\N	\N	\N	\N	30	2025-03-13 06:51:34.227173	2025-03-13 06:51:34.227173
140	Annual Leave	39	2025-02-27 07:30:00	2025-03-04 16:30:00	75	100	t	100	t	31	2025-03-05 07:22:45.978887	2025-03-18 09:28:55.876066
146	Annual Leave	39	2025-03-07 14:30:00	2025-03-07 16:30:00	75	100	t	100	t	31	2025-03-10 08:37:45.233784	2025-03-18 09:29:14.544749
147	Annual Leave	39	2025-03-10 08:00:00	2025-03-10 10:00:00	75	100	t	100	t	31	2025-03-10 08:39:40.568082	2025-03-18 09:29:47.395885
159	Annual Leave	9	2025-03-20 08:30:00	2025-03-21 16:30:00	27	8	t	8	t	31	2025-03-19 07:01:46.782332	2025-03-19 08:05:47.491448
156	Annual Leave	24	2025-02-28 08:00:00	2025-02-28 16:30:00	55	8	t	8	t	31	2025-03-18 13:35:47.472961	2025-03-19 08:06:07.939102
157	Sick Leave	78	2025-03-18 08:00:00	2025-03-18 16:30:00	2	6	t	6	t	31	2025-03-18 18:00:50.644141	2025-03-19 08:18:35.532351
161	Maternity Leave	56	2025-03-17 14:08:00	2025-07-25 14:08:00	8	\N	\N	\N	\N	33	2025-03-19 14:13:08.252055	2025-03-20 04:59:42.497525
155	Sick Leave	80	2025-03-17 09:30:00	2025-03-17 12:00:00	2	28	t	28	t	31	2025-03-18 00:28:03.030574	2025-03-20 07:10:49.880188
154	Annual Leave	71	2025-03-19 08:00:00	2025-03-21 16:30:00	31	28	t	28	t	31	2025-03-14 17:01:20.480904	2025-03-20 07:10:58.73829
151	Annual Leave	31	2025-03-14 08:00:00	2025-03-14 16:30:00	71	28	t	28	t	31	2025-03-13 10:18:47.554105	2025-03-20 07:11:06.682269
160	Annual Leave	89	2025-03-19 09:11:00	2025-03-19 09:11:00	2	\N	\N	\N	\N	33	2025-03-19 09:12:20.37584	2025-03-20 08:19:27.235697
162	Maternity Leave	56	2025-03-17 08:00:00	2025-06-13 16:30:00	97	8	t	8	t	31	2025-03-20 13:30:52.284682	2025-03-20 14:18:38.356758
164	Annual Leave	48	2025-03-24 08:00:00	2025-03-24 16:30:00	61	\N	\N	\N	\N	33	2025-03-22 13:36:54.917847	2025-03-24 07:11:39.199459
163	Annual Leave	60	2025-03-27 08:00:00	2025-03-28 16:30:00	97	\N	\N	\N	\N	33	2025-03-21 06:24:13.154489	2025-03-24 07:17:49.712338
166	Sick Leave	78	2025-03-21 08:00:00	2025-03-21 16:30:00	2	\N	\N	\N	\N	30	2025-03-24 07:44:17.142463	2025-03-24 07:44:17.142463
165	Annual Leave	60	2025-03-25 08:00:00	2025-03-27 16:30:00	97	8	t	8	t	31	2025-03-24 07:21:35.710272	2025-03-24 07:45:33.337459
168	Annual Leave	48	2025-03-25 08:00:00	2025-03-25 16:30:00	61	\N	\N	\N	\N	30	2025-03-24 12:48:48.148125	2025-03-24 12:48:48.148125
167	Annual Leave	58	2025-03-28 08:00:00	2025-03-28 16:30:00	27	8	t	8	t	31	2025-03-24 11:50:36.637673	2025-03-24 13:08:32.704619
169	Compassionate Leave	75	2025-04-01 08:00:00	2025-04-01 16:30:00	62	\N	\N	\N	\N	30	2025-03-27 14:52:49.019113	2025-03-27 14:52:49.019113
170	Annual Leave	55	2025-04-01 07:30:00	2025-04-02 16:30:00	24	8	t	8	t	31	2025-03-28 06:43:38.578742	2025-03-28 07:06:07.512057
172	Annual Leave	107	2025-04-02 08:00:00	2025-04-02 16:30:00	28	28	t	28	t	31	2025-04-01 15:50:07.225338	2025-04-03 07:59:23.712404
174	Annual Leave	95	2025-04-04 07:30:00	2025-04-04 16:30:00	75	\N	\N	\N	\N	30	2025-04-03 12:32:38.250852	2025-04-03 12:32:38.250852
177	Annual Leave	48	2025-04-07 08:00:00	2025-04-07 16:30:00	61	\N	\N	\N	\N	30	2025-04-04 13:45:08.212415	2025-04-04 13:45:08.212415
176	Annual Leave	60	2025-04-08 08:00:00	2025-04-08 16:30:00	97	8	t	8	t	31	2025-04-04 11:51:18.253982	2025-04-04 14:55:04.682401
171	Annual Leave	6	2025-03-28 12:00:00	2025-03-28 16:30:00	2	11	t	11	t	31	2025-03-28 07:30:10.735962	2025-04-08 06:17:13.094112
180	Annual Leave	27	2025-04-09 08:00:00	2025-04-09 16:30:00	55	8	t	8	t	31	2025-04-08 07:27:47.699556	2025-04-08 07:28:18.76543
182	Annual Leave	84	2025-04-22 08:00:00	2025-04-23 16:30:00	96	96	t	96	t	31	2025-04-10 08:58:23.316499	2025-04-11 08:22:03.071738
184	Sick Leave	90	2025-04-01 08:00:00	2025-04-01 16:30:00	41	\N	\N	\N	\N	33	2025-04-11 07:32:16.945373	2025-04-11 14:20:47.146506
181	Annual Leave	36	2025-04-11 08:00:00	2025-04-11 16:30:00	28	28	t	28	t	31	2025-04-09 21:57:56.811143	2025-04-11 14:45:32.478842
183	Study Leave	9	2025-04-14 08:30:00	2025-04-17 16:30:00	27	8	t	8	t	31	2025-04-11 06:43:50.667105	2025-04-12 12:42:35.303609
178	Annual Leave	8	2025-04-11 08:00:00	2025-04-11 12:00:00	33	11	t	11	t	31	2025-04-07 08:45:22.941058	2025-04-14 12:47:50.573192
179	Annual Leave	62	2025-04-10 08:00:00	2025-04-11 16:30:00	2	\N	\N	\N	\N	33	2025-04-08 07:04:06.08536	2025-04-14 12:57:59.750234
189	Annual Leave	73	2025-04-22 04:30:00	2025-04-22 16:30:00	62	\N	\N	\N	\N	33	2025-04-16 06:55:51.554327	2025-04-16 06:56:21.310637
187	Annual Leave	89	2025-04-22 08:00:00	2025-04-23 16:30:00	66	45	t	45	t	31	2025-04-15 08:21:34.249865	2025-04-16 11:30:07.408917
173	Annual Leave	83	2025-04-22 08:00:00	2025-04-25 16:30:00	45	45	t	45	t	31	2025-04-03 10:56:03.598694	2025-04-16 11:32:48.079291
158	Annual Leave	82	2025-03-26 08:00:00	2025-03-28 08:00:00	83	45	t	45	t	31	2025-03-19 06:24:12.251609	2025-04-16 11:35:03.675515
152	Annual Leave	66	2025-03-17 08:00:00	2025-03-19 16:30:00	89	45	t	45	t	31	2025-03-13 13:25:21.552783	2025-04-16 11:44:32.082491
192	Annual Leave	45	2025-04-17 08:00:00	2025-04-16 14:00:00	82	\N	\N	\N	\N	30	2025-04-16 11:48:27.061663	2025-04-16 11:48:27.061663
195	Annual Leave	98	2025-04-06 08:00:00	2025-04-08 16:30:00	40	\N	\N	\N	\N	33	2025-04-17 12:46:38.184525	2025-04-17 13:19:38.871982
186	Annual Leave	82	2025-04-23 08:00:00	2025-04-23 08:00:00	105	45	t	45	t	31	2025-04-14 07:00:59.988179	2025-04-18 04:49:07.456619
193	Annual Leave	106	2025-04-23 08:00:00	2025-04-23 16:30:00	45	45	t	45	t	31	2025-04-17 05:46:13.891243	2025-04-18 04:49:16.290221
191	Annual Leave	87	2025-04-17 07:17:00	2025-04-18 07:17:00	33	11	t	11	t	31	2025-04-16 07:19:42.810293	2025-04-22 07:16:50.634212
201	Annual Leave	48	2025-04-23 09:34:00	2025-04-23 09:34:00	6	\N	\N	\N	\N	33	2025-04-22 09:35:04.666145	2025-04-22 09:36:13.20735
204	Annual Leave	48	2025-04-23 08:00:00	2025-04-23 04:30:00	6	\N	\N	\N	\N	33	2025-04-22 09:37:29.29981	2025-04-22 09:37:44.883777
205	Annual Leave	48	2025-04-23 08:00:00	2025-04-23 16:30:00	6	\N	\N	\N	\N	30	2025-04-22 09:38:48.838717	2025-04-22 09:38:48.838717
185	Sick Leave	90	2025-04-01 20:00:00	2025-04-01 16:30:00	78	61	t	61	t	31	2025-04-11 14:22:18.614327	2025-04-22 09:52:42.166578
194	Sick Leave	90	2025-04-17 08:00:00	2025-04-17 16:30:00	78	61	t	61	t	31	2025-04-17 08:20:02.992639	2025-04-22 09:53:04.300777
200	Annual Leave	90	2025-04-23 08:00:00	2025-04-23 04:30:00	78	61	t	61	t	31	2025-04-22 08:13:09.105836	2025-04-22 09:53:50.504029
202	Annual Leave	91	2025-04-23 08:00:00	2025-04-23 16:30:00	6	61	t	61	t	31	2025-04-22 09:35:16.949852	2025-04-22 09:54:01.372371
206	Annual Leave	8	2025-04-24 08:00:00	2025-04-24 16:30:00	33	\N	\N	\N	\N	33	2025-04-23 06:37:32.42617	2025-04-23 12:23:59.659137
196	Annual Leave	98	2025-04-07 08:00:00	2025-04-08 16:30:00	40	33	t	33	t	31	2025-04-17 13:22:24.732765	2025-05-06 07:20:59.362999
208	Annual Leave	8	2025-04-25 08:00:00	2025-04-28 16:30:00	33	11	t	11	t	31	2025-04-23 12:27:29.273419	2025-05-06 13:16:09.244174
203	Annual Leave	61	2025-04-23 08:00:00	2025-04-23 16:30:00	6	6	t	6	t	31	2025-04-22 09:37:07.318466	2025-05-16 06:50:54.180711
199	Annual Leave	32	2025-04-11 08:00:00	2025-04-11 16:30:00	2	6	t	6	t	31	2025-04-20 20:52:29.939082	2025-05-16 06:52:49.351167
198	Annual Leave	32	2025-03-26 08:00:00	2025-03-26 16:30:00	2	6	t	6	t	31	2025-04-20 20:47:58.611465	2025-05-16 06:53:54.632452
175	Annual Leave	2	2025-04-23 08:00:00	2025-04-23 16:30:00	6	6	t	6	t	31	2025-04-03 14:29:40.002232	2025-05-16 06:58:55.130037
153	Annual Leave	32	2025-03-17 08:00:00	2025-03-17 16:30:00	2	6	t	6	t	31	2025-03-14 13:40:13.970404	2025-05-16 07:06:41.253317
149	Annual Leave	61	2025-03-10 13:30:00	2025-03-10 16:30:00	2	6	t	6	t	31	2025-03-11 07:45:58.905452	2025-05-16 07:08:03.615876
207	Annual Leave	39	2025-04-22 08:00:00	2025-04-22 16:30:00	62	100	t	100	t	31	2025-04-23 07:26:04.066909	2025-05-19 01:41:50.825258
197	Annual Leave	78	2025-04-23 08:00:00	2025-04-23 16:30:00	2	6	t	6	t	31	2025-04-18 01:38:23.141206	2025-06-20 10:13:08.133494
212	Annual Leave	40	2025-04-29 08:00:00	2025-04-30 16:30:00	103	\N	\N	\N	\N	33	2025-04-25 06:18:54.144252	2025-04-25 08:16:21.945066
214	Annual Leave	91	2025-04-25 13:00:00	2025-04-25 16:30:00	61	\N	\N	\N	\N	30	2025-04-25 10:04:04.287794	2025-04-25 10:04:04.287794
215	Annual Leave	62	2025-05-02 08:00:00	2025-05-02 16:30:00	73	\N	\N	\N	\N	30	2025-04-25 14:32:28.659825	2025-04-25 14:32:28.659825
209	Annual Leave	74	2025-05-15 08:00:00	2025-05-16 16:30:00	96	\N	\N	\N	\N	33	2025-04-23 13:24:41.386652	2025-04-28 07:40:05.498129
211	Annual Leave	55	2025-05-02 07:30:00	2025-05-02 16:30:00	24	8	t	8	t	31	2025-04-25 06:02:44.082964	2025-04-29 14:27:02.189043
220	Study Leave	58	2025-05-02 08:00:00	2025-05-05 16:30:00	9	8	t	8	t	31	2025-04-29 13:55:27.437248	2025-04-29 14:28:14.665611
216	Annual Leave	66	2025-04-30 08:00:00	2025-05-06 16:30:00	89	45	t	45	t	31	2025-04-28 06:37:52.273391	2025-05-02 17:49:04.775279
213	Annual Leave	40	2025-04-28 08:00:00	2025-05-02 16:30:00	103	33	t	33	t	31	2025-04-25 08:17:46.248519	2025-05-06 07:20:35.656003
226	Annual Leave	48	2025-05-06 13:00:00	2025-05-06 16:30:00	2	\N	\N	\N	\N	30	2025-05-06 08:51:12.843108	2025-05-06 08:51:12.843108
225	Annual Leave	33	2025-05-09 08:00:00	2025-05-14 16:31:00	8	11	t	11	t	31	2025-05-06 07:18:11.487872	2025-05-06 13:15:38.962276
224	Annual Leave	43	2025-05-02 08:00:00	2025-05-02 16:30:00	28	28	t	28	t	31	2025-04-30 13:52:49.092803	2025-05-07 13:03:51.544582
188	Annual Leave	73	2025-04-17 08:00:00	2025-04-17 16:30:00	62	39	t	39	t	34	2025-04-16 06:53:34.978369	2025-07-30 12:41:00.703958
219	Annual Leave	42	2025-05-05 08:00:00	2025-05-05 16:30:00	31	28	t	28	t	31	2025-04-29 11:57:47.854674	2025-05-07 13:04:01.198333
223	Annual Leave	87	2025-05-02 08:00:00	2025-05-02 16:30:00	8	\N	\N	\N	\N	33	2025-04-30 11:31:14.893965	2025-05-07 14:13:45.977437
227	Annual Leave	36	2025-05-09 08:00:00	2025-05-09 16:30:00	28	28	t	28	t	31	2025-05-08 07:56:23.015984	2025-05-09 09:27:42.602672
222	Annual Leave	27	2025-05-15 08:00:00	2025-05-20 16:30:00	99	8	t	8	t	31	2025-04-30 07:52:42.772506	2025-05-12 09:16:10.088766
217	Annual Leave	61	2025-05-02 13:00:00	2025-05-02 16:30:00	78	6	t	6	t	31	2025-04-28 13:16:23.641634	2025-05-16 06:50:00.14653
144	Compassionate Leave	32	2025-03-04 08:00:00	2025-03-04 16:30:00	2	6	t	6	t	31	2025-03-09 12:14:35.485012	2025-05-16 07:09:21.422661
137	Annual Leave	77	2025-02-26 08:00:00	2025-02-26 16:30:00	90	6	t	6	t	31	2025-02-27 13:32:05.567	2025-05-16 07:09:54.282325
229	Annual Leave	60	2025-05-19 08:00:00	2025-05-13 16:30:00	97	\N	\N	\N	\N	33	2025-05-16 11:37:35.609117	2025-05-16 16:44:10.361079
230	Annual Leave	32	2025-05-15 08:00:00	2025-05-16 16:30:00	2	\N	\N	\N	\N	30	2025-05-19 07:28:29.389818	2025-05-19 07:28:29.389818
232	Annual Leave	80	2025-05-15 08:00:00	2025-05-16 16:30:00	28	28	t	28	t	31	2025-05-19 14:31:06.924208	2025-05-19 14:41:55.346924
233	Annual Leave	36	2025-05-19 12:00:00	2025-05-20 16:30:00	28	28	t	28	t	31	2025-05-19 14:42:13.585407	2025-05-19 14:51:58.246921
228	Annual Leave	9	2025-05-22 08:30:00	2025-05-23 16:30:00	27	8	t	8	t	31	2025-05-15 13:04:01.496065	2025-05-20 07:45:51.42004
237	Annual Leave	75	2025-05-23 08:00:00	2025-05-23 16:30:00	39	\N	\N	\N	\N	30	2025-05-22 11:42:50.481802	2025-05-22 11:42:50.481802
236	Annual Leave	43	2025-05-23 08:00:00	2025-05-23 11:59:00	6	28	t	28	t	31	2025-05-22 08:15:03.942363	2025-05-22 16:14:12.617104
239	Annual Leave	114	2025-05-26 08:00:00	2025-05-27 16:30:00	2	\N	\N	\N	\N	30	2025-05-25 06:30:38.961226	2025-05-25 06:30:38.961226
234	Paternity Leave	84	2025-05-20 08:00:00	2025-05-26 16:30:00	96	96	t	96	t	31	2025-05-20 14:53:20.911424	2025-05-26 09:27:04.3677
240	Annual Leave	84	2025-05-27 08:00:00	2025-06-06 16:30:00	96	96	t	96	t	31	2025-05-25 13:09:12.001048	2025-05-26 09:27:15.792751
241	Annual Leave	8	2025-05-29 06:05:00	2025-06-02 06:05:00	33	11	t	11	t	31	2025-05-26 06:34:11.969967	2025-05-26 09:31:21.793182
231	Annual Leave	6	2025-05-29 08:00:00	2025-05-29 16:30:00	2	11	t	11	t	31	2025-05-19 14:23:56.931741	2025-05-26 09:31:35.828498
221	Annual Leave	96	2025-04-30 14:40:00	2025-05-04 14:40:00	74	11	t	11	t	31	2025-04-29 14:42:22.10156	2025-05-26 09:31:59.279598
210	Annual Leave	33	2025-04-28 08:00:00	2025-04-30 16:30:00	87	11	t	11	t	31	2025-04-24 09:11:03.516612	2025-05-26 09:32:19.342354
243	Compassionate Leave	113	2025-05-29 08:00:00	2025-05-29 16:30:00	2	\N	\N	\N	\N	30	2025-05-26 14:01:08.542359	2025-05-26 14:01:08.542359
242	Annual Leave	58	2025-05-30 08:00:00	2025-05-30 16:30:00	9	8	t	8	t	31	2025-05-26 08:00:20.252792	2025-05-27 12:02:50.074496
245	Annual Leave	103	2025-05-28 09:04:00	2025-05-28 09:04:00	2	\N	\N	\N	\N	33	2025-05-28 09:04:45.946923	2025-05-28 09:05:12.549813
235	Annual Leave	98	2025-05-22 08:00:00	2025-05-23 17:00:00	40	33	t	33	t	31	2025-05-21 07:34:49.337789	2025-05-28 12:48:59.558623
238	Annual Leave	103	2025-05-26 08:00:00	2025-05-27 16:30:00	40	33	t	33	t	31	2025-05-23 09:33:51.595144	2025-05-28 12:49:18.642978
251	Annual Leave	45	2025-05-30 00:00:00	2025-06-06 16:30:00	83	\N	\N	\N	\N	30	2025-05-30 06:26:28.78299	2025-05-30 06:26:28.78299
247	Annual Leave	24	2025-05-26 08:00:00	2025-05-26 16:30:00	55	8	t	8	t	31	2025-05-28 13:35:26.191544	2025-06-03 12:43:54.968959
248	Annual Leave	24	2025-05-30 08:00:00	2025-05-30 16:30:00	55	8	t	8	t	31	2025-05-28 13:36:40.555143	2025-06-03 12:44:10.832738
249	Annual Leave	24	2025-06-02 08:00:00	2025-06-02 16:30:00	2	8	t	8	t	31	2025-05-28 13:38:12.809245	2025-06-03 12:44:36.759182
246	Annual Leave	97	2025-05-30 08:00:00	2025-05-30 16:30:00	99	8	t	8	t	31	2025-05-28 13:00:48.417361	2025-06-03 12:45:17.505599
254	Annual Leave	60	2025-06-06 08:00:00	2025-06-06 16:30:00	97	8	t	8	t	31	2025-06-02 06:52:22.882906	2025-06-03 12:45:38.901814
244	Annual Leave	87	2025-05-30 08:00:00	2025-06-03 16:30:00	33	11	t	11	t	31	2025-05-27 12:13:51.914527	2025-06-04 07:10:26.56156
256	Annual Leave	73	2025-06-06 08:00:00	2025-06-09 16:30:00	2	\N	\N	\N	\N	33	2025-06-04 13:49:08.976316	2025-06-04 13:49:42.683855
253	Annual Leave	107	2025-05-30 14:23:00	2025-05-30 14:23:00	2	\N	\N	\N	\N	33	2025-05-30 14:23:41.554663	2025-06-05 08:47:03.985922
259	Sick Leave	36	2025-06-04 08:00:00	2025-06-05 16:30:00	28	28	t	28	t	31	2025-06-05 04:29:52.238072	2025-06-05 13:25:06.990138
252	Annual Leave	107	2025-06-02 08:00:00	2025-06-03 16:30:00	80	28	t	28	t	31	2025-05-30 11:46:14.606939	2025-06-06 06:14:56.948464
255	Annual Leave	28	2025-05-22 08:30:00	2025-05-30 16:30:00	6	11	t	11	t	31	2025-06-02 06:59:52.768023	2025-06-06 06:34:02.035256
257	Annual Leave	56	2025-06-09 08:00:00	2025-06-27 16:30:00	97	8	t	8	t	31	2025-06-04 14:16:41.953031	2025-06-06 06:39:57.366885
260	Annual Leave	107	2025-06-06 06:32:00	2025-06-06 06:32:00	2	28	t	28	t	31	2025-06-06 06:32:29.863874	2025-06-06 07:27:17.681645
261	Annual Leave	62	2025-06-06 07:29:00	2025-06-06 07:29:00	2	\N	\N	\N	\N	30	2025-06-06 07:29:52.494514	2025-06-06 07:29:52.494514
262	Compassionate Leave	105	2025-06-09 08:00:00	2025-06-09 16:30:00	83	\N	\N	\N	\N	30	2025-06-06 07:55:38.11647	2025-06-06 07:55:38.11647
263	Compassionate Leave	105	2025-06-10 08:00:00	2025-06-10 08:00:00	83	\N	\N	\N	\N	33	2025-06-09 06:04:00.643042	2025-06-09 06:04:18.845601
250	Annual Leave	89	2025-05-29 08:00:00	2025-05-29 16:30:00	45	45	t	45	t	31	2025-05-29 09:48:54.497616	2025-06-10 14:55:38.310649
264	Compassionate Leave	105	2025-06-10 08:00:00	2025-06-10 16:30:00	83	45	t	45	t	31	2025-06-09 06:06:13.507697	2025-06-13 06:03:34.440638
265	Annual Leave	66	2025-06-13 14:00:00	2025-06-13 16:30:00	89	45	t	45	t	31	2025-06-13 08:21:01.647688	2025-06-13 10:06:25.016735
266	Annual Leave	106	2025-06-16 08:00:00	2025-06-16 16:30:00	105	45	t	45	t	31	2025-06-13 14:20:53.322407	2025-06-16 06:51:21.059434
267	Annual Leave	71	2025-06-20 08:00:00	2025-06-20 16:30:00	31	28	t	28	t	31	2025-06-16 08:06:14.216705	2025-06-18 10:34:00.023753
273	Annual Leave	95	2025-06-23 08:00:00	2025-06-23 16:30:00	75	\N	\N	\N	\N	30	2025-06-20 08:22:09.808128	2025-06-20 08:22:09.808128
268	Annual Leave	66	2025-06-20 08:00:00	2025-06-20 16:30:00	89	45	t	45	t	31	2025-06-17 11:58:32.200284	2025-06-20 09:43:08.503728
218	Annual Leave	78	2025-05-05 08:00:00	2025-05-09 16:30:00	2	6	t	6	t	31	2025-04-29 09:56:26.358279	2025-06-20 10:13:22.361463
274	Annual Leave	39	2025-06-20 13:00:00	2025-06-27 16:30:00	75	100	t	100	t	31	2025-06-20 10:01:40.5708	2025-06-20 10:22:15.344633
276	Annual Leave	39	2025-06-24 08:00:00	2025-06-24 12:00:00	75	100	t	100	t	31	2025-06-20 10:06:00.801183	2025-06-20 10:22:36.514827
270	Annual Leave	109	2025-06-20 08:00:00	2025-06-20 16:30:00	110	28	t	28	t	31	2025-06-19 16:54:36.972527	2025-06-20 11:42:07.515187
271	Annual Leave	36	2025-06-20 08:00:00	2025-06-20 16:30:00	28	28	t	28	t	31	2025-06-20 05:17:51.412513	2025-06-20 11:42:19.114197
272	Annual Leave	104	2025-06-20 13:00:00	2025-06-20 16:30:00	28	28	t	28	t	31	2025-06-20 07:34:07.916519	2025-06-20 11:42:57.882872
269	Annual Leave	60	2025-06-20 08:00:00	2025-06-20 16:30:00	97	8	t	8	t	31	2025-06-19 11:17:46.559045	2025-06-20 13:09:19.5776
279	Annual Leave	62	2025-07-03 08:00:00	2025-07-08 16:30:00	75	\N	\N	\N	\N	30	2025-06-23 07:00:32.555335	2025-06-23 07:00:32.555335
280	Annual Leave	31	2025-06-27 08:00:00	2025-06-27 04:30:00	70	\N	\N	\N	\N	33	2025-06-23 11:48:34.90088	2025-06-23 12:01:15.206641
281	Annual Leave	31	2025-06-27 08:00:00	2025-06-27 16:30:00	70	28	t	28	t	31	2025-06-23 12:03:10.107955	2025-06-23 12:04:44.267126
278	Annual Leave	107	2025-06-20 14:44:00	2025-06-20 14:44:00	2	28	t	28	t	31	2025-06-20 14:45:04.296534	2025-07-03 07:47:52.778847
277	Study Leave	80	2025-06-23 08:00:00	2025-06-27 16:30:00	28	28	t	28	t	31	2025-06-20 12:01:24.287477	2025-07-14 07:52:03.521053
275	Annual Leave	80	2025-06-20 12:00:00	2025-06-20 16:30:00	2	28	t	28	t	31	2025-06-20 10:06:00.485827	2025-07-14 07:52:12.225111
282	Annual Leave	108	2025-07-28 09:09:00	2025-07-28 09:09:00	2	28	t	28	t	31	2025-07-28 07:09:38.595874	2025-07-28 07:10:38.064945
96	Annual Leave	65	2024-12-13 08:00:00	2024-12-16 11:00:00	73	39	t	39	t	34	2024-12-16 06:03:02.976698	2025-07-30 12:40:18.54392
190	Annual Leave	73	2025-04-22 08:00:00	2025-04-22 16:30:00	62	39	t	39	t	34	2025-04-16 06:57:56.419949	2025-07-30 12:40:33.830958
258	Annual Leave	7	2025-06-06 08:00:00	2025-09-06 16:30:00	62	39	t	39	t	34	2025-06-04 19:55:55.408149	2025-07-30 12:40:47.886884
\.


--
-- Data for Name: leave_summaries; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.leave_summaries (leave_summary_id, leave_type, employee_id, leave_days_total, leave_days_balance, financial_year, created_at, updated_at) FROM stdin;
9	Annual Leave	12	0	0	2023	2024-03-08 13:04:46.037098	2024-03-08 13:04:46.037098
11	Annual Leave	5	0	0	2023	2024-03-08 13:04:46.050162	2024-03-08 13:04:46.050162
12	Annual Leave	5	0	0	2024	2024-03-08 13:04:46.054736	2024-03-08 13:04:46.054736
13	Annual Leave	19	0	0	2023	2024-03-08 13:04:46.061214	2024-03-08 13:04:46.061214
14	Annual Leave	19	0	0	2024	2024-03-08 13:04:46.065226	2024-03-08 13:04:46.065226
15	Annual Leave	3	0	0	2023	2024-03-08 13:04:46.071565	2024-03-08 13:04:46.071565
16	Annual Leave	3	0	0	2024	2024-03-08 13:04:46.087107	2024-03-08 13:04:46.087107
17	Annual Leave	11	0	0	2023	2024-03-08 13:04:46.095226	2024-03-08 13:04:46.095226
19	Annual Leave	39	0	0	2023	2024-03-08 13:04:46.105351	2024-03-08 13:04:46.105351
21	Annual Leave	8	0	0	2023	2024-03-08 13:04:46.115807	2024-03-08 13:04:46.115807
23	Annual Leave	33	0	0	2023	2024-03-08 13:04:46.144008	2024-03-08 13:04:46.144008
25	Annual Leave	27	0	0	2023	2024-03-08 13:04:46.154925	2024-03-08 13:04:46.154925
27	Annual Leave	24	0	0	2023	2024-03-08 13:04:46.166409	2024-03-08 13:04:46.166409
29	Annual Leave	40	0	0	2023	2024-03-08 13:04:46.177367	2024-03-08 13:04:46.177367
31	Annual Leave	9	0	0	2023	2024-03-08 13:04:46.189892	2024-03-08 13:04:46.189892
33	Annual Leave	35	0	0	2023	2024-03-08 13:04:46.200046	2024-03-08 13:04:46.200046
35	Annual Leave	34	0	0	2023	2024-03-08 13:04:46.209525	2024-03-08 13:04:46.209525
37	Annual Leave	1	0	0	2023	2024-03-08 13:04:46.234276	2024-03-08 13:04:46.234276
38	Annual Leave	1	0	0	2024	2024-03-08 13:04:46.238904	2024-03-08 13:04:46.238904
39	Annual Leave	2	0	0	2023	2024-03-08 13:04:46.245663	2024-03-08 13:04:46.245663
41	Annual Leave	37	0	0	2023	2024-03-08 13:04:46.255714	2024-03-08 13:04:46.255714
43	Annual Leave	6	0	0	2023	2024-03-08 13:04:46.265995	2024-03-08 13:04:46.265995
45	Annual Leave	29	0	0	2023	2024-03-08 13:04:46.277696	2024-03-08 13:04:46.277696
47	Annual Leave	28	0	0	2023	2024-03-08 13:04:46.288176	2024-03-08 13:04:46.288176
49	Annual Leave	7	0	0	2023	2024-03-08 13:04:46.297912	2024-03-08 13:04:46.297912
51	Annual Leave	22	0	0	2023	2024-03-08 13:04:46.307414	2024-03-08 13:04:46.307414
53	Annual Leave	31	0	0	2023	2024-03-08 13:04:46.316713	2024-03-08 13:04:46.316713
55	Annual Leave	20	0	0	2023	2024-03-08 13:04:46.34036	2024-03-08 13:04:46.34036
57	Annual Leave	32	0	0	2023	2024-03-08 13:04:46.350224	2024-03-08 13:04:46.350224
59	Annual Leave	41	0	0	2023	2024-03-08 13:04:46.361717	2024-03-08 13:04:46.361717
61	Annual Leave	25	0	0	2023	2024-03-08 13:04:46.374778	2024-03-08 13:04:46.374778
62	Annual Leave	25	0	0	2024	2024-03-08 13:04:46.379705	2024-03-08 13:04:46.379705
63	Annual Leave	16	0	0	2023	2024-03-08 13:04:46.387205	2024-03-08 13:04:46.387205
64	Annual Leave	16	0	0	2024	2024-03-08 13:04:46.391571	2024-03-08 13:04:46.391571
65	Annual Leave	38	0	0	2023	2024-03-08 13:04:46.39769	2024-03-08 13:04:46.39769
67	Annual Leave	36	0	0	2023	2024-03-08 13:04:46.407391	2024-03-08 13:04:46.407391
69	Annual Leave	43	0	0	2023	2024-03-08 13:04:46.416773	2024-03-08 13:04:46.416773
71	Annual Leave	14	0	0	2023	2024-03-08 13:04:46.444351	2024-03-08 13:04:46.444351
72	Annual Leave	14	0	0	2024	2024-03-08 13:04:46.448792	2024-03-08 13:04:46.448792
73	Annual Leave	10	0	0	2023	2024-03-08 13:04:46.458851	2024-03-08 13:04:46.458851
75	Annual Leave	42	0	0	2023	2024-03-08 13:04:46.47431	2024-03-08 13:04:46.47431
77	Annual Leave	26	0	0	2023	2024-03-08 13:04:46.487627	2024-03-08 13:04:46.487627
79	Annual Leave	48	0	0	2023	2024-03-08 13:04:46.499135	2024-03-08 13:04:46.499135
81	Annual Leave	21	0	0	2023	2024-03-08 13:04:46.510222	2024-03-08 13:04:46.510222
82	Annual Leave	21	0	0	2024	2024-03-08 13:04:46.514191	2024-03-08 13:04:46.514191
83	Annual Leave	44	0	0	2023	2024-03-08 13:04:46.53453	2024-03-08 13:04:46.53453
85	Annual Leave	13	0	0	2023	2024-03-08 13:04:46.544789	2024-03-08 13:04:46.544789
86	Annual Leave	13	0	0	2024	2024-03-08 13:04:46.548208	2024-03-08 13:04:46.548208
87	Annual Leave	18	0	0	2023	2024-03-08 13:04:46.556376	2024-03-08 13:04:46.556376
88	Annual Leave	18	0	0	2024	2024-03-08 13:04:46.560277	2024-03-08 13:04:46.560277
89	Annual Leave	47	0	0	2023	2024-03-08 13:04:46.567948	2024-03-08 13:04:46.567948
74	Annual Leave	10	0	0	2024	2024-03-08 13:04:46.464979	2024-08-28 06:41:52.991372
10	Annual Leave	12	0	0	2024	2024-03-08 13:04:46.043108	2024-08-28 06:41:53.002419
56	Annual Leave	20	0	0	2024	2024-03-08 13:04:46.34409	2024-07-01 14:29:31.29742
78	Annual Leave	26	0	0	2024	2024-03-08 13:04:46.492546	2025-01-22 13:57:10.144457
48	Annual Leave	28	0	0	2024	2024-03-08 13:04:46.292032	2025-01-22 13:57:10.322973
46	Annual Leave	29	0	0	2024	2024-03-08 13:04:46.28233	2025-01-22 13:57:10.346848
24	Annual Leave	33	0	0	2024	2024-03-08 13:04:46.14832	2025-01-22 13:57:10.455019
54	Annual Leave	31	0	0	2024	2024-03-08 13:04:46.334151	2025-01-22 13:57:10.368337
58	Annual Leave	32	0	0	2024	2024-03-08 13:04:46.353867	2025-01-22 13:57:10.393961
42	Annual Leave	37	0	0	2024	2024-03-08 13:04:46.259384	2024-08-28 06:41:53.394301
68	Annual Leave	36	0	0	2024	2024-03-08 13:04:46.4111	2025-01-22 13:57:10.515656
30	Annual Leave	40	0	0	2024	2024-03-08 13:04:46.182862	2024-08-28 06:41:53.405143
66	Annual Leave	38	0	0	2024	2024-03-08 13:04:46.401846	2025-01-22 13:57:10.622329
18	Annual Leave	11	0	0	2024	2024-03-08 13:04:46.099719	2025-01-22 13:57:10.756247
50	Annual Leave	7	0	0	2024	2024-03-08 13:04:46.301849	2025-01-22 13:57:09.797277
36	Annual Leave	34	0	0	2024	2024-03-08 13:04:46.213075	2024-03-08 13:04:47.71063
76	Annual Leave	42	0	0	2024	2024-03-08 13:04:46.479668	2025-01-22 13:57:10.900074
26	Annual Leave	27	0	0	2024	2024-03-08 13:04:46.159264	2025-01-22 13:57:10.213345
80	Annual Leave	48	0	0	2024	2024-03-08 13:04:46.503951	2025-01-22 13:57:09.68395
52	Annual Leave	22	0	0	2024	2024-03-08 13:04:46.311223	2025-01-22 13:57:10.076697
32	Annual Leave	9	0	0	2024	2024-03-08 13:04:46.194241	2025-01-22 13:57:09.898155
84	Annual Leave	44	0	0	2024	2024-03-08 13:04:46.538525	2025-01-22 13:57:09.983437
22	Annual Leave	8	0	0	2024	2024-03-08 13:04:46.13669	2025-01-22 13:57:09.878896
60	Annual Leave	41	0	0	2024	2024-03-08 13:04:46.366089	2025-01-22 13:57:10.802182
20	Annual Leave	39	0	0	2024	2024-03-08 13:04:46.109535	2025-01-22 13:57:10.646868
28	Annual Leave	24	0	0	2024	2024-03-08 13:04:46.170839	2025-01-22 13:57:10.120588
70	Annual Leave	43	0	0	2024	2024-03-08 13:04:46.436739	2025-01-22 13:57:10.923877
44	Annual Leave	6	0	0	2024	2024-03-08 13:04:46.269663	2025-01-22 13:57:09.774189
90	Annual Leave	47	0	0	2024	2024-03-08 13:04:46.572812	2024-03-08 13:04:46.572812
91	Annual Leave	50	0	0	2023	2024-03-08 13:04:46.579432	2024-03-08 13:04:46.579432
93	Annual Leave	49	0	0	2023	2024-03-08 13:04:46.590614	2024-03-08 13:04:46.590614
95	Annual Leave	51	0	0	2023	2024-03-08 13:04:46.601137	2024-03-08 13:04:46.601137
97	Annual Leave	53	0	0	2023	2024-03-08 13:04:46.611605	2024-03-08 13:04:46.611605
99	Annual Leave	54	0	0	2023	2024-03-08 13:04:46.637172	2024-03-08 13:04:46.637172
101	Annual Leave	52	0	0	2023	2024-03-08 13:04:46.649875	2024-03-08 13:04:46.649875
1270	Sick Leave	107	0	0	2025	2025-04-01 05:07:44.763421	2025-04-01 05:07:44.763421
103	Annual Leave	45	0	0	2023	2024-03-08 13:04:46.661375	2024-03-08 13:04:46.661375
105	Compassionate Leave	2	0	0	2024	2024-03-08 13:04:46.712288	2024-03-08 13:04:46.712288
107	Compassionate Leave	6	0	0	2024	2024-03-08 13:04:46.745449	2024-03-08 13:04:46.745449
108	Sick Leave	6	0	0	2024	2024-03-08 13:04:46.750653	2024-03-08 13:04:46.750653
109	Compassionate Leave	7	0	0	2024	2024-03-08 13:04:46.76335	2024-03-08 13:04:46.76335
110	Sick Leave	7	0	0	2024	2024-03-08 13:04:46.768713	2024-03-08 13:04:46.768713
111	Compassionate Leave	8	0	0	2024	2024-03-08 13:04:46.789348	2024-03-08 13:04:46.789348
113	Compassionate Leave	9	0	0	2024	2024-03-08 13:04:46.804807	2024-03-08 13:04:46.804807
114	Sick Leave	9	0	0	2024	2024-03-08 13:04:46.808546	2024-03-08 13:04:46.808546
115	Compassionate Leave	10	0	0	2024	2024-03-08 13:04:46.834515	2024-03-08 13:04:46.834515
116	Sick Leave	10	0	0	2024	2024-03-08 13:04:46.840283	2024-03-08 13:04:46.840283
117	Compassionate Leave	11	0	0	2024	2024-03-08 13:04:46.853432	2024-03-08 13:04:46.853432
118	Sick Leave	11	0	0	2024	2024-03-08 13:04:46.858884	2024-03-08 13:04:46.858884
121	Compassionate Leave	20	0	0	2024	2024-03-08 13:04:46.894212	2024-03-08 13:04:46.894212
122	Sick Leave	20	0	0	2024	2024-03-08 13:04:46.899421	2024-03-08 13:04:46.899421
123	Compassionate Leave	22	0	0	2024	2024-03-08 13:04:46.910297	2024-03-08 13:04:46.910297
124	Sick Leave	22	0	0	2024	2024-03-08 13:04:46.914476	2024-03-08 13:04:46.914476
125	Compassionate Leave	24	0	0	2024	2024-03-08 13:04:46.936392	2024-03-08 13:04:46.936392
127	Compassionate Leave	26	0	0	2024	2024-03-08 13:04:46.950806	2024-03-08 13:04:46.950806
129	Compassionate Leave	27	0	0	2024	2024-03-08 13:04:46.964542	2024-03-08 13:04:46.964542
131	Compassionate Leave	28	0	0	2024	2024-03-08 13:04:46.979907	2024-03-08 13:04:46.979907
132	Sick Leave	28	0	0	2024	2024-03-08 13:04:46.983605	2024-03-08 13:04:46.983605
133	Compassionate Leave	29	0	0	2024	2024-03-08 13:04:46.996308	2024-03-08 13:04:46.996308
135	Compassionate Leave	31	0	0	2024	2024-03-08 13:04:47.011272	2024-03-08 13:04:47.011272
136	Sick Leave	31	0	0	2024	2024-03-08 13:04:47.038851	2024-03-08 13:04:47.038851
137	Compassionate Leave	32	0	0	2024	2024-03-08 13:04:47.050438	2024-03-08 13:04:47.050438
139	Compassionate Leave	33	0	0	2024	2024-03-08 13:04:47.065246	2024-03-08 13:04:47.065246
142	Sick Leave	35	0	0	2024	2024-03-08 13:04:47.083976	2024-03-08 13:04:47.083976
143	Compassionate Leave	36	0	0	2024	2024-03-08 13:04:47.095154	2024-03-08 13:04:47.095154
145	Compassionate Leave	37	0	0	2024	2024-03-08 13:04:47.11062	2024-03-08 13:04:47.11062
147	Compassionate Leave	38	0	0	2024	2024-03-08 13:04:47.144927	2024-03-08 13:04:47.144927
149	Compassionate Leave	39	0	0	2024	2024-03-08 13:04:47.160938	2024-03-08 13:04:47.160938
150	Sick Leave	39	0	0	2024	2024-03-08 13:04:47.164856	2024-03-08 13:04:47.164856
151	Compassionate Leave	40	0	0	2024	2024-03-08 13:04:47.177534	2024-03-08 13:04:47.177534
152	Sick Leave	40	0	0	2024	2024-03-08 13:04:47.182412	2024-03-08 13:04:47.182412
154	Sick Leave	41	0	0	2024	2024-03-08 13:04:47.200176	2024-03-08 13:04:47.200176
155	Compassionate Leave	42	0	0	2024	2024-03-08 13:04:47.215113	2024-03-08 13:04:47.215113
156	Sick Leave	42	0	0	2024	2024-03-08 13:04:47.239216	2024-03-08 13:04:47.239216
157	Compassionate Leave	43	0	0	2024	2024-03-08 13:04:47.250838	2024-03-08 13:04:47.250838
160	Sick Leave	44	0	0	2024	2024-03-08 13:04:47.26994	2024-03-08 13:04:47.26994
100	Annual Leave	54	0	0	2024	2024-03-08 13:04:46.64135	2024-08-28 06:41:53.149365
161	Compassionate Leave	45	0	0	2024	2024-03-08 13:04:47.280451	2024-03-08 13:04:47.280451
162	Sick Leave	45	0	0	2024	2024-03-08 13:04:47.284269	2024-03-08 13:04:47.284269
165	Sick Leave	46	0	0	2024	2024-03-08 13:04:47.300046	2024-03-08 13:04:47.760089
164	Compassionate Leave	46	0	0	2024	2024-03-08 13:04:47.296604	2024-03-08 13:04:47.296604
94	Annual Leave	49	0	0	2024	2024-03-08 13:04:46.59451	2024-03-08 13:04:47.30757
166	Compassionate Leave	49	0	0	2024	2024-03-08 13:04:47.310957	2024-03-08 13:04:47.310957
167	Sick Leave	49	0	0	2024	2024-03-08 13:04:47.315369	2024-03-08 13:04:47.315369
112	Sick Leave	8	0	0	2024	2024-03-08 13:04:46.794911	2024-08-28 06:41:53.343027
168	Compassionate Leave	50	0	0	2024	2024-03-08 13:04:47.339623	2024-03-08 13:04:47.339623
34	Annual Leave	35	0	0	2024	2024-03-08 13:04:46.203721	2025-01-22 13:57:10.489458
170	Compassionate Leave	51	0	0	2024	2024-03-08 13:04:47.353586	2024-03-08 13:04:47.353586
171	Sick Leave	51	0	0	2024	2024-03-08 13:04:47.357402	2024-03-08 13:04:47.357402
92	Annual Leave	50	0	0	2024	2024-03-08 13:04:46.584376	2024-07-01 14:29:31.444594
119	Compassionate Leave	12	0	0	2024	2024-03-08 13:04:46.87307	2024-04-22 14:44:49.640793
98	Annual Leave	53	0	0	2024	2024-03-08 13:04:46.614986	2024-08-28 06:41:53.142709
106	Sick Leave	2	0	0	2024	2024-03-08 13:04:46.716545	2024-03-08 13:04:47.582144
120	Sick Leave	12	0	0	2024	2024-03-08 13:04:46.878315	2024-03-08 13:04:47.635173
130	Sick Leave	27	0	0	2024	2024-03-08 13:04:46.968869	2024-03-08 13:04:47.678222
138	Sick Leave	32	0	0	2024	2024-03-08 13:04:47.055049	2024-03-08 13:04:47.701981
163	Annual Leave	46	0	0	2024	2024-03-08 13:04:47.288164	2024-05-03 08:59:45.955978
141	Compassionate Leave	35	0	0	2024	2024-03-08 13:04:47.079623	2024-03-08 13:04:47.718252
144	Sick Leave	36	0	0	2024	2024-03-08 13:04:47.099817	2024-03-08 13:04:47.734606
148	Sick Leave	38	0	0	2024	2024-03-08 13:04:47.149472	2024-08-28 06:41:53.402002
153	Compassionate Leave	41	0	0	2024	2024-03-08 13:04:47.194549	2024-03-08 13:04:47.749402
96	Annual Leave	51	0	0	2024	2024-03-08 13:04:46.605431	2024-08-28 06:41:53.128982
169	Sick Leave	50	0	0	2024	2024-03-08 13:04:47.343721	2024-03-08 13:04:47.766031
146	Sick Leave	37	0	0	2024	2024-03-08 13:04:47.114978	2024-08-28 06:41:53.398446
159	Compassionate Leave	44	0	0	2024	2024-03-08 13:04:47.265996	2024-08-28 06:41:53.412156
158	Sick Leave	43	0	0	2024	2024-03-08 13:04:47.255078	2024-04-22 14:44:49.654652
104	Annual Leave	45	0	0	2024	2024-03-08 13:04:46.66611	2025-01-22 13:57:10.192353
128	Sick Leave	26	0	0	2024	2024-03-08 13:04:46.954876	2024-08-28 06:41:53.359788
134	Sick Leave	29	0	0	2024	2024-03-08 13:04:47.000751	2024-08-28 06:41:53.372924
140	Sick Leave	33	0	0	2024	2024-03-08 13:04:47.069311	2024-08-28 06:41:53.387034
40	Annual Leave	2	0	0	2024	2024-03-08 13:04:46.249637	2025-01-22 13:57:09.631662
172	Compassionate Leave	52	0	0	2024	2024-03-08 13:04:47.368731	2024-03-08 13:04:47.368731
174	Compassionate Leave	53	0	0	2024	2024-03-08 13:04:47.383	2024-03-08 13:04:47.383
176	Compassionate Leave	54	0	0	2024	2024-03-08 13:04:47.39773	2024-03-08 13:04:47.39773
214	Sick Leave	65	0	0	2024	2024-04-22 14:44:49.677055	2024-04-22 14:44:49.679473
179	Compassionate Leave	55	0	0	2024	2024-03-08 13:04:47.436176	2024-03-08 13:04:47.436176
180	Sick Leave	55	0	0	2024	2024-03-08 13:04:47.442114	2024-03-08 13:04:47.442114
197	Sick Leave	66	0	0	2024	2024-03-21 14:10:52.007282	2024-04-22 14:44:49.685357
182	Compassionate Leave	56	0	0	2024	2024-03-08 13:04:47.459024	2024-03-08 13:04:47.459024
183	Sick Leave	56	0	0	2024	2024-03-08 13:04:47.463264	2024-03-08 13:04:47.463264
185	Compassionate Leave	57	0	0	2024	2024-03-08 13:04:47.476602	2024-03-08 13:04:47.476602
215	Sick Leave	69	0	0	2024	2024-04-22 14:44:49.688726	2024-04-22 14:44:49.69177
189	Sick Leave	58	0	0	2024	2024-03-08 13:04:47.500562	2024-03-08 13:04:47.500562
216	Sick Leave	70	0	0	2024	2024-04-24 14:16:40.107961	2024-04-24 14:16:40.107961
191	Compassionate Leave	59	0	0	2024	2024-03-08 13:04:47.515197	2024-03-08 13:04:47.515197
192	Sick Leave	59	0	0	2024	2024-03-08 13:04:47.519772	2024-03-08 13:04:47.519772
193	Study Leave	24	0	0	2024	2024-03-08 13:04:47.662376	2024-03-08 13:04:47.666326
194	Study Leave	27	0	0	2024	2024-03-08 13:04:47.683177	2024-03-08 13:04:47.687687
217	Compassionate Leave	70	0	0	2024	2024-04-24 14:16:40.113012	2024-04-24 14:16:40.113012
177	Sick Leave	54	0	0	2024	2024-03-08 13:04:47.401905	2024-03-08 13:04:47.789074
186	Sick Leave	57	0	0	2024	2024-03-08 13:04:47.480828	2024-03-08 13:04:47.793232
188	Compassionate Leave	58	0	0	2024	2024-03-08 13:04:47.494847	2024-03-08 13:04:47.797308
195	Sick Leave	61	0	0	2024	2024-03-08 13:04:47.800939	2024-03-08 13:04:47.804013
198	Compassionate Leave	66	0	0	2024	2024-03-21 14:10:52.01149	2024-03-21 14:10:52.01149
200	Sick Leave	74	0	0	2024	2024-04-02 13:31:36.233421	2024-04-02 13:31:36.233421
203	Sick Leave	75	0	0	2024	2024-04-03 06:40:09.758581	2024-04-03 06:40:09.758581
204	Compassionate Leave	75	0	0	2024	2024-04-03 06:40:09.768523	2024-04-03 06:40:09.768523
218	Annual Leave	76	0	0	2024	2024-05-03 08:59:46.072014	2025-01-22 13:57:09.751321
222	Compassionate Leave	69	0	0	2024	2024-05-03 08:59:46.134713	2024-05-03 08:59:46.137426
223	Sick Leave	73	0	0	2024	2024-05-09 13:05:29.648364	2024-05-09 13:05:29.648364
224	Compassionate Leave	73	0	0	2024	2024-05-09 13:05:29.652858	2024-05-09 13:05:29.652858
205	Annual Leave	60	0	0	2024	2024-04-22 14:44:49.50961	2025-01-22 13:57:10.234695
126	Sick Leave	24	0	0	2024	2024-03-08 13:04:46.940492	2024-08-28 06:41:53.35237
231	Compassionate Leave	83	0	0	2024	2024-08-11 10:02:32.888236	2024-08-11 10:02:32.888236
208	Annual Leave	65	0	0	2024	2024-04-22 14:44:49.544444	2025-01-22 13:57:10.669958
196	Annual Leave	66	0	0	2024	2024-03-21 14:10:52.000155	2025-01-22 13:57:10.575617
201	Compassionate Leave	74	0	0	2024	2024-04-02 13:31:36.238788	2024-08-28 06:41:53.422064
233	Sick Leave	82	0	0	2024	2024-08-28 06:41:53.424968	2024-08-28 06:41:53.427489
232	Annual Leave	84	0	0	2024	2024-08-28 06:41:53.288799	2025-01-22 13:57:10.168115
173	Sick Leave	52	0	0	2024	2024-03-08 13:04:47.372964	2024-04-22 14:44:49.661292
175	Sick Leave	53	0	0	2024	2024-03-08 13:04:47.387355	2024-04-22 14:44:49.664491
213	Sick Leave	60	0	0	2024	2024-04-22 14:44:49.667882	2024-04-22 14:44:49.670318
234	Compassionate Leave	82	0	0	2024	2024-10-01 11:08:33.626839	2024-10-01 11:08:33.626839
102	Annual Leave	52	0	0	2024	2024-03-08 13:04:46.654187	2024-08-28 06:41:53.135991
199	Annual Leave	74	0	0	2024	2024-04-02 13:31:36.227305	2025-01-22 13:57:10.423566
225	Annual Leave	80	0	0	2024	2024-06-04 06:08:35.198812	2025-01-22 13:57:10.781272
1310	Sick Leave	109	0	0	2025	2025-06-19 16:52:24.681632	2025-06-19 16:52:24.681632
237	Compassionate Leave	62	0	0	2024	2024-10-07 06:54:31.305736	2024-10-07 06:54:31.305736
212	Annual Leave	73	0	0	2024	2024-04-22 14:44:49.580626	2025-01-22 13:57:09.730196
220	Annual Leave	78	0	0	2024	2024-05-03 08:59:46.088827	2025-01-22 13:57:09.819079
184	Annual Leave	57	0	0	2024	2024-03-08 13:04:47.467545	2024-07-01 14:29:31.478114
210	Annual Leave	70	0	0	2024	2024-04-22 14:44:49.564451	2025-01-22 13:57:10.025085
206	Annual Leave	61	0	0	2024	2024-04-22 14:44:49.517701	2025-01-22 13:57:09.839403
221	Annual Leave	79	0	0	2024	2024-05-03 08:59:46.096282	2024-08-28 06:41:53.262185
227	Annual Leave	82	0	0	2024	2024-07-01 14:29:31.619636	2025-01-22 13:57:10.824086
226	Annual Leave	81	0	0	2024	2024-07-01 14:29:31.59025	2024-08-28 06:41:53.272716
190	Annual Leave	59	0	0	2024	2024-03-08 13:04:47.50549	2025-01-22 13:57:10.877882
238	Compassionate Leave	61	0	0	2024	2024-10-11 08:17:29.951255	2024-10-11 08:17:29.951255
235	Compassionate Leave	65	0	0	2024	2024-10-04 13:20:28.969466	2024-10-04 13:20:28.969466
236	Sick Leave	62	0	0	2024	2024-10-07 06:54:31.300905	2024-10-07 06:54:31.300905
229	Study Leave	73	0	0	2024	2024-07-01 14:29:31.660606	2024-07-01 14:29:31.66339
187	Annual Leave	58	0	0	2024	2024-03-08 13:04:47.485538	2025-01-22 13:57:10.965149
211	Annual Leave	71	0	0	2024	2024-04-22 14:44:49.571944	2025-01-22 13:57:10.257674
219	Annual Leave	77	0	0	2024	2024-05-03 08:59:46.081293	2025-01-22 13:57:09.921314
181	Annual Leave	56	0	0	2024	2024-03-08 13:04:47.447623	2025-01-22 13:57:10.715976
209	Annual Leave	69	0	0	2024	2024-04-22 14:44:49.557112	2024-07-01 14:29:31.535941
230	Sick Leave	83	0	0	2024	2024-08-11 10:02:32.883692	2024-08-11 10:02:32.883692
207	Annual Leave	62	0	0	2024	2024-04-22 14:44:49.536458	2025-01-22 13:57:10.693899
239	Sick Leave	84	0	0	2024	2024-10-14 06:24:17.131345	2024-10-14 06:24:17.131345
228	Annual Leave	83	0	0	2024	2024-07-01 14:29:31.627054	2025-01-22 13:57:10.053462
178	Annual Leave	55	0	0	2024	2024-03-08 13:04:47.406974	2025-01-22 13:57:10.280118
240	Compassionate Leave	84	0	0	2024	2024-10-14 06:24:17.135972	2024-10-14 06:24:17.135972
241	Sick Leave	80	0	0	2024	2024-10-18 07:15:23.979535	2024-10-18 07:15:23.979535
242	Compassionate Leave	80	0	0	2024	2024-10-18 07:15:23.984217	2024-10-18 07:15:23.984217
243	Sick Leave	79	0	0	2024	2024-10-18 07:25:16.963372	2024-10-18 07:25:16.963372
244	Compassionate Leave	79	0	0	2024	2024-10-18 07:25:16.968123	2024-10-18 07:25:16.968123
245	Annual Leave	85	0	0	2024	2024-10-22 06:36:00.188469	2024-10-22 06:36:00.188469
246	Sick Leave	85	0	0	2024	2024-10-22 06:36:00.193996	2024-10-22 06:36:00.193996
247	Compassionate Leave	85	0	0	2024	2024-10-22 06:36:00.198089	2024-10-22 06:36:00.198089
248	Sick Leave	76	0	0	2024	2024-10-22 11:08:59.022962	2024-10-22 11:08:59.022962
249	Compassionate Leave	76	0	0	2024	2024-10-22 11:08:59.027773	2024-10-22 11:08:59.027773
250	Compassionate Leave	60	0	0	2024	2024-10-28 14:09:57.339678	2024-10-28 14:09:57.339678
251	Sick Leave	71	0	0	2024	2024-11-11 05:43:14.685992	2024-11-11 05:43:14.685992
252	Compassionate Leave	71	0	0	2024	2024-11-11 05:43:14.692939	2024-11-11 05:43:14.692939
254	Sick Leave	91	0	0	2024	2024-11-25 11:43:43.183229	2024-11-25 11:43:43.183229
255	Compassionate Leave	91	0	0	2024	2024-11-25 11:43:43.1882	2024-11-25 11:43:43.1882
257	Sick Leave	89	0	0	2024	2024-11-29 10:06:58.871069	2024-11-29 10:06:58.871069
258	Compassionate Leave	89	0	0	2024	2024-11-29 10:06:58.875311	2024-11-29 10:06:58.875311
1273	Sick Leave	87	0	0	2025	2025-04-16 07:17:29.703142	2025-04-16 07:17:29.703142
1274	Compassionate Leave	87	0	0	2025	2025-04-16 07:17:29.706904	2025-04-16 07:17:29.706904
1292	Sick Leave	114	0	0	2025	2025-05-22 13:45:04.542844	2025-05-22 13:45:04.542844
1293	Compassionate Leave	114	0	0	2025	2025-05-22 13:45:04.548288	2025-05-22 13:45:04.548288
1272	Annual Leave	87	0	0	2025	2025-04-16 07:17:29.698479	2025-06-05 08:31:21.555219
1291	Annual Leave	114	0	0	2025	2025-05-22 13:45:04.537227	2025-06-05 08:31:21.710389
1311	Compassionate Leave	109	0	0	2025	2025-06-19 16:52:24.686142	2025-06-19 16:52:24.686142
202	Annual Leave	75	0	0	2024	2024-04-03 06:40:09.751819	2025-01-22 13:57:09.707155
256	Annual Leave	89	0	0	2024	2024-11-29 10:06:58.865577	2025-01-22 13:57:10.85222
1276	Sick Leave	106	0	0	2025	2025-04-16 18:49:37.251977	2025-04-16 18:49:37.251977
1277	Compassionate Leave	106	0	0	2025	2025-04-16 18:49:37.255877	2025-04-16 18:49:37.255877
1294	Sick Leave	103	0	0	2025	2025-05-23 09:31:20.676687	2025-05-23 09:31:20.676687
1295	Compassionate Leave	103	0	0	2025	2025-05-23 09:31:20.681206	2025-05-23 09:31:20.681206
1275	Annual Leave	106	0	0	2025	2025-04-16 18:49:37.247072	2025-06-05 08:31:21.658705
1282	Compassionate Leave	10	0	0	2025	2025-04-22 14:10:12.019987	2025-04-22 14:10:12.02246
1283	Sick Leave	40	0	0	2025	2025-04-22 14:10:12.05621	2025-04-22 14:10:12.059913
1297	Sick Leave	113	0	0	2025	2025-05-26 10:02:37.36729	2025-05-26 10:02:37.36729
1298	Compassionate Leave	113	0	0	2025	2025-05-26 10:02:37.376224	2025-05-26 10:02:37.376224
1043	Annual Leave	9	0	0	2025	2025-01-22 14:37:44.476916	2025-06-05 08:31:21.341361
1278	Annual Leave	10	0	0	2025	2025-04-22 14:10:11.676479	2025-06-05 08:31:21.348825
1138	Annual Leave	28	0	0	2025	2025-01-22 14:37:44.795577	2025-06-05 08:31:21.380662
1279	Annual Leave	40	0	0	2025	2025-04-22 14:10:11.752419	2025-06-05 08:31:21.420751
1203	Annual Leave	65	0	0	2025	2025-01-22 14:37:45.047134	2025-06-05 08:31:21.477471
1280	Annual Leave	81	0	0	2025	2025-04-22 14:10:11.871212	2025-06-05 08:31:21.534854
1281	Annual Leave	101	0	0	2025	2025-04-22 14:10:11.95737	2025-06-05 08:31:21.628118
1296	Annual Leave	113	0	0	2025	2025-05-26 10:02:37.362442	2025-06-05 08:31:21.705442
1103	Annual Leave	84	0	0	2025	2025-01-22 14:37:44.67735	2025-06-05 08:31:21.749923
1284	Annual Leave	100	0	0	2025	2025-04-22 14:11:14.379677	2025-06-05 08:31:21.561071
1285	Annual Leave	103	0	0	2025	2025-04-22 14:11:14.455474	2025-06-05 08:31:21.637917
1299	Annual Leave	105	0	0	2025	2025-06-05 08:31:21.647147	2025-06-05 08:31:21.653078
1300	Annual Leave	108	0	0	2025	2025-06-05 08:31:21.667611	2025-06-05 08:31:21.67205
1301	Annual Leave	110	0	0	2025	2025-06-05 08:31:21.680715	2025-06-05 08:31:21.685353
1302	Annual Leave	111	0	0	2025	2025-06-05 08:31:21.68883	2025-06-05 08:31:21.693092
1303	Annual Leave	112	0	0	2025	2025-06-05 08:31:21.696211	2025-06-05 08:31:21.70039
1304	Annual Leave	115	0	0	2025	2025-06-05 08:31:21.713912	2025-06-05 08:31:21.718341
253	Annual Leave	91	0	0	2024	2024-11-25 11:43:43.178302	2025-01-22 13:57:10.600911
1288	Annual Leave	109	0	0	2025	2025-04-22 14:11:53.706067	2025-06-05 08:31:21.67741
1015	Sick Leave	7	0	0	2025	2025-01-22 14:37:44.3795	2025-04-22 14:11:14.501625
1018	Annual Leave	7	0	0	2025	2025-01-22 14:37:44.388601	2025-06-05 08:31:21.323386
1023	Annual Leave	78	0	0	2025	2025-01-22 14:37:44.405894	2025-06-05 08:31:21.524805
1005	Sick Leave	76	0	0	2025	2025-01-22 14:37:44.335702	2025-04-22 14:11:53.894659
1033	Annual Leave	88	0	0	2025	2025-01-22 14:37:44.443287	2025-06-05 08:31:21.565008
988	Annual Leave	94	0	0	2025	2025-01-22 14:37:44.256545	2025-06-05 08:31:21.597656
1038	Annual Leave	8	0	0	2025	2025-01-22 14:37:44.459222	2025-06-05 08:31:21.332607
980	Sick Leave	2	0	0	2025	2025-01-22 14:37:44.216569	2025-04-22 14:10:11.999974
1020	Sick Leave	78	0	0	2025	2025-01-22 14:37:44.396071	2025-04-22 14:11:53.901734
1035	Sick Leave	8	0	0	2025	2025-01-22 14:37:44.451034	2025-04-22 14:10:12.009936
1040	Sick Leave	9	0	0	2025	2025-01-22 14:37:44.468379	2025-04-22 14:10:12.016637
993	Annual Leave	48	0	0	2025	2025-01-22 14:37:44.279557	2025-04-22 14:11:53.797356
1286	Annual Leave	102	0	0	2025	2025-04-22 14:11:53.675769	2025-06-05 08:31:21.632871
1271	Compassionate Leave	107	0	0	2025	2025-04-01 05:07:44.767438	2025-04-22 14:11:53.930286
1028	Annual Leave	61	0	0	2025	2025-01-22 14:37:44.42367	2025-06-05 08:31:21.465647
1287	Annual Leave	104	0	0	2025	2025-04-22 14:11:53.688082	2025-06-05 08:31:21.64358
979	Study Leave	2	0	0	2025	2025-01-22 14:37:44.209631	2025-01-22 14:37:44.209631
981	Compassionate Leave	2	0	0	2025	2025-01-22 14:37:44.222184	2025-01-22 14:37:44.222184
982	Paternity Leave	2	0	0	2025	2025-01-22 14:37:44.226902	2025-01-22 14:37:44.226902
984	Study Leave	94	0	0	2025	2025-01-22 14:37:44.239154	2025-01-22 14:37:44.239154
986	Compassionate Leave	94	0	0	2025	2025-01-22 14:37:44.248414	2025-01-22 14:37:44.248414
987	Paternity Leave	94	0	0	2025	2025-01-22 14:37:44.252384	2025-01-22 14:37:44.252384
989	Study Leave	48	0	0	2025	2025-01-22 14:37:44.263224	2025-01-22 14:37:44.263224
990	Sick Leave	48	0	0	2025	2025-01-22 14:37:44.267291	2025-01-22 14:37:44.267291
991	Compassionate Leave	48	0	0	2025	2025-01-22 14:37:44.271326	2025-01-22 14:37:44.271326
992	Paternity Leave	48	0	0	2025	2025-01-22 14:37:44.275433	2025-01-22 14:37:44.275433
994	Study Leave	75	0	0	2025	2025-01-22 14:37:44.286269	2025-01-22 14:37:44.286269
995	Sick Leave	75	0	0	2025	2025-01-22 14:37:44.289799	2025-01-22 14:37:44.289799
996	Compassionate Leave	75	0	0	2025	2025-01-22 14:37:44.293116	2025-01-22 14:37:44.293116
997	Paternity Leave	75	0	0	2025	2025-01-22 14:37:44.295854	2025-01-22 14:37:44.295854
999	Study Leave	73	0	0	2025	2025-01-22 14:37:44.303724	2025-01-22 14:37:44.303724
1000	Sick Leave	73	0	0	2025	2025-01-22 14:37:44.307343	2025-01-22 14:37:44.307343
1001	Compassionate Leave	73	0	0	2025	2025-01-22 14:37:44.31071	2025-01-22 14:37:44.31071
1002	Paternity Leave	73	0	0	2025	2025-01-22 14:37:44.314066	2025-01-22 14:37:44.314066
1004	Study Leave	76	0	0	2025	2025-01-22 14:37:44.331673	2025-01-22 14:37:44.331673
1006	Compassionate Leave	76	0	0	2025	2025-01-22 14:37:44.340597	2025-01-22 14:37:44.340597
1007	Paternity Leave	76	0	0	2025	2025-01-22 14:37:44.344616	2025-01-22 14:37:44.344616
1009	Study Leave	6	0	0	2025	2025-01-22 14:37:44.357154	2025-01-22 14:37:44.357154
1010	Sick Leave	6	0	0	2025	2025-01-22 14:37:44.360492	2025-01-22 14:37:44.360492
1011	Compassionate Leave	6	0	0	2025	2025-01-22 14:37:44.363987	2025-01-22 14:37:44.363987
1012	Paternity Leave	6	0	0	2025	2025-01-22 14:37:44.367684	2025-01-22 14:37:44.367684
1014	Study Leave	7	0	0	2025	2025-01-22 14:37:44.37625	2025-01-22 14:37:44.37625
1016	Compassionate Leave	7	0	0	2025	2025-01-22 14:37:44.382295	2025-01-22 14:37:44.382295
1017	Paternity Leave	7	0	0	2025	2025-01-22 14:37:44.385846	2025-01-22 14:37:44.385846
1019	Study Leave	78	0	0	2025	2025-01-22 14:37:44.393253	2025-01-22 14:37:44.393253
1021	Compassionate Leave	78	0	0	2025	2025-01-22 14:37:44.39868	2025-01-22 14:37:44.39868
1022	Paternity Leave	78	0	0	2025	2025-01-22 14:37:44.402226	2025-01-22 14:37:44.402226
1024	Study Leave	61	0	0	2025	2025-01-22 14:37:44.411596	2025-01-22 14:37:44.411596
1026	Compassionate Leave	61	0	0	2025	2025-01-22 14:37:44.417144	2025-01-22 14:37:44.417144
1027	Paternity Leave	61	0	0	2025	2025-01-22 14:37:44.419627	2025-01-22 14:37:44.419627
1029	Study Leave	88	0	0	2025	2025-01-22 14:37:44.428323	2025-01-22 14:37:44.428323
1030	Sick Leave	88	0	0	2025	2025-01-22 14:37:44.432613	2025-01-22 14:37:44.432613
1031	Compassionate Leave	88	0	0	2025	2025-01-22 14:37:44.436591	2025-01-22 14:37:44.436591
1032	Paternity Leave	88	0	0	2025	2025-01-22 14:37:44.439377	2025-01-22 14:37:44.439377
1034	Study Leave	8	0	0	2025	2025-01-22 14:37:44.448378	2025-01-22 14:37:44.448378
1036	Compassionate Leave	8	0	0	2025	2025-01-22 14:37:44.454025	2025-01-22 14:37:44.454025
1037	Paternity Leave	8	0	0	2025	2025-01-22 14:37:44.456528	2025-01-22 14:37:44.456528
1039	Study Leave	9	0	0	2025	2025-01-22 14:37:44.465177	2025-01-22 14:37:44.465177
1041	Compassionate Leave	9	0	0	2025	2025-01-22 14:37:44.471061	2025-01-22 14:37:44.471061
1269	Annual Leave	107	0	0	2025	2025-04-01 05:07:44.757777	2025-06-05 08:31:21.755576
1305	Sick Leave	108	0	0	2025	2025-06-05 08:41:08.180404	2025-06-05 08:41:08.180404
1306	Sick Leave	104	0	0	2025	2025-06-05 08:41:59.866046	2025-06-05 08:41:59.866046
1025	Sick Leave	61	0	0	2025	2025-01-22 14:37:44.414424	2025-04-22 14:11:53.834173
1003	Annual Leave	73	0	0	2025	2025-01-22 14:37:44.324182	2025-06-05 08:31:21.50004
985	Sick Leave	94	0	0	2025	2025-01-22 14:37:44.244294	2025-04-22 14:11:14.679522
1307	Compassionate Leave	104	0	0	2025	2025-06-05 08:41:59.870247	2025-06-05 08:41:59.870247
1289	Compassionate Leave	108	0	0	2025	2025-04-22 14:11:53.933795	2025-04-22 14:11:53.937077
983	Annual Leave	2	0	0	2025	2025-01-22 14:37:44.230706	2025-06-05 08:31:21.308986
1013	Annual Leave	6	0	0	2025	2025-01-22 14:37:44.370899	2025-06-05 08:31:21.316161
998	Annual Leave	75	0	0	2025	2025-01-22 14:37:44.298488	2025-06-05 08:31:21.51011
1008	Annual Leave	76	0	0	2025	2025-01-22 14:37:44.34922	2025-06-05 08:31:21.515116
1042	Paternity Leave	9	0	0	2025	2025-01-22 14:37:44.474121	2025-01-22 14:37:44.474121
1044	Study Leave	77	0	0	2025	2025-01-22 14:37:44.482396	2025-01-22 14:37:44.482396
1046	Compassionate Leave	77	0	0	2025	2025-01-22 14:37:44.487695	2025-01-22 14:37:44.487695
1047	Paternity Leave	77	0	0	2025	2025-01-22 14:37:44.490461	2025-01-22 14:37:44.490461
1049	Study Leave	93	0	0	2025	2025-01-22 14:37:44.498058	2025-01-22 14:37:44.498058
1051	Compassionate Leave	93	0	0	2025	2025-01-22 14:37:44.503533	2025-01-22 14:37:44.503533
1052	Paternity Leave	93	0	0	2025	2025-01-22 14:37:44.506157	2025-01-22 14:37:44.506157
1054	Study Leave	90	0	0	2025	2025-01-22 14:37:44.515487	2025-01-22 14:37:44.515487
1056	Compassionate Leave	90	0	0	2025	2025-01-22 14:37:44.521751	2025-01-22 14:37:44.521751
1057	Paternity Leave	90	0	0	2025	2025-01-22 14:37:44.524719	2025-01-22 14:37:44.524719
1059	Study Leave	44	0	0	2025	2025-01-22 14:37:44.534618	2025-01-22 14:37:44.534618
1060	Sick Leave	44	0	0	2025	2025-01-22 14:37:44.537597	2025-01-22 14:37:44.537597
1061	Compassionate Leave	44	0	0	2025	2025-01-22 14:37:44.540512	2025-01-22 14:37:44.540512
1062	Paternity Leave	44	0	0	2025	2025-01-22 14:37:44.543687	2025-01-22 14:37:44.543687
1063	Annual Leave	44	0	0	2025	2025-01-22 14:37:44.546253	2025-01-22 14:37:44.546253
1064	Study Leave	96	0	0	2025	2025-01-22 14:37:44.55097	2025-01-22 14:37:44.55097
1065	Sick Leave	96	0	0	2025	2025-01-22 14:37:44.553639	2025-01-22 14:37:44.553639
1066	Compassionate Leave	96	0	0	2025	2025-01-22 14:37:44.556176	2025-01-22 14:37:44.556176
1067	Paternity Leave	96	0	0	2025	2025-01-22 14:37:44.55959	2025-01-22 14:37:44.55959
1069	Study Leave	70	0	0	2025	2025-01-22 14:37:44.567421	2025-01-22 14:37:44.567421
1070	Sick Leave	70	0	0	2025	2025-01-22 14:37:44.570499	2025-01-22 14:37:44.570499
1071	Compassionate Leave	70	0	0	2025	2025-01-22 14:37:44.572963	2025-01-22 14:37:44.572963
1072	Paternity Leave	70	0	0	2025	2025-01-22 14:37:44.575819	2025-01-22 14:37:44.575819
1074	Study Leave	83	0	0	2025	2025-01-22 14:37:44.58283	2025-01-22 14:37:44.58283
1076	Compassionate Leave	83	0	0	2025	2025-01-22 14:37:44.588213	2025-01-22 14:37:44.588213
1077	Paternity Leave	83	0	0	2025	2025-01-22 14:37:44.590746	2025-01-22 14:37:44.590746
1079	Study Leave	22	0	0	2025	2025-01-22 14:37:44.600224	2025-01-22 14:37:44.600224
1080	Sick Leave	22	0	0	2025	2025-01-22 14:37:44.603838	2025-01-22 14:37:44.603838
1081	Compassionate Leave	22	0	0	2025	2025-01-22 14:37:44.607175	2025-01-22 14:37:44.607175
1082	Paternity Leave	22	0	0	2025	2025-01-22 14:37:44.609694	2025-01-22 14:37:44.609694
1084	Study Leave	98	0	0	2025	2025-01-22 14:37:44.617506	2025-01-22 14:37:44.617506
1085	Sick Leave	98	0	0	2025	2025-01-22 14:37:44.619923	2025-01-22 14:37:44.619923
1086	Compassionate Leave	98	0	0	2025	2025-01-22 14:37:44.623509	2025-01-22 14:37:44.623509
1087	Paternity Leave	98	0	0	2025	2025-01-22 14:37:44.626614	2025-01-22 14:37:44.626614
1089	Study Leave	24	0	0	2025	2025-01-22 14:37:44.634912	2025-01-22 14:37:44.634912
1091	Compassionate Leave	24	0	0	2025	2025-01-22 14:37:44.640288	2025-01-22 14:37:44.640288
1092	Paternity Leave	24	0	0	2025	2025-01-22 14:37:44.643062	2025-01-22 14:37:44.643062
1094	Study Leave	26	0	0	2025	2025-01-22 14:37:44.650095	2025-01-22 14:37:44.650095
1095	Sick Leave	26	0	0	2025	2025-01-22 14:37:44.65325	2025-01-22 14:37:44.65325
1096	Compassionate Leave	26	0	0	2025	2025-01-22 14:37:44.656326	2025-01-22 14:37:44.656326
1097	Paternity Leave	26	0	0	2025	2025-01-22 14:37:44.659537	2025-01-22 14:37:44.659537
1099	Study Leave	84	0	0	2025	2025-01-22 14:37:44.667033	2025-01-22 14:37:44.667033
1101	Compassionate Leave	84	0	0	2025	2025-01-22 14:37:44.672401	2025-01-22 14:37:44.672401
1102	Paternity Leave	84	0	0	2025	2025-01-22 14:37:44.674865	2025-01-22 14:37:44.674865
1104	Study Leave	45	0	0	2025	2025-01-22 14:37:44.683158	2025-01-22 14:37:44.683158
1105	Sick Leave	45	0	0	2025	2025-01-22 14:37:44.687169	2025-01-22 14:37:44.687169
1106	Compassionate Leave	45	0	0	2025	2025-01-22 14:37:44.69075	2025-01-22 14:37:44.69075
1107	Paternity Leave	45	0	0	2025	2025-01-22 14:37:44.693823	2025-01-22 14:37:44.693823
1109	Study Leave	27	0	0	2025	2025-01-22 14:37:44.701776	2025-01-22 14:37:44.701776
1110	Sick Leave	27	0	0	2025	2025-01-22 14:37:44.704194	2025-01-22 14:37:44.704194
1112	Paternity Leave	27	0	0	2025	2025-01-22 14:37:44.709524	2025-01-22 14:37:44.709524
1114	Study Leave	60	0	0	2025	2025-01-22 14:37:44.717077	2025-01-22 14:37:44.717077
1115	Sick Leave	60	0	0	2025	2025-01-22 14:37:44.720327	2025-01-22 14:37:44.720327
1117	Paternity Leave	60	0	0	2025	2025-01-22 14:37:44.726378	2025-01-22 14:37:44.726378
1119	Study Leave	71	0	0	2025	2025-01-22 14:37:44.734197	2025-01-22 14:37:44.734197
1121	Compassionate Leave	71	0	0	2025	2025-01-22 14:37:44.739717	2025-01-22 14:37:44.739717
1122	Paternity Leave	71	0	0	2025	2025-01-22 14:37:44.742554	2025-01-22 14:37:44.742554
1124	Study Leave	55	0	0	2025	2025-01-22 14:37:44.750457	2025-01-22 14:37:44.750457
1125	Sick Leave	55	0	0	2025	2025-01-22 14:37:44.753568	2025-01-22 14:37:44.753568
1073	Annual Leave	70	0	0	2025	2025-01-22 14:37:44.578111	2025-06-05 08:31:21.489436
1108	Annual Leave	45	0	0	2025	2025-01-22 14:37:44.696797	2025-06-05 08:31:21.440944
1111	Compassionate Leave	27	0	0	2025	2025-01-22 14:37:44.707069	2025-04-22 14:10:12.036134
1116	Compassionate Leave	60	0	0	2025	2025-01-22 14:37:44.723495	2025-04-22 14:11:53.811308
1123	Annual Leave	71	0	0	2025	2025-01-22 14:37:44.745215	2025-06-05 08:31:21.494861
1078	Annual Leave	83	0	0	2025	2025-01-22 14:37:44.595499	2025-06-05 08:31:21.545093
1055	Sick Leave	90	0	0	2025	2025-01-22 14:37:44.518347	2025-04-22 14:11:53.919866
1045	Sick Leave	77	0	0	2025	2025-01-22 14:37:44.485404	2025-04-22 14:11:14.59636
1053	Annual Leave	93	0	0	2025	2025-01-22 14:37:44.510032	2025-06-05 08:31:21.592594
1050	Sick Leave	93	0	0	2025	2025-01-22 14:37:44.500884	2025-04-22 14:11:53.923467
1088	Annual Leave	98	0	0	2025	2025-01-22 14:37:44.629805	2025-06-05 08:31:21.617956
1113	Annual Leave	27	0	0	2025	2025-01-22 14:37:44.712298	2025-06-05 08:31:21.375604
1118	Annual Leave	60	0	0	2025	2025-01-22 14:37:44.729224	2025-06-05 08:31:21.460625
1090	Sick Leave	24	0	0	2025	2025-01-22 14:37:44.637789	2025-04-22 14:10:12.028603
1120	Sick Leave	71	0	0	2025	2025-01-22 14:37:44.73723	2025-04-22 14:11:14.576904
1098	Annual Leave	26	0	0	2025	2025-01-22 14:37:44.662063	2025-06-05 08:31:21.370118
1058	Annual Leave	90	0	0	2025	2025-01-22 14:37:44.528969	2025-06-05 08:31:21.576673
1075	Sick Leave	83	0	0	2025	2025-01-22 14:37:44.585567	2025-04-22 14:11:14.633303
1100	Sick Leave	84	0	0	2025	2025-01-22 14:37:44.669725	2025-04-22 14:11:14.660198
1068	Annual Leave	96	0	0	2025	2025-01-22 14:37:44.562401	2025-06-05 08:31:21.607711
1093	Annual Leave	24	0	0	2025	2025-01-22 14:37:44.64558	2025-06-05 08:31:21.365192
1048	Annual Leave	77	0	0	2025	2025-01-22 14:37:44.492894	2025-06-05 08:31:21.520022
1083	Annual Leave	22	0	0	2025	2025-01-22 14:37:44.612806	2025-06-05 08:31:21.360153
1126	Compassionate Leave	55	0	0	2025	2025-01-22 14:37:44.756478	2025-01-22 14:37:44.756478
1127	Paternity Leave	55	0	0	2025	2025-01-22 14:37:44.759063	2025-01-22 14:37:44.759063
1129	Study Leave	99	0	0	2025	2025-01-22 14:37:44.767321	2025-01-22 14:37:44.767321
1130	Sick Leave	99	0	0	2025	2025-01-22 14:37:44.770686	2025-01-22 14:37:44.770686
1132	Paternity Leave	99	0	0	2025	2025-01-22 14:37:44.776356	2025-01-22 14:37:44.776356
1134	Study Leave	28	0	0	2025	2025-01-22 14:37:44.784631	2025-01-22 14:37:44.784631
1136	Compassionate Leave	28	0	0	2025	2025-01-22 14:37:44.790284	2025-01-22 14:37:44.790284
1137	Paternity Leave	28	0	0	2025	2025-01-22 14:37:44.792859	2025-01-22 14:37:44.792859
1139	Study Leave	29	0	0	2025	2025-01-22 14:37:44.799973	2025-01-22 14:37:44.799973
1140	Sick Leave	29	0	0	2025	2025-01-22 14:37:44.80226	2025-01-22 14:37:44.80226
1141	Compassionate Leave	29	0	0	2025	2025-01-22 14:37:44.805054	2025-01-22 14:37:44.805054
1142	Paternity Leave	29	0	0	2025	2025-01-22 14:37:44.807575	2025-01-22 14:37:44.807575
1143	Annual Leave	29	0	0	2025	2025-01-22 14:37:44.809943	2025-01-22 14:37:44.809943
1144	Study Leave	31	0	0	2025	2025-01-22 14:37:44.815228	2025-01-22 14:37:44.815228
1145	Sick Leave	31	0	0	2025	2025-01-22 14:37:44.818397	2025-01-22 14:37:44.818397
1146	Compassionate Leave	31	0	0	2025	2025-01-22 14:37:44.820875	2025-01-22 14:37:44.820875
1147	Paternity Leave	31	0	0	2025	2025-01-22 14:37:44.823906	2025-01-22 14:37:44.823906
1149	Study Leave	32	0	0	2025	2025-01-22 14:37:44.83123	2025-01-22 14:37:44.83123
1152	Paternity Leave	32	0	0	2025	2025-01-22 14:37:44.838521	2025-01-22 14:37:44.838521
1154	Study Leave	74	0	0	2025	2025-01-22 14:37:44.847699	2025-01-22 14:37:44.847699
1156	Compassionate Leave	74	0	0	2025	2025-01-22 14:37:44.854401	2025-01-22 14:37:44.854401
1157	Paternity Leave	74	0	0	2025	2025-01-22 14:37:44.857023	2025-01-22 14:37:44.857023
1159	Study Leave	33	0	0	2025	2025-01-22 14:37:44.86519	2025-01-22 14:37:44.86519
1160	Sick Leave	33	0	0	2025	2025-01-22 14:37:44.867706	2025-01-22 14:37:44.867706
1161	Compassionate Leave	33	0	0	2025	2025-01-22 14:37:44.87065	2025-01-22 14:37:44.87065
1162	Paternity Leave	33	0	0	2025	2025-01-22 14:37:44.873263	2025-01-22 14:37:44.873263
1164	Study Leave	35	0	0	2025	2025-01-22 14:37:44.881538	2025-01-22 14:37:44.881538
1166	Compassionate Leave	35	0	0	2025	2025-01-22 14:37:44.887924	2025-01-22 14:37:44.887924
1167	Paternity Leave	35	0	0	2025	2025-01-22 14:37:44.892274	2025-01-22 14:37:44.892274
1169	Study Leave	36	0	0	2025	2025-01-22 14:37:44.900314	2025-01-22 14:37:44.900314
1171	Compassionate Leave	36	0	0	2025	2025-01-22 14:37:44.905872	2025-01-22 14:37:44.905872
1172	Paternity Leave	36	0	0	2025	2025-01-22 14:37:44.908847	2025-01-22 14:37:44.908847
1174	Study Leave	95	0	0	2025	2025-01-22 14:37:44.917991	2025-01-22 14:37:44.917991
1175	Sick Leave	95	0	0	2025	2025-01-22 14:37:44.921787	2025-01-22 14:37:44.921787
1176	Compassionate Leave	95	0	0	2025	2025-01-22 14:37:44.926012	2025-01-22 14:37:44.926012
1177	Paternity Leave	95	0	0	2025	2025-01-22 14:37:44.930343	2025-01-22 14:37:44.930343
1179	Study Leave	66	0	0	2025	2025-01-22 14:37:44.940343	2025-01-22 14:37:44.940343
1182	Paternity Leave	66	0	0	2025	2025-01-22 14:37:44.954666	2025-01-22 14:37:44.954666
1184	Study Leave	91	0	0	2025	2025-01-22 14:37:44.966118	2025-01-22 14:37:44.966118
1185	Sick Leave	91	0	0	2025	2025-01-22 14:37:44.969609	2025-01-22 14:37:44.969609
1186	Compassionate Leave	91	0	0	2025	2025-01-22 14:37:44.97415	2025-01-22 14:37:44.97415
1187	Paternity Leave	91	0	0	2025	2025-01-22 14:37:44.978282	2025-01-22 14:37:44.978282
1189	Study Leave	38	0	0	2025	2025-01-22 14:37:44.98939	2025-01-22 14:37:44.98939
1190	Sick Leave	38	0	0	2025	2025-01-22 14:37:44.993239	2025-01-22 14:37:44.993239
1191	Compassionate Leave	38	0	0	2025	2025-01-22 14:37:44.997451	2025-01-22 14:37:44.997451
1192	Paternity Leave	38	0	0	2025	2025-01-22 14:37:45.002285	2025-01-22 14:37:45.002285
1193	Annual Leave	38	0	0	2025	2025-01-22 14:37:45.007901	2025-01-22 14:37:45.007901
1194	Study Leave	39	0	0	2025	2025-01-22 14:37:45.015715	2025-01-22 14:37:45.015715
1195	Sick Leave	39	0	0	2025	2025-01-22 14:37:45.020552	2025-01-22 14:37:45.020552
1196	Compassionate Leave	39	0	0	2025	2025-01-22 14:37:45.024345	2025-01-22 14:37:45.024345
1197	Paternity Leave	39	0	0	2025	2025-01-22 14:37:45.027557	2025-01-22 14:37:45.027557
1199	Study Leave	65	0	0	2025	2025-01-22 14:37:45.034931	2025-01-22 14:37:45.034931
1201	Compassionate Leave	65	0	0	2025	2025-01-22 14:37:45.041778	2025-01-22 14:37:45.041778
1202	Paternity Leave	65	0	0	2025	2025-01-22 14:37:45.044729	2025-01-22 14:37:45.044729
1204	Study Leave	62	0	0	2025	2025-01-22 14:37:45.053662	2025-01-22 14:37:45.053662
1205	Sick Leave	62	0	0	2025	2025-01-22 14:37:45.058301	2025-01-22 14:37:45.058301
1206	Compassionate Leave	62	0	0	2025	2025-01-22 14:37:45.062499	2025-01-22 14:37:45.062499
1207	Paternity Leave	62	0	0	2025	2025-01-22 14:37:45.066172	2025-01-22 14:37:45.066172
1209	Study Leave	56	0	0	2025	2025-01-22 14:37:45.078654	2025-01-22 14:37:45.078654
1170	Sick Leave	36	0	0	2025	2025-01-22 14:37:44.903533	2025-04-22 14:11:53.777055
1150	Sick Leave	32	0	0	2025	2025-01-22 14:37:44.833864	2025-04-22 14:10:12.047009
1198	Annual Leave	39	0	0	2025	2025-01-22 14:37:45.029946	2025-06-05 08:31:21.415931
1158	Annual Leave	74	0	0	2025	2025-01-22 14:37:44.860211	2025-06-05 08:31:21.505037
1181	Compassionate Leave	66	0	0	2025	2025-01-22 14:37:44.950529	2025-04-22 14:11:53.875132
1183	Annual Leave	66	0	0	2025	2025-01-22 14:37:44.959278	2025-06-05 08:31:21.482275
1200	Sick Leave	65	0	0	2025	2025-01-22 14:37:45.037868	2025-04-22 14:11:14.567036
1180	Sick Leave	66	0	0	2025	2025-01-22 14:37:44.945864	2025-04-22 14:11:53.879403
1131	Compassionate Leave	99	0	0	2025	2025-01-22 14:37:44.773723	2025-04-22 14:11:53.926968
1151	Compassionate Leave	32	0	0	2025	2025-01-22 14:37:44.836274	2025-04-22 14:11:53.77
1163	Annual Leave	33	0	0	2025	2025-01-22 14:37:44.876167	2025-06-05 08:31:21.400269
1165	Sick Leave	35	0	0	2025	2025-01-22 14:37:44.884682	2025-04-22 14:11:14.531746
1188	Annual Leave	91	0	0	2025	2025-01-22 14:37:44.982491	2025-06-05 08:31:21.582266
1155	Sick Leave	74	0	0	2025	2025-01-22 14:37:44.850894	2025-04-22 14:11:14.586424
1153	Annual Leave	32	0	0	2025	2025-01-22 14:37:44.842029	2025-06-05 08:31:21.390477
1135	Sick Leave	28	0	0	2025	2025-01-22 14:37:44.787227	2025-04-22 14:11:14.524596
1168	Annual Leave	35	0	0	2025	2025-01-22 14:37:44.895131	2025-06-05 08:31:21.405605
1208	Annual Leave	62	0	0	2025	2025-01-22 14:37:45.071234	2025-06-05 08:31:21.471131
1178	Annual Leave	95	0	0	2025	2025-01-22 14:37:44.933645	2025-06-05 08:31:21.602678
1133	Annual Leave	99	0	0	2025	2025-01-22 14:37:44.779432	2025-06-05 08:31:21.622866
1173	Annual Leave	36	0	0	2025	2025-01-22 14:37:44.911277	2025-06-05 08:31:21.41062
1128	Annual Leave	55	0	0	2025	2025-01-22 14:37:44.76149	2025-06-05 08:31:21.44561
1148	Annual Leave	31	0	0	2025	2025-01-22 14:37:44.826167	2025-06-05 08:31:21.385538
1211	Compassionate Leave	56	0	0	2025	2025-01-22 14:37:45.086624	2025-01-22 14:37:45.086624
1212	Paternity Leave	56	0	0	2025	2025-01-22 14:37:45.090272	2025-01-22 14:37:45.090272
1214	Study Leave	92	0	0	2025	2025-01-22 14:37:45.100478	2025-01-22 14:37:45.100478
1215	Sick Leave	92	0	0	2025	2025-01-22 14:37:45.104883	2025-01-22 14:37:45.104883
1216	Compassionate Leave	92	0	0	2025	2025-01-22 14:37:45.109091	2025-01-22 14:37:45.109091
1217	Paternity Leave	92	0	0	2025	2025-01-22 14:37:45.113254	2025-01-22 14:37:45.113254
1219	Study Leave	11	0	0	2025	2025-01-22 14:37:45.123225	2025-01-22 14:37:45.123225
1220	Sick Leave	11	0	0	2025	2025-01-22 14:37:45.127267	2025-01-22 14:37:45.127267
1221	Compassionate Leave	11	0	0	2025	2025-01-22 14:37:45.130605	2025-01-22 14:37:45.130605
1222	Paternity Leave	11	0	0	2025	2025-01-22 14:37:45.135454	2025-01-22 14:37:45.135454
1226	Compassionate Leave	80	0	0	2025	2025-01-22 14:37:45.153744	2025-01-22 14:37:45.153744
1227	Paternity Leave	80	0	0	2025	2025-01-22 14:37:45.157029	2025-01-22 14:37:45.157029
1229	Study Leave	41	0	0	2025	2025-01-22 14:37:45.168701	2025-01-22 14:37:45.168701
1232	Paternity Leave	41	0	0	2025	2025-01-22 14:37:45.178056	2025-01-22 14:37:45.178056
1234	Study Leave	82	0	0	2025	2025-01-22 14:37:45.18633	2025-01-22 14:37:45.18633
1236	Compassionate Leave	82	0	0	2025	2025-01-22 14:37:45.191595	2025-01-22 14:37:45.191595
1237	Paternity Leave	82	0	0	2025	2025-01-22 14:37:45.193999	2025-01-22 14:37:45.193999
1239	Study Leave	89	0	0	2025	2025-01-22 14:37:45.201692	2025-01-22 14:37:45.201692
1240	Sick Leave	89	0	0	2025	2025-01-22 14:37:45.204489	2025-01-22 14:37:45.204489
1241	Compassionate Leave	89	0	0	2025	2025-01-22 14:37:45.207046	2025-01-22 14:37:45.207046
1242	Paternity Leave	89	0	0	2025	2025-01-22 14:37:45.209759	2025-01-22 14:37:45.209759
1244	Study Leave	59	0	0	2025	2025-01-22 14:37:45.216697	2025-01-22 14:37:45.216697
1245	Sick Leave	59	0	0	2025	2025-01-22 14:37:45.219654	2025-01-22 14:37:45.219654
1246	Compassionate Leave	59	0	0	2025	2025-01-22 14:37:45.22212	2025-01-22 14:37:45.22212
1247	Paternity Leave	59	0	0	2025	2025-01-22 14:37:45.225381	2025-01-22 14:37:45.225381
1248	Annual Leave	59	0	0	2025	2025-01-22 14:37:45.227928	2025-01-22 14:37:45.227928
1249	Study Leave	42	0	0	2025	2025-01-22 14:37:45.233838	2025-01-22 14:37:45.233838
1250	Sick Leave	42	0	0	2025	2025-01-22 14:37:45.236913	2025-01-22 14:37:45.236913
1251	Compassionate Leave	42	0	0	2025	2025-01-22 14:37:45.239728	2025-01-22 14:37:45.239728
1252	Paternity Leave	42	0	0	2025	2025-01-22 14:37:45.242135	2025-01-22 14:37:45.242135
1254	Study Leave	43	0	0	2025	2025-01-22 14:37:45.25238	2025-01-22 14:37:45.25238
1256	Compassionate Leave	43	0	0	2025	2025-01-22 14:37:45.258597	2025-01-22 14:37:45.258597
1257	Paternity Leave	43	0	0	2025	2025-01-22 14:37:45.261141	2025-01-22 14:37:45.261141
1259	Study Leave	97	0	0	2025	2025-01-22 14:37:45.270114	2025-01-22 14:37:45.270114
1260	Sick Leave	97	0	0	2025	2025-01-22 14:37:45.272813	2025-01-22 14:37:45.272813
1261	Compassionate Leave	97	0	0	2025	2025-01-22 14:37:45.275686	2025-01-22 14:37:45.275686
1262	Paternity Leave	97	0	0	2025	2025-01-22 14:37:45.278167	2025-01-22 14:37:45.278167
1264	Study Leave	58	0	0	2025	2025-01-22 14:37:45.285883	2025-01-22 14:37:45.285883
1265	Sick Leave	58	0	0	2025	2025-01-22 14:37:45.288591	2025-01-22 14:37:45.288591
1266	Compassionate Leave	58	0	0	2025	2025-01-22 14:37:45.291091	2025-01-22 14:37:45.291091
1267	Paternity Leave	58	0	0	2025	2025-01-22 14:37:45.294732	2025-01-22 14:37:45.294732
1235	Sick Leave	82	0	0	2025	2025-01-22 14:37:45.188787	2025-04-22 14:11:53.916002
1290	Compassionate Leave	40	0	0	2025	2025-04-25 06:17:21.420809	2025-04-25 06:17:21.420809
1223	Annual Leave	11	0	0	2025	2025-01-22 14:37:45.138979	2025-06-05 08:31:21.355243
1233	Annual Leave	41	0	0	2025	2025-01-22 14:37:45.181336	2025-06-05 08:31:21.425773
1253	Annual Leave	42	0	0	2025	2025-01-22 14:37:45.246325	2025-06-05 08:31:21.430779
1230	Sick Leave	41	0	0	2025	2025-01-22 14:37:45.171806	2025-04-22 14:11:53.783857
1258	Annual Leave	43	0	0	2025	2025-01-22 14:37:45.264864	2025-06-05 08:31:21.435727
1213	Annual Leave	56	0	0	2025	2025-01-22 14:37:45.094316	2025-06-05 08:31:21.450484
1268	Annual Leave	58	0	0	2025	2025-01-22 14:37:45.297884	2025-06-05 08:31:21.455476
1255	Sick Leave	43	0	0	2025	2025-01-22 14:37:45.255415	2025-04-22 14:11:53.790382
1210	Sick Leave	56	0	0	2025	2025-01-22 14:37:45.082319	2025-04-22 14:11:53.801192
1231	Compassionate Leave	41	0	0	2025	2025-01-22 14:37:45.175354	2025-04-22 14:11:14.547159
1228	Annual Leave	80	0	0	2025	2025-01-22 14:37:45.162462	2025-06-05 08:31:21.529826
1238	Annual Leave	82	0	0	2025	2025-01-22 14:37:45.196826	2025-06-05 08:31:21.540032
1243	Annual Leave	89	0	0	2025	2025-01-22 14:37:45.212148	2025-06-05 08:31:21.571246
1225	Sick Leave	80	0	0	2025	2025-01-22 14:37:45.15019	2025-04-22 14:11:53.905585
1224	Study Leave	80	0	0	2025	2025-01-22 14:37:45.146323	2025-04-22 14:11:53.908975
1218	Annual Leave	92	0	0	2025	2025-01-22 14:37:45.116874	2025-06-05 08:31:21.587575
1263	Annual Leave	97	0	0	2025	2025-01-22 14:37:45.281065	2025-06-05 08:31:21.612665
1308	Sick Leave	105	0	0	2025	2025-06-06 07:52:14.85393	2025-06-06 07:52:14.85393
1309	Compassionate Leave	105	0	0	2025	2025-06-06 07:52:14.858759	2025-06-06 07:52:14.858759
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.logs (id, loggable_type, loggable_id, prev_state, next_state, transition, transition_by, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.people (person_id, first_name, middle_name, last_name, birth_date, gender, marital_status, primary_phone, alt_phone, email_address, official_email, postal_address, residential_address, landmark, voided, created_at, updated_at) FROM stdin;
108	Paul		Martin	2000-01-01	Male	--	--	--	mkhalipiwatipatso@gmail.com	\N	P.O. Box 100 Mulanje	\N	\N	f	2025-03-19 09:41:51.360062	2025-12-12 08:14:07.531646
34	Pilirani	\N	Chikudzu	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 30364 Lilongwe 3	\N	\N	f	2024-02-27 11:12:54.447993	2024-02-27 11:12:54.447993
35	Pistone	\N	Sanjama	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	Box 31 Ngabu	\N	\N	f	2024-02-27 11:12:54.715747	2024-02-27 11:12:54.715747
37	Sharon	\N	Ngozo	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 44 Liwonde	\N	\N	f	2024-02-27 11:12:55.302815	2024-02-27 11:12:55.302815
38	Sithembinkosi	\N	Phombeya	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 30765 Blantyre 3	\N	\N	f	2024-02-27 11:12:55.577914	2024-02-27 11:12:55.577914
40	Timothy	Kumbweza	Banda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	C/o E.M Mvula, ARET, P/Bag 9 Lilongwe	\N	\N	f	2024-02-27 11:12:56.11039	2024-02-27 11:12:56.11039
41	Tobias	\N	Bendabenda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 20485	\N	\N	f	2024-02-27 11:12:56.369948	2024-02-27 11:12:56.369948
44	Foster	\N	Sentala	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 40046 Kanengo LL4	\N	\N	f	2024-02-27 11:12:57.171408	2024-02-27 11:12:57.171408
45	Lloyd	\N	Kayembe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 139 Mulanje	\N	\N	f	2024-02-27 11:12:57.44862	2024-02-27 11:12:57.44862
46	Yusuf	Joseph	Mtila	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	Box 368 Lilongwe	\N	\N	f	2024-02-27 11:12:57.723035	2024-02-27 11:12:57.723035
47	Julius	\N	Chimphampa	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:57.986841	2024-02-27 11:12:57.986841
36	Rashid	\N	Deula	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:55.02575	2025-06-11 10:41:48.833139
39	Sophie	Gondwe	Mvula	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	C/o Hector Mvula, P.O. Box 31024 Lilongwe	\N	\N	f	2024-02-27 11:12:55.846607	2025-06-11 10:41:48.843156
42	Wiza	\N	Munthali	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 30608 Blantyre 3	\N	\N	f	2024-02-27 11:12:56.632587	2025-06-11 10:41:48.853802
43	Wonderful	\N	Lijoni	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P/Bag 261 Blantyre	\N	\N	f	2024-02-27 11:12:56.890006	2025-06-11 10:41:48.85759
49	Cossam	\N	Kabaghe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:58.51542	2024-02-27 11:12:58.51542
50	Hazel	\N	Nanchinga	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:58.780345	2024-02-27 11:12:58.780345
51	Jane	\N	Chaponda	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:59.040494	2024-02-27 11:12:59.040494
52	Irene	Marvellous	Makina	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:59.303506	2024-02-27 11:12:59.303506
53	John	\N	Kabambe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:59.570092	2024-02-27 11:12:59.570092
54	Micheal	\N	Simenti	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:59.845866	2024-02-27 11:12:59.845866
55	Michael	James	Harawa	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	C/o Prescot Nsini, NEEF , P.O. Box 779 Lilongwe	\N	\N	f	2024-02-27 11:13:00.112645	2024-02-27 11:13:00.112645
56	Teleza	\N	Kanthonga	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	C/o Simeon Mbaisa, MRA, P.O. Box 312 Mzuzu	\N	\N	f	2024-02-27 11:13:00.382945	2024-02-27 11:13:00.382945
57	Phillimon	Kent	Chunga	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:13:00.670073	2024-02-27 11:13:00.670073
58	Yawapo	\N	Chibaka	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	C/o Chawanangwa Kayira, P.O. Box 986 Lilongwe	\N	\N	f	2024-02-27 11:13:00.936616	2024-02-27 11:13:00.936616
59	Willie	Brian	Kasakula	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	Mvama CCAP, P.O. Box 40202 Lilongwe 4	\N	\N	f	2024-02-27 11:13:01.211032	2024-02-27 11:13:01.211032
60	Martha	\N	Madziatera	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 40379 Kanengo	\N	\N	f	2024-02-27 11:13:01.496386	2024-02-27 11:13:01.496386
61	Daphne	Thenjiwe	Magela	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:13:01.789292	2024-02-27 11:13:01.789292
62	Tamika	\N	Mulenga	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 30317 Liliongwe 3	\N	\N	f	2024-02-27 11:13:02.09526	2024-02-27 11:13:02.09526
63	Gloria	\N	Naluso	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	C/o Cosmas Mwalyambwire P.O. Box 31305 	\N	\N	f	2024-02-27 11:13:02.390092	2024-02-27 11:13:02.390092
65	Steven	\N	Kholowa	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2118 Blantyre	\N	\N	f	2024-02-27 11:13:02.949676	2024-02-27 11:13:02.949676
67	Comfort	\N	Mwalija	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 402806 Kanengo	\N	\N	f	2024-02-27 11:13:03.509882	2024-02-27 11:13:03.509882
68	Nigel	\N	Banda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 40522 Kanengo	\N	\N	f	2024-02-27 11:13:03.778123	2024-02-27 11:13:03.778123
69	Martin	\N	Yapu	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2365 Lilongwe	\N	\N	f	2024-02-27 11:13:04.049745	2024-02-27 11:13:04.049745
70	Hope	\N	Madziakapita	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	Private Bag 7 Blantyre	\N	\N	f	2024-02-27 11:13:04.320964	2024-02-27 11:13:04.320964
71	Maxwell	\N	Kapezi	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:13:04.586509	2024-02-27 11:13:04.586509
72	Chipiliro	Sato	Yikwanga	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P/Bag 90 Lilongwe	\N	\N	f	2024-02-27 11:13:04.862945	2024-02-27 11:13:04.862945
74	Oveka	\N	Mwanza	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 30972, Lilongwe	\N	\N	f	2024-04-02 11:25:26.455812	2024-04-02 11:25:26.455812
77	Dominic	\N	Mapanje	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 563, Lilongwe	\N	\N	f	2024-04-17 13:30:15.978832	2024-04-17 13:30:15.978832
79	Janet	\N	Chalera	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 941 Zomba	\N	\N	f	2024-04-25 08:07:34.886594	2024-04-25 08:07:34.886594
81	Phoebe	Nelima	Khagame	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-06-14 06:32:55.043288	2024-06-14 06:32:55.043288
84	Lekodi	Zacharia	Magombo	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-07-02 12:38:17.336558	2024-07-02 12:38:17.336558
85	Joana	Promise	Mhone	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 507 Mzuzu	\N	\N	f	2024-08-22 06:27:12.616584	2024-08-22 06:27:12.616584
86	Ekariorama	Buledi	Magaleta	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 41 Liwonde	\N	\N	f	2024-08-22 07:59:16.802264	2024-08-22 07:59:16.802264
88	Davie	\N	Banda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P/Bag B35	\N	\N	f	2024-10-21 06:49:38.701503	2024-10-21 06:49:38.701503
89	William	\N	Chonzie	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2440 Lilongwe	\N	\N	f	2024-11-11 06:22:54.462666	2024-11-11 06:22:54.462666
90	Ethel	Sambakamwe	Utumbe	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 40680 Kanengo	\N	\N	f	2024-11-11 07:00:15.73339	2024-11-11 07:00:15.73339
91	Samuel	Manjalazi	Chingoka	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O.Box 30606 Lilongwe 3	\N	\N	f	2024-11-11 07:05:20.529725	2024-11-11 07:05:20.529725
66	Rodger	\N	Kumwanje	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P/Bag B387 Lilongwe	\N	\N	f	2024-02-27 11:13:03.220856	2025-06-11 10:41:48.76745
82	Victor	\N	Mzembe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 65 Chilumba	\N	\N	f	2024-06-24 07:39:27.649113	2025-06-11 10:41:48.772362
73	Cecilia	\N	Kapalamula	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P/Bag 66 Zomba	\N	\N	f	2024-03-15 10:08:52.283193	2025-06-11 10:41:48.788608
78	Cletia	\N	Nsambo	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 51255, Limbe	\N	\N	f	2024-04-17 13:38:03.383384	2025-06-11 10:41:48.791858
87	Neo	\N	Kazembe	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	C/o Mrs Kazembe P.O. Box 55 Dedza	\N	\N	f	2024-09-30 07:29:42.565305	2025-06-11 10:41:48.827186
48	Brenda	\N	Luhanga	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:58.24954	2024-12-16 09:08:13.28351
101	Tamandani	\N	Whayo	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 149 Lilongwe	\N	\N	f	2025-02-07 07:04:41.097723	2025-02-07 07:04:41.097723
102	Blessings	Nthezemu	Kamanga	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2025-02-17 06:11:15.410055	2025-02-17 06:11:15.410055
104	Ruth		Chirwa	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P. O. Box 673 Lilongwe	\N	\N	f	2025-03-19 08:45:22.978654	2025-03-19 08:45:22.978654
105	Asante		Chisa	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 3218 Lilongwe	\N	\N	f	2025-03-19 09:15:48.526539	2025-03-19 09:15:48.526539
107	Shadreck		Khamba	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 1064 Lilongwe	\N	\N	f	2025-03-19 09:36:11.840918	2025-03-19 09:36:11.840918
109	Kelvin		Sande	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 156 Likuni	\N	\N	f	2025-03-19 09:44:37.721484	2025-03-19 09:44:37.721484
106	Ephraim	Khalauheni	Mandala	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 316 Mzuzu	\N	\N	f	2025-03-19 09:22:24.031838	2025-03-19 14:19:25.45729
110	Mabuchi		Nyirenda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2186 Blantyre	\N	\N	f	2025-05-02 13:14:05.193405	2025-05-02 13:14:05.193405
111	Ruth	Michelle	Msinkhu	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 88 Likuni	\N	\N	f	2025-05-19 13:48:06.230137	2025-05-19 13:48:06.230137
112	Jane		Mabaso	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 221	\N	\N	f	2025-05-19 13:51:12.965323	2025-05-19 13:51:12.965323
113	Emmanuel		Mtegha	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P/Bag 122 Blantyre	\N	\N	f	2025-05-19 13:54:58.345364	2025-05-19 13:54:58.345364
114	Waliko		Kondowe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P/Bag 303 Blantyre	\N	\N	f	2025-05-19 13:58:34.977423	2025-05-19 13:58:34.977423
115	Rodgers		Mkandawire	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box X111 Lilongwe	\N	\N	f	2025-05-23 10:46:56.140519	2025-05-23 10:46:56.140519
28	Mtheto	\N	Sinjani	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:52.78251	2025-06-06 06:45:27.619026
83	Janet	\N	Douglas	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P/Bag 2 Chilema	\N	\N	f	2024-06-24 10:59:36.809381	2025-06-11 10:41:48.775588
94	Benjamin	\N	Munyenyembe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P. O. Box X111 Lilongwe	\N	\N	f	2024-11-25 14:01:26.926314	2025-06-11 10:41:48.781553
103	Bryan	\N	Malunje	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 40676 Lilongwe 4	\N	\N	f	2025-02-17 06:22:16.498166	2025-06-11 10:41:48.784711
93	Doreen	\N	Thotho	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 40097 Lilongwe	\N	\N	f	2024-11-11 07:21:38.993458	2025-06-11 10:41:48.807757
96	Frank	\N	Gondwe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-12-02 09:53:59.384585	2025-06-11 10:41:48.811447
98	Jones	Chimwano	Blackwell	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 131 Namitete Lilongwe	\N	\N	f	2024-12-14 09:33:31.16841	2025-06-11 10:41:48.815033
99	Moses	\N	Gwaza	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 1113 Lilongwe	\N	\N	f	2024-12-14 09:38:32.931879	2025-06-11 10:41:48.822277
95	Richard	Kumbukani	Kachipapa	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 149 Lilongwe	\N	\N	f	2024-12-02 09:48:28.32643	2025-06-11 10:41:48.836308
20	Innocent	\N	Kumwenda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:50.615086	2024-02-27 11:12:50.615086
21	Israel	\N	Ghambi	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:50.879442	2024-02-27 11:12:50.879442
23	Joseph	\N	Sakala	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	Box 44 Liwonde	\N	\N	f	2024-02-27 11:12:51.429146	2024-02-27 11:12:51.429146
24	Kelvin	\N	Msiska	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:51.694776	2024-02-27 11:12:51.694776
25	Kelvin	\N	Saidi	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:51.961966	2024-02-27 11:12:51.961966
26	Kennedy	\N	Linzie	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:52.245792	2024-02-27 11:12:52.245792
27	Luke	\N	Kamvazina	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:52.507206	2024-02-27 11:12:52.507206
29	Mwabi	\N	Lungu	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:53.070662	2024-02-27 11:12:53.070662
30	Naomi	Langson	Thompson	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:53.34444	2024-02-27 11:12:53.34444
31	Naomi	\N	Nyama	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:53.645532	2024-02-27 11:12:53.645532
32	Neverson	Steven	Nkhata	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 372 Kasungu	\N	\N	f	2024-02-27 11:12:53.911735	2024-02-27 11:12:53.911735
33	Peter	\N	Namagonya	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	JMS Agriculture P/Bag A-7	\N	\N	f	2024-02-27 11:12:54.17718	2024-02-27 11:12:54.17718
64	Hannah	Talitha	Masangwi	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 51522 Limbe	\N	\N	f	2024-02-27 11:13:02.675377	2024-02-27 11:13:02.675377
22	John	\N	Abudul	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:51.149538	2024-03-15 10:36:22.084686
100	Rosert	Zione	Malikebu	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	p.o. bOX X111 Lilongwe	\N	\N	f	2025-01-07 11:47:14.120644	2025-06-11 10:41:48.839733
92	Thokozani	Lester	Chirombo	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 31478 Lilongwe	\N	\N	f	2024-11-11 07:19:29.050684	2025-06-11 10:41:48.849587
97	Yamikani	\N	Sita	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P/Bag 12 Blantyre	\N	\N	f	2024-12-02 10:05:48.218063	2025-06-11 10:41:48.861397
80	Titani	\N	Manda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-05-21 06:09:49.530172	2025-06-11 10:41:48.866769
11	Timothy	Mayamiko	Mtonga	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2064, Lilongwe	\N	\N	f	2024-02-27 11:12:48.209961	2025-06-11 13:20:08.046583
1	Angela	Chifundo	Chindebvu	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2073 Lilongwe	\N	\N	f	2024-02-27 11:12:45.452865	2024-02-27 11:12:45.452865
2	Aubrey	\N	Chinkunda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 30455 Lilongwe	\N	\N	f	2024-02-27 11:12:45.751372	2024-02-27 11:12:45.751372
3	Beatrice	\N	Matambo	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	Kamuzu College of Nursin P/Bag 1 Lilongwe	\N	\N	f	2024-02-27 11:12:46.012609	2024-02-27 11:12:46.012609
4	Blessings	\N	Chidambe	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:46.299379	2024-02-27 11:12:46.299379
5	Boniface	Moffat	Kaseka	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:46.585414	2024-02-27 11:12:46.585414
6	Chimwemwe	\N	Tiyesi	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:46.847252	2024-02-27 11:12:46.847252
7	Chipiliro	\N	Kadzakumanja	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 20485 Lilongwe 2	\N	\N	f	2024-02-27 11:12:47.120531	2024-02-27 11:12:47.120531
8	Deliwe	Bernadette	Nkhoma	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	P.O. Box 191 Mzuzu	\N	\N	f	2024-02-27 11:12:47.387907	2024-02-27 11:12:47.387907
9	Dereck	\N	Katuli	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2381	\N	\N	f	2024-02-27 11:12:47.670729	2024-02-27 11:12:47.670729
10	Dokiso	\N	Makwakwa	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 20426 Kawale	\N	\N	f	2024-02-27 11:12:47.942408	2024-02-27 11:12:47.942408
12	Elizabeth	Towela	Nthapalapa	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:48.487297	2024-02-27 11:12:48.487297
13	Emmanuel	\N	Chauya	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 132 Luchenza	\N	\N	f	2024-02-27 11:12:48.765643	2024-02-27 11:12:48.765643
14	Eunice	\N	Msiska	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:49.025656	2024-02-27 11:12:49.025656
15	Evance	\N	Mose	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:49.289378	2024-02-27 11:12:49.289378
16	Fatsani	\N	Tamandikani	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:49.554675	2024-02-27 11:12:49.554675
17	Francis	\N	Sambani	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 29 Ntcheu	\N	\N	f	2024-02-27 11:12:49.820141	2024-02-27 11:12:49.820141
18	Goodluck	Halord	Banda	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:50.091239	2024-02-27 11:12:50.091239
19	Grace	Favour	Bwanali	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	\N	\N	\N	f	2024-02-27 11:12:50.35605	2024-02-27 11:12:50.35605
75	Carolyn	Kazado	Ngwira	2000-01-01	Female	--	--	--	manda.titani@gmail.com	\N	c/o Mr. G. Ngwira,P.O. Box 30797, Lilongwe	\N	\N	f	2024-04-02 12:03:25.035242	2024-04-02 12:03:25.035242
76	Chikonzero	Alexander	Simkoza	2000-01-01	Male	--	--	--	manda.titani@gmail.com	\N	P.O. Box 2588, Devlin Road, Nyambadwe, Blantyre	\N	\N	f	2024-04-17 12:45:07.297516	2024-04-17 12:45:07.297516
\.


--
-- Data for Name: petty_cash_comments; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.petty_cash_comments (id, comment, used_amount, requisition_id, created_at, updated_at) FROM stdin;
1	\N	4000.00	21	2025-06-18 09:00:56.578098	2025-06-18 09:00:56.581185
2	\N	2500.00	10	2025-06-19 14:14:08.711968	2025-06-19 14:14:08.715619
3	\N	22400.00	32	2025-06-19 14:14:57.003302	2025-06-19 14:14:57.006129
4	\N	22400.00	33	2025-06-19 14:15:20.915119	2025-06-19 14:15:20.919354
5	\N	24000.00	23	2025-06-19 14:16:42.222978	2025-06-19 14:16:42.225918
6	\N	0.00	20	2025-06-19 14:24:40.304397	2025-06-19 14:24:40.304397
7	\N	38045.00	25	2025-06-19 14:25:45.223634	2025-06-19 14:25:45.22635
8	\N	0.00	27	2025-06-19 14:26:22.25611	2025-06-19 14:26:22.25611
9	\N	24000.00	35	2025-06-19 14:26:46.358977	2025-06-19 14:26:46.361287
10	\N	39000.00	29	2025-06-19 14:27:09.015469	2025-06-19 14:27:09.018078
11	\N	0.00	22	2025-06-19 14:27:34.712194	2025-06-19 14:27:34.712194
12	\N	6000.00	38	2025-07-03 07:49:02.634611	2025-07-03 07:49:02.642824
13	\N	0.00	36	2025-07-03 07:49:33.089654	2025-07-03 07:49:33.089654
14	\N	17000.00	74	2025-07-17 09:48:05.777374	2025-07-17 09:48:05.787037
15	\N	2000.00	72	2025-07-18 10:47:47.406033	2025-07-18 10:47:47.433203
16	\N	6000.00	73	2025-07-18 10:48:02.907392	2025-07-18 10:48:02.924794
17	\N	2000.00	91	2025-07-24 07:20:40.763288	2025-07-24 07:20:40.779309
18	\N	5000.00	102	2025-07-30 06:44:49.920143	2025-07-30 06:44:49.93211
19	\N	5000.00	103	2025-07-30 07:53:45.240403	2025-07-30 07:53:45.249427
20	\N	5000.00	104	2025-07-30 08:05:43.796936	2025-07-30 08:05:43.806697
\.


--
-- Data for Name: project_task_assignments; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.project_task_assignments (project_task_assignment_id, project_task_id, assigned_to, revoked, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: project_tasks; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.project_tasks (project_task_id, project_id, task_description, estimated_duration, deadline, task_status, performed_by, voided, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: project_teams; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.project_teams (project_team_id, project_id, employee_id, allocated_effort, start_date, end_date, voided, created_at, updated_at) FROM stdin;
1	5	1	75	2023-01-03	\N	f	2024-02-27 11:13:07.766948	2024-02-27 11:13:07.766948
2	12	1	15	2023-01-03	\N	f	2024-02-27 11:13:07.783657	2024-02-27 11:13:07.783657
3	2	1	10	2023-01-03	\N	f	2024-02-27 11:13:07.79696	2024-02-27 11:13:07.79696
4	1	2	100	2021-10-01	2022-07-30	f	2024-02-27 11:13:07.806801	2024-02-27 11:13:07.806801
5	2	2	50	2022-08-01	\N	f	2024-02-27 11:13:07.816525	2024-02-27 11:13:07.816525
6	23	2	50	2022-08-01	\N	f	2024-02-27 11:13:07.826517	2024-02-27 11:13:07.826517
7	5	3	100	2022-11-28	\N	f	2024-02-27 11:13:07.852551	2024-02-27 11:13:07.852551
8	5	4	100	2022-11-28	\N	f	2024-02-27 11:13:07.869421	2024-02-27 11:13:07.869421
9	23	5	100	2023-04-03	\N	f	2024-02-27 11:13:07.885852	2024-02-27 11:13:07.885852
13	12	7	100	2021-10-29	2022-07-30	f	2024-02-27 11:13:07.9286	2024-02-27 11:13:07.9286
14	23	7	45	2022-08-01	\N	f	2024-02-27 11:13:07.947357	2024-02-27 11:13:07.947357
15	12	7	55	2022-08-01	\N	f	2024-02-27 11:13:07.962334	2024-02-27 11:13:07.962334
16	5	8	100	2022-10-01	\N	f	2024-02-27 11:13:07.976721	2024-02-27 11:13:07.976721
17	5	9	100	2022-11-28	\N	f	2024-02-27 11:13:07.991268	2024-02-27 11:13:07.991268
18	23	10	54	2022-09-26	\N	f	2024-02-27 11:13:08.003619	2024-02-27 11:13:08.003619
19	23	11	30	2022-08-01	2022-09-30	f	2024-02-27 11:13:08.014138	2024-02-27 11:13:08.014138
20	5	11	60	2022-09-30	\N	f	2024-02-27 11:13:08.024367	2024-02-27 11:13:08.024367
21	2	11	10	2022-08-01	\N	f	2024-02-27 11:13:08.042224	2024-02-27 11:13:08.042224
22	23	11	10	2022-09-30	\N	f	2024-02-27 11:13:08.055403	2024-02-27 11:13:08.055403
23	23	12	100	2023-04-11	2023-10-09	f	2024-02-27 11:13:08.071266	2024-02-27 11:13:08.071266
24	1	12	100	2023-10-09	2024-01-01	f	2024-02-27 11:13:08.08432	2024-02-27 11:13:08.08432
25	10	12	100	2024-01-02	\N	f	2024-02-27 11:13:08.094862	2024-02-27 11:13:08.094862
26	2	13	100	2023-04-03	\N	f	2024-02-27 11:13:08.10477	2024-02-27 11:13:08.10477
27	23	14	100	2022-10-10	\N	f	2024-02-27 11:13:08.114199	2024-02-27 11:13:08.114199
28	13	15	100	2022-06-27	\N	f	2024-02-27 11:13:08.125055	2024-02-27 11:13:08.125055
29	23	16	100	2022-08-29	\N	f	2024-02-27 11:13:08.143984	2024-02-27 11:13:08.143984
30	1	17	100	2021-10-01	2022-07-30	f	2024-02-27 11:13:08.157535	2024-02-27 11:13:08.157535
31	2	17	50	2022-08-01	\N	f	2024-02-27 11:13:08.170044	2024-02-27 11:13:08.170044
32	23	17	50	2022-08-01	\N	f	2024-02-27 11:13:08.18174	2024-02-27 11:13:08.18174
33	23	18	100	2023-04-11	\N	f	2024-02-27 11:13:08.194335	2024-02-27 11:13:08.194335
34	23	19	100	2023-04-11	\N	f	2024-02-27 11:13:08.205727	2024-02-27 11:13:08.205727
35	13	20	100	2022-11-22	\N	f	2024-02-27 11:13:08.215795	2024-02-27 11:13:08.215795
36	7	21	100	2023-06-19	\N	f	2024-02-27 11:13:08.225321	2024-02-27 11:13:08.225321
37	1	22	100	2021-11-01	\N	f	2024-02-27 11:13:08.239613	2024-02-27 11:13:08.239613
38	23	22	54	2022-08-01	\N	f	2024-02-27 11:13:08.252377	2024-02-27 11:13:08.252377
39	5	23	100	2023-02-20	\N	f	2024-02-27 11:13:08.267745	2024-02-27 11:13:08.267745
40	5	24	100	2022-11-28	\N	f	2024-02-27 11:13:08.281931	2024-02-27 11:13:08.281931
41	23	25	100	2023-03-02	2023-09-11	f	2024-02-27 11:13:08.293082	2024-02-27 11:13:08.293082
42	1	25	100	2023-09-11	\N	f	2024-02-27 11:13:08.303157	2024-02-27 11:13:08.303157
43	13	26	100	2023-03-08	\N	f	2024-02-27 11:13:08.313703	2024-02-27 11:13:08.313703
44	5	27	100	2022-11-28	\N	f	2024-02-27 11:13:08.327067	2024-02-27 11:13:08.327067
45	23	28	20	2022-08-01	\N	f	2024-02-27 11:13:08.342602	2024-02-27 11:13:08.342602
46	14	28	70	2022-09-21	2023-04-23	f	2024-02-27 11:13:08.355805	2024-02-27 11:13:08.355805
47	13	28	10	2023-01-01	\N	f	2024-02-27 11:13:08.369092	2024-02-27 11:13:08.369092
48	7	28	20	2023-04-24	2023-09-29	f	2024-02-27 11:13:08.383385	2024-02-27 11:13:08.383385
49	14	28	50	2023-04-24	2023-09-29	f	2024-02-27 11:13:08.396159	2024-02-27 11:13:08.396159
51	23	29	55	2022-08-01	2022-11-30	f	2024-02-27 11:13:08.41795	2024-02-27 11:13:08.41795
52	2	29	50	2022-12-01	2023-12-31	f	2024-02-27 11:13:08.428729	2024-02-27 11:13:08.428729
53	23	29	27	2022-12-01	2023-12-31	f	2024-02-27 11:13:08.444358	2024-02-27 11:13:08.444358
54	2	29	100	2024-01-01	\N	f	2024-02-27 11:13:08.459168	2024-02-27 11:13:08.459168
55	23	30	100	2022-10-10	\N	f	2024-02-27 11:13:08.480134	2024-02-27 11:13:08.480134
56	13	31	100	2022-08-26	\N	f	2024-02-27 11:13:08.495178	2024-02-27 11:13:08.495178
57	1	32	100	2021-10-29	2022-07-30	f	2024-02-27 11:13:08.507508	2024-02-27 11:13:08.507508
58	23	32	50	2022-08-01	\N	f	2024-02-27 11:13:08.519166	2024-02-27 11:13:08.519166
59	5	33	100	2022-10-01	\N	f	2024-02-27 11:13:08.529948	2024-02-27 11:13:08.529948
60	5	34	80	2023-01-03	\N	f	2024-02-27 11:13:08.549354	2024-02-27 11:13:08.549354
61	12	34	20	2023-01-03	\N	f	2024-02-27 11:13:08.567904	2024-02-27 11:13:08.567904
62	5	35	100	2022-11-28	\N	f	2024-02-27 11:13:08.584461	2024-02-27 11:13:08.584461
63	23	36	30	2022-08-01	\N	f	2024-02-27 11:13:08.597928	2024-02-27 11:13:08.597928
64	14	36	50	2022-09-21	\N	f	2024-02-27 11:13:08.609606	2024-02-27 11:13:08.609606
65	1	37	100	2021-10-01	2022-07-30	f	2024-02-27 11:13:08.622787	2024-02-27 11:13:08.622787
66	2	37	50	2022-08-01	\N	f	2024-02-27 11:13:08.639388	2024-02-27 11:13:08.639388
67	23	37	50	2022-08-01	\N	f	2024-02-27 11:13:08.656986	2024-02-27 11:13:08.656986
68	6	38	50	2022-09-05	2023-12-31	f	2024-02-27 11:13:08.673233	2024-02-27 11:13:08.673233
69	12	39	100	2022-03-28	2022-07-30	f	2024-02-27 11:13:08.689207	2024-02-27 11:13:08.689207
70	23	39	61	2022-08-01	2023-09-29	f	2024-02-27 11:13:08.700277	2024-02-27 11:13:08.700277
71	5	39	65	2023-09-30	\N	f	2024-02-27 11:13:08.712475	2024-02-27 11:13:08.712475
72	2	39	5	2023-09-30	\N	f	2024-02-27 11:13:08.723251	2024-02-27 11:13:08.723251
73	23	39	10	2023-09-30	\N	f	2024-02-27 11:13:08.737002	2024-02-27 11:13:08.737002
74	5	40	100	2022-11-28	\N	f	2024-02-27 11:13:08.750255	2024-02-27 11:13:08.750255
75	1	41	100	2021-10-29	2022-07-30	f	2024-02-27 11:13:08.763511	2024-02-27 11:13:08.763511
76	23	41	50	2022-08-01	\N	f	2024-02-27 11:13:08.781151	2024-02-27 11:13:08.781151
77	13	42	100	2023-03-07	\N	f	2024-02-27 11:13:08.79407	2024-02-27 11:13:08.79407
78	21	43	100	2022-08-01	2023-04-24	f	2024-02-27 11:13:08.804316	2024-02-27 11:13:08.804316
79	7	43	100	2023-04-24	2023-09-29	f	2024-02-27 11:13:08.813431	2024-02-27 11:13:08.813431
80	21	43	30	2023-09-29	\N	f	2024-02-27 11:13:08.822475	2024-02-27 11:13:08.822475
81	2	44	100	2023-07-03	\N	f	2024-02-27 11:13:08.835649	2024-02-27 11:13:08.835649
82	2	45	100	2023-08-21	\N	f	2024-02-27 11:13:08.850872	2024-02-27 11:13:08.850872
83	5	46	80	2023-06-06	\N	f	2024-02-27 11:13:08.864833	2024-02-27 11:13:08.864833
84	1	47	100	2023-07-03	\N	f	2024-02-27 11:13:08.877617	2024-02-27 11:13:08.877617
85	1	48	100	2023-01-18	\N	f	2024-02-27 11:13:08.889114	2024-02-27 11:13:08.889114
86	8	49	100	2023-09-11	\N	f	2024-02-27 11:13:08.899358	2024-02-27 11:13:08.899358
87	8	50	100	2023-09-25	\N	f	2024-02-27 11:13:08.908479	2024-02-27 11:13:08.908479
88	23	51	100	2023-10-17	\N	f	2024-02-27 11:13:08.919045	2024-02-27 11:13:08.919045
89	23	52	100	2023-10-17	\N	f	2024-02-27 11:13:08.928604	2024-02-27 11:13:08.928604
90	23	53	100	2023-10-17	\N	f	2024-02-27 11:13:08.941158	2024-02-27 11:13:08.941158
91	23	54	100	2023-10-17	\N	f	2024-02-27 11:13:08.952959	2024-02-27 11:13:08.952959
92	5	55	100	2023-11-27	\N	f	2024-02-27 11:13:08.96384	2024-02-27 11:13:08.96384
93	5	56	100	2023-11-27	\N	f	2024-02-27 11:13:08.979261	2024-02-27 11:13:08.979261
94	27	57	100	2023-11-27	\N	f	2024-02-27 11:13:08.991038	2024-02-27 11:13:08.991038
95	5	58	100	2023-12-18	\N	f	2024-02-27 11:13:09.001519	2024-02-27 11:13:09.001519
96	5	59	100	2023-12-11	\N	f	2024-02-27 11:13:09.010656	2024-02-27 11:13:09.010656
97	5	60	100	2024-01-02	\N	f	2024-02-27 11:13:09.02023	2024-02-27 11:13:09.02023
11	1	6	50	2023-03-01	2024-03-05	f	2024-02-27 11:13:07.907993	2024-04-19 12:49:04.774754
12	2	6	50	2023-03-01	2024-03-05	f	2024-02-27 11:13:07.918589	2024-04-19 12:49:04.777602
10	1	6	100	2022-10-03	2023-03-01	f	2024-02-27 11:13:07.897304	2024-04-19 12:50:00.501361
98	10	61	100	2024-01-08	\N	f	2024-02-27 11:13:09.029732	2024-02-27 11:13:09.029732
99	12	62	30	2024-01-29	\N	f	2024-02-27 11:13:09.055104	2024-02-27 11:13:09.055104
100	5	62	60	2024-01-29	\N	f	2024-02-27 11:13:09.072888	2024-02-27 11:13:09.072888
101	2	62	10	2024-01-29	\N	f	2024-02-27 11:13:09.089767	2024-02-27 11:13:09.089767
102	5	63	100	2024-01-29	\N	f	2024-02-27 11:13:09.100867	2024-02-27 11:13:09.100867
103	25	64	100	2024-02-07	\N	f	2024-02-27 11:13:09.111507	2024-02-27 11:13:09.111507
104	12	65	30	2024-01-30	\N	f	2024-02-27 11:13:09.123925	2024-02-27 11:13:09.123925
105	5	65	60	2024-01-30	\N	f	2024-02-27 11:13:09.148475	2024-02-27 11:13:09.148475
106	2	65	10	2024-01-30	\N	f	2024-02-27 11:13:09.172004	2024-02-27 11:13:09.172004
107	2	66	100	2024-01-22	\N	f	2024-02-27 11:13:09.186761	2024-02-27 11:13:09.186761
108	13	67	100	2021-10-01	\N	f	2024-02-27 11:13:09.1974	2024-02-27 11:13:09.1974
109	12	68	100	2022-04-28	\N	f	2024-02-27 11:13:09.206546	2024-02-27 11:13:09.206546
110	12	69	100	2024-02-08	\N	f	2024-02-27 11:13:09.216653	2024-02-27 11:13:09.216653
111	13	70	100	2024-02-20	\N	f	2024-02-27 11:13:09.225603	2024-02-27 11:13:09.225603
112	13	71	100	2024-02-20	\N	f	2024-02-27 11:13:09.241879	2024-02-27 11:13:09.241879
113	12	72	100	2024-02-21	\N	f	2024-02-27 11:13:09.25945	2024-02-27 11:13:09.25945
114	12	73	100	2024-03-06	\N	f	2024-03-15 10:34:25.834168	2024-03-20 16:16:22.034072
50	14	28	70	2023-09-30	2024-04-01	f	2024-02-27 11:13:08.40762	2024-04-02 11:20:42.214451
115	14	74	100	2024-04-02	\N	f	2024-04-02 11:34:32.444666	2024-04-02 11:34:32.444666
116	5	75	80	2024-04-02	\N	f	2024-04-02 12:12:01.423752	2024-04-02 12:12:01.423752
117	23	78	100	2024-04-17	\N	f	2024-04-17 13:57:35.899793	2024-04-17 13:57:35.899793
118	23	77	100	2024-04-17	\N	f	2024-04-17 13:59:18.347998	2024-04-17 13:59:18.347998
119	23	76	100	2024-04-15	\N	f	2024-04-17 14:03:16.933971	2024-04-17 14:03:16.933971
120	10	6	20	2024-03-06	\N	f	2024-04-19 12:53:17.728351	2024-04-19 12:53:17.728351
121	2	6	10	2024-03-06	\N	f	2024-04-19 12:54:24.906775	2024-04-19 12:54:24.906775
122	23	6	55	2024-03-06	\N	f	2024-04-19 12:55:31.90594	2024-04-19 12:55:31.90594
123	2	81	100	2023-02-01	\N	f	2024-06-14 09:10:53.974051	2024-06-14 09:10:53.974051
124	2	82	100	2024-06-17	\N	f	2024-06-24 07:51:08.690475	2024-06-24 07:51:08.690475
125	2	83	100	2024-06-17	\N	f	2024-06-24 11:03:37.748079	2024-06-24 11:03:37.748079
126	25	84	100	2024-07-01	2024-09-30	f	2024-07-02 12:57:12.240893	2024-10-03 11:04:52.02041
127	25	84	22.5	2024-10-01	\N	f	2024-10-03 11:16:05.955193	2024-10-03 11:16:05.955193
128	14	84	77.5	2024-10-01	\N	f	2024-10-03 11:17:14.353458	2024-10-03 11:17:14.353458
129	5	87	80	2024-09-30	\N	f	2024-10-03 11:18:31.370777	2024-10-03 11:18:31.370777
130	23	89	100	2024-10-22	\N	f	2024-11-11 06:46:30.618198	2024-11-11 06:46:30.618198
131	23	90	100	2024-10-22	\N	f	2024-11-11 07:01:25.428018	2024-11-11 07:01:25.428018
132	23	91	100	2024-10-22	\N	f	2024-11-11 07:06:07.848461	2024-11-11 07:06:07.848461
133	14	92	100	2024-11-04	\N	f	2024-11-11 07:20:01.173693	2024-11-11 07:20:01.173693
134	14	93	100	2024-11-04	\N	f	2024-11-11 07:22:13.198823	2024-11-11 07:22:13.198823
135	14	94	100	2024-11-25	\N	f	2024-11-25 14:03:21.483685	2024-11-25 14:03:21.483685
136	14	95	100	2024-12-02	\N	f	2024-12-02 09:49:15.420335	2024-12-02 09:49:15.420335
137	14	96	100	2024-11-29	\N	f	2024-12-02 09:54:48.277421	2024-12-02 09:54:48.277421
138	5	97	100	2024-12-02	\N	f	2024-12-02 10:06:37.177869	2024-12-02 10:06:37.177869
139	5	98	100	2024-12-09	\N	f	2024-12-14 09:34:24.70615	2024-12-14 09:34:24.70615
140	5	99	100	2025-01-06	\N	f	2024-12-14 09:40:04.77414	2024-12-14 09:40:04.77414
141	5	100	65	2025-01-06	\N	f	2025-01-07 11:48:32.895112	2025-01-07 11:48:32.895112
142	14	101	100	2025-01-01	\N	f	2025-02-07 07:05:32.798683	2025-02-07 07:05:32.798683
143	14	102	100	2025-02-10	\N	f	2025-02-17 06:11:56.221017	2025-02-17 06:11:56.221017
144	5	103	100	2025-01-22	\N	f	2025-02-17 06:22:51.958806	2025-02-17 06:22:51.958806
145	8	104	100	2025-02-24	\N	f	2025-03-19 08:45:23.255445	2025-03-19 08:45:23.255445
146	2	105	100	2025-03-26	\N	f	2025-03-19 09:15:48.78999	2025-03-19 09:15:48.78999
147	2	106	100	2025-02-26	\N	f	2025-03-19 09:22:24.293731	2025-03-19 09:22:24.293731
148	12	107	100	2025-02-24	\N	f	2025-03-19 09:36:12.115287	2025-03-19 09:36:12.115287
149	12	108	100	2025-03-04	\N	f	2025-03-19 09:41:51.624819	2025-03-19 09:41:51.624819
150	13	109	100	2025-02-24	\N	f	2025-03-19 09:44:37.994317	2025-03-19 09:44:37.994317
151	13	110	100	2025-05-05	\N	f	2025-05-02 13:14:05.460172	2025-05-02 13:14:05.460172
152	1	111	100	2025-05-15	\N	f	2025-05-19 13:48:06.511687	2025-05-19 13:48:06.511687
153	1	112	100	2025-05-15	\N	f	2025-05-19 13:51:13.227292	2025-05-19 13:51:13.227292
154	1	113	100	2025-05-15	\N	f	2025-05-19 13:54:58.608026	2025-05-19 13:54:58.608026
155	1	114	100	2025-05-15	\N	f	2025-05-19 13:58:35.237304	2025-05-19 13:58:35.237304
156	14	115	100	2025-05-26	\N	f	2025-05-23 10:46:56.409034	2025-05-23 10:46:56.409034
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.projects (project_id, project_name, short_name, project_description, manager, created_by, closed_by, is_active, completed_at, created_at, updated_at) FROM stdin;
1	OpenO2	OpenO2	Capacity building intiative to train new biomedical engineers and repair and assess oxygen concentrators	29	\N	\N	t	\N	2020-01-09 00:00:00	2024-02-27 11:13:07.481419
2	Oxygen Alliance	Oxygen Alliance	Advocacy program in 15 african countries	29	\N	\N	t	\N	2021-09-17 00:00:00	2024-02-27 11:13:07.492757
3	BRINGO2	BRINGO2	Sub-contract with PIH to support facilities	29	\N	\N	t	2023-01-04 00:00:00	2022-12-04 00:00:00	2024-02-27 11:13:07.501122
4	OpenO2-PATH	OpenO2-PATH	Sub-contract with PATH to maintain oxygen concentrators	29	\N	\N	t	\N	2022-07-06 00:00:00	2024-02-27 11:13:07.508299
5	Malawi EMR Data Use	MEDU	CDC funded programs to improve the utilization of CDR data for decision making	11	\N	\N	t	\N	2022-09-30 00:00:00	2024-02-27 11:13:07.515366
6	Community Hypertension Project	BP Project	Project to improve management of hypertension through improved record keeping and communicatiin with nearest health center	28	\N	\N	t	\N	2022-01-01 00:00:00	2024-02-27 11:13:07.521951
8	Order Entry & Results Reporting	OERR	Project to improve availability and use of laboratory test results at the bedside	28	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.557577
9	Neonatal Oxygen Concentrator	NeoO2	Project to develop a neonatal oxygen concentrator	29	\N	\N	t	\N	2023-11-18 00:00:00	2024-02-27 11:13:07.569102
10	Ambulance Oxygen Concentrator	PO2C	Project to develop a portable oxygen concentrator for ambulances.	29	\N	\N	t	\N	2023-06-30 00:00:00	2024-02-27 11:13:07.580243
11	Crosscutting	Crosscutting	Umbrella container for all activities that are designed to benefit the entire organization	11	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.589871
12	GHII	GHII	Umbrella container for all core GHII activities	11	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.599089
13	AppHatchery	AppHatchery	Product Development program for Emory University	28	\N	\N	t	\N	2021-01-09 00:00:00	2024-02-27 11:13:07.60659
14	Neotree	Neotree	Implementation project for neotree in partnership with UCL and Neotree charity	28	\N	\N	t	\N	2022-09-21 00:00:00	2024-02-27 11:13:07.617117
15	Public Holiday	Public Holiday	Placeholder for all public holidays	39	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.625607
16	Annual Leave	Annual Leave	Placeholder for all annual leaves	39	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.639733
17	Paternity Leave	Paternity Leave	Placeholder for all paternity leaves	39	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.65043
18	Compassionate Leave	Compassionate Leave	Placeholder for all compassionate leaves	39	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.659922
19	Sick Leave	Sick Leave	Placeholder for all sick leaves	39	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.669661
20	Study Leave	Study Leave	Placeholder for all study leaves	39	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.680156
21	CAD/CAM Tools	GHII CNC CAD	Maintaining and Building tools for CAD and CAM	28	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.688222
22	Serial Communication project	Serial Comm	Proof of concept for serial communication	28	\N	\N	t	\N	2023-01-01 00:00:00	2024-02-27 11:13:07.697972
23	SINTHA-Malawi	SINTHA-Malawi	Implementation project for OpenO2 and OERR funded by EU	11	\N	\N	t	\N	2022-01-08 00:00:00	2024-02-27 11:13:07.705172
24	Health Informatics Assoc. of Malawi	HIAM	Administrative work for HIAM	39	\N	\N	t	2023-12-31 00:00:00	2023-08-23 00:00:00	2024-02-27 11:13:07.712693
25	Neotree-NIHR	Neotree-PE	Public engagement activities for neotree	28	\N	\N	t	\N	2023-01-12 00:00:00	2024-02-27 11:13:07.719644
26	GHII-Health Informatics Reference Implementation 	GHII-HIRI	Reference implementation for biomedical informatics interventions	28	\N	\N	t	\N	2024-01-01 00:00:00	2024-02-27 11:13:07.726854
27	Electronics Club	EC	Drop-in session to provide hands on electronics training	28	\N	\N	t	\N	2020-01-01 00:00:00	2024-02-27 11:13:07.736375
28	Compensatory Leave	Compensatory Leave	Placeholder for all compensatory leave	39	\N	\N	t	\N	2024-05-15 14:03:22.237572	2024-05-15 14:03:22.237572
29	Oxygen CoLab Innovation Support	Oxygen CoLab	Project for the further development of the Konza App	81	\N	\N	t	\N	2024-06-14 09:08:20.824229	2024-06-14 09:08:20.824229
7	Universal POCT Reader	UCR	Project to improve readability of point of care diagnostic tests	28	\N	\N	f	2023-09-29 00:00:00	2023-04-24 00:00:00	2025-01-08 07:42:39.308631
30	Maternity Leave	Maternity Leave	Placeholder for all maternity leave	39	\N	\N	t	\N	2025-04-22 12:46:06.480315	2025-04-22 12:46:06.480315
31	OpenSpO2	OpenSpO2	Assessmsnet and repair of pulse oximeters and patient monitors	6	\N	\N	t	\N	2025-05-19 13:48:46.162749	2025-05-19 13:48:46.162749
\.


--
-- Data for Name: purchase_request_attachments; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.purchase_request_attachments (id, requisition_id, voided, comments, created_at, updated_at, stakeholder_id, supplier, item_requested, requires_ipc) FROM stdin;
1	60	f	\N	2025-07-11 09:02:12.190067	2025-07-11 09:02:12.190067	2	\N	\N	f
2	61	f	\N	2025-07-14 06:40:46.054781	2025-07-14 06:40:46.054781	1	\N	\N	f
3	62	f	\N	2025-07-14 06:49:20.532684	2025-07-14 06:49:20.532684	2	\N	\N	f
5	64	f	\N	2025-07-14 07:45:17.524732	2025-07-14 07:45:17.524732	1	\N	\N	f
7	67	f	\N	2025-07-14 09:55:00.707742	2025-07-14 09:55:00.707742	1	\N	\N	f
9	70	f	\N	2025-07-15 13:20:38.7533	2025-07-15 13:31:39.821483	2	Chipiku	Chairs	f
8	69	f	\N	2025-07-15 12:51:39.489657	2025-07-15 14:13:59.473474	1	game	Laptops	f
6	66	f	\N	2025-07-14 08:17:26.48112	2025-07-17 09:09:16.348549	2	Toyota	\N	f
4	63	f	\N	2025-07-14 07:12:57.951694	2025-07-18 08:29:01.612463	1	Game	\N	f
11	75	f	\N	2025-07-18 09:22:35.43142	2025-07-18 09:53:37.91053	1	chipiku	BMW	f
12	76	f	\N	2025-07-18 10:45:03.737012	2025-07-18 11:43:45.711219	1	chipiku	work suits	f
13	77	f	\N	2025-07-18 10:47:00.154434	2025-07-18 12:39:11.048588	1	chipiku	Laptops	f
14	78	f	\N	2025-07-18 14:20:43.045095	2025-07-18 14:28:38.478285	1	chipiku	boots	f
10	71	f	\N	2025-07-15 14:10:06.664929	2025-07-21 06:30:50.961404	1	game	Chairs	f
16	80	f	\N	2025-07-21 08:05:28.718974	2025-07-21 08:05:28.718974	2	\N	extensions	f
18	82	f	\N	2025-07-21 08:16:03.095836	2025-07-21 08:16:03.095836	1	\N	thegfe	f
20	84	f	\N	2025-07-21 08:27:59.843229	2025-07-21 08:27:59.843229	1	\N	nbxj	f
23	87	f	\N	2025-07-21 08:56:24.864122	2025-07-21 08:56:24.864122	1	\N	hbsn	f
17	81	f	\N	2025-07-21 08:07:32.268318	2025-07-22 07:21:48.711469	1	TNM	yhe	f
25	89	f	\N	2025-07-23 09:21:45.039456	2025-07-23 09:21:45.039456	1	\N	Speakers	f
15	79	f	\N	2025-07-21 07:56:39.701968	2025-07-23 10:04:18.382382	2	chipiku	Laptop chargers	f
27	92	f	\N	2025-07-24 08:05:46.982148	2025-07-24 08:05:46.982148	2	\N	extensions	f
26	90	f	\N	2025-07-23 09:22:30.120871	2025-07-24 09:26:52.387502	2	chipiku	hgshs	f
19	83	f	\N	2025-07-21 08:26:21.055624	2025-07-24 09:37:15.769742	2	chipiku	bd	f
22	86	f	\N	2025-07-21 08:46:11.293054	2025-07-24 09:44:39.752683	1	chipiku	hsndb	f
29	94	f	\N	2025-07-25 06:28:19.537979	2025-07-25 07:04:46.240559	1	Radio Exchange	laptops	f
24	88	f	\N	2025-07-23 09:20:08.037164	2025-07-25 07:31:17.835447	2	Game	Fun	f
21	85	f	\N	2025-07-21 08:44:10.191566	2025-07-25 07:46:31.104431	2	Radio Exchange	the	f
30	96	f	\N	2025-07-26 16:21:02.079143	2025-07-26 16:21:02.079143	1	\N	Laptops	f
31	97	f	\N	2025-07-26 16:33:19.72095	2025-07-26 16:33:19.72095	2	\N	work suits	f
32	98	f	\N	2025-07-26 16:40:39.821656	2025-07-26 16:40:39.821656	2	\N	laptops	f
34	100	f	\N	2025-07-29 06:34:31.583351	2025-07-29 06:34:31.583351	1	\N	Chairs	f
35	101	f	\N	2025-07-29 08:17:47.635331	2025-07-29 08:17:47.635331	1	\N	Laptop	f
28	93	f	\N	2025-07-24 08:08:13.813748	2025-07-30 10:18:39.499628	1	chipiku	chairs	f
33	99	f	\N	2025-07-28 14:04:49.443729	2025-07-30 10:29:01.713258	1	game	BMW	f
37	107	f	\N	2025-07-30 12:52:06.379636	2025-07-30 12:52:06.379636	2	\N	Speakers	f
36	106	f	\N	2025-07-30 12:44:13.007063	2025-07-30 13:51:11.768641	1	chipiku	Laptop chargers	f
39	109	f	\N	2025-07-31 07:46:50.53201	2025-07-31 07:46:50.53201	1	\N	laptops	f
41	111	f	\N	2025-07-31 07:47:37.475218	2025-07-31 07:47:37.475218	1	\N	work suits	f
38	108	f	\N	2025-07-31 07:46:10.00864	2025-07-31 07:48:37.547621	1	chipiku	laptops	f
42	112	f	\N	2025-08-01 09:12:05.557281	2025-08-01 09:12:05.557281	2	\N	jombo	f
43	122	f	\N	2025-12-12 07:32:50.698872	2025-12-12 07:32:50.698872	1	\N	laptop	f
44	123	f	\N	2025-12-12 07:38:51.961596	2025-12-12 07:38:51.961596	1	\N	Laptop	f
45	124	f	\N	2025-12-12 08:15:55.953557	2025-12-12 08:15:55.953557	1	\N	Laptop	f
46	127	f	\N	2025-12-15 07:14:13.051952	2025-12-15 07:23:33.090169	1	M1 Electronics	Printer	f
40	110	f	\N	2025-07-31 07:47:14.799171	2025-12-15 07:44:39.123118	1	M1 Electronics	BMW	f
\.


--
-- Data for Name: report_statistics; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.report_statistics (statistic_id, period_start, period_end, period_label, statistic_description, statistic_value, created_at, updated_at) FROM stdin;
2	2021-07-01	2021-09-30	2021-Q3	Turnover Rate	0.0	2024-03-27 09:31:25.195243	2024-03-27 09:31:25.195243
3	2021-10-01	2021-12-31	2021-Q4	Retention Rate	0.0	2024-03-27 09:31:25.20162	2024-03-27 09:31:25.20162
4	2021-10-01	2021-12-31	2021-Q4	Turnover Rate	0.0	2024-03-27 09:31:25.205567	2024-03-27 09:31:25.205567
5	2022-01-01	2022-03-31	2022-Q1	Retention Rate	0.0	2024-03-27 09:31:25.215046	2024-03-27 09:31:25.215046
6	2022-01-01	2022-03-31	2022-Q1	Turnover Rate	0.0	2024-03-27 09:31:25.219796	2024-03-27 09:31:25.219796
7	2022-04-01	2022-06-30	2022-Q2	Retention Rate	0.0	2024-03-27 09:31:25.235092	2024-03-27 09:31:25.235092
8	2022-04-01	2022-06-30	2022-Q2	Turnover Rate	0.0	2024-03-27 09:31:25.242377	2024-03-27 09:31:25.242377
9	2022-07-01	2022-09-30	2022-Q3	Retention Rate	0.0	2024-03-27 09:31:25.252258	2024-03-27 09:31:25.252258
10	2022-07-01	2022-09-30	2022-Q3	Turnover Rate	0.0	2024-03-27 09:31:25.25797	2024-03-27 09:31:25.25797
11	2022-10-01	2022-12-31	2022-Q4	Retention Rate	0.0	2024-03-27 09:31:25.270317	2024-03-27 09:31:25.270317
12	2022-10-01	2022-12-31	2022-Q4	Turnover Rate	0.0	2024-03-27 09:31:25.275656	2024-03-27 09:31:25.275656
13	2023-01-01	2023-03-31	2023-Q1	Retention Rate	0.0	2024-03-27 09:31:25.283955	2024-03-27 09:31:25.283955
1	2021-07-01	2021-09-30	2021-Q3	Retention Rate	0.0	2024-03-27 09:31:25.190637	2024-10-18 07:33:18.830397
14	2023-01-01	2023-03-31	2023-Q1	Turnover Rate	0.0	2024-03-27 09:31:25.287899	2024-10-18 07:33:18.885471
15	2023-04-01	2023-06-30	2023-Q2	Retention Rate	0.0	2024-03-27 09:31:25.295502	2024-10-18 07:33:18.893052
16	2023-04-01	2023-06-30	2023-Q2	Turnover Rate	0.0	2024-03-27 09:31:25.303881	2024-10-18 07:33:18.897628
17	2023-07-01	2023-09-30	2023-Q3	Retention Rate	0.0	2024-03-27 09:31:25.310084	2024-10-18 07:33:18.904161
18	2023-07-01	2023-09-30	2023-Q3	Turnover Rate	0.0	2024-03-27 09:31:25.314629	2024-10-18 07:33:18.907572
19	2023-10-01	2023-12-31	2023-Q4	Retention Rate	0.0	2024-03-27 09:31:25.338025	2024-10-18 07:33:18.91354
20	2023-10-01	2023-12-31	2023-Q4	Turnover Rate	0.0	2024-03-27 09:31:25.34365	2024-10-18 07:33:18.918665
21	2024-01-01	2024-03-31	2024-Q1	Retention Rate	0.0	2024-03-27 09:31:25.352897	2024-10-18 07:33:18.924771
22	2024-01-01	2024-03-31	2024-Q1	Turnover Rate	0.0	2024-03-27 09:31:25.358117	2024-10-18 07:33:18.928677
23	2024-04-01	2024-06-30	2024-Q2	Retention Rate	0.0	2024-07-01 14:29:31.677251	2024-10-18 07:33:18.937486
24	2024-04-01	2024-06-30	2024-Q2	Turnover Rate	0.0	2024-07-01 14:29:31.681623	2024-10-18 07:33:18.941402
25	2024-07-01	2024-09-30	2024-Q3	Retention Rate	0.0	2024-10-18 07:33:18.94787	2024-10-18 07:33:18.94787
26	2024-07-01	2024-09-30	2024-Q3	Turnover Rate	0.0	2024-10-18 07:33:18.952547	2024-12-17 11:47:46.508164
27	2025-01-01	2025-03-31	2025-Q1	Retention Rate	0.0	2025-06-05 08:31:21.774204	2025-06-05 08:31:21.774204
28	2025-01-01	2025-03-31	2025-Q1	Turnover Rate	0.0	2025-06-05 08:31:21.780645	2025-06-05 08:31:21.780645
\.


--
-- Data for Name: requisition_items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.requisition_items (requisition_item_id, requisition_id, quantity, value, item_description, created_at, updated_at) FROM stdin;
1	1	1.0	0.0	Petty Cash	2024-10-07 12:22:06.273922	2024-10-07 12:22:06.273922
2	2	1.0	0.0	Petty Cash	2024-10-07 13:36:23.867818	2024-10-07 13:36:23.867818
3	3	1.0	0.0	Petty Cash	2024-10-09 08:38:09.755702	2024-10-09 08:38:09.755702
4	4	1.0	0.0	Petty Cash	2024-10-21 08:27:13.957391	2024-10-21 08:27:13.957391
5	5	1.0	0.0	Petty Cash	2024-10-22 14:16:38.863345	2024-10-22 14:16:38.863345
6	6	1.0	0.0	Petty Cash	2024-10-23 06:03:41.471727	2024-10-23 06:03:41.471727
7	7	1.0	0.0	Petty Cash	2024-10-23 06:11:20.073226	2024-10-23 06:11:20.073226
8	8	1.0	0.0	Petty Cash	2024-10-30 12:49:18.086303	2024-10-30 12:49:18.086303
9	9	1.0	0.0	Petty Cash	2024-11-07 08:05:30.192962	2024-11-07 08:05:30.192962
10	10	1.0	0.0	Petty Cash	2024-11-19 14:42:27.84701	2024-11-19 14:42:27.84701
11	11	1.0	0.0	Petty Cash	2024-11-26 12:58:04.594279	2024-11-26 12:58:04.594279
12	12	1.0	0.0	Petty Cash	2024-12-17 11:53:32.967799	2024-12-17 11:53:32.967799
13	13	1.0	0.0	Petty Cash	2024-12-17 11:54:17.908343	2024-12-17 11:54:17.908343
14	14	1.0	0.0	Petty Cash	2024-12-17 11:54:38.785157	2024-12-17 11:54:38.785157
15	15	1.0	0.0	Petty Cash	2025-04-24 06:51:54.692283	2025-04-24 06:51:54.692283
16	16	1.0	0.0	Petty Cash	2025-05-29 09:50:03.759739	2025-05-29 09:50:03.759739
17	17	1.0	0.0	Petty Cash	2025-06-02 11:56:02.287742	2025-06-02 11:56:02.287742
18	18	1.0	0.0	Petty Cash	2025-06-06 06:16:16.846581	2025-06-06 06:16:16.846581
19	19	1.0	0.0	Petty Cash	2025-06-06 06:48:16.224822	2025-06-06 06:48:16.224822
20	20	1.0	0.0	Petty Cash	2025-06-06 07:28:05.620924	2025-06-06 07:28:05.620924
21	21	1.0	0.0	Petty Cash	2025-06-06 07:51:53.849309	2025-06-06 07:51:53.849309
22	22	1.0	0.0	Petty Cash	2025-06-06 07:52:12.979071	2025-06-06 07:52:12.979071
23	23	1.0	0.0	Petty Cash	2025-06-06 07:58:36.017244	2025-06-06 07:58:36.017244
24	24	1.0	0.0	Petty Cash	2025-06-06 08:12:44.084547	2025-06-06 08:12:44.084547
25	25	1.0	0.0	Petty Cash	2025-06-06 12:56:57.510228	2025-06-06 12:56:57.510228
26	26	1.0	0.0	Petty Cash	2025-06-11 10:03:39.74084	2025-06-11 10:03:39.74084
27	27	1.0	0.0	Petty Cash	2025-06-11 11:51:36.045681	2025-06-11 11:51:36.045681
28	28	1.0	0.0	Petty Cash	2025-06-12 06:25:57.680878	2025-06-12 06:25:57.680878
29	29	1.0	0.0	Petty Cash	2025-06-12 06:38:11.597761	2025-06-12 06:38:11.597761
30	30	1.0	0.0	Petty Cash	2025-06-12 07:55:17.946756	2025-06-12 07:55:17.946756
31	31	1.0	0.0	Petty Cash	2025-06-16 06:52:08.567986	2025-06-16 06:52:08.567986
32	32	1.0	0.0	Petty Cash	2025-06-16 09:27:08.055363	2025-06-16 09:27:08.055363
33	33	1.0	0.0	Petty Cash	2025-06-16 09:27:47.379375	2025-06-16 09:27:47.379375
34	34	1.0	0.0	Petty Cash	2025-06-18 13:13:46.290837	2025-06-18 13:13:46.290837
35	35	1.0	0.0	Petty Cash	2025-06-18 13:14:41.231936	2025-06-18 13:14:41.231936
36	36	1.0	0.0	Petty Cash	2025-06-20 10:37:28.537432	2025-06-20 10:37:28.537432
37	37	1.0	0.0	Petty Cash	2025-06-23 06:13:22.214453	2025-06-23 06:13:22.214453
38	38	1.0	30000.0	Petty Cash	2025-07-02 14:33:21.329095	2025-07-02 14:33:21.329095
39	39	1.0	4000.0	Petty Cash	2025-07-03 07:42:43.478592	2025-07-03 07:42:43.478592
41	41	1.0	6000.0	Petty Cash	2025-07-08 09:23:21.14711	2025-07-08 09:23:21.14711
81	82	3.0	0.0	hgs	2025-07-21 08:16:03.068808	2025-07-21 08:16:03.068808
40	40	1.0	11000.0	Petty Cash	2025-07-03 07:45:24.147076	2025-07-08 09:35:36.113223
42	42	1.0	6000.0	Petty Cash	2025-07-08 10:01:59.390105	2025-07-08 10:01:59.390105
43	43	1.0	8000.0	Petty Cash	2025-07-08 10:02:35.989595	2025-07-08 10:02:35.989595
44	44	1.0	7000.0	Petty Cash	2025-07-08 10:08:56.647156	2025-07-08 10:08:56.647156
45	45	1.0	5000.0	Petty Cash	2025-07-08 10:09:22.20745	2025-07-08 10:09:22.20745
46	46	1.0	4000.0	Petty Cash	2025-07-08 10:10:38.474323	2025-07-08 10:10:38.474323
47	48	2.0	0.0	black work suits	2025-07-09 13:38:34.878481	2025-07-09 13:38:34.878481
48	49	2.0	0.0	Black 	2025-07-11 07:33:09.824875	2025-07-11 07:33:09.824875
49	50	3.0	0.0	Whatever	2025-07-11 07:34:04.622343	2025-07-11 07:34:04.622343
50	51	2.0	0.0	gaga	2025-07-11 07:35:21.52192	2025-07-11 07:35:21.52192
51	52	2.0	0.0	gegeh	2025-07-11 07:42:28.927377	2025-07-11 07:42:28.927377
52	53	3.0	0.0	gshsh	2025-07-11 07:50:16.108571	2025-07-11 07:50:16.108571
53	54	3.0	0.0	d cn\n	2025-07-11 08:02:22.553657	2025-07-11 08:02:22.553657
54	55	2.0	0.0	teheb	2025-07-11 08:04:02.536225	2025-07-11 08:04:02.536225
55	56	2.0	0.0	feth	2025-07-11 08:08:56.574158	2025-07-11 08:08:56.574158
56	57	1.0	45.0	Petty Cash	2025-07-11 08:41:20.671711	2025-07-11 08:41:20.671711
57	58	3.0	0.0	testing	2025-07-11 08:48:10.433898	2025-07-11 08:48:10.433898
58	59	3.0	0.0	litres	2025-07-11 08:53:56.70836	2025-07-11 08:53:56.70836
59	60	3.0	340000.0	gsjs	2025-07-11 09:02:12.13034	2025-07-11 10:13:39.799009
60	61	3.0	0.0	gshgs	2025-07-14 06:40:45.961762	2025-07-14 06:40:45.961762
61	62	3.0	0.0	the black one	2025-07-14 06:49:20.497162	2025-07-14 06:49:20.497162
63	64	3.0	0.0	VX	2025-07-14 07:45:17.500783	2025-07-14 07:45:17.500783
64	65	1.0	4000.0	Petty Cash	2025-07-14 07:47:44.19891	2025-07-14 07:47:44.19891
66	67	3.0	0.0	42 inche screen	2025-07-14 09:55:00.690027	2025-07-14 09:55:00.690027
69	70	2.0	300000.0	Arm rest	2025-07-15 13:20:38.740793	2025-07-15 13:31:39.8077
68	69	3.0	3000000.0	hp	2025-07-15 12:51:39.454192	2025-07-15 14:13:59.458384
65	66	2.0	400000.0	BMW and fortuner	2025-07-14 08:17:26.456562	2025-07-17 09:09:16.336421
71	72	1.0	4000.0	Petty Cash	2025-07-17 09:35:29.948591	2025-07-17 09:35:29.948591
72	73	1.0	7000.0	Petty Cash	2025-07-17 09:40:18.849705	2025-07-17 09:40:18.849705
73	74	1.0	20000.0	Petty Cash	2025-07-17 09:44:51.632768	2025-07-17 09:44:51.632768
62	63	2.0	4000000.0	Swivel Chair: Headrest, Arm Rest	2025-07-14 07:12:57.941252	2025-07-18 08:29:01.601807
74	75	2.0	40000000.0	Petrol engines	2025-07-18 09:22:35.406292	2025-07-18 09:53:37.886671
75	76	2.0	4000000.0	black suits	2025-07-18 10:45:03.721371	2025-07-18 11:43:45.693606
76	77	3.0	5000000.0	dell model\n	2025-07-18 10:47:00.139877	2025-07-18 12:39:11.031097
77	78	3.0	4000000.0	medium size	2025-07-18 14:20:43.032494	2025-07-18 14:28:38.465998
70	71	2.0	5000000.0	arm rest	2025-07-15 14:10:06.650382	2025-07-21 06:30:50.947859
83	84	3.0	0.0	djjs	2025-07-21 08:27:59.795733	2025-07-21 08:27:59.795733
86	87	2.0	0.0	xx	2025-07-21 08:56:24.823633	2025-07-21 08:56:24.823633
80	81	3.0	5000000.0	xx	2025-07-21 08:07:32.236299	2025-07-22 07:21:48.69689
79	80	3.0	2000000.0	2 meters with 5 sockets	2025-07-21 08:05:28.682269	2025-07-23 09:16:32.096872
78	79	3.0	500000.0	hp ones	2025-07-21 07:56:39.680765	2025-07-23 10:04:18.362695
90	91	1.0	3000.0	Petty Cash	2025-07-23 12:32:16.405102	2025-07-23 12:32:16.405102
91	92	3.0	0.0	2 metres long with 5 pots each	2025-07-24 08:05:46.966342	2025-07-24 08:05:46.966342
89	90	3.0	899990.0	hvshx	2025-07-23 09:22:30.115037	2025-07-24 09:26:52.370461
82	83	2.0	3000000.0	xnjs	2025-07-21 08:26:21.003495	2025-07-24 09:37:15.752126
85	86	3.0	30000000.0	hsjs	2025-07-21 08:46:11.234152	2025-07-24 09:44:39.717423
93	94	2.0	3500000.0	8GB RAM, 2TB SSD, 2.7GHz  i7 intel 	2025-07-25 06:28:19.526277	2025-07-25 07:04:46.223252
88	89	2.0	35000000.0	Upright speakers	2025-07-23 09:21:45.030705	2025-07-25 07:11:05.177091
87	88	3.0	400000.0	top mounted funs	2025-07-23 09:20:08.022923	2025-07-25 07:31:17.815172
84	85	2.0	50000000.0	hhx	2025-07-21 08:44:10.149284	2025-07-25 07:46:31.089773
94	95	1.0	6000.0	Petty Cash	2025-07-26 16:17:44.679023	2025-07-26 16:17:44.679023
95	96	3.0	0.0	good condition	2025-07-26 16:21:02.065235	2025-07-26 16:21:02.065235
96	97	3.0	0.0	black colour	2025-07-26 16:33:19.674033	2025-07-26 16:33:19.674033
97	98	2.0	4000000.0	The ahahs	2025-07-26 16:40:39.783231	2025-07-28 14:20:31.758046
100	101	2.0	0.0	4GB, 1TB, 3GHz	2025-07-29 08:17:47.624395	2025-07-29 08:17:47.624395
99	100	2.0	100000.0	Headrest and arm rest	2025-07-29 06:34:31.544642	2025-07-29 08:33:52.317148
101	102	1.0	5000.0	Petty Cash	2025-07-30 06:43:23.487462	2025-07-30 06:43:23.487462
102	103	1.0	10000.0	Petty Cash	2025-07-30 06:46:48.263989	2025-07-30 06:46:48.263989
98	99	3.0	7000000.0	2 exals	2025-07-28 14:04:49.431633	2025-07-30 10:29:01.695343
103	104	1.0	6000.0	Petty Cash	2025-07-30 07:55:13.665734	2025-07-30 07:55:13.665734
104	105	1.0	5000.0	Petty Cash	2025-07-30 08:01:54.911897	2025-07-30 08:01:54.911897
92	93	2.0	50000000.0	Wooden chairs	2025-07-24 08:08:13.803527	2025-07-30 10:18:39.486905
106	107	2.0	0.0	bluetooth speakers	2025-07-30 12:52:06.372855	2025-07-30 12:52:06.372855
105	106	3.0	50000000.0	wffe	2025-07-30 12:44:12.997141	2025-07-30 13:51:11.756892
108	109	3.0	0.0	rehe	2025-07-31 07:46:50.522141	2025-07-31 07:46:50.522141
110	111	2.0	0.0	teh	2025-07-31 07:47:37.46697	2025-07-31 07:47:37.46697
107	108	3.0	4000000.0	The v	2025-07-31 07:46:09.992705	2025-07-31 07:48:37.533487
111	112	3.0	0.0	Testing testing	2025-08-01 09:12:05.545787	2025-08-01 09:12:05.545787
121	122	1.0	0.0	dell laptos, C-type charger	2025-12-12 07:32:50.659057	2025-12-12 07:32:50.659057
122	123	2.0	0.0	dell laptos, Ctype charger 	2025-12-12 07:38:51.943158	2025-12-12 07:38:51.943158
123	124	2.0	0.0	dell laptops, Ctype charger	2025-12-12 08:15:55.9351	2025-12-12 08:15:55.9351
126	127	2.0	2000000.0	Zebra	2025-12-15 07:14:13.018682	2025-12-15 07:23:33.078377
109	110	1.0	3000000.0	teh	2025-07-31 07:47:14.789699	2025-12-15 07:44:39.104405
127	128	1.0	39998.0	Petty Cash	2025-12-16 12:54:38.234879	2025-12-16 12:54:38.234879
128	129	1.0	20000.0	Petty Cash	2025-12-16 12:56:54.415609	2025-12-16 12:56:54.415609
129	130	1.0	20000.0	Petty Cash	2025-12-16 13:10:03.387073	2025-12-16 13:10:03.387073
130	131	1.0	20000.0	Petty Cash	2025-12-16 13:17:59.959913	2025-12-16 13:17:59.959913
131	132	1.0	2000.0	Petty Cash	2025-12-16 13:43:40.21733	2025-12-16 13:43:40.21733
132	133	1.0	20000.0	Petty Cash	2025-12-17 06:14:31.831362	2025-12-17 06:14:31.831362
\.


--
-- Data for Name: requisition_notes; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.requisition_notes (id, requisition_id, user_id, note, voided, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: requisitions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.requisitions (requisition_id, purpose, initiated_by, initiated_on, requisition_type, reviewed_by, approved_by, workflow_state_id, voided, created_at, updated_at, project_id, department_id) FROM stdin;
3	Airtime for project router	38	2024-10-09 00:00:00	Petty Cash	\N	\N	23	t	2024-10-09 08:38:09.736753	2024-10-11 13:07:39.870338	26	\N
5	Lunch allowance for 2 external actors at KCH for a Pumani CPAP teardown Video	45	2024-10-22 00:00:00	Petty Cash	\N	\N	23	t	2024-10-22 14:16:38.859546	2024-10-22 14:32:00.087165	2	\N
4	Purchase of internet bundles for KCH and PHCs	74	2024-10-21 00:00:00	Petty Cash	\N	\N	23	t	2024-10-21 08:27:13.95163	2024-10-29 08:36:33.02632	14	\N
8	To Print Patient Receipt on the Wandikweza Billing System	28	2024-10-30 00:00:00	Petty Cash	\N	\N	23	t	2024-10-30 12:49:18.081599	2024-10-30 13:19:46.574875	26	\N
6	Router airtime foe the director	66	2024-10-23 00:00:00	Petty Cash	\N	\N	23	t	2024-10-23 06:03:41.468054	2024-11-04 06:32:37.074457	2	\N
14	Supper for Jones while working on Reporting pipeline	35	2024-12-17 00:00:00	Petty Cash	\N	\N	23	t	2024-12-17 11:54:38.782076	2024-12-17 12:10:30.922777	5	\N
12	Supper for Pistone and Timothy while working on Reporting pipeline	35	2024-12-17 00:00:00	Petty Cash	\N	\N	23	t	2024-12-17 11:53:32.964159	2024-12-17 12:10:36.921187	5	\N
13	Supper for Peter and Willie while working on Reporting pipeline	35	2024-12-17 00:00:00	Petty Cash	\N	\N	23	t	2024-12-17 11:54:17.904315	2024-12-17 12:10:42.524008	5	\N
11	Airtime for Internet bundles for Neotree sites; KCH, Kabudula and Lumbadzi	92	2024-11-26 00:00:00	Petty Cash	\N	\N	23	t	2024-11-26 12:58:04.590642	2025-01-17 09:04:53.407661	14	\N
1	Airtime for office Phone	62	2024-10-07 00:00:00	Petty Cash	\N	\N	23	t	2024-10-07 12:22:06.249254	2025-04-14 12:56:47.370011	12	\N
19	Testing for official email	80	2025-06-06 00:00:00	Petty Cash	28	\N	23	t	2025-06-06 06:48:16.220741	2025-06-11 09:40:58.621919	12	\N
17	Testing Petty Cash	80	2025-06-02 00:00:00	Petty Cash	28	\N	23	t	2025-06-02 11:56:02.271264	2025-06-11 09:51:27.221018	12	\N
104	Testing admin part further	62	2025-07-30 00:00:00	Petty Cash	39	62	36	f	2025-07-30 07:55:13.660197	2025-07-30 08:05:43.816076	1	\N
57	fwf	80	2025-07-11 00:00:00	Petty Cash	28	\N	23	t	2025-07-11 08:41:20.654445	2025-07-30 12:43:11.333332	1	\N
106	used by intern for open O2	80	2025-07-30 00:00:00	Purchase Request	28	62	42	f	2025-07-30 12:44:12.982882	2025-07-30 13:51:11.733962	\N	4
111	Fouth	108	2025-07-31 00:00:00	Purchase Request	\N	\N	37	f	2025-07-31 07:47:37.444696	2025-07-31 07:47:37.444696	\N	4
108	Testing the modal	108	2025-07-31 00:00:00	Purchase Request	28	62	42	f	2025-07-31 07:46:09.964618	2025-07-31 07:48:37.51525	\N	4
109	Another modal testing	108	2025-07-31 00:00:00	Purchase Request	28	\N	41	f	2025-07-31 07:46:50.511996	2025-07-31 09:29:02.113645	\N	4
112	Check for pending description	80	2025-08-01 00:00:00	Purchase Request	\N	\N	50	f	2025-08-01 09:12:05.528172	2025-08-01 09:24:39.38837	\N	3
58	gsejj	80	2025-07-11 00:00:00	Purchase Request	28	\N	50	f	2025-07-11 08:48:10.414887	2025-08-01 09:48:01.061372	\N	1
46	Mailing	80	2025-07-08 00:00:00	Petty Cash	28	62	27	f	2025-07-08 10:10:38.468206	2025-07-14 08:00:20.313195	1	\N
60	further testing	108	2025-07-11 00:00:00	Purchase Request	28	62	44	f	2025-07-11 09:02:12.056389	2025-07-24 10:05:47.330204	\N	2
127	Patient Registration	80	2025-12-15 00:00:00	Purchase Request	28	62	49	f	2025-12-15 07:14:12.995984	2025-12-15 07:32:25.099846	\N	2
110	Until it works	108	2025-07-31 00:00:00	Purchase Request	28	62	42	f	2025-07-31 07:47:14.774776	2025-12-15 07:44:39.090458	\N	3
123	bdn	80	2025-12-12 00:00:00	Purchase Request	28	\N	39	f	2025-12-12 07:38:51.922731	2025-12-15 08:28:27.433669	\N	2
128	Buy fuel	80	2025-12-16 00:00:00	Petty Cash	\N	\N	22	f	2025-12-16 12:54:38.193618	2025-12-16 12:54:38.193618	1	\N
129	Buy fuel	80	2025-12-16 00:00:00	Petty Cash	\N	\N	22	f	2025-12-16 12:56:54.401435	2025-12-16 12:56:54.401435	1	\N
131	Buy fuel	80	2025-12-16 00:00:00	Petty Cash	\N	\N	22	f	2025-12-16 13:17:59.941254	2025-12-16 13:17:59.941254	1	\N
133	Buy fuel	80	2025-12-17 00:00:00	Petty Cash	\N	\N	22	f	2025-12-17 06:14:31.776607	2025-12-17 06:14:31.776607	1	\N
48	Buying microphone	108	2025-07-09 00:00:00	Purchase Request	28	\N	39	f	2025-07-09 13:38:34.829163	2025-07-11 09:03:17.741179	\N	3
49	Buying microphone	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 07:33:09.781899	2025-07-11 09:03:27.120745	\N	2
50	Buying microphone	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 07:34:04.608868	2025-07-11 09:03:34.90614	\N	5
51	Buying microphone	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 07:35:21.507166	2025-07-11 09:03:42.648775	\N	3
52	Buying microphone	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 07:42:28.907285	2025-07-11 09:03:49.875015	\N	2
53	further testing	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 07:50:16.093897	2025-07-11 09:04:20.182051	\N	3
54	xxgn	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 08:02:22.534904	2025-07-11 09:04:31.055749	\N	3
55	Buy fuel	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 08:04:02.517887	2025-07-11 09:04:39.45951	\N	2
56	Buying microphone	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 08:08:56.538883	2025-07-11 09:04:51.124949	\N	3
61	Buying microphone	108	2025-07-14 00:00:00	Purchase Request	28	\N	39	f	2025-07-14 06:40:45.940998	2025-07-14 07:50:50.948023	\N	2
2	with purpose: URLLZV	28	2024-10-07 00:00:00	Petty Cash	11	62	27	t	2024-10-07 13:36:23.863192	2025-06-24 12:38:47.04845	8	\N
59	Buy fuel	108	2025-07-11 00:00:00	Purchase Request	28	\N	39	f	2025-07-11 08:53:56.689572	2025-07-14 06:49:54.45782	\N	3
105	further testing	62	2025-07-30 00:00:00	Petty Cash	\N	\N	22	f	2025-07-30 08:01:54.900751	2025-07-30 08:01:54.900751	1	\N
89	used on lunch hour	80	2025-07-23 00:00:00	Purchase Request	28	62	50	f	2025-07-23 09:21:45.01189	2025-08-01 09:49:12.90477	\N	3
107	used on lunch hour	80	2025-07-30 00:00:00	Purchase Request	28	\N	38	f	2025-07-30 12:52:06.357687	2025-07-31 07:36:06.210285	\N	3
75	used by openO2 projects	108	2025-07-18 00:00:00	Purchase Request	28	62	44	f	2025-07-18 09:22:35.390086	2025-07-25 09:24:51.446944	\N	4
65	Buying microphone	108	2025-07-14 00:00:00	Petty Cash	\N	\N	23	f	2025-07-14 07:47:44.170138	2025-07-14 07:48:43.285627	1	\N
64	for project demonstration 	108	2025-07-14 00:00:00	Purchase Request	28	\N	39	f	2025-07-14 07:45:17.458662	2025-07-14 07:51:48.63222	\N	2
7	with purpose: YLSYFM	45	2024-10-23 00:00:00	Petty Cash	\N	\N	22	t	2024-10-23 06:11:20.069825	2025-06-24 12:38:47.057422	2	\N
9	with purpose: OPGOAQ	45	2024-11-07 00:00:00	Petty Cash	\N	\N	22	t	2024-11-07 08:05:30.188371	2025-06-24 12:38:47.063841	2	\N
10	with purpose: MGMYUX	36	2024-11-19 00:00:00	Petty Cash	28	62	36	t	2024-11-19 14:42:27.842765	2025-06-24 12:38:47.069786	1	\N
15	with purpose: CJXGTZ	95	2025-04-24 00:00:00	Petty Cash	39	\N	24	t	2025-04-24 06:51:54.68678	2025-07-08 09:58:05.689274	14	\N
16	with purpose: IJATVW	112	2025-05-29 00:00:00	Petty Cash	\N	\N	22	t	2025-05-29 09:50:03.744612	2025-06-24 12:38:47.079959	23	\N
18	with purpose: KARTGM	28	2025-06-06 00:00:00	Petty Cash	11	62	27	t	2025-06-06 06:16:16.841415	2025-06-24 12:38:47.086438	8	\N
20	with purpose: NQVKOI	28	2025-06-06 00:00:00	Petty Cash	0	\N	36	t	2025-06-06 07:28:05.616819	2025-06-24 12:38:47.096302	8	\N
21	with purpose: JRIDJU	2	2025-06-06 00:00:00	Petty Cash	0	62	36	t	2025-06-06 07:51:53.844255	2025-06-24 12:38:47.106551	1	\N
22	with purpose: ZTSCRN	102	2025-06-06 00:00:00	Petty Cash	96	62	36	t	2025-06-06 07:52:12.97496	2025-06-24 12:38:47.114418	14	\N
23	with purpose: YZZBLI	40	2025-06-06 00:00:00	Petty Cash	33	\N	36	t	2025-06-06 07:58:36.012966	2025-06-24 12:38:47.12455	5	\N
24	with purpose: SSKUGP	27	2025-06-06 00:00:00	Petty Cash	0	11	27	t	2025-06-06 08:12:44.080527	2025-06-24 12:38:47.131644	5	\N
25	with purpose: LQQGTR	2	2025-06-06 00:00:00	Petty Cash	0	\N	36	t	2025-06-06 12:56:57.505135	2025-06-24 12:38:47.14513	1	\N
26	with purpose: RASRVU	62	2025-06-11 00:00:00	Petty Cash	0	11	29	t	2025-06-11 10:03:39.735786	2025-06-24 12:38:47.154316	12	\N
27	with purpose: MOBDWJ	28	2025-06-11 00:00:00	Petty Cash	0	\N	36	t	2025-06-11 11:51:36.041522	2025-06-24 12:38:47.162219	8	\N
28	with purpose: THUQGC	76	2025-06-12 00:00:00	Petty Cash	\N	\N	26	t	2025-06-12 06:25:57.676082	2025-06-24 12:38:47.170309	23	\N
29	with purpose: ZFWYCS	2	2025-06-12 00:00:00	Petty Cash	0	\N	36	t	2025-06-12 06:38:11.59412	2025-06-24 12:38:47.178858	1	\N
30	with purpose: EWMULQ	76	2025-06-12 00:00:00	Petty Cash	\N	\N	22	t	2025-06-12 07:55:17.938979	2025-06-24 12:38:47.186715	23	\N
31	with purpose: JYPQYU	62	2025-06-16 00:00:00	Petty Cash	39	\N	24	t	2025-06-16 06:52:08.562719	2025-07-08 09:09:58.513725	5	\N
32	with purpose: LPPQSX	58	2025-06-16 00:00:00	Petty Cash	0	\N	36	t	2025-06-16 09:27:08.050599	2025-06-24 12:38:47.201875	5	\N
33	with purpose: PVIQBG	58	2025-06-16 00:00:00	Petty Cash	8	62	36	t	2025-06-16 09:27:47.375148	2025-06-24 12:38:47.210455	5	\N
34	with purpose: PPNCVY	58	2025-06-18 00:00:00	Petty Cash	8	62	27	t	2025-06-18 13:13:46.286484	2025-06-24 12:38:47.216576	5	\N
35	with purpose: KWYMAE	58	2025-06-18 00:00:00	Petty Cash	8	62	36	t	2025-06-18 13:14:41.228021	2025-06-24 12:38:47.226349	5	\N
36	with purpose: OPHMBK	28	2025-06-20 00:00:00	Petty Cash	0	11	36	t	2025-06-20 10:37:28.530913	2025-07-03 07:49:33.10874	26	\N
37	with purpose: YKTWSZ	94	2025-06-23 00:00:00	Petty Cash	74	\N	24	t	2025-06-23 06:13:22.208436	2025-06-24 12:38:47.243731	14	\N
38	Buy extensition	108	2025-07-02 00:00:00	Petty Cash	28	62	36	t	2025-07-02 14:33:21.295996	2025-07-03 07:49:02.651113	12	\N
39	new database	80	2025-07-03 00:00:00	Petty Cash	28	62	27	t	2025-07-03 07:42:43.463741	2025-07-03 07:49:52.12216	1	\N
40	Beha	108	2025-07-03 00:00:00	Petty Cash	28	\N	24	t	2025-07-03 07:45:24.141699	2025-07-08 09:44:13.186642	3	\N
41	further testing	62	2025-07-08 00:00:00	Petty Cash	39	\N	24	t	2025-07-08 09:23:21.135622	2025-07-08 09:50:02.314348	1	\N
42	Admin email testing	108	2025-07-08 00:00:00	Petty Cash	28	\N	24	t	2025-07-08 10:01:59.38009	2025-07-08 10:03:11.649569	1	\N
43	test 2	108	2025-07-08 00:00:00	Petty Cash	28	\N	24	t	2025-07-08 10:02:35.979563	2025-07-08 10:04:40.321298	1	\N
44	Hardcode resolve	80	2025-07-08 00:00:00	Petty Cash	28	\N	24	t	2025-07-08 10:08:56.637669	2025-07-08 10:17:17.739042	1	\N
45	hardcode	80	2025-07-08 00:00:00	Petty Cash	28	\N	26	t	2025-07-08 10:09:22.197816	2025-07-11 09:04:07.514524	1	\N
62	Buying microphone	108	2025-07-14 00:00:00	Purchase Request	28	62	47	f	2025-07-14 06:49:20.444346	2025-07-30 14:14:11.99293	\N	3
66	Used by intern	108	2025-07-14 00:00:00	Purchase Request	28	62	44	f	2025-07-14 08:17:26.429865	2025-07-26 16:16:29.684512	\N	3
83	js	80	2025-07-21 00:00:00	Purchase Request	28	62	43	f	2025-07-21 08:26:20.965001	2025-07-30 08:53:28.270074	\N	2
88	used in conference room	80	2025-07-23 00:00:00	Purchase Request	28	62	43	f	2025-07-23 09:20:08.002832	2025-07-30 08:53:47.929729	\N	3
74	buy drinks	108	2025-07-17 00:00:00	Petty Cash	28	62	36	f	2025-07-17 09:44:51.625907	2025-07-17 09:48:05.796347	1	\N
76	for openO2	80	2025-07-18 00:00:00	Purchase Request	28	62	50	f	2025-07-18 10:45:03.696635	2025-08-01 09:51:58.044548	\N	3
78	used by intern for open O2	28	2025-07-18 00:00:00	Purchase Request	11	62	44	f	2025-07-18 14:20:43.008714	2025-07-26 16:16:51.604938	\N	2
71	used by informatics interns	28	2025-07-15 00:00:00	Purchase Request	11	62	44	f	2025-07-15 14:10:06.624852	2025-07-24 12:43:04.517171	\N	3
72	Buy plain papers	108	2025-07-17 00:00:00	Petty Cash	28	62	36	f	2025-07-17 09:35:29.909704	2025-07-18 10:47:47.459691	1	\N
69	used by informatics interns	108	2025-07-15 00:00:00	Purchase Request	28	62	44	f	2025-07-15 12:51:39.388555	2025-07-28 08:40:00.679589	\N	2
73	Buy fuel	28	2025-07-17 00:00:00	Petty Cash	11	11	36	f	2025-07-17 09:40:18.836605	2025-07-18 10:48:02.939081	1	\N
67	Show casing the project	108	2025-07-14 00:00:00	Purchase Request	28	62	44	f	2025-07-14 09:55:00.665328	2025-07-25 12:07:33.184591	\N	3
81	bs	80	2025-07-21 00:00:00	Purchase Request	28	62	50	f	2025-07-21 08:07:32.187261	2025-08-01 09:49:30.436295	\N	4
86	jjs	80	2025-07-21 00:00:00	Purchase Request	28	62	43	f	2025-07-21 08:46:11.180528	2025-07-30 12:06:37.529714	\N	4
84	jsks	80	2025-07-21 00:00:00	Purchase Request	28	62	43	f	2025-07-21 08:27:59.753111	2025-07-25 12:08:01.827262	\N	2
79	used by newly recruited individuals	80	2025-07-21 00:00:00	Purchase Request	28	62	49	f	2025-07-21 07:56:39.660883	2025-07-30 09:06:56.335843	\N	2
87	gshw	80	2025-07-21 00:00:00	Purchase Request	28	\N	50	f	2025-07-21 08:56:24.783774	2025-08-01 09:48:14.508331	\N	3
77	for wandikweza intern	80	2025-07-18 00:00:00	Purchase Request	28	62	50	f	2025-07-18 10:47:00.120742	2025-08-01 09:52:17.002086	\N	3
85	xhjxj	80	2025-07-21 00:00:00	Purchase Request	28	62	43	f	2025-07-21 08:44:10.092787	2025-07-28 14:08:23.440929	\N	5
103	Buy fuel	62	2025-07-30 00:00:00	Petty Cash	39	62	36	f	2025-07-30 06:46:48.249794	2025-07-30 07:53:45.261788	1	\N
91	chan	80	2025-07-23 00:00:00	Petty Cash	28	62	36	f	2025-07-23 12:32:16.358954	2025-07-24 07:20:40.793713	1	\N
80	used by intern for open O2	80	2025-07-21 00:00:00	Purchase Request	28	62	43	f	2025-07-21 08:05:28.641114	2025-07-30 08:53:18.038943	\N	2
63	Used by intern	108	2025-07-14 00:00:00	Purchase Request	28	62	43	f	2025-07-14 07:12:57.927136	2025-07-24 10:05:26.166112	\N	3
82	hss s	80	2025-07-21 00:00:00	Purchase Request	28	\N	49	f	2025-07-21 08:16:03.029372	2025-07-30 10:28:12.886264	\N	4
94	Used by interns	108	2025-07-25 00:00:00	Purchase Request	28	62	44	f	2025-07-25 06:28:19.493093	2025-07-25 12:04:01.475509	\N	3
99	used by employees lives from a far	108	2025-07-28 00:00:00	Purchase Request	28	62	42	f	2025-07-28 14:04:49.415204	2025-07-30 10:29:01.679404	\N	2
95	Thobwa	108	2025-07-26 00:00:00	Petty Cash	\N	\N	22	f	2025-07-26 16:17:44.662353	2025-07-26 16:17:44.662353	1	\N
96	used by informatics interns	108	2025-07-26 00:00:00	Purchase Request	28	\N	39	f	2025-07-26 16:21:02.047585	2025-07-28 14:10:47.599947	\N	3
93	For set up of new office	80	2025-07-24 00:00:00	Purchase Request	28	62	43	f	2025-07-24 08:08:13.78915	2025-07-30 12:10:37.332263	\N	2
98	used by informatics interns	108	2025-07-26 00:00:00	Purchase Request	28	62	43	f	2025-07-26 16:40:39.721338	2025-07-30 12:13:40.654725	\N	4
97	Used by intern	108	2025-07-26 00:00:00	Purchase Request	28	62	46	f	2025-07-26 16:33:19.638919	2025-07-29 07:27:19.752702	\N	3
70	used by appHatchery department	108	2025-07-15 00:00:00	Purchase Request	28	62	47	f	2025-07-15 13:20:38.719372	2025-07-30 13:54:07.413645	\N	4
101	used by appHatchery department	108	2025-07-29 00:00:00	Purchase Request	28	\N	38	f	2025-07-29 08:17:47.611391	2025-07-31 07:36:16.585452	\N	3
92	Used in comference room	80	2025-07-24 00:00:00	Purchase Request	28	\N	50	f	2025-07-24 08:05:46.948596	2025-08-01 09:47:11.354064	\N	3
100	Used for informatics department	108	2025-07-29 00:00:00	Purchase Request	28	62	43	f	2025-07-29 06:34:31.499654	2025-07-29 08:35:29.507145	\N	3
90	gbd	80	2025-07-23 00:00:00	Purchase Request	28	62	50	f	2025-07-23 09:22:30.095298	2025-08-01 09:49:42.2097	\N	3
102	Testing self approve	62	2025-07-30 00:00:00	Petty Cash	39	62	36	f	2025-07-30 06:43:23.465771	2025-07-30 06:44:49.940768	1	\N
122	bdn	80	2025-12-12 00:00:00	Purchase Request	\N	\N	50	f	2025-12-12 07:32:50.623316	2025-12-12 07:37:57.650101	\N	3
124	bdn	80	2025-12-12 00:00:00	Purchase Request	\N	\N	37	f	2025-12-12 08:15:55.915659	2025-12-12 08:15:55.915659	\N	1
130	Buy fuel	80	2025-12-16 00:00:00	Petty Cash	\N	\N	22	f	2025-12-16 13:10:03.35325	2025-12-16 13:10:03.35325	12	\N
132	Buy fuel	80	2025-12-16 00:00:00	Petty Cash	\N	\N	22	f	2025-12-16 13:43:40.182587	2025-12-16 13:43:40.182587	1	\N
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.schema_migrations (version) FROM stdin;
20230503052510
20230503052539
20230503052550
20230503052607
20230503052626
20230503052646
20230503052655
20230503052705
20230503052712
20230503052719
20230503052726
20230503052735
20230503052742
20230503054319
20230503054348
20230503054357
20230503054411
20230824183057
20230917175715
20230927095336
20231106090654
20231214200504
20231216071011
20240105062015
20240105062428
20240105070344
20240105070905
20240112104007
20240315124907
20240324144057
20240418094817
20240418094827
20240418094836
20240418132946
20240418133311
20240314090216
20240314090635
20240314102724
20240710072853
20240711123623
20240711131049
20240730071915
20240816090805
20241007064220
20250610143533
20250630082347
20250630141207
20250701070117
20250701084304
20250616133736
20250616134335
20250619124922
20250620072307
20250626125755
20250715124557
20250716140635
20250721074333
20250804085317
\.


--
-- Data for Name: stakeholders; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.stakeholders (stakeholder_id, stakeholder_name, contact_email, is_partner, is_donor, donation_frequency, partnership_tier, voided, created_at, updated_at) FROM stdin;
1	USAID	usaid@gmail.com	f	t	annually	\N	f	2025-07-09 08:19:05.862663	2025-07-09 08:19:05.862663
2	UNHCR	unhcr@gmail.com	f	t	quarterly	\N	f	2025-07-09 08:19:05.865415	2025-07-09 08:19:05.865415
3	UNIMA	unima.ac.mw	t	f	\N	silver	f	2025-07-09 08:19:05.866816	2025-07-09 08:19:05.866816
4	KCH	kch@gmail.com	t	f	\N	gold	f	2025-07-09 08:19:05.868978	2025-07-09 08:19:05.868978
\.


--
-- Data for Name: supervisions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.supervisions (supervision_id, supervisor, supervisee, started_on, ended_on, is_terminated, created_at, updated_at) FROM stdin;
1	39	1	2023-01-03	\N	f	2024-02-27 11:13:06.636226	2024-02-27 11:13:06.636226
3	8	3	2022-11-28	\N	f	2024-02-27 11:13:06.665022	2024-02-27 11:13:06.665022
4	33	4	2022-11-28	\N	f	2024-02-27 11:13:06.678159	2024-02-27 11:13:06.678159
5	29	5	2023-04-03	\N	f	2024-02-27 11:13:06.688708	2024-02-27 11:13:06.688708
7	39	7	2021-10-29	\N	f	2024-02-27 11:13:06.708051	2024-02-27 11:13:06.708051
8	11	8	2022-10-01	\N	f	2024-02-27 11:13:06.716637	2024-02-27 11:13:06.716637
9	8	9	2022-11-28	\N	f	2024-02-27 11:13:06.726969	2024-02-27 11:13:06.726969
10	7	10	2022-09-26	\N	f	2024-02-27 11:13:06.740919	2024-02-27 11:13:06.740919
12	29	13	2023-04-03	\N	f	2024-02-27 11:13:06.77027	2024-02-27 11:13:06.77027
13	29	14	2022-10-10	\N	f	2024-02-27 11:13:06.785633	2024-02-27 11:13:06.785633
14	28	15	2023-01-01	\N	f	2024-02-27 11:13:06.798449	2024-02-27 11:13:06.798449
15	29	16	2022-08-29	\N	f	2024-02-27 11:13:06.807838	2024-02-27 11:13:06.807838
16	29	17	2021-10-01	\N	f	2024-02-27 11:13:06.818543	2024-02-27 11:13:06.818543
17	29	18	2023-04-11	\N	f	2024-02-27 11:13:06.84649	2024-02-27 11:13:06.84649
18	29	19	2023-04-11	\N	f	2024-02-27 11:13:06.859985	2024-02-27 11:13:06.859985
19	28	20	2023-01-01	\N	f	2024-02-27 11:13:06.871981	2024-02-27 11:13:06.871981
20	28	21	2023-06-19	\N	f	2024-02-27 11:13:06.884302	2024-02-27 11:13:06.884302
21	7	22	2021-11-01	\N	f	2024-02-27 11:13:06.893394	2024-02-27 11:13:06.893394
22	11	23	2023-02-20	\N	f	2024-02-27 11:13:06.902595	2024-02-27 11:13:06.902595
23	8	24	2022-11-28	\N	f	2024-02-27 11:13:06.9122	2024-02-27 11:13:06.9122
24	29	25	2023-03-02	\N	f	2024-02-27 11:13:06.921219	2024-02-27 11:13:06.921219
25	28	26	2023-03-08	\N	f	2024-02-27 11:13:06.934032	2024-02-27 11:13:06.934032
26	8	27	2022-11-28	\N	f	2024-02-27 11:13:06.945936	2024-02-27 11:13:06.945936
27	11	28	2022-06-27	\N	f	2024-02-27 11:13:06.959287	2024-02-27 11:13:06.959287
29	29	30	2022-10-10	\N	f	2024-02-27 11:13:06.986129	2024-02-27 11:13:06.986129
30	28	31	2023-01-01	\N	f	2024-02-27 11:13:06.999347	2024-02-27 11:13:06.999347
32	11	33	2022-10-01	\N	f	2024-02-27 11:13:07.020373	2024-02-27 11:13:07.020373
33	39	34	2023-01-03	\N	f	2024-02-27 11:13:07.04033	2024-02-27 11:13:07.04033
34	33	35	2022-11-28	\N	f	2024-02-27 11:13:07.051038	2024-02-27 11:13:07.051038
35	11	36	2022-05-26	\N	f	2024-02-27 11:13:07.06306	2024-02-27 11:13:07.06306
37	28	38	2022-09-05	\N	f	2024-02-27 11:13:07.088675	2024-02-27 11:13:07.088675
39	33	40	2022-11-28	\N	f	2024-02-27 11:13:07.112554	2024-02-27 11:13:07.112554
41	28	42	2023-03-07	\N	f	2024-02-27 11:13:07.142863	2024-02-27 11:13:07.142863
42	28	43	2022-08-01	\N	f	2024-02-27 11:13:07.15392	2024-02-27 11:13:07.15392
43	29	44	2023-07-03	\N	f	2024-02-27 11:13:07.164156	2024-02-27 11:13:07.164156
44	29	45	2023-08-21	\N	f	2024-02-27 11:13:07.177094	2024-02-27 11:13:07.177094
45	11	46	2023-06-06	\N	f	2024-02-27 11:13:07.187003	2024-02-27 11:13:07.187003
46	29	47	2023-07-03	\N	f	2024-02-27 11:13:07.196043	2024-02-27 11:13:07.196043
47	29	48	2023-01-18	\N	f	2024-02-27 11:13:07.20431	2024-02-27 11:13:07.20431
48	28	49	2023-09-11	\N	f	2024-02-27 11:13:07.212533	2024-02-27 11:13:07.212533
49	28	50	2023-09-25	\N	f	2024-02-27 11:13:07.220209	2024-02-27 11:13:07.220209
54	8	55	2023-11-27	\N	f	2024-02-27 11:13:07.272404	2024-02-27 11:13:07.272404
55	8	56	2023-11-27	\N	f	2024-02-27 11:13:07.282246	2024-02-27 11:13:07.282246
56	43	57	2023-11-27	\N	f	2024-02-27 11:13:07.29106	2024-02-27 11:13:07.29106
57	8	58	2023-12-18	\N	f	2024-02-27 11:13:07.300569	2024-02-27 11:13:07.300569
58	33	59	2023-12-11	\N	f	2024-02-27 11:13:07.309105	2024-02-27 11:13:07.309105
59	8	60	2024-01-02	\N	f	2024-02-27 11:13:07.317319	2024-02-27 11:13:07.317319
61	39	62	2024-01-29	\N	f	2024-02-27 11:13:07.339969	2024-02-27 11:13:07.339969
62	39	63	2024-01-29	\N	f	2024-02-27 11:13:07.349613	2024-02-27 11:13:07.349613
63	28	64	2024-02-07	\N	f	2024-02-27 11:13:07.358921	2024-02-27 11:13:07.358921
64	39	65	2024-01-30	\N	f	2024-02-27 11:13:07.370689	2024-02-27 11:13:07.370689
65	29	66	2024-01-22	\N	f	2024-02-27 11:13:07.380066	2024-02-27 11:13:07.380066
66	28	67	2023-01-01	\N	f	2024-02-27 11:13:07.389559	2024-02-27 11:13:07.389559
67	39	68	2022-04-28	\N	f	2024-02-27 11:13:07.398187	2024-02-27 11:13:07.398187
68	39	69	2024-02-08	\N	f	2024-02-27 11:13:07.405923	2024-02-27 11:13:07.405923
69	28	70	2024-02-20	\N	f	2024-02-27 11:13:07.414304	2024-02-27 11:13:07.414304
70	28	71	2024-02-20	\N	f	2024-02-27 11:13:07.436465	2024-02-27 11:13:07.436465
71	39	72	2024-02-21	\N	f	2024-02-27 11:13:07.450626	2024-02-27 11:13:07.450626
72	39	73	2024-03-06	\N	f	2024-03-15 10:30:20.681767	2024-03-15 10:30:20.681767
73	6	37	2024-03-06	\N	f	2024-03-26 05:59:19.245717	2024-03-26 05:59:19.245717
36	29	37	2021-10-01	2024-03-05	t	2024-02-27 11:13:07.074058	2024-03-26 05:59:38.23724
2	29	2	2021-10-01	2024-03-05	t	2024-02-27 11:13:06.649665	2024-03-26 06:01:24.904092
74	6	2	2024-03-06	\N	f	2024-03-26 06:01:44.141726	2024-03-26 06:01:44.141726
50	37	51	2023-10-17	\N	f	2024-02-27 11:13:07.229327	2024-03-26 06:08:38.157299
51	37	52	2023-10-17	\N	f	2024-02-27 11:13:07.242948	2024-03-26 06:08:38.159574
52	2	53	2023-10-17	\N	f	2024-02-27 11:13:07.252316	2024-03-26 06:09:41.815311
53	2	54	2023-10-17	\N	f	2024-02-27 11:13:07.262629	2024-03-26 06:09:41.817297
11	6	12	2023-04-11	\N	f	2024-02-27 11:13:06.754649	2024-03-26 06:15:20.208578
60	6	61	2024-01-08	\N	f	2024-02-27 11:13:07.324948	2024-03-26 06:15:20.21082
75	6	76	2024-04-15	\N	f	2024-04-17 12:56:55.025	2024-04-17 12:56:55.025
76	6	77	2024-04-17	\N	f	2024-04-17 13:31:26.175456	2024-04-17 13:31:26.175456
77	6	78	2024-04-17	\N	f	2024-04-17 13:38:40.506335	2024-04-17 13:38:40.506335
6	29	6	2023-03-01	2024-03-06	f	2024-02-27 11:13:06.698807	2024-04-19 12:36:46.708462
78	11	6	2024-03-06	\N	f	2024-04-19 12:37:31.793733	2024-04-19 12:37:31.793733
79	6	79	2024-04-22	\N	f	2024-04-25 08:12:38.474003	2024-04-25 08:12:38.474003
80	28	80	2024-05-13	\N	f	2024-05-21 06:17:28.09261	2024-05-21 06:17:28.09261
81	11	81	2024-06-14	\N	f	2024-06-14 08:51:48.195033	2024-06-14 08:51:48.195033
92	62	88	2024-09-30	\N	f	2024-10-21 07:08:13.538316	2024-10-21 07:09:43.238493
82	81	29	2024-01-01	\N	f	2024-06-14 08:53:49.271191	2024-06-14 08:53:49.271191
28	11	29	2022-06-27	2023-12-31	t	2024-02-27 11:13:06.974002	2024-06-14 08:54:02.909102
83	29	82	2024-06-17	\N	f	2024-06-24 07:52:00.116814	2024-06-24 07:52:00.116814
31	29	32	2021-10-29	2024-03-05	f	2024-02-27 11:13:07.010463	2024-06-24 08:00:15.782386
40	29	41	2021-10-29	2024-03-05	f	2024-02-27 11:13:07.123937	2024-06-24 08:00:15.784711
84	6	32	2024-03-06	\N	f	2024-06-24 09:14:08.128585	2024-06-24 09:14:08.128585
85	6	41	2024-03-06	\N	f	2024-06-24 09:14:29.04773	2024-06-24 09:14:29.04773
87	11	84	2024-07-01	\N	f	2024-07-02 12:57:51.909878	2024-07-02 12:57:51.909878
88	29	83	2024-06-17	\N	f	2024-07-15 07:35:04.611765	2024-07-15 07:35:04.611765
93	11	74	2024-04-02	\N	f	2024-10-31 06:41:15.596026	2024-10-31 06:41:15.596026
86	83	29	2024-06-17	2024-06-17	t	2024-06-24 11:05:08.139245	2024-07-23 12:24:22.656485
89	28	85	2024-08-22	\N	f	2024-09-17 13:45:37.147344	2024-09-17 13:45:37.147344
90	28	86	2024-08-22	\N	f	2024-09-17 13:46:39.746334	2024-09-17 13:46:39.746334
91	11	87	2024-09-30	\N	f	2024-09-30 07:44:40.469364	2024-09-30 07:44:40.469364
94	2	89	2024-10-22	\N	f	2024-11-11 06:42:29.681602	2024-11-11 06:42:29.681602
95	61	89	2024-10-22	\N	f	2024-11-11 06:43:14.440708	2024-11-11 06:43:14.440708
96	78	89	2024-10-22	\N	f	2024-11-11 06:43:57.507353	2024-11-11 06:43:57.507353
97	2	90	2024-10-22	\N	f	2024-11-11 07:01:03.747132	2024-11-11 07:01:03.747132
98	61	90	2024-10-22	\N	f	2024-11-11 07:01:12.590442	2024-11-11 07:01:12.590442
99	78	90	2024-10-22	\N	f	2024-11-11 07:01:18.81509	2024-11-11 07:01:18.81509
100	2	91	2024-10-22	\N	f	2024-11-11 07:05:47.972396	2024-11-11 07:05:47.972396
101	61	91	2024-10-22	\N	f	2024-11-11 07:05:53.701196	2024-11-11 07:05:53.701196
102	78	91	2024-10-22	\N	f	2024-11-11 07:05:59.904622	2024-11-11 07:05:59.904622
103	74	92	2024-11-04	\N	f	2024-11-11 07:19:52.974839	2024-11-11 07:19:52.974839
104	74	93	2024-11-04	\N	f	2024-11-11 07:22:06.777076	2024-11-11 07:22:06.777076
105	74	94	2024-11-25	\N	f	2024-11-25 14:03:14.297055	2024-11-25 14:03:14.297055
106	39	95	2024-12-02	\N	f	2024-12-02 09:49:04.289178	2024-12-02 09:49:04.289178
107	11	96	2024-11-29	\N	f	2024-12-02 09:54:37.149152	2024-12-02 09:54:37.149152
108	8	97	2024-12-02	\N	f	2024-12-02 10:06:23.838393	2024-12-02 10:06:23.838393
109	33	98	2024-12-09	\N	f	2024-12-14 09:34:15.987148	2024-12-14 09:34:15.987148
110	8	99	2025-01-06	\N	f	2024-12-14 09:39:47.343115	2024-12-14 09:39:47.343115
111	11	100	2025-01-06	\N	f	2025-01-07 11:48:16.80166	2025-01-07 11:48:16.80166
38	11	39	2022-03-28	2025-01-05	t	2024-02-27 11:13:07.100404	2025-01-07 11:50:16.648234
112	100	39	2025-01-06	\N	f	2025-01-07 11:51:09.815508	2025-01-07 11:51:09.815508
113	96	74	2024-11-29	\N	f	2025-01-08 08:38:02.207563	2025-01-08 08:38:02.207563
114	96	92	2024-11-29	\N	f	2025-01-22 14:50:26.241816	2025-01-22 14:50:26.241816
115	96	93	2024-11-29	\N	f	2025-01-22 14:50:36.500859	2025-01-22 14:50:36.500859
116	96	94	2024-11-29	\N	f	2025-01-22 14:50:45.770876	2025-01-22 14:50:45.770876
117	96	84	2024-11-29	\N	f	2025-01-22 14:54:38.821645	2025-01-22 14:54:38.821645
118	74	101	2025-01-01	\N	f	2025-02-07 07:05:26.046245	2025-02-07 07:05:26.046245
119	96	102	2025-02-10	\N	f	2025-02-17 06:11:47.788778	2025-02-17 06:11:47.788778
120	33	103	2025-01-22	\N	f	2025-02-17 06:22:44.685068	2025-02-17 06:22:44.685068
121	28	104	2025-02-24	\N	f	2025-03-19 08:45:23.258291	2025-03-19 08:45:23.258291
122	29	105	2025-02-26	\N	f	2025-03-19 09:15:48.791321	2025-03-19 09:15:48.791321
123	29	106	2025-02-26	\N	f	2025-03-19 09:22:24.296783	2025-03-19 09:22:24.296783
124	28	107	2025-02-24	\N	f	2025-03-19 09:36:12.11688	2025-03-19 09:36:12.11688
125	28	108	2025-03-03	\N	f	2025-03-19 09:41:51.626445	2025-03-19 09:41:51.626445
126	28	109	2025-02-24	\N	f	2025-03-19 09:44:37.996272	2025-03-19 09:44:37.996272
127	28	36	2025-01-01	\N	f	2025-04-03 09:17:59.232967	2025-04-03 09:17:59.232967
128	45	82	2025-01-01	\N	f	2025-04-07 14:11:32.61647	2025-04-07 14:11:32.61647
129	45	83	2025-01-01	\N	f	2025-04-07 14:18:13.833702	2025-04-07 14:18:13.833702
130	45	105	2025-01-01	\N	f	2025-04-07 14:30:24.220402	2025-04-07 14:30:24.220402
131	45	106	2025-01-01	\N	f	2025-04-07 14:31:23.696373	2025-04-07 14:31:23.696373
132	45	66	2025-01-01	\N	f	2025-04-14 12:44:45.711517	2025-04-14 12:44:45.711517
133	45	89	2025-02-28	\N	f	2025-04-14 12:45:36.15563	2025-04-14 12:45:36.15563
134	28	110	2025-05-05	\N	f	2025-05-02 13:14:05.462058	2025-05-02 13:14:05.462058
135	6	111	2025-05-15	\N	f	2025-05-19 13:48:06.514398	2025-05-19 13:48:06.514398
136	6	112	2025-05-15	\N	f	2025-05-19 13:51:13.228444	2025-05-19 13:51:13.228444
137	6	113	2025-05-15	\N	f	2025-05-19 13:54:58.609314	2025-05-19 13:54:58.609314
138	6	114	2025-05-15	\N	f	2025-05-19 13:58:35.238487	2025-05-19 13:58:35.238487
139	74	115	2025-05-26	\N	f	2025-05-23 10:46:56.411043	2025-05-23 10:46:56.411043
\.


--
-- Data for Name: timesheet_tasks; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.timesheet_tasks (id, timesheet_id, project_id, task_date, description, duration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: timesheets; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.timesheets (timesheet_id, employee_id, timesheet_week, submitted_on, approved_by, approved_on, created_at, updated_at, state) FROM stdin;
1	80	2025-06-22	\N	\N	\N	2025-06-24 09:31:43.47579	2025-06-24 09:31:43.47579	6
4	62	2025-06-29	\N	\N	\N	2025-06-30 07:40:24.195012	2025-06-30 07:40:24.195012	6
5	108	2025-06-29	\N	\N	\N	2025-06-30 12:38:37.98983	2025-06-30 12:38:37.98983	6
6	80	2025-06-29	\N	\N	\N	2025-07-02 06:21:10.348874	2025-07-02 06:21:10.348874	6
7	28	2025-06-29	\N	\N	\N	2025-07-03 07:43:18.588962	2025-07-03 07:43:18.588962	6
8	108	2025-07-06	\N	\N	\N	2025-07-08 06:06:50.665339	2025-07-08 06:06:50.665339	6
9	62	2025-07-06	\N	\N	\N	2025-07-08 09:07:10.41855	2025-07-08 09:07:10.41855	6
10	100	2025-07-06	\N	\N	\N	2025-07-08 09:09:35.834103	2025-07-08 09:09:35.834103	6
11	39	2025-07-06	\N	\N	\N	2025-07-08 09:09:52.295015	2025-07-08 09:09:52.295015	6
13	80	2025-07-06	\N	\N	\N	2025-07-08 10:08:39.683194	2025-07-08 10:08:39.683194	6
14	108	2025-07-13	\N	\N	\N	2025-07-14 06:39:45.530789	2025-07-14 06:39:45.530789	6
15	28	2025-07-13	\N	\N	\N	2025-07-14 06:49:46.264715	2025-07-14 06:49:46.264715	6
17	11	2025-07-13	\N	\N	\N	2025-07-17 09:41:07.969318	2025-07-17 09:41:07.969318	6
18	80	2025-07-13	\N	\N	\N	2025-07-18 10:44:11.592196	2025-07-18 10:44:11.592196	6
19	100	2025-07-13	\N	\N	\N	2025-07-18 14:27:46.689406	2025-07-18 14:27:46.689406	6
21	80	2025-07-20	\N	\N	\N	2025-07-21 07:55:26.772806	2025-07-21 07:55:26.772806	6
22	28	2025-07-20	\N	\N	\N	2025-07-21 08:56:54.074129	2025-07-21 08:56:54.074129	6
23	108	2025-07-20	\N	\N	\N	2025-07-22 07:14:55.086524	2025-07-22 07:14:55.086524	6
24	100	2025-07-20	\N	\N	\N	2025-07-24 09:48:25.612114	2025-07-24 09:48:25.612114	6
25	39	2025-07-20	\N	\N	\N	2025-07-24 09:48:39.851972	2025-07-24 09:48:39.851972	6
26	39	2025-07-27	\N	\N	\N	2025-07-28 02:21:24.823366	2025-07-28 02:21:24.823366	6
27	108	2025-07-27	\N	\N	\N	2025-07-28 07:09:11.834255	2025-07-28 07:09:11.834255	6
28	28	2025-07-27	\N	\N	\N	2025-07-28 07:10:19.813268	2025-07-28 07:10:19.813268	6
30	80	2025-07-27	\N	\N	\N	2025-07-29 14:08:16.530379	2025-07-29 14:08:16.530379	6
31	11	2025-07-27	\N	\N	\N	2025-07-30 08:05:17.925089	2025-07-30 08:05:17.925089	6
2	28	2025-06-22	2025-07-30 10:27:36.518398	\N	\N	2025-06-24 09:31:57.689701	2025-07-30 10:27:36.520559	7
12	28	2025-07-06	2025-07-30 10:27:43.767527	\N	\N	2025-07-08 09:44:06.585279	2025-07-30 10:27:43.770188	7
3	62	2025-06-22	\N	\N	\N	2025-06-24 09:34:30.493451	2025-07-30 12:39:31.246206	9
29	62	2025-07-27	2025-07-30 10:26:26.194471	39	2025-07-30 12:39:39.218452	2025-07-28 12:28:54.747074	2025-07-30 12:39:39.220127	10
16	62	2025-07-13	2025-07-30 10:26:43.033142	39	2025-07-30 12:39:47.159695	2025-07-14 07:26:46.717242	2025-07-30 12:39:47.163439	10
20	62	2025-07-20	2025-07-30 10:26:35.065788	39	2025-07-30 12:39:55.647567	2025-07-21 06:26:32.034816	2025-07-30 12:39:55.649834	10
32	28	2025-08-03	\N	\N	\N	2025-08-04 08:03:16.51481	2025-08-04 08:03:16.51481	6
33	108	2025-08-03	\N	\N	\N	2025-08-05 07:40:21.804022	2025-08-05 07:40:21.804022	6
34	108	2025-08-10	\N	\N	\N	2025-08-12 06:27:54.989786	2025-08-12 06:27:54.989786	6
35	28	2025-08-10	\N	\N	\N	2025-08-12 08:01:44.416912	2025-08-12 08:01:44.416912	6
36	62	2025-08-10	\N	\N	\N	2025-08-12 08:02:36.507014	2025-08-12 08:02:36.507014	6
37	39	2025-08-10	\N	\N	\N	2025-08-13 13:22:05.144234	2025-08-13 13:22:05.144234	6
38	80	2025-12-07	\N	\N	\N	2025-12-11 09:42:55.022492	2025-12-11 09:42:55.022492	6
39	80	2025-12-14	\N	\N	\N	2025-12-15 07:09:14.182643	2025-12-15 07:09:14.182643	6
40	28	2025-12-14	\N	\N	\N	2025-12-15 07:15:03.025555	2025-12-15 07:15:03.025555	6
41	62	2025-12-14	\N	\N	\N	2025-12-15 07:16:40.216368	2025-12-15 07:16:40.216368	6
\.


--
-- Data for Name: token_logs; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.token_logs (token_id, token, created_at, updated_at) FROM stdin;
1	6qfEA24aTOxPkuvi	2024-03-18 07:11:49.157321	2024-03-18 07:11:49.157321
2	RjlcWfwbwr1L0S4M	2024-03-18 07:15:38.402189	2024-03-18 07:15:38.402189
3	bzPsHOOxc8e77n9G	2024-03-18 08:41:58.498377	2024-03-18 08:41:58.498377
4	731O9qlVzb1UQ26p	2024-03-18 11:42:21.639149	2024-03-18 11:42:21.639149
5	AekvwHLfxcpSmPvC	2024-03-18 13:41:05.209716	2024-03-18 13:41:05.209716
6	z4P4S8V3y4q4vLkT	2024-03-18 16:35:01.216064	2024-03-18 16:35:01.216064
7	XA2ELSxLEz8aVMkh	2024-03-18 16:35:32.675452	2024-03-18 16:35:32.675452
8	TlcUxX9awikZv1Op	2024-03-18 16:35:53.26317	2024-03-18 16:35:53.26317
9	7V7JMsBZjzpG1fSH	2024-03-18 16:36:35.833897	2024-03-18 16:36:35.833897
10	dChBHmCmlicKWShO	2024-03-18 16:36:42.122849	2024-03-18 16:36:42.122849
11	Rgb9zlHYwDrBGvbf	2024-03-18 20:38:40.187552	2024-03-18 20:38:40.187552
12	cYl5oX7gNmm2VFVW	2024-03-18 20:38:53.500895	2024-03-18 20:38:53.500895
13	q0ADlaYo2BFF58ma	2024-03-19 12:00:40.052846	2024-03-19 12:00:40.052846
14	KcqPz3w7lPmCrZuG	2024-03-19 12:00:43.89952	2024-03-19 12:00:43.89952
15	FcmR5lliGS0nU7wI	2024-03-19 12:00:53.278983	2024-03-19 12:00:53.278983
16	6lItIGDS45CwkNvB	2024-03-19 12:00:56.101851	2024-03-19 12:00:56.101851
17	qAvY51JUQzfNdkGL	2024-03-21 05:59:34.792765	2024-03-21 05:59:34.792765
18	KKY9AP7GrqIUrHBS	2024-03-26 07:17:05.184427	2024-03-26 07:17:05.184427
19	QoFH4dcmVaCCNPzE	2024-03-26 07:17:08.573282	2024-03-26 07:17:08.573282
20	jxhHCzlKNywbezVn	2024-03-27 08:48:58.40001	2024-03-27 08:48:58.40001
21	P5d97CWMADykBfZL	2024-03-27 08:49:09.30918	2024-03-27 08:49:09.30918
22	Ox4OBQbSvvrFGg4y	2024-03-27 09:37:21.789833	2024-03-27 09:37:21.789833
23	5MJlsZnC9OQgbpwg	2024-03-27 09:37:26.372145	2024-03-27 09:37:26.372145
24	2YqB3MbS1SayjUUm	2024-03-27 09:38:19.308605	2024-03-27 09:38:19.308605
25	ZnLkV5wpW7PuYewO	2024-03-27 09:38:37.134519	2024-03-27 09:38:37.134519
26	wCsw539r2nwrjFzA	2024-03-27 09:40:06.692205	2024-03-27 09:40:06.692205
27	tPZX6pNPM90xtUjm	2024-03-28 07:23:33.427948	2024-03-28 07:23:33.427948
28	QitoVevvtVc3WfDb	2024-03-28 07:23:37.294588	2024-03-28 07:23:37.294588
29	UEY9NEP1W2CjHTNw	2024-03-28 07:23:41.007065	2024-03-28 07:23:41.007065
30	jUXZ7FuK5HmWLqyb	2024-03-28 08:24:53.125653	2024-03-28 08:24:53.125653
31	x7RMnUKtAZDkXoDf	2024-03-28 08:27:25.490752	2024-03-28 08:27:25.490752
32	9SUp3OQHoBXAJcri	2024-03-28 09:34:56.083973	2024-03-28 09:34:56.083973
33	W9mL3NQyeqN91Mld	2024-04-02 06:41:45.116861	2024-04-02 06:41:45.116861
34	APOD2EHG0AThmNMX	2024-04-03 06:40:42.852306	2024-04-03 06:40:42.852306
35	N5X2RiGXKNA1t5W1	2024-04-03 13:44:59.84763	2024-04-03 13:44:59.84763
36	mhgwmtkBH8Vu93Ms	2024-04-15 06:17:57.094893	2024-04-15 06:17:57.094893
37	Vq8YefbVFOZmUEKQ	2024-04-24 14:17:11.938449	2024-04-24 14:17:11.938449
38	po2GvJm7QuRe3kVN	2024-05-13 06:47:39.041809	2024-05-13 06:47:39.041809
39	kmdn7RFxNV7CKjNG	2024-05-15 16:46:28.28856	2024-05-15 16:46:28.28856
40	4ortWjxOCAMHfpZW	2024-07-15 07:57:11.279103	2024-07-15 07:57:11.279103
41	4LNgdSKPBi52VKJ4	2024-08-14 07:33:19.441129	2024-08-14 07:33:19.441129
42	iAGeEhooHYkBMJ7L	2024-08-16 12:37:04.879455	2024-08-16 12:37:04.879455
43	7p9Ncy7YJsWdXrBy	2024-08-16 13:01:42.194211	2024-08-16 13:01:42.194211
44	vbcG1cH4H8fxUDVk	2024-09-10 10:47:18.502198	2024-09-10 10:47:18.502198
45	fQIv5g7Pp8pvs94r	2024-09-24 08:28:45.318233	2024-09-24 08:28:45.318233
46	vxRxLtIjTgHG3eEs	2024-10-03 14:00:36.572621	2024-10-03 14:00:36.572621
47	PGXo4kOkn1nmdRod	2024-10-15 12:05:21.350673	2024-10-15 12:05:21.350673
48	KEtNAo2SdZVZNTDM	2024-10-22 14:13:44.476466	2024-10-22 14:13:44.476466
49	MDhsrSmMNNLd0jJU	2024-10-22 14:16:57.355846	2024-10-22 14:16:57.355846
50	WwICVwWMHsXt3COu	2024-10-29 09:14:36.751457	2024-10-29 09:14:36.751457
51	ntqxHWwchhWzCOrF	2024-11-05 08:15:43.252646	2024-11-05 08:15:43.252646
52	KK95snoJ9Xfy98zP	2024-11-05 08:19:26.9673	2024-11-05 08:19:26.9673
53	PTAQLctengFEy3rv	2024-11-14 09:36:28.43372	2024-11-14 09:36:28.43372
54	VZgMAEHeRsHLSdKz	2024-11-25 07:32:02.715042	2024-11-25 07:32:02.715042
55	DCJVPqa5ipRBJykV	2024-11-25 12:46:31.760904	2024-11-25 12:46:31.760904
56	FWuEk2n9lPt6bZ26	2024-11-29 07:31:11.283975	2024-11-29 07:31:11.283975
57	7JLbDKXWvy7glp1B	2024-11-29 11:09:04.902694	2024-11-29 11:09:04.902694
58	J7ckpT5TqdI9WGJZ	2024-12-03 10:02:45.576308	2024-12-03 10:02:45.576308
59	TBlYfQoClbgZwfiL	2024-12-03 11:39:38.573761	2024-12-03 11:39:38.573761
60	L97dAocA6634pKsh	2024-12-11 04:26:44.930027	2024-12-11 04:26:44.930027
61	Iffl87z53ndHmMOl	2025-03-06 12:30:24.754413	2025-03-06 12:30:24.754413
62	KOXMUK1ohelxbUNJ	2025-03-06 13:17:29.776415	2025-03-06 13:17:29.776415
63	C7ukHC56dcSpDIYI	2025-03-06 21:25:37.723046	2025-03-06 21:25:37.723046
64	d5iZNwDrRQjuSufs	2025-04-08 08:22:07.937531	2025-04-08 08:22:07.937531
65	WO53v6dUiZ00bZEn	2025-04-22 06:46:08.436847	2025-04-22 06:46:08.436847
66	94xqFcCZhARKBQOn	2025-04-28 06:35:54.973491	2025-04-28 06:35:54.973491
67	1z1LZ1s06crj2TBO	2025-04-29 09:40:36.973432	2025-04-29 09:40:36.973432
68	ZlxhvvRkMUmSHhB9	2025-05-05 08:32:26.28896	2025-05-05 08:32:26.28896
69	RKCD8vNhPkMiIzzk	2025-05-07 09:59:40.478168	2025-05-07 09:59:40.478168
70	WQQRzX9eBAb4t3mC	2025-05-08 06:23:11.539276	2025-05-08 06:23:11.539276
71	h0t8C6vtnGzLcLpi	2025-05-19 06:58:35.574867	2025-05-19 06:58:35.574867
72	0UIF0VWjNk0wXAct	2025-05-21 08:25:58.233317	2025-05-21 08:25:58.233317
73	XgiqLYp4X9H8T8Yx	2025-05-23 12:58:35.639789	2025-05-23 12:58:35.639789
74	UXjlJp3EzfBReZUi	2025-05-26 11:52:41.757076	2025-05-26 11:52:41.757076
75	rte9jrjm3VpE4TGp	2025-06-06 16:45:25.252726	2025-06-06 16:45:25.252726
\.


--
-- Data for Name: travel_requests; Type: TABLE DATA; Schema: public; Owner: ghii
--

COPY public.travel_requests (id, requisition_id, distance, voided, traveler_names, departure_date, return_date, created_at, updated_at, destination, asset_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.users (user_id, employee_id, username, password_digest, password_confirmation, activated_at, deactivated_at, reset_needed, activated, last_login, created_at, updated_at) FROM stdin;
4	4	ChidambeB054	$2a$12$eP696Pm8djUOvehfHwuw1.MVEHlfbgm1Hbig2TmqkBg1CwvG10l9W	\N	2022-11-28 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:46.581264	2025-06-24 09:22:17.926177
5	5	KasekaB026	$2a$12$YoHK7F86HaSH8aiYKa2iJOcUpZSOphdb2wvYlIs6QycNMEV5Hpe0S	\N	2023-04-03 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:46.843224	2025-06-24 09:22:18.202355
13	13	ChauyaE093	$2a$12$GnTzFLt4bsba69.mRYaLA.KnoxJp3hTx4WdLDqhCaWT8geyfT0C5.	\N	2023-04-03 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:49.022739	2025-06-24 09:22:18.444548
3	3	MatamboB055	$2a$12$eBs0fJY9aeZjT39fabiWeOkGLk.vNmG/LXJSbLL5SinH5fa6al4rq	\N	2022-11-28 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:46.296018	2025-06-24 09:22:18.704685
2	2	ChinkundaA021	$2a$12$VtMxmeG7LXk.c0EJFxGkw.ihVhzBLn/JPrqNZPeFe1qsrzGArx6NS	\N	2021-10-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:46.008871	2025-06-24 09:22:18.995552
48	48	LuhangaB027	$2a$12$QvxI.aZ9b7jKQ7Yngl4In.XFYZARDP3iCOLJP1ENFQHycHwGvJcRi	\N	2023-01-18 00:00:00	2024-07-03 10:25:23.946379	f	t	\N	2024-02-27 11:12:58.511367	2025-06-24 09:22:19.237395
7	7	KadzakumanjaC061	$2a$12$hJQGBHaAAWVaa2zWvU2CD.aYg.3bF4lbnjIekpSoKCnIpx/y0eR6S	\N	2021-10-29 00:00:00	\N	f	t	\N	2024-02-27 11:12:47.383828	2025-06-24 09:22:19.484769
9	9	KatuliD093	$2a$12$/CYriVde3lQANmrKG9DB9OzZ8aaUh9y14BnUriROvAUOwPNhMPKCS	\N	2022-11-28 00:00:00	\N	f	t	\N	2024-02-27 11:12:47.93695	2025-06-24 09:22:19.736169
24	24	MsiskaK050	$2a$12$w.43J6NgHHQ4OKxs9.GwYeukEI5R7d.wnm4SpmSMVnegOSV62RU86	\N	2022-11-28 00:00:00	\N	f	t	\N	2024-02-27 11:12:51.957661	2025-06-24 09:22:20.007327
14	14	MsiskaE098	$2a$12$wLhJhFQBZKOCNFQJUsWzt.TWVCg6AJOKcMaitYYSqkM5OV6lhkw2.	\N	2022-10-10 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:49.285656	2025-06-24 09:22:20.273342
15	15	MoseE067	$2a$12$BFpElSUBFYHJi5lwiMcRhuCnqNcMWpu7ABFwt1qjWUmFRtXBKsa5y	\N	2022-01-10 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:49.55049	2025-06-24 09:22:20.513028
17	17	SambaniF058	$2a$12$bIQwLg.qVSeZCa/unRXEN.SZzduLI9tuc07o1Sx.LYnjlbBrrBWWG	\N	2021-10-01 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:50.088031	2025-06-24 09:22:21.031449
18	18	BandaG069	$2a$12$7.qWRVs9eX6NfXX6cbmp1OAWBo1WIYhm..AExn/RI56GZ.RjWj7TS	\N	2023-04-11 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:50.351865	2025-06-24 09:22:21.283014
19	19	BwanaliG014	$2a$12$95xp042Mocl3iJ1aBa4k2.4kXV85tl8l4q4/y91qd12noNQURe9Fu	\N	2023-04-11 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:50.612051	2025-06-24 09:22:21.551106
21	21	GhambiI074	$2a$12$rLQdMi5i/pwQjJKeRWMvBeGz0IZrIwJixhNLKtHvl7FZPxPHep5Xm	\N	2023-06-19 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:51.143566	2025-06-24 09:22:21.820881
45	45	KayembeL089	$2a$12$kua2R7QfLuh/YAK63otuzuZlD7WtFR7079chTJ6DLWIFSNntY8ble	\N	2023-08-21 00:00:00	\N	f	t	\N	2024-02-27 11:12:57.720019	2025-06-24 09:22:22.086188
23	23	SakalaJ002	$2a$12$zn5DMyMfotWaZ4TTGLRdzuE/Fy2ZkfZMbQZ1tDFiujQnXfHmuCTDa	\N	2023-02-20 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:51.69167	2025-06-24 09:22:22.328851
41	41	BendabendaT075	$2a$12$Po0vkXMYdK6gFdBN7DH3DO2DaLKJc9YUGzKBbytdbdtx1JXEYNa1a	\N	2021-10-29 00:00:00	\N	f	t	\N	2024-02-27 11:12:56.628827	2025-06-24 09:22:22.591231
46	46	MtilaY054	$2a$12$nN8UuMNeJ2gk21oKBwd0FebFCSUJtfgFiSVp6YEmGziplOlXXiZDa	\N	2023-06-06 00:00:00	2024-07-03 10:25:23.946379	f	f	\N	2024-02-27 11:12:57.983422	2025-06-24 09:22:22.868716
49	49	KabagheC045	$2a$12$O2umYAFAmXixssrfofIiiO8DOY75ZnS59s1/E3maMLUovr3FckC9S	\N	2023-09-11 00:00:00	2024-07-03 10:25:23.946379	f	f	\N	2024-02-27 11:12:58.776531	2025-06-24 09:22:23.125117
29	29	LunguM009	$2a$12$0CZBuXVkQLeDbjjZZ246GeRO37UN2ZU8Q2qn2tWq2rhZ4SUAWI8wa	\N	2021-07-06 00:00:00	\N	f	t	\N	2024-02-27 11:12:53.339089	2025-06-24 09:22:23.378012
35	35	SanjamaP066	$2a$12$eDq9WOGdoD49Rmrh3G9CMuvBjeQGOECySZfIr2ruGqt94pI04Zxia	\N	2022-11-28 00:00:00	\N	f	t	\N	2024-02-27 11:12:55.021389	2025-06-24 09:22:23.622515
34	34	ChikudzuP007	$2a$12$HM/OsWfMpQ4Lz2y4dy4Fyu6zgfS3mhwdgrCOqou6KXhbNpAE9YNfO	\N	2023-01-03 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:54.711971	2025-06-24 09:22:23.869733
31	31	NyamaN011	$2a$12$hHOllRSbCjGC8YVqNA6dfu9EicNUY77LxDey2H/iuWadJSXSksSOW	\N	2022-06-06 00:00:00	\N	f	t	\N	2024-02-27 11:12:53.908765	2025-06-24 09:22:24.135858
47	47	ChimphampaJ021	$2a$12$LLMc6KKWJK3q/betdrgx4.BcVNnlSiJczqUCChvgN6.bcJDxwtA8i	\N	2023-07-03 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:58.24531	2025-06-24 09:22:24.397116
38	38	PhombeyaS025	$2a$12$WrqdlckWoY65lRje3VBIvOSyLZ.XQPyJ7aQg5ZXiboTqCw/yfhc.2	\N	2022-09-05 00:00:00	\N	f	t	\N	2024-02-27 11:12:55.842742	2025-06-24 09:22:24.709985
22	22	AbudulJ059	$2a$12$sFGr0hDgohBhyHpKhpH0N.IXX.CP0ea8jJFXZCyID2as00HEhhfgW	\N	2021-11-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:51.425644	2025-06-24 09:22:25.016843
28	28	SinjaniM008	$2a$12$01iEoQTlqWHJS8XEl4sk6e7nCEpI9OM8tASFY1vhWT0FWByGB.88u	\N	2021-07-06 00:00:00	\N	f	t	\N	2024-02-27 11:12:53.063757	2025-06-24 09:22:25.276304
8	8	NkhomaD062	$2a$12$LoXOCsqOfzQttSVB3rOZR.L81NSB7qfYK4YG.H5rhTHCgr6W507Z2	\N	2022-10-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:47.666029	2025-06-24 09:22:25.529111
12	12	NthapalapaE015	$2a$12$T2V30xoA8vn..Zv1CejFP.pvWb2C98JJJUEK1qRQ4X/nxO1yxl.hm	\N	2023-04-11 00:00:00	\N	f	t	\N	2024-02-27 11:12:48.760879	2025-06-24 09:22:25.854619
52	52	MakinaI033	$2a$12$K0VEO7uVJ69Kq5QJDcB4c.LI6JgxwYxGuCs7FflsOf.a.Iw6gz1/C	\N	2023-10-17 00:00:00	\N	f	t	\N	2024-02-27 11:12:59.565809	2025-06-24 09:22:26.14862
32	32	NkhataN050	$2a$12$T67T1eUXLeN/oijooT8dyO0MxSUpeim4FsBdKuVkFVzzWs/1nj5ui	\N	2021-10-29 00:00:00	\N	f	t	\N	2024-02-27 11:12:54.172694	2025-06-24 09:22:26.436361
50	50	NanchingaH069	$2a$12$Z4mf30EL4f7I5WqllWIvL.9YJYL5dRTMZ8xNwtIRyIPqwi.H1n8XC	\N	2023-09-25 00:00:00	\N	f	t	\N	2024-02-27 11:12:59.036032	2025-06-24 09:22:26.790553
10	10	MakwakwaD000	$2a$12$OzCvZLy6I2Sco8HNsJebHOStJdb0bh5OJ1hQdWVPn7hAzYw5Pg6Py	\N	2022-09-26 00:00:00	\N	f	t	\N	2024-02-27 11:12:48.206054	2025-06-24 09:22:27.048157
42	42	MunthaliW093	$2a$12$W5yux61rS4B9wQzG4Vc.cuVHpiV99WYg.yW92rFory.RJGEfTOM3S	\N	2023-03-07 00:00:00	\N	f	t	\N	2024-02-27 11:12:56.886244	2025-06-24 09:22:27.324026
39	39	MvulaS093	$2a$12$8EqssmyJK.B3WeMGpsSymOQh/VUptnLjZVbxP6apK0hNpv4IzsGnq	\N	2022-03-28 00:00:00	\N	f	t	\N	2024-02-27 11:12:56.107281	2025-06-24 09:22:27.583719
51	51	ChapondaJ029	$2a$12$KmsobjWjap1avC4ydhHwz.a9Dtr66KXrDGXSxF9YAYhtM5PyzZLky	\N	2023-10-17 00:00:00	\N	f	t	\N	2024-02-27 11:12:59.300489	2025-06-24 09:22:27.83347
44	44	SentalaF041	$2a$12$tc6p5QsX0iy4rgKoBv9tYOLlIUOET2Td6EKy.fH6ryt0gOMKn4ltu	\N	2023-07-03 00:00:00	\N	f	t	\N	2024-02-27 11:12:57.443756	2025-06-24 09:22:28.114019
36	36	DeulaR022	$2a$12$BzuLVD9lKBRzTj5zdepz0uO6RX3zrW/XdQ.MnqCXbz1pMVxC9JGJW	\N	2022-05-26 00:00:00	\N	t	t	\N	2024-02-27 11:12:55.299049	2025-06-24 09:22:28.385056
40	40	BandaT073	$2a$12$N9tbPq1EYiFY1.Yhfe8g3OuxjEeOGVVtfWkkzBXKR6JUG8a7yh2tq	\N	2022-11-28 00:00:00	\N	f	t	\N	2024-02-27 11:12:56.366421	2025-06-24 09:22:28.654318
37	37	NgozoS085	$2a$12$5pM0MW.ALrmlPxB5BuIofuSfxfkwbZtVLmYdhXV7q4r9qUAUUJTkq	\N	2021-10-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:55.573768	2025-06-24 09:22:28.896759
11	11	MtongaT003	$2a$12$4Wc.caFvl5cQ6QE1ivzzUO8mvBRYtLlE3fevV4v5uZNsQQYn8c2mO	\N	2022-01-26 00:00:00	\N	f	t	\N	2024-02-27 11:12:48.483021	2025-06-24 09:22:29.178417
20	20	KumwendaI056	$2a$12$r6oNB3DC23aazW4DW0gqGe.1ASEJplP/BgJd2lpuDDkijuI3dmFzG	\N	2022-11-22 00:00:00	\N	t	f	\N	2024-02-27 11:12:50.874813	2025-06-24 09:22:29.450581
27	27	KamvazinaL035	$2a$12$7NdWuhcBTWUijUA0POY1ueSaNFoE8jWNMDerY1NolS3JbxHK9iB46	\N	2022-11-28 00:00:00	\N	f	t	\N	2024-02-27 11:12:52.777074	2025-06-24 09:22:29.761923
33	33	NamagonyaP031	$2a$12$8c4l1RHztsmDglEZF4seyOa4THW7kG4zvmHQzX.M1UISkKlPDU47y	\N	2022-10-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:54.443565	2025-06-24 09:22:30.045904
43	43	LijoniW064	$2a$12$mRH0IGDu.8/74DXr2ytVA.ipLmUaf3IyI9XMxrYOkGIOmOrgwkrY6	\N	2022-08-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:57.167076	2025-06-24 09:22:30.32321
54	54	SimentiM075	$2a$12$Ij5rcTBxErkI5VUnwy023.wboqHwyymgocmda643oYdLpPXCj6CTS	\N	2023-10-17 00:00:00	\N	f	t	\N	2024-02-27 11:13:00.109549	2025-06-24 09:22:30.604481
64	64	MasangwiH065	$2a$12$zvli0VsISnwf8UM5plWa/uSe6nNmb/94lIga9fLwggM7iFt2vwYWe	\N	2024-02-07 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:13:02.945045	2025-06-24 09:22:30.872637
62	62	MulengaT060	$2a$12$BUxgEENRCd2zePYBeEov6uA.j19xSjlPxNsy6vx7l4k40Du3lkJoK	\N	2024-01-29 00:00:00	\N	f	t	\N	2024-02-27 11:13:02.385155	2025-06-24 09:22:31.153799
65	65	KholowaS056	$2a$12$RPO89Sm8XWas3TasFTFvkuFVHEJ.Ub08oFogGnbqvvRf6DWXC1TZW	\N	2024-01-30 00:00:00	\N	f	t	\N	2024-02-27 11:13:03.217045	2025-06-24 09:22:31.691408
75	75	NgwiraC672	$2a$12$MuBC2JpcbPG1hYf89fwL2eN8xuOVCrnQj3hWF5kgH6V8k253x8xm6	\N	2024-04-02 12:06:58.411179	\N	f	t	\N	2024-04-02 12:06:58.652133	2025-06-24 09:22:31.925893
66	66	KumwanjeR098	$2a$12$oMwAgw9m5J53J71nSRYxVOWv8Ccyy1qciGh7xNg6BwXs.AkTWX1nG	\N	2024-01-22 00:00:00	\N	f	t	\N	2024-02-27 11:13:03.506651	2025-06-24 09:22:32.195347
76	78	NsamboC020	$2a$12$StvgUguCgH89PKNu/bbTMOYg5AFZnSWx4xuj4gJhJss8gnFmOU7Ka	\N	\N	\N	t	t	\N	2024-04-17 13:49:58.209085	2025-06-24 09:22:32.462851
77	77	MapanjeD009	$2a$12$oWugcWMB86TQNrTVVpGCo.x0.XI.Nl66vLpJnE1rsMzQeIfNGSQeS	\N	\N	\N	t	t	\N	2024-04-17 14:00:37.824733	2025-06-24 09:22:32.72319
68	68	BandaN035	$2a$12$DsSm.ilAjc7vcWp3xrCqxeyi0X.sR2MhOSsdglochRACAm8FLicGO	\N	2022-04-28 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:13:04.044861	2025-06-24 09:22:33.26544
83	83	DouglasJ162	$2a$12$xogZyGMyWWQdU4QKOB0CYOgRlhO/WsEvU0/r7RSykFPgJn.u6mZhi	\N	2024-06-24 00:00:00	\N	f	t	\N	2024-06-24 11:01:15.996762	2025-06-24 09:22:33.535136
69	69	YapuM051	$2a$12$yjqnTpwwOBz8WB4.tBLvruAfTSPJi7dWEGh2ImgpVSnEggXC.OTcS	\N	2024-02-08 00:00:00	\N	f	f	\N	2024-02-27 11:13:04.317046	2025-06-24 09:22:33.777601
79	79	ChaleraJ008	$2a$12$lttNdZyyVO2LocXEdOnVJe8V2P/gUuvfZpPM7YMRRFuTUJxcVVQyC	\N	2024-04-25 00:00:00	\N	f	t	\N	2024-04-25 08:20:15.25377	2025-06-24 09:22:34.05496
57	57	ChungaP099	$2a$12$0ISNqUaLs2yf4TEhKBgYw.Z37WfmwQ78RQhI6eTgqh76nMhcLHZZi	\N	2023-11-27 00:00:00	\N	f	t	\N	2024-02-27 11:13:00.930688	2025-06-24 09:22:34.296553
59	59	KasakulaW097	$2a$12$2JBIJvqJZA7hUzNoeZNmMOSRoWC4XTugWPn1dwmRcbbehURaCNTb.	\N	2023-12-11 00:00:00	\N	f	t	\N	2024-02-27 11:13:01.493064	2025-06-24 09:22:34.581014
55	55	HarawaM094	$2a$12$P6dgHW3X2rT2g2yhghBTH.jVfO4eaM4srMBpbNMsAhCnUqYU2nj4u	\N	2023-11-27 00:00:00	\N	f	t	\N	2024-02-27 11:13:00.376512	2025-06-24 09:22:34.808281
53	53	KabambeJ061	$2a$12$hwpLDWIXs7wdp4p8V.zHZezbS9U49/x70VG7n7ZrEf0BhW5onHgyG	\N	2023-10-17 00:00:00	\N	f	t	\N	2024-02-27 11:12:59.841967	2025-06-24 09:22:35.089542
61	61	MagelaD017	$2a$12$4DsToLTieydJR8soIsghlOTlwPBu5l/s8kUW86bR.oqoGw14F7jBe	\N	2024-01-08 00:00:00	\N	f	t	\N	2024-02-27 11:13:02.092136	2025-06-24 09:22:35.328829
60	60	MadziateraM047	$2a$12$KgJgc8YnJt5waC7G9AXPmOMh37adoxEM.9kU7x0Jnj5LEuUo3cxp2	\N	2024-01-02 00:00:00	\N	f	t	\N	2024-02-27 11:13:01.785376	2025-06-24 09:22:35.58195
70	70	MadziakapitaH066	$2a$12$hcwKXu2jIVGhYNZBydkhr.TjbC4emSj/PdeKH3niOrXFHF1SSPr66	\N	2024-02-20 00:00:00	\N	f	t	\N	2024-02-27 11:13:04.581998	2025-06-24 09:22:35.873617
6	6	TiyesiC095	$2a$12$j1EwA7Yl9HfVl.tRQCiCMu6WnDbO8xgob0ulNtSImxSQi0gD9ow/G	\N	2023-03-01 00:00:00	\N	f	t	\N	2024-02-27 11:12:47.116991	2025-06-24 09:22:36.189651
58	58	ChibakaY092	$2a$12$z2IYWm25LD5EJ2/rPTGu.ufz1kAXSoyKrayNpnidlfdejVv.70RRu	\N	2023-12-18 00:00:00	\N	f	t	\N	2024-02-27 11:13:01.207763	2025-06-24 09:22:36.513208
56	56	KanthongaT025	$2a$12$vunw1BfGnrA56L1zRBow7.s/kZp6v36xYB/kza4bNXfi5TwGs7UhS	\N	2023-11-27 00:00:00	\N	f	t	\N	2024-02-27 11:13:00.664657	2025-06-24 09:22:36.84746
71	71	KapeziM078	$2a$12$wrXCZQ4rbF3tadea6MBzreDQed5rvTtP3jw9aXUvKhcB8cLt6SKyW	\N	2024-02-20 00:00:00	\N	f	t	\N	2024-02-27 11:13:04.856941	2025-06-24 09:22:37.133536
73	73	KapalamulaC015	$2a$12$i40Ai7/ban/dbAxrFIp5tuFK3NtIa9/r03HtZwC.oCKpzmNBC9bFC	\N	2024-03-15 00:00:00	\N	f	t	\N	2024-03-15 10:28:06.816309	2025-06-24 09:22:37.372054
82	82	MzembeV568	$2a$12$.zNiy4TC1VNx4bB2gAKqWegD1p/UMpv0xhdWW7NGrcvicNeGIbRyK	\N	2024-06-24 00:00:00	\N	f	t	\N	2024-06-24 07:47:51.122613	2025-06-24 09:22:37.6325
72	72	YikwangaC092	$2a$12$t.1kHM0fmyK1JcJKJh3X1OT1w3.ZqWg3Ipbw7VefBRqdssNGUbXcq	\N	2024-02-21 00:00:00	2024-07-03 10:25:23.946379	f	f	\N	2024-02-27 11:13:05.145804	2025-06-24 09:22:37.877799
84	84	MagomboL373	$2a$12$XpBCz89kvWNICZEW3gjJhuJ8kYog45u.n.cQOCCc7nDSLZit/T.xu	\N	2024-07-02 00:00:00	\N	f	t	\N	2024-07-02 12:40:28.933008	2025-06-24 09:22:38.133313
30	30	ThompsonN035	$2a$12$gXW4BLvGlYxQceeDz4r3nukNNqx2EUXZoLytqf3sy0kXHax0bAyrS	\N	2022-10-10 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:53.64039	2025-06-24 09:22:38.382357
1	1	ChindebvuA039	$2a$12$s4YQiEhsghI1ymcNylJqUeZFn7s0q2ZbAEr52HG5XtoKeQOVqsY3m	\N	2023-01-03 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:45.74792	2025-06-24 09:22:38.633032
25	25	SaidiK005	$2a$12$lRWHR7aZtn7Jy57ZyuAYxu5inCfOnb.M1T7t56d.W67Hu71AtbEG.	\N	2023-03-02 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:52.24109	2025-06-24 09:22:38.895462
63	63	NalusoG054	$2a$12$0wPwaGh.JGdNQE05c1y6LOlapMkOwo3klQxtWJ3/Y9Ql2Er6.gAq6	\N	2024-01-29 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:13:02.67117	2025-06-24 09:22:39.181457
87	87	KazembeN062	$2a$12$3TRLalKCxq7NJYoXIUms5e00/6AJVcrRw14b2tRXav6SQrxZEBYB2	\N	2024-09-30 00:00:00	\N	f	t	\N	2024-09-30 07:30:59.637605	2025-06-24 09:22:39.400556
78	76	SimkozaC006	$2a$12$MZapxRWfsK5MpB5jx5ICJuKGvaOf.ff6XusiAVbpp6Yzm9oAXC6cy	\N	2024-04-15 00:00:00	\N	f	t	\N	2024-04-17 14:04:33.758755	2025-06-24 09:22:39.71433
85	85	MhoneJ094	$2a$12$556j2W5O8eqSMD6YPPdZLOedak8ta2pyV1dTHiP6gj4TtQ7vDx2Xe	\N	2024-08-22 06:38:51.958699	\N	f	t	\N	2024-08-22 06:37:18.700604	2025-06-24 09:22:40.033555
81	81	KhagameP038	$2a$12$q2u6KG9t7GzvczaJKAxDH.w55zVn/Zdrl1Xgt4zFQwCQ9zfPX7CNi	\N	2024-06-14 00:00:00	\N	f	t	\N	2024-06-14 06:44:58.501029	2025-06-24 09:22:40.313385
80	80	MandaT001	$2a$12$JaYxyRhqkmr79uJjLP5wWuVQ7glk7M.MN5Pmw4AOip2MZ1nEh8ZL.	\N	2024-05-13 06:12:45.528253	\N	f	t	\N	2024-05-21 06:12:45.528253	2025-06-24 09:22:40.565227
86	86	MagaletaE098	$2a$12$AADeethOVbIfNqNF2JKOvOSv5JWl9Nq72WLP4dB/otbOViCr1JWEi	\N	2024-08-21 08:00:14.001124	\N	f	t	\N	2024-08-22 08:06:33.73989	2025-06-24 09:22:40.815445
93	93	ThothoD166	$2a$12$necCfjkN4wtA.Y..k9oHVuer3/.rCxoscEqNIMA6JyhPItoX7B9jK	\N	2024-11-11 07:21:53.051306	\N	f	t	\N	2024-11-11 07:21:53.293531	2025-06-24 09:22:41.065977
88	88	BandaD001	$2a$12$42b/jckosAmzsrzQwBr.cOyxmt5ZPvsmQOXX3mcODDFhZeG5nEkwu	\N	2024-09-30 00:00:00	\N	f	t	\N	2024-10-21 07:00:26.500351	2025-06-24 09:22:41.320114
92	92	ChiromboT538	$2a$12$a7fgxZxUzt/QvruXgEaYXejF05ysYFN4gnfB6No1NsDfpRPMSl6ta	\N	2024-11-11 07:19:41.672637	\N	f	t	\N	2024-11-11 07:19:41.927111	2025-06-24 09:22:41.581778
89	89	ChonzieW306	$2a$12$q7kTZtEfD0vXIILxoy2hFOvdz92OFXsZ4W0/GvYLc8.8sAOg8cx56	\N	2024-11-11 06:31:34.492816	\N	f	t	\N	2024-11-11 06:31:34.758083	2025-06-24 09:22:41.825599
91	91	ChingokaS550	$2a$12$R7PPsyEC4/bJE9mphiCYmOTJj0plPNOJBefN0Lor6/aco7DMQVHgu	\N	2024-11-11 07:05:34.959045	\N	f	t	\N	2024-11-11 07:05:35.215177	2025-06-24 09:22:42.084673
90	90	UtumbeE878	$2a$12$XQI9J/HunMFO9j0oiyLkZeJeLM3mMoIVjzQK3lLwK2DdFJFg.j2dC	\N	2024-11-11 07:00:35.661051	\N	f	t	\N	2024-11-11 07:00:35.915494	2025-06-24 09:22:42.335233
96	96	GondweF188	$2a$12$JKP3JEvb70RQSfCgZaUrfuZAooNzLRUPKNAuIJ2DbV5gke4qT5bGK	\N	2024-12-02 09:54:17.701948	\N	f	t	\N	2024-12-02 09:54:17.94634	2025-06-24 09:22:42.576995
95	95	KachipapaR818	$2a$12$9OnE0nBsU7W/hoBmP/UBz.THcf6X2HEBwAHLY47MJqNiQYNgRe9AG	\N	2024-12-02 09:48:47.188398	\N	f	t	\N	2024-12-02 09:48:47.445146	2025-06-24 09:22:42.843093
97	97	SitaY369	$2a$12$mSaZhXK2dY1BZB079Fouw.sL1Tuxn1nh.b95R/xVtWo9bEZP0hM9C	\N	2024-12-02 10:06:04.71244	\N	f	t	\N	2024-12-02 10:06:04.966822	2025-06-24 09:22:43.360077
98	98	BlackwellJ155	$2a$12$j/TtcnQudq1hrSOPW7Q3num20Fmn3bqg6BTLTFU52ExpP2WH7VDYm	\N	2024-12-14 09:33:50.997919	\N	f	t	\N	2024-12-14 09:33:51.252089	2025-06-24 09:22:43.614524
99	99	GwazaM449	$2a$12$ovBBcqp.YbXOD41VL0B/MeK.b7mrG7NmEijROCpqqOKwaSsPrZiB6	\N	2024-12-14 09:38:58.175372	\N	f	t	\N	2024-12-14 09:38:58.41724	2025-06-24 09:22:43.869223
100	100	MalikebuR124	$2a$12$qBc15UJHZHzz/MHk6AXopu020Z8GmueAFTUrEX0fVhoH1zM12CHxS	\N	2025-01-07 11:47:59.280306	\N	f	t	\N	2025-01-07 11:47:59.536594	2025-06-24 09:22:44.13974
102	102	KamangaB859	$2a$12$qXxao9DNwXNiKp0iJZMusuSN2C1BDxO.IgOkgxp.HV4.lP9OcgUTi	\N	2025-02-17 06:11:31.070153	\N	f	t	\N	2025-02-17 06:11:31.324236	2025-06-24 09:22:44.416181
103	103	MalunjeB875	$2a$12$BXThLe8TECtp3lGURZOUDenY2CeLJ/7XZWtuGtYDISxTiXAbJlIDG	\N	2025-02-17 06:22:29.42544	\N	f	t	\N	2025-02-17 06:22:29.678007	2025-06-24 09:22:44.664614
101	101	WhayoT798	$2a$12$X5saAdjJSDF3ModV5H8tMeTjMbzULl6pYzGPAf1l52oH08AP2A6Om	\N	2025-02-07 07:05:00.529601	\N	f	t	\N	2025-02-07 07:05:00.792042	2025-06-24 09:22:44.932841
26	26	LinzieK063	$2a$12$RR7s40z1SOhJoxhYrwiQte8iYa9YmvtAayuyGq1MIXFFRr8qsgdJq	\N	2023-03-08 00:00:00	\N	f	t	\N	2024-02-27 11:12:52.504313	2025-06-24 09:22:17.686264
16	16	TamandikaniF076	$2a$12$YpIJw3qRFw4LJ69vNrhlLeRf9UxSzUqvU9KohyncCedArCuj5FbUO	\N	2022-08-29 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:12:49.816814	2025-06-24 09:22:20.772843
74	74	MwanzaO652	$2a$12$QVe4OMJzq2Ft3CIegkqRHO9qwmpp5EVYuIuCtwtWpixgLgbDqgGOS	\N	2024-04-02 11:42:30.170462	\N	f	t	\N	2024-04-02 11:42:30.426997	2025-06-24 09:22:31.433819
67	67	MwalijaC019	$2a$12$ILb8V9erbS.wq2dYiv8p6ean2l/IPp/VnCLh8PyACNC60kgl/Ncg2	\N	2021-10-01 00:00:00	2024-07-03 10:25:23.946379	t	f	\N	2024-02-27 11:13:03.772968	2025-06-24 09:22:32.988393
94	94	MunyenyembeB348	$2a$12$u8J9xDeR8EKy5U/fk5fyvedKfFiE1l2K8.8GXPmTbnUKsEKexk4Se	\N	2024-11-25 14:02:26.094577	\N	f	t	\N	2024-11-25 14:02:26.358447	2025-06-24 09:22:43.096288
104	104	ChirwaN26	$2a$12$9KhTHE5Jnux6GSuBP9TEUOTFcHJoenCQd8pXFZb.53CmmtfJTe2/6	\N	2025-03-19 08:45:22.985767	\N	f	t	\N	2025-03-19 08:45:23.232462	2025-06-24 09:22:45.198853
105	105	ChisaRGe	$2a$12$HjmmY/Fv.HCSqa2Kxv2xcuL3NCS18qQPAXU4EC2C8/GqE/A7qIcnW	\N	2025-03-19 09:15:48.532525	\N	f	t	\N	2025-03-19 09:15:48.774946	2025-06-24 09:22:45.469973
109	109	SandeBJl	$2a$12$0KfuAa66eR7l2r/R3Qyf7O7BcbhnqNx5rMhP34RYNngfLolgcSofK	\N	2025-03-19 09:44:37.727492	\N	f	t	\N	2025-03-19 09:44:37.971719	2025-06-24 09:22:45.705156
108	108	MartinuSM	$2a$12$tdYp2RhClm4PgdmZX3BR8uiXAPkLAqqQgA8E3/TKOUpoFMS66D1Fq	\N	2025-03-19 09:41:51.365391	\N	f	t	\N	2025-03-19 09:41:51.610368	2025-06-24 09:22:45.973655
106	106	MandalaOUS	$2a$12$d/wkhXAnPW5MvC/I7eokH.eCEbvIUzom0/.HF9sLIoZfoxmZIj6QS	\N	2025-03-19 09:22:24.036877	\N	f	t	\N	2025-03-19 09:22:24.280339	2025-06-24 09:22:46.228792
110	110	Nyirenda0qp	$2a$12$wLpCdHFbjFNoY1nBdv2zZuPu22gzr2G7PBLOWRBZ94RzyjPMjlqP6	\N	2025-05-02 13:14:05.199799	\N	f	t	\N	2025-05-02 13:14:05.44234	2025-06-24 09:22:46.487834
107	107	KhambaRBY	$2a$12$Y.iMwWOYwk/xjaPLEiazhOmG3YllYjZ1FckysJlCeEv4/PChdAGh6	\N	2025-03-19 09:36:11.846715	\N	f	t	\N	2025-03-19 09:36:12.097813	2025-06-24 09:22:46.754923
111	111	Msinkhuszw	$2a$12$NXY9At9sa9vTDSqWS0BVc.8FcADT8BNXmY9h2g6Unh6V1MglSTvAq	\N	2025-05-19 13:48:06.2375	\N	f	t	\N	2025-05-19 13:48:06.486418	2025-06-24 09:22:47.019322
114	114	KondoweBvS	$2a$12$iVLcpyMRchXbywub0WpI0uKLsj8yEgk4R44pEy/SUvtR9DJTeDawe	\N	2025-05-19 13:58:34.983053	\N	f	t	\N	2025-05-19 13:58:35.224735	2025-06-24 09:22:47.265183
113	113	MteghaTPK	$2a$12$T0MPgLdfjXjRnGToyTSjPOdagn3sD8gMBi6hnwDWZ1nwzfamuH1Xq	\N	2025-05-19 13:54:58.350612	\N	f	t	\N	2025-05-19 13:54:58.591837	2025-06-24 09:22:47.526529
115	115	Mkandawire1W3	$2a$12$FZ9xje7PkH4MLgbfL7cVkOh/S7S/AXjOokKyY4di1w.PvnfSyitH2	\N	2025-05-23 10:46:56.149111	\N	f	t	\N	2025-05-23 10:46:56.390515	2025-06-24 09:22:47.788735
112	112	MabasonDo	$2a$12$7Uh0cxTxWcTq6VnTnOjLNOmw8YEIEjhSm5wsOASGHK4rDI7zF3fj2	\N	2025-05-19 13:51:12.971853	\N	f	t	\N	2025-05-19 13:51:13.213887	2025-06-24 09:22:48.065717
\.


--
-- Data for Name: workflow_processes; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.workflow_processes (workflow_process_id, workflow, created_at, updated_at, active) FROM stdin;
1	Asset Request	2024-09-27 13:26:38.262355	2024-09-27 13:26:38.262355	t
2	Timesheet	2024-09-27 13:26:38.335577	2024-09-27 13:26:38.335577	t
3	Transport Request	2024-09-27 13:26:38.399781	2024-09-27 13:26:38.399781	t
4	Petty Cash Request	2024-09-27 13:26:38.454947	2024-09-27 13:26:38.454947	t
5	Leave Request	2024-09-27 13:26:38.541934	2024-09-27 13:26:38.541934	t
6	Purchase Request	2025-07-09 08:19:05.914934	2025-07-09 08:19:05.914934	t
\.


--
-- Data for Name: workflow_state_actions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.workflow_state_actions (id, workflow_state_id, state_action, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: workflow_state_actors; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.workflow_state_actors (id, workflow_state_id, employee_designation_id, voided, created_at, updated_at) FROM stdin;
47	21	4	t	2024-09-27 14:31:43.899052	2024-09-27 14:31:43.899052
52	22	4	t	2024-09-27 14:31:43.922484	2024-09-27 14:31:43.922484
76	4	1	t	2024-09-27 14:40:00.744045	2024-09-27 14:40:00.744045
77	4	24	t	2024-09-27 14:40:00.74997	2024-09-27 14:40:00.74997
78	4	2	t	2024-09-27 14:40:00.755441	2024-09-27 14:40:00.755441
79	4	4	t	2024-09-27 14:40:00.760732	2024-09-27 14:40:00.760732
80	4	55	t	2024-09-27 14:40:00.766149	2024-09-27 14:40:00.766149
81	7	15	t	2024-09-27 14:40:00.789822	2024-09-27 14:40:00.789822
82	7	1	t	2024-09-27 14:40:00.795307	2024-09-27 14:40:00.795307
83	7	3	t	2024-09-27 14:40:00.8002	2024-09-27 14:40:00.8002
84	7	4	t	2024-09-27 14:40:00.805108	2024-09-27 14:40:00.805108
85	7	2	t	2024-09-27 14:40:00.814506	2024-09-27 14:40:00.814506
86	7	55	t	2024-09-27 14:40:00.819529	2024-09-27 14:40:00.819529
87	7	24	t	2024-09-27 14:40:00.824008	2024-09-27 14:40:00.824008
88	9	1	t	2024-09-27 14:40:00.842568	2024-09-27 14:40:00.842568
89	9	24	t	2024-09-27 14:40:00.848184	2024-09-27 14:40:00.848184
90	9	2	t	2024-09-27 14:40:00.853737	2024-09-27 14:40:00.853737
91	9	4	t	2024-09-27 14:40:00.860095	2024-09-27 14:40:00.860095
92	9	55	t	2024-09-27 14:40:00.865654	2024-09-27 14:40:00.865654
93	14	12	t	2024-09-27 14:40:00.90092	2024-09-27 14:40:00.90092
94	14	6	t	2024-09-27 14:40:00.906329	2024-09-27 14:40:00.906329
95	14	4	t	2024-09-27 14:40:00.911445	2024-09-27 14:40:00.911445
96	14	3	t	2024-09-27 14:40:00.917219	2024-09-27 14:40:00.917219
97	17	12	t	2024-09-27 14:40:00.942341	2024-09-27 14:40:00.942341
98	17	6	t	2024-09-27 14:40:00.948316	2024-09-27 14:40:00.948316
99	17	4	t	2024-09-27 14:40:00.953878	2024-09-27 14:40:00.953878
100	17	3	t	2024-09-27 14:40:00.959014	2024-09-27 14:40:00.959014
101	19	1	t	2024-09-27 14:40:00.97365	2024-09-27 14:40:00.97365
102	19	24	t	2024-09-27 14:40:00.977356	2024-09-27 14:40:00.977356
103	19	2	t	2024-09-27 14:40:00.98113	2024-09-27 14:40:00.98113
104	19	4	t	2024-09-27 14:40:00.984575	2024-09-27 14:40:00.984575
105	19	55	t	2024-09-27 14:40:00.98755	2024-09-27 14:40:00.98755
106	20	1	t	2024-09-27 14:40:00.995105	2024-09-27 14:40:00.995105
107	20	24	t	2024-09-27 14:40:00.998075	2024-09-27 14:40:00.998075
108	20	2	t	2024-09-27 14:40:01.001465	2024-09-27 14:40:01.001465
109	20	4	t	2024-09-27 14:40:01.005372	2024-09-27 14:40:01.005372
110	20	55	t	2024-09-27 14:40:01.009073	2024-09-27 14:40:01.009073
111	21	2	t	2024-09-27 14:40:01.016951	2024-09-27 14:40:01.016951
112	21	4	t	2024-09-27 14:40:01.021017	2024-09-27 14:40:01.021017
113	21	9	t	2024-09-27 14:40:01.025608	2024-09-27 14:40:01.025608
114	21	5	t	2024-09-27 14:40:01.033814	2024-09-27 14:40:01.033814
115	21	4	t	2024-09-27 14:40:01.040156	2024-09-27 14:40:01.040156
116	22	2	t	2024-09-27 14:40:01.051891	2024-09-27 14:40:01.051891
117	22	4	t	2024-09-27 14:40:01.057602	2024-09-27 14:40:01.057602
118	22	9	t	2024-09-27 14:40:01.062468	2024-09-27 14:40:01.062468
119	22	5	t	2024-09-27 14:40:01.067379	2024-09-27 14:40:01.067379
120	22	4	t	2024-09-27 14:40:01.072242	2024-09-27 14:40:01.072242
121	23	1	t	2024-09-27 14:40:01.08352	2024-09-27 14:40:01.08352
122	24	1	t	2024-09-27 14:40:01.094339	2024-09-27 14:40:01.094339
123	28	1	t	2024-09-27 14:40:01.113138	2024-09-27 14:40:01.113138
124	28	24	t	2024-09-27 14:40:01.116682	2024-09-27 14:40:01.116682
125	28	25	t	2024-09-27 14:40:01.11975	2024-09-27 14:40:01.11975
126	28	5	t	2024-09-27 14:40:01.123728	2024-09-27 14:40:01.123728
127	28	6	t	2024-09-27 14:40:01.127999	2024-09-27 14:40:01.127999
128	29	1	t	2024-09-27 14:40:01.141403	2024-09-27 14:40:01.141403
129	29	24	t	2024-09-27 14:40:01.147695	2024-09-27 14:40:01.147695
130	29	25	t	2024-09-27 14:40:01.153223	2024-09-27 14:40:01.153223
131	29	5	t	2024-09-27 14:40:01.158247	2024-09-27 14:40:01.158247
132	29	6	t	2024-09-27 14:40:01.1639	2024-09-27 14:40:01.1639
133	30	2	t	2024-09-27 14:40:01.175233	2024-09-27 14:40:01.175233
134	30	4	t	2024-09-27 14:40:01.181455	2024-09-27 14:40:01.181455
135	30	5	t	2024-09-27 14:40:01.187715	2024-09-27 14:40:01.187715
136	30	4	t	2024-09-27 14:40:01.192878	2024-09-27 14:40:01.192878
137	1	15	t	2024-09-27 14:42:34.448944	2024-09-27 14:42:34.448944
138	3	15	t	2024-09-27 14:42:34.463743	2024-09-27 14:42:34.463743
139	3	1	t	2024-09-27 14:42:34.467831	2024-09-27 14:42:34.467831
140	3	3	t	2024-09-27 14:42:34.472538	2024-09-27 14:42:34.472538
141	3	4	t	2024-09-27 14:42:34.47673	2024-09-27 14:42:34.47673
142	3	2	t	2024-09-27 14:42:34.480899	2024-09-27 14:42:34.480899
143	4	1	t	2024-09-27 14:42:34.488336	2024-09-27 14:42:34.488336
144	4	24	t	2024-09-27 14:42:34.491735	2024-09-27 14:42:34.491735
145	4	2	t	2024-09-27 14:42:34.494854	2024-09-27 14:42:34.494854
146	4	4	t	2024-09-27 14:42:34.498039	2024-09-27 14:42:34.498039
147	4	55	t	2024-09-27 14:42:34.501138	2024-09-27 14:42:34.501138
148	7	15	t	2024-09-27 14:42:34.514664	2024-09-27 14:42:34.514664
149	7	1	t	2024-09-27 14:42:34.517846	2024-09-27 14:42:34.517846
150	7	3	t	2024-09-27 14:42:34.520707	2024-09-27 14:42:34.520707
151	7	4	t	2024-09-27 14:42:34.524044	2024-09-27 14:42:34.524044
152	7	2	t	2024-09-27 14:42:34.531947	2024-09-27 14:42:34.531947
153	7	55	t	2024-09-27 14:42:34.535886	2024-09-27 14:42:34.535886
154	7	24	t	2024-09-27 14:42:34.539348	2024-09-27 14:42:34.539348
155	9	1	t	2024-09-27 14:42:34.552043	2024-09-27 14:42:34.552043
156	9	24	t	2024-09-27 14:42:34.555595	2024-09-27 14:42:34.555595
157	9	2	t	2024-09-27 14:42:34.559366	2024-09-27 14:42:34.559366
158	9	4	t	2024-09-27 14:42:34.563163	2024-09-27 14:42:34.563163
159	9	55	t	2024-09-27 14:42:34.566304	2024-09-27 14:42:34.566304
160	14	12	t	2024-09-27 14:42:34.590357	2024-09-27 14:42:34.590357
161	14	6	t	2024-09-27 14:42:34.593811	2024-09-27 14:42:34.593811
162	14	4	t	2024-09-27 14:42:34.597036	2024-09-27 14:42:34.597036
163	14	3	t	2024-09-27 14:42:34.600441	2024-09-27 14:42:34.600441
164	17	12	t	2024-09-27 14:42:34.615362	2024-09-27 14:42:34.615362
165	17	6	t	2024-09-27 14:42:34.619316	2024-09-27 14:42:34.619316
166	17	4	t	2024-09-27 14:42:34.623458	2024-09-27 14:42:34.623458
167	17	3	t	2024-09-27 14:42:34.627051	2024-09-27 14:42:34.627051
168	19	1	t	2024-09-27 14:42:34.6419	2024-09-27 14:42:34.6419
169	19	24	t	2024-09-27 14:42:34.645747	2024-09-27 14:42:34.645747
170	19	2	t	2024-09-27 14:42:34.649747	2024-09-27 14:42:34.649747
171	19	4	t	2024-09-27 14:42:34.653166	2024-09-27 14:42:34.653166
172	19	55	t	2024-09-27 14:42:34.656974	2024-09-27 14:42:34.656974
173	20	1	t	2024-09-27 14:42:34.666359	2024-09-27 14:42:34.666359
174	20	24	t	2024-09-27 14:42:34.669663	2024-09-27 14:42:34.669663
175	20	2	t	2024-09-27 14:42:34.673249	2024-09-27 14:42:34.673249
176	20	4	t	2024-09-27 14:42:34.676221	2024-09-27 14:42:34.676221
177	20	55	t	2024-09-27 14:42:34.679677	2024-09-27 14:42:34.679677
178	21	2	t	2024-09-27 14:42:34.687236	2024-09-27 14:42:34.687236
179	21	4	t	2024-09-27 14:42:34.690581	2024-09-27 14:42:34.690581
180	21	9	t	2024-09-27 14:42:34.693471	2024-09-27 14:42:34.693471
181	21	5	t	2024-09-27 14:42:34.697753	2024-09-27 14:42:34.697753
182	21	4	t	2024-09-27 14:42:34.701288	2024-09-27 14:42:34.701288
183	22	2	t	2024-09-27 14:42:34.708455	2024-09-27 14:42:34.708455
184	22	4	t	2024-09-27 14:42:34.711944	2024-09-27 14:42:34.711944
185	22	9	t	2024-09-27 14:42:34.714731	2024-09-27 14:42:34.714731
186	22	5	t	2024-09-27 14:42:34.717905	2024-09-27 14:42:34.717905
187	22	4	t	2024-09-27 14:42:34.721583	2024-09-27 14:42:34.721583
188	23	1	t	2024-09-27 14:42:34.729324	2024-09-27 14:42:34.729324
189	24	1	t	2024-09-27 14:42:34.737119	2024-09-27 14:42:34.737119
190	28	1	t	2024-09-27 14:42:34.756529	2024-09-27 14:42:34.756529
191	28	24	t	2024-09-27 14:42:34.760375	2024-09-27 14:42:34.760375
192	28	25	t	2024-09-27 14:42:34.763624	2024-09-27 14:42:34.763624
193	28	5	t	2024-09-27 14:42:34.766959	2024-09-27 14:42:34.766959
194	28	6	t	2024-09-27 14:42:34.769867	2024-09-27 14:42:34.769867
195	29	1	t	2024-09-27 14:42:34.777785	2024-09-27 14:42:34.777785
196	29	24	t	2024-09-27 14:42:34.781641	2024-09-27 14:42:34.781641
197	29	25	t	2024-09-27 14:42:34.785203	2024-09-27 14:42:34.785203
198	29	5	t	2024-09-27 14:42:34.788165	2024-09-27 14:42:34.788165
199	29	6	t	2024-09-27 14:42:34.791946	2024-09-27 14:42:34.791946
200	30	2	t	2024-09-27 14:42:34.800158	2024-09-27 14:42:34.800158
201	30	4	t	2024-09-27 14:42:34.803947	2024-09-27 14:42:34.803947
202	1	15	t	2024-09-27 14:44:01.852114	2024-09-27 14:44:01.852114
203	3	15	t	2024-09-27 14:44:01.874609	2024-09-27 14:44:01.874609
204	3	1	t	2024-09-27 14:44:01.880828	2024-09-27 14:44:01.880828
205	3	3	t	2024-09-27 14:44:01.888203	2024-09-27 14:44:01.888203
206	3	4	t	2024-09-27 14:44:01.89496	2024-09-27 14:44:01.89496
207	3	2	t	2024-09-27 14:44:01.900879	2024-09-27 14:44:01.900879
208	4	1	t	2024-09-27 14:44:01.911147	2024-09-27 14:44:01.911147
209	4	24	t	2024-09-27 14:44:01.915456	2024-09-27 14:44:01.915456
210	4	2	t	2024-09-27 14:44:01.918919	2024-09-27 14:44:01.918919
211	4	4	t	2024-09-27 14:44:01.92252	2024-09-27 14:44:01.92252
212	4	55	t	2024-09-27 14:44:01.926554	2024-09-27 14:44:01.926554
213	7	15	t	2024-09-27 14:44:01.947452	2024-09-27 14:44:01.947452
214	7	1	t	2024-09-27 14:44:01.953581	2024-09-27 14:44:01.953581
215	7	3	t	2024-09-27 14:44:01.959109	2024-09-27 14:44:01.959109
216	7	4	t	2024-09-27 14:44:01.964184	2024-09-27 14:44:01.964184
217	7	2	t	2024-09-27 14:44:01.973985	2024-09-27 14:44:01.973985
218	7	55	t	2024-09-27 14:44:01.979995	2024-09-27 14:44:01.979995
219	7	24	t	2024-09-27 14:44:01.985257	2024-09-27 14:44:01.985257
220	9	1	t	2024-09-27 14:44:02.000589	2024-09-27 14:44:02.000589
221	9	24	t	2024-09-27 14:44:02.004358	2024-09-27 14:44:02.004358
222	9	2	t	2024-09-27 14:44:02.008251	2024-09-27 14:44:02.008251
223	9	4	t	2024-09-27 14:44:02.012348	2024-09-27 14:44:02.012348
224	9	55	t	2024-09-27 14:44:02.01582	2024-09-27 14:44:02.01582
225	14	12	t	2024-09-27 14:44:02.04662	2024-09-27 14:44:02.04662
226	14	6	t	2024-09-27 14:44:02.051006	2024-09-27 14:44:02.051006
227	14	4	t	2024-09-27 14:44:02.055801	2024-09-27 14:44:02.055801
228	14	3	t	2024-09-27 14:44:02.060615	2024-09-27 14:44:02.060615
229	17	12	t	2024-09-27 14:44:02.081501	2024-09-27 14:44:02.081501
230	17	6	t	2024-09-27 14:44:02.087502	2024-09-27 14:44:02.087502
231	17	4	t	2024-09-27 14:44:02.092	2024-09-27 14:44:02.092
232	17	3	t	2024-09-27 14:44:02.095531	2024-09-27 14:44:02.095531
233	19	1	t	2024-09-27 14:44:02.108479	2024-09-27 14:44:02.108479
234	19	24	t	2024-09-27 14:44:02.111809	2024-09-27 14:44:02.111809
235	19	2	t	2024-09-27 14:44:02.115379	2024-09-27 14:44:02.115379
236	19	4	t	2024-09-27 14:44:02.118527	2024-09-27 14:44:02.118527
237	19	55	t	2024-09-27 14:44:02.122467	2024-09-27 14:44:02.122467
238	20	1	t	2024-09-27 14:44:02.133608	2024-09-27 14:44:02.133608
239	20	24	t	2024-09-27 14:44:02.138984	2024-09-27 14:44:02.138984
240	20	2	t	2024-09-27 14:44:02.145756	2024-09-27 14:44:02.145756
241	20	4	t	2024-09-27 14:44:02.152257	2024-09-27 14:44:02.152257
242	20	55	t	2024-09-27 14:44:02.158554	2024-09-27 14:44:02.158554
243	21	2	t	2024-09-27 14:44:02.174156	2024-09-27 14:44:02.174156
244	21	4	t	2024-09-27 14:44:02.181137	2024-09-27 14:44:02.181137
245	21	9	t	2024-09-27 14:44:02.187148	2024-09-27 14:44:02.187148
246	21	5	t	2024-09-27 14:44:02.193581	2024-09-27 14:44:02.193581
247	21	4	t	2024-09-27 14:44:02.197428	2024-09-27 14:44:02.197428
248	22	2	t	2024-09-27 14:44:02.205199	2024-09-27 14:44:02.205199
249	22	4	t	2024-09-27 14:44:02.20863	2024-09-27 14:44:02.20863
250	22	9	t	2024-09-27 14:44:02.211718	2024-09-27 14:44:02.211718
251	22	5	t	2024-09-27 14:44:02.215119	2024-09-27 14:44:02.215119
252	22	4	t	2024-09-27 14:44:02.218387	2024-09-27 14:44:02.218387
253	23	1	t	2024-09-27 14:44:02.228836	2024-09-27 14:44:02.228836
254	24	1	t	2024-09-27 14:44:02.241622	2024-09-27 14:44:02.241622
255	28	1	t	2024-09-27 14:44:02.273708	2024-09-27 14:44:02.273708
256	28	24	t	2024-09-27 14:44:02.279637	2024-09-27 14:44:02.279637
257	28	25	t	2024-09-27 14:44:02.285102	2024-09-27 14:44:02.285102
258	28	5	t	2024-09-27 14:44:02.290784	2024-09-27 14:44:02.290784
259	28	6	t	2024-09-27 14:44:02.295355	2024-09-27 14:44:02.295355
260	29	1	t	2024-09-27 14:44:02.303653	2024-09-27 14:44:02.303653
261	29	24	t	2024-09-27 14:44:02.307292	2024-09-27 14:44:02.307292
262	29	25	t	2024-09-27 14:44:02.31083	2024-09-27 14:44:02.31083
263	29	5	t	2024-09-27 14:44:02.313785	2024-09-27 14:44:02.313785
264	29	6	t	2024-09-27 14:44:02.317074	2024-09-27 14:44:02.317074
265	30	2	t	2024-09-27 14:44:02.325558	2024-09-27 14:44:02.325558
266	30	4	t	2024-09-27 14:44:02.331445	2024-09-27 14:44:02.331445
267	31	2	t	2024-09-27 14:44:02.350028	2024-09-27 14:44:02.350028
268	31	4	t	2024-09-27 14:44:02.356264	2024-09-27 14:44:02.356264
269	32	2	t	2024-09-27 14:44:02.374813	2024-09-27 14:44:02.374813
270	32	4	t	2024-09-27 14:44:02.380022	2024-09-27 14:44:02.380022
271	25	12	t	2024-10-31 07:17:10.41569	2024-10-31 07:17:10.41569
272	27	12	t	2024-10-31 07:17:10.419437	2024-10-31 07:17:10.419437
273	28	12	t	2024-10-31 07:17:10.421403	2024-10-31 07:17:10.421403
1	1	40	t	2024-09-27 13:36:30.918447	2025-05-29 09:21:57.442197
2	1	15	t	2024-09-27 14:31:43.570477	2025-05-29 09:21:57.445426
3	3	15	t	2024-09-27 14:31:43.596037	2025-05-29 09:21:57.448797
4	3	1	t	2024-09-27 14:31:43.600323	2025-05-29 09:21:57.451928
5	3	3	t	2024-09-27 14:31:43.604492	2025-05-29 09:21:57.457062
6	3	4	t	2024-09-27 14:31:43.607875	2025-05-29 09:21:57.461089
7	3	2	t	2024-09-27 14:31:43.611612	2025-05-29 09:21:57.464227
8	4	1	t	2024-09-27 14:31:43.621055	2025-05-29 09:21:57.468196
9	4	24	t	2024-09-27 14:31:43.624578	2025-05-29 09:21:57.471533
10	4	2	t	2024-09-27 14:31:43.628021	2025-05-29 09:21:57.474323
11	4	4	t	2024-09-27 14:31:43.631381	2025-05-29 09:21:57.477701
12	4	55	t	2024-09-27 14:31:43.634965	2025-05-29 09:21:57.480947
13	7	15	t	2024-09-27 14:31:43.666984	2025-05-29 09:21:57.483805
14	7	1	t	2024-09-27 14:31:43.67113	2025-05-29 09:21:57.48699
15	7	3	t	2024-09-27 14:31:43.674585	2025-05-29 09:21:57.489806
16	7	4	t	2024-09-27 14:31:43.67857	2025-05-29 09:21:57.49285
17	7	2	t	2024-09-27 14:31:43.681969	2025-05-29 09:21:57.496058
18	7	55	t	2024-09-27 14:31:43.68525	2025-05-29 09:21:57.499104
19	7	24	t	2024-09-27 14:31:43.689051	2025-05-29 09:21:57.501878
20	9	1	t	2024-09-27 14:31:43.70626	2025-05-29 09:21:57.504902
21	9	24	t	2024-09-27 14:31:43.709533	2025-05-29 09:21:57.507795
22	9	2	t	2024-09-27 14:31:43.712625	2025-05-29 09:21:57.511365
23	9	4	t	2024-09-27 14:31:43.715394	2025-05-29 09:21:57.515429
24	9	55	t	2024-09-27 14:31:43.718671	2025-05-29 09:21:57.518728
25	14	12	t	2024-09-27 14:31:43.770428	2025-05-29 09:21:57.5216
26	14	6	t	2024-09-27 14:31:43.775356	2025-05-29 09:21:57.525012
27	14	4	t	2024-09-27 14:31:43.779953	2025-05-29 09:21:57.528246
28	14	3	t	2024-09-27 14:31:43.78374	2025-05-29 09:21:57.531302
29	17	12	t	2024-09-27 14:31:43.807495	2025-05-29 09:21:57.534482
30	17	6	t	2024-09-27 14:31:43.810664	2025-05-29 09:21:57.53744
31	17	4	t	2024-09-27 14:31:43.813563	2025-05-29 09:21:57.540746
32	17	3	t	2024-09-27 14:31:43.816516	2025-05-29 09:21:57.543986
33	19	1	t	2024-09-27 14:31:43.833525	2025-05-29 09:21:57.546863
34	19	24	t	2024-09-27 14:31:43.837534	2025-05-29 09:21:57.54996
35	19	2	t	2024-09-27 14:31:43.84125	2025-05-29 09:21:57.553085
36	19	4	t	2024-09-27 14:31:43.845049	2025-05-29 09:21:57.556148
37	19	55	t	2024-09-27 14:31:43.847991	2025-05-29 09:21:57.559682
38	20	1	t	2024-09-27 14:31:43.858888	2025-05-29 09:21:57.56287
39	20	24	t	2024-09-27 14:31:43.862902	2025-05-29 09:21:57.566068
40	20	2	t	2024-09-27 14:31:43.866238	2025-05-29 09:21:57.569946
41	20	4	t	2024-09-27 14:31:43.870468	2025-05-29 09:21:57.57292
42	20	55	t	2024-09-27 14:31:43.874103	2025-05-29 09:21:57.577384
43	21	2	t	2024-09-27 14:31:43.885596	2025-05-29 09:21:57.580919
44	21	4	t	2024-09-27 14:31:43.888917	2025-05-29 09:21:57.584541
45	21	9	t	2024-09-27 14:31:43.892771	2025-05-29 09:21:57.589434
46	21	5	t	2024-09-27 14:31:43.895671	2025-05-29 09:21:57.594287
48	22	2	t	2024-09-27 14:31:43.909489	2025-05-29 09:21:57.598455
49	22	4	t	2024-09-27 14:31:43.912932	2025-05-29 09:21:57.603075
50	22	9	t	2024-09-27 14:31:43.915723	2025-05-29 09:21:57.607671
51	22	5	t	2024-09-27 14:31:43.918891	2025-05-29 09:21:57.611767
53	22	1	t	2024-09-27 14:31:43.933909	2025-05-29 09:21:57.616331
54	24	12	t	2024-09-27 14:31:43.946402	2025-05-29 09:21:57.620702
55	28	1	t	2024-09-27 14:31:43.980167	2025-05-29 09:21:57.624806
56	28	24	t	2024-09-27 14:31:43.984401	2025-05-29 09:21:57.629254
57	28	25	t	2024-09-27 14:31:43.98741	2025-05-29 09:21:57.633874
58	28	5	t	2024-09-27 14:31:43.992195	2025-05-29 09:21:57.638105
59	28	6	t	2024-09-27 14:31:43.995235	2025-05-29 09:21:57.642529
60	29	1	t	2024-09-27 14:31:44.006012	2025-05-29 09:21:57.646557
61	29	24	t	2024-09-27 14:31:44.008923	2025-05-29 09:21:57.650662
62	29	25	t	2024-09-27 14:31:44.012071	2025-05-29 09:21:57.65493
63	29	5	t	2024-09-27 14:31:44.01492	2025-05-29 09:21:57.658313
64	29	6	t	2024-09-27 14:31:44.017794	2025-05-29 09:21:57.661188
65	30	2	t	2024-09-27 14:31:44.028741	2025-05-29 09:21:57.664472
66	30	4	t	2024-09-27 14:31:44.03321	2025-05-29 09:21:57.667631
67	30	9	t	2024-09-27 14:31:44.037077	2025-05-29 09:21:57.67077
68	30	5	t	2024-09-27 14:31:44.041288	2025-05-29 09:21:57.673862
69	22	25	t	2024-09-27 14:42:34.708455	2024-09-27 14:42:34.708455
70	31	2	t	2024-09-27 14:44:02.350028	2024-09-27 14:44:02.350028
71	31	4	t	2024-09-27 14:44:02.356264	2024-09-27 14:44:02.356264
72	32	2	t	2024-09-27 14:44:02.374813	2024-09-27 14:44:02.374813
73	32	4	t	2024-09-27 14:44:02.380022	2024-09-27 14:44:02.380022
74	25	5	t	2024-10-31 07:17:10.41569	2024-10-31 07:17:10.41569
75	27	12	t	2024-10-31 07:17:10.419437	2024-10-31 07:17:10.419437
274	1	40	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
275	1	15	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
276	3	15	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
277	3	1	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
278	3	3	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
279	3	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
280	3	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
281	4	1	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
282	4	24	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
283	4	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
284	4	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
285	4	55	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
286	7	15	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
287	7	1	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
288	7	3	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
289	7	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
290	7	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
291	7	55	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
292	7	24	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
293	9	1	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
294	9	24	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
295	9	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
296	9	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
297	9	55	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
298	14	12	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
299	14	6	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
300	14	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
301	14	3	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
302	17	12	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
303	17	6	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
304	17	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
305	17	3	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
306	19	1	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
307	19	24	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
308	19	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
309	19	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
310	19	55	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
311	20	1	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
312	20	24	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
313	20	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
314	20	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
315	20	55	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
316	21	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
317	21	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
318	21	9	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
319	21	5	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
320	24	12	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
321	28	12	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
322	29	12	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
323	30	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
324	30	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
325	30	9	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
326	30	5	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
327	31	2	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
328	31	4	t	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
332	1	40	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
333	1	15	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
334	3	15	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
335	3	1	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
336	3	3	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
337	3	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
338	3	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
339	4	1	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
340	4	24	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
341	4	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
342	4	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
343	4	55	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
344	7	15	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
345	7	1	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
346	7	3	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
347	7	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
348	7	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
349	7	55	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
331	42	12	f	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
330	47	12	f	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
329	43	12	f	2025-06-30 07:56:39.937197	2025-06-30 07:56:39.937197
350	7	24	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
351	9	1	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
352	9	24	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
353	9	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
354	9	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
355	9	55	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
356	14	12	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
357	14	6	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
358	14	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
359	14	3	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
360	17	12	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
361	17	6	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
362	17	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
363	17	3	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
364	19	1	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
365	19	24	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
366	19	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
367	19	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
368	19	55	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
369	20	1	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
370	20	24	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
371	20	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
372	20	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
373	20	55	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
374	21	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
375	21	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
376	21	9	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
377	21	5	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
378	24	12	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
379	28	12	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
380	29	12	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
381	30	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
382	30	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
383	30	9	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
384	30	5	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
385	31	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
386	31	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
387	32	2	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
388	32	4	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
389	25	5	f	2025-07-08 09:09:02.979444	2025-07-08 09:09:02.979444
390	38	12	f	2025-07-09 08:19:05.905236	2025-07-09 08:19:05.905236
391	40	12	f	2025-07-09 08:19:05.907398	2025-07-09 08:19:05.907398
392	42	5	f	2025-07-09 08:19:05.908809	2025-07-09 08:19:05.908809
393	41	12	f	2025-07-09 08:19:05.910013	2025-07-09 08:19:05.910013
\.


--
-- Data for Name: workflow_state_transitioners; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.workflow_state_transitioners (id, workflow_state_transition, stakeholder, start_date, end_date, voided, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: workflow_state_transitions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.workflow_state_transitions (id, workflow_state_id, next_state, voided, created_at, updated_at, action, by_owner, by_supervisor) FROM stdin;
1	6	7	t	2024-09-27 13:26:38.599084	2024-09-27 13:26:38.599084	Submit Timesheet	t	f
2	7	8	t	2024-09-27 14:31:43.581635	2024-09-27 14:31:43.581635	Recall Timesheet	t	f
3	7	9	t	2024-09-27 14:31:43.591177	2024-09-27 14:31:43.591177	Reject Timesheet	f	t
4	7	10	t	2024-09-27 14:31:43.617799	2024-09-27 14:31:43.617799	Approve Timesheet	f	t
5	8	12	t	2024-09-27 14:31:43.642968	2024-09-27 14:31:43.642968	Re-submit Timesheet	t	f
6	9	12	t	2024-09-27 14:31:43.65027	2024-09-27 14:31:43.65027	Re-submit Timesheet	t	f
7	10	11	t	2024-09-27 14:31:43.662024	2024-09-27 14:31:43.662024	Re-open Timesheet	f	t
8	11	12	t	2024-09-27 14:31:43.696226	2024-09-27 14:31:43.696226	Re-submit Timesheet	t	f
9	12	10	t	2024-09-27 14:31:43.703088	2024-09-27 14:31:43.703088	Approve Timesheet	f	t
10	1	2	t	2024-09-27 14:31:43.726642	2024-09-27 14:31:43.726642	Approve Request	f	t
11	1	3	t	2024-09-27 14:31:43.735498	2024-09-27 14:31:43.735498	Reject Request	f	t
12	1	13	t	2024-09-27 14:31:43.745777	2024-09-27 14:31:43.745777	Withdrawal Request	t	f
13	2	13	t	2024-09-27 14:31:43.754335	2024-09-27 14:31:43.754335	Withdrawal Request	t	f
14	2	4	t	2024-09-27 14:31:43.764515	2024-09-27 14:31:43.764515	Asset Prepared	f	f
15	4	13	t	2024-09-27 14:31:43.791477	2024-09-27 14:31:43.791477	Withdrawal Request	t	f
16	4	5	t	2024-09-27 14:31:43.798053	2024-09-27 14:31:43.798053	Collect Asset	t	f
17	4	5	t	2024-09-27 14:31:43.804404	2024-09-27 14:31:43.804404	Release Asset	t	f
18	14	18	t	2024-09-27 14:31:43.822239	2024-09-27 14:31:43.822239	Rescind Request	t	f
19	14	15	t	2024-09-27 14:31:43.829814	2024-09-27 14:31:43.829814	Approve Travel	f	t
20	14	19	t	2024-09-27 14:31:43.854775	2024-09-27 14:31:43.854775	Deny Travel	f	t
21	15	16	t	2024-09-27 14:31:43.881211	2024-09-27 14:31:43.881211	Approve Travel	f	f
22	15	20	t	2024-09-27 14:31:43.904875	2024-09-27 14:31:43.904875	Deny Travel	f	f
23	16	17	t	2024-09-27 14:31:43.929527	2024-09-27 14:31:43.929527	Approve 	f	f
24	16	21	t	2024-09-27 14:31:43.941306	2024-09-27 14:31:43.941306	Deny Travel	f	f
25	15	18	t	2024-09-27 14:31:43.953697	2024-09-27 14:31:43.953697	Rescind Request	t	f
26	16	18	t	2024-09-27 14:31:43.961599	2024-09-27 14:31:43.961599	Rescind Request	t	f
27	22	23	t	2024-09-27 14:31:43.968381	2024-09-27 14:31:43.968381	Rescind Request	t	f
28	22	26	t	2024-09-27 14:31:43.975351	2024-09-27 14:31:43.975351	Reject Request	f	t
29	22	24	t	2024-09-27 14:31:44.002564	2024-09-27 14:31:44.002564	Approve Request	f	t
30	24	25	t	2024-09-27 14:31:44.024611	2024-09-27 14:31:44.024611	Approve Funds	f	f
31	24	27	t	2024-09-27 14:44:02.343294	2024-09-27 14:44:02.343294	Deny Funds	f	f
32	25	28	t	2024-09-27 14:44:02.368452	2024-09-27 14:44:02.368452	Release Funds	f	f
33	28	29	t	2024-09-27 14:44:02.391129	2024-09-27 14:44:02.391129	Collect Funds	t	f
34	26	23	t	2024-09-27 14:44:02.399392	2024-09-27 14:44:02.399392	Rescind Request	t	f
35	30	31	t	2024-09-27 14:44:02.405217	2024-09-27 14:44:02.405217	Approve Leave	f	t
36	30	32	t	2024-09-27 14:44:02.413185	2024-09-27 14:44:02.413185	Deny Leave	f	t
37	30	33	t	2024-09-27 14:44:02.4203	2024-09-27 14:44:02.4203	Rescind Request	t	f
38	32	31	t	2024-09-27 14:44:02.430521	2024-09-27 14:44:02.430521	Approve Leave	f	t
39	31	34	t	2024-09-27 14:44:02.439378	2024-09-27 14:44:02.439378	Cancel Leave	f	t
40	26	35	t	2025-04-24 10:07:36.745249	2025-04-24 10:07:36.745249	Recall Request	t	f
41	35	22	t	2025-04-28 11:41:13.346325	2025-04-28 11:41:13.346325	Re-submit Request	t	f
42	22	35	t	2025-04-30 14:21:33.969245	2025-04-30 14:21:33.969245	Recall Request	t	f
43	29	36	t	2025-06-11 09:28:46.382999	2025-06-11 09:28:46.382999	Liquidate Funds	f	f
44	28	29	t	2025-06-11 09:28:46.385074	2025-06-11 09:28:46.385074	Disburse Funds	f	f
45	26	35	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Recall Request	t	f
46	35	22	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Re-submit Request	t	f
47	22	35	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Recall Request	t	f
48	29	36	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Liquidate Funds	f	f
49	28	29	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Disburse Funds	f	f
50	6	7	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Submit Timesheet	t	f
51	7	8	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Recall Timesheet	t	f
52	7	9	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Reject Timesheet	f	t
53	7	10	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Timesheet	f	t
54	8	12	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Re-submit Timesheet	t	f
55	9	12	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Re-submit Timesheet	t	f
56	10	11	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Re-open Timesheet	f	t
57	11	12	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Re-submit Timesheet	t	f
58	12	10	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Timesheet	f	t
59	1	2	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Request	f	t
60	1	3	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Reject Request	f	t
61	1	13	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Withdrawal Request	t	f
62	2	13	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Withdrawal Request	t	f
63	2	4	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Asset Prepared	f	f
64	4	13	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Withdrawal Request	t	f
65	4	5	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Collect Asset	t	f
66	4	5	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Release Asset	t	f
67	14	18	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Rescind Request	t	f
68	14	15	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Travel	f	t
69	14	19	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Deny Travel	f	t
70	15	16	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Travel	f	f
71	15	20	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Deny Travel	f	f
72	16	17	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve 	f	f
73	16	21	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Deny Travel	f	f
74	15	18	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Rescind Request	t	f
75	16	18	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Rescind Request	t	f
76	22	23	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Rescind Request	t	f
77	22	26	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Reject Request	f	t
78	22	24	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Request	f	t
79	24	25	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Funds	f	f
80	24	27	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Deny Funds	f	f
81	25	28	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Release Funds	f	f
82	28	29	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Collect Funds	t	f
83	26	23	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Rescind Request	t	f
84	30	31	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Leave	f	t
85	30	32	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Deny Leave	f	t
86	30	33	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Rescind Request	t	f
87	31	34	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Cancel Leave	f	t
88	32	31	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Approve Leave	f	t
89	9	8	t	2025-06-30 07:58:20.335319	2025-06-30 07:58:20.335319	Recall Timesheet	t	f
90	26	35	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Recall Request	t	f
91	35	22	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Re-submit Request	t	f
92	22	35	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Recall Request	t	f
93	29	36	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Liquidate Funds	f	f
94	28	29	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Disburse Funds	f	f
95	6	7	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Submit Timesheet	t	f
96	7	8	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Recall Timesheet	t	f
97	7	9	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Reject Timesheet	f	t
98	7	10	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Timesheet	f	t
99	8	12	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Re-submit Timesheet	t	f
100	9	12	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Re-submit Timesheet	t	f
101	10	11	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Re-open Timesheet	f	t
102	11	12	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Re-submit Timesheet	t	f
103	12	10	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Timesheet	f	t
104	1	2	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Request	f	t
105	1	3	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Reject Request	f	t
106	1	13	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Withdrawal Request	t	f
107	2	13	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Withdrawal Request	t	f
108	2	4	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Asset Prepared	f	f
109	4	13	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Withdrawal Request	t	f
110	4	5	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Collect Asset	t	f
111	4	5	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Release Asset	t	f
112	14	18	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Rescind Request	t	f
113	14	15	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Travel	f	t
114	14	19	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Deny Travel	f	t
115	15	16	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Travel	f	f
116	15	20	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Deny Travel	f	f
117	16	17	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve 	f	f
118	16	21	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Deny Travel	f	f
119	15	18	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Rescind Request	t	f
120	16	18	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Rescind Request	t	f
121	22	23	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Rescind Request	t	f
122	22	26	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Reject Request	f	t
123	22	24	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Request	f	t
124	24	25	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Funds	f	f
125	24	27	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Deny Funds	f	f
126	25	28	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Release Funds	f	f
127	28	29	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Collect Funds	t	f
128	26	23	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Rescind Request	t	f
129	30	31	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Leave	f	t
130	30	32	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Deny Leave	f	t
131	30	33	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Rescind Request	t	f
132	31	34	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Cancel Leave	f	t
133	32	31	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Approve Leave	f	t
134	9	8	f	2025-07-08 09:08:45.710439	2025-07-08 09:08:45.710439	Recall Timesheet	t	f
135	37	38	f	2025-07-09 08:19:05.924616	2025-07-09 08:19:05.924616	Approve Request	f	t
136	37	39	f	2025-07-09 08:19:05.927755	2025-07-09 08:19:05.927755	Reject Request	f	t
139	40	42	f	2025-07-09 08:19:05.934578	2025-07-09 08:19:05.934578	Request Payment	f	f
140	41	42	f	2025-07-09 08:19:05.936777	2025-07-09 08:19:05.936777	Request Payment	f	f
141	42	43	f	2025-07-09 08:19:05.939305	2025-07-09 08:19:05.939305	Approve Funds	f	f
142	42	44	f	2025-07-09 08:19:05.941444	2025-07-09 08:19:05.941444	Deny Funds	f	f
144	40	45	f	2025-07-17 11:25:33.753027	2025-07-17 11:25:33.753027	Confirm Delivery	f	f
143	42	45	f	2025-07-16 12:25:33.753027	2025-07-16 12:25:33.753027	Confirm Delivery	f	f
138	38	41	f	2025-07-09 08:19:05.932392	2025-07-09 08:19:05.932392	Initiate Payment Request	f	f
145	38	46	f	2025-07-23 08:19:05.941444	2025-07-23 08:19:05.941444	Withdraw Request	f	f
137	38	40	t	2025-07-09 08:19:05.930167	2025-07-09 08:19:05.930167	Source Quotations	f	f
146	45	47	f	2025-07-29 08:19:05.941444	2025-07-29 08:19:05.941444	Accept Item	t	t
147	45	48	f	2025-07-29 08:19:05.941444	2025-07-29 08:19:05.941444	Reject Item	t	t
148	47	49	f	2025-07-30 12:08:26.166105	2025-07-30 12:08:26.166105	Finish Process	f	f
149	43	45	f	2025-07-30 12:08:26.166105	2025-07-30 12:08:26.166105	Confirm Delivery	f	f
150	37	50	f	2025-08-01 12:08:26.166105	2025-08-01 12:08:26.166105	Rescind Request	t	f
151	39	50	f	2025-08-01 12:08:26.166105	2025-08-01 12:08:26.166105	Rescind Request	t	f
152	44	50	f	2025-08-01 12:08:26.166105	2025-08-01 12:08:26.166105	Rescind Request	t	f
153	46	50	f	2025-08-01 12:08:26.166105	2025-08-01 12:08:26.166105	Rescind Request	t	f
\.


--
-- Data for Name: workflow_states; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.workflow_states (workflow_state_id, workflow_process_id, state, description, voided, created_at, updated_at) FROM stdin;
1	1	Requested	Initial State of requesting an asset	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
2	1	Approved	Request for the asset has been approved and asset can be given	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
3	1	Rejected	Request for the asset has been rejected	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
4	1	Prepared	Asset approved for use is ready for collection	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
5	1	Collected	Approved asset has been collected by requester	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
6	2	Pending Submission	State where the timesheet is open for editing by the user	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
7	2	Submitted	State where the timesheet has been submitted by the employee to the supervisor for review	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
8	2	Recalled	State where the timesheet was previously submitted by the employee to the supervisor for review but the employee requested the timesheet to be re-opened for editing	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
9	2	Rejected	State where a submitted timesheet has been sent back by the supervisor for the employee to fix something	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
10	2	Approved	State where a submitted timesheet has been cleared by the supervisor	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
11	2	Re-opened	State where a previously approved timesheet is made available for editing by the supervisor or designated official	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
12	2	Re-submitted	State where a timesheet has been resubmitted and has to be approves by the supervisor or designated official	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
13	1	Rescinded	Request for asset has been withdrawn	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
14	3	Initiated	Initial state were someone has requested travel	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
15	3	Program Approved	State where the program manager has approved the trip as being necessary	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
16	3	Budget Approved	State where the finance team has confirmed that the necessary budget for the travel is available	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
17	3	Approved	The travel has been fully approved and can take place	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
18	3	Rescinded	Original Requester has withdrawn the request for the travel	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
19	3	Program Rejected	Travel rejected for programmatic reasons	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
20	3	Budget Rejected	Travel rejected for budget or financial reasons	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
21	3	Denied	Travel not approved and shouldn’t take place	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
22	4	Requested	State where petty cash has been requested	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
23	4	Rescinded	State where request for petty cash has been withdrawn	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
24	4	Approved	State where supervisor has approved request for petty cash	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
25	4	Finances Approved	State where finance team has confirmed availability of funds	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
26	4	Rejected	State where supervisor has rejected the request for petty cash	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
27	4	Finances Rejected	State where finance team has rejected request due to insufficient funds	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
28	4	Prepared	State where petty cash is ready for collection	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
29	4	Collected	State where petty cash has been collected	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
30	5	Requested	Initial State for leave requests	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
31	5	Approved	Leave request approved by supervisor and can be taken	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
32	5	Rejected	Leave rejected by supervisor	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
33	5	Rescinded	Leave Request rescinded	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
34	5	Canceled	Leave request canceled by supervisor	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
35	4	Recalled	State where petty cash has been recalled	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
36	4	Liquidated	State where petty cash has been liquidated	f	2025-07-08 09:08:26.166105	2025-07-08 09:08:26.166105
37	6	Requested	Purchase request has been initiated	f	2025-07-09 13:33:59.589456	2025-07-09 13:33:59.589456
40	6	Under Procurement	Purchase request is under procurement	f	2025-07-09 13:33:59.593336	2025-07-09 13:33:59.593336
39	6	Rejected	State where purchase request has rejected	f	2025-07-09 13:33:59.59681	2025-07-09 13:33:59.59681
42	6	Payment Requested	Purchase request has requested payment	f	2025-07-09 13:33:59.60192	2025-07-09 13:33:59.60192
43	6	Funds Approved	Funds for the purchase request have been approved	f	2025-07-09 13:33:59.606661	2025-07-09 13:33:59.606661
44	6	Funds Rejected	Funds for the purchase request have been rejected	f	2025-07-09 13:33:59.609073	2025-07-09 13:33:59.609073
45	6	Delivered	Purchase request has been delivered	f	2025-07-16 12:25:33.741691	2025-07-16 12:25:33.741691
41	6	Pending Payment Request	Purchase request has been appealed to LPC	f	2025-07-09 13:33:59.59937	2025-07-09 13:33:59.59937
46	6	Withdrawn	Purchase request has been withdrawn	f	2025-07-25 12:08:26.166105	2025-07-25 12:08:26.166105
38	6	Under Procurement	Purchase request has been approved	f	2025-07-09 13:33:59.604344	2025-07-09 13:33:59.604344
48	6	Item Rejected	Purchased item has been rejected	f	2025-07-30 12:08:26.166105	2025-07-30 12:08:26.166105
47	6	Item Accepted	Purchased item has been received	f	2025-07-30 12:08:26.166105	2025-07-30 12:08:26.166105
49	6	Process Completed	Purchase request process has completed	f	2025-07-30 12:08:26.166105	2025-07-30 12:08:26.166105
50	6	Rescinded	State where the purchase request has rescinded	f	2025-08-01 12:08:26.166105	2025-08-01 12:08:26.166105
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, false);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, false);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: affiliations_affliation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.affiliations_affliation_id_seq', 113, true);


--
-- Name: asset_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.asset_categories_id_seq', 8, true);


--
-- Name: assets_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.assets_asset_id_seq', 224, true);


--
-- Name: branches_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.branches_branch_id_seq', 1, true);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 5, true);


--
-- Name: designation_workflow_state_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.designation_workflow_state_actions_id_seq', 1, false);


--
-- Name: designations_designation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.designations_designation_id_seq', 55, true);


--
-- Name: employee_designations_employee_designation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.employee_designations_employee_designation_id_seq', 135, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 115, true);


--
-- Name: global_properties_property_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.global_properties_property_id_seq', 14, true);


--
-- Name: initial_states_initial_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.initial_states_initial_state_id_seq', 11, true);


--
-- Name: inventory_item_categories_inventory_item_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.inventory_item_categories_inventory_item_category_id_seq', 1, false);


--
-- Name: inventory_item_issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.inventory_item_issues_id_seq', 1, false);


--
-- Name: inventory_item_thresholds_inventory_item_threshold_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.inventory_item_thresholds_inventory_item_threshold_id_seq', 1, false);


--
-- Name: inventory_item_types_inventory_item_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.inventory_item_types_inventory_item_type_id_seq', 1, false);


--
-- Name: inventory_items_inventory_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.inventory_items_inventory_item_id_seq', 1, false);


--
-- Name: leave_requests_leave_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.leave_requests_leave_request_id_seq', 282, true);


--
-- Name: leave_summaries_leave_summary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.leave_summaries_leave_summary_id_seq', 1311, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.logs_id_seq', 1, false);


--
-- Name: people_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.people_person_id_seq', 115, true);


--
-- Name: petty_cash_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.petty_cash_comments_id_seq', 20, true);


--
-- Name: project_task_assignments_project_task_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.project_task_assignments_project_task_assignment_id_seq', 1, false);


--
-- Name: project_tasks_project_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.project_tasks_project_task_id_seq', 1, false);


--
-- Name: project_teams_project_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.project_teams_project_team_id_seq', 156, true);


--
-- Name: projects_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.projects_project_id_seq', 31, true);


--
-- Name: purchase_request_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.purchase_request_attachments_id_seq', 46, true);


--
-- Name: report_statistics_statistic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.report_statistics_statistic_id_seq', 28, true);


--
-- Name: requisition_items_requisition_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.requisition_items_requisition_item_id_seq', 132, true);


--
-- Name: requisition_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.requisition_notes_id_seq', 1, false);


--
-- Name: requisitions_requisition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.requisitions_requisition_id_seq', 133, true);


--
-- Name: stakeholders_stakeholder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.stakeholders_stakeholder_id_seq', 4, true);


--
-- Name: supervisions_supervision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.supervisions_supervision_id_seq', 139, true);


--
-- Name: timesheet_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.timesheet_tasks_id_seq', 1, false);


--
-- Name: timesheets_timesheet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.timesheets_timesheet_id_seq', 41, true);


--
-- Name: token_logs_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.token_logs_token_id_seq', 75, true);


--
-- Name: travel_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ghii
--

SELECT pg_catalog.setval('public.travel_requests_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.users_user_id_seq', 115, true);


--
-- Name: workflow_processes_workflow_process_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.workflow_processes_workflow_process_id_seq', 5, true);


--
-- Name: workflow_state_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.workflow_state_actions_id_seq', 1, false);


--
-- Name: workflow_state_actors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.workflow_state_actors_id_seq', 393, true);


--
-- Name: workflow_state_transitioners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.workflow_state_transitioners_id_seq', 1, false);


--
-- Name: workflow_state_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.workflow_state_transitions_id_seq', 137, true);


--
-- Name: workflow_states_workflow_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.workflow_states_workflow_state_id_seq', 36, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: affiliations affiliations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.affiliations
    ADD CONSTRAINT affiliations_pkey PRIMARY KEY (affliation_id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: asset_categories asset_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT asset_categories_pkey PRIMARY KEY (id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (asset_id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (branch_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: designation_workflow_state_actions designation_workflow_state_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.designation_workflow_state_actions
    ADD CONSTRAINT designation_workflow_state_actions_pkey PRIMARY KEY (id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (designation_id);


--
-- Name: employee_designations employee_designations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.employee_designations
    ADD CONSTRAINT employee_designations_pkey PRIMARY KEY (employee_designation_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: global_properties global_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.global_properties
    ADD CONSTRAINT global_properties_pkey PRIMARY KEY (property_id);


--
-- Name: initial_states initial_states_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.initial_states
    ADD CONSTRAINT initial_states_pkey PRIMARY KEY (initial_state_id);


--
-- Name: inventory_item_categories inventory_item_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_categories
    ADD CONSTRAINT inventory_item_categories_pkey PRIMARY KEY (inventory_item_category_id);


--
-- Name: inventory_item_issues inventory_item_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_issues
    ADD CONSTRAINT inventory_item_issues_pkey PRIMARY KEY (id);


--
-- Name: inventory_item_thresholds inventory_item_thresholds_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_thresholds
    ADD CONSTRAINT inventory_item_thresholds_pkey PRIMARY KEY (inventory_item_threshold_id);


--
-- Name: inventory_item_types inventory_item_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_item_types
    ADD CONSTRAINT inventory_item_types_pkey PRIMARY KEY (inventory_item_type_id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (inventory_item_id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (leave_request_id);


--
-- Name: leave_summaries leave_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.leave_summaries
    ADD CONSTRAINT leave_summaries_pkey PRIMARY KEY (leave_summary_id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (person_id);


--
-- Name: petty_cash_comments petty_cash_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.petty_cash_comments
    ADD CONSTRAINT petty_cash_comments_pkey PRIMARY KEY (id);


--
-- Name: project_task_assignments project_task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.project_task_assignments
    ADD CONSTRAINT project_task_assignments_pkey PRIMARY KEY (project_task_assignment_id);


--
-- Name: project_tasks project_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.project_tasks
    ADD CONSTRAINT project_tasks_pkey PRIMARY KEY (project_task_id);


--
-- Name: project_teams project_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.project_teams
    ADD CONSTRAINT project_teams_pkey PRIMARY KEY (project_team_id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- Name: purchase_request_attachments purchase_request_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.purchase_request_attachments
    ADD CONSTRAINT purchase_request_attachments_pkey PRIMARY KEY (id);


--
-- Name: report_statistics report_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.report_statistics
    ADD CONSTRAINT report_statistics_pkey PRIMARY KEY (statistic_id);


--
-- Name: requisition_items requisition_items_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisition_items
    ADD CONSTRAINT requisition_items_pkey PRIMARY KEY (requisition_item_id);


--
-- Name: requisition_notes requisition_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisition_notes
    ADD CONSTRAINT requisition_notes_pkey PRIMARY KEY (id);


--
-- Name: requisitions requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT requisitions_pkey PRIMARY KEY (requisition_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stakeholders stakeholders_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.stakeholders
    ADD CONSTRAINT stakeholders_pkey PRIMARY KEY (stakeholder_id);


--
-- Name: supervisions supervisions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.supervisions
    ADD CONSTRAINT supervisions_pkey PRIMARY KEY (supervision_id);


--
-- Name: timesheet_tasks timesheet_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.timesheet_tasks
    ADD CONSTRAINT timesheet_tasks_pkey PRIMARY KEY (id);


--
-- Name: timesheets timesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_pkey PRIMARY KEY (timesheet_id);


--
-- Name: token_logs token_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.token_logs
    ADD CONSTRAINT token_logs_pkey PRIMARY KEY (token_id);


--
-- Name: travel_requests travel_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.travel_requests
    ADD CONSTRAINT travel_requests_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: workflow_processes workflow_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_processes
    ADD CONSTRAINT workflow_processes_pkey PRIMARY KEY (workflow_process_id);


--
-- Name: workflow_state_actions workflow_state_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_actions
    ADD CONSTRAINT workflow_state_actions_pkey PRIMARY KEY (id);


--
-- Name: workflow_state_actors workflow_state_actors_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_actors
    ADD CONSTRAINT workflow_state_actors_pkey PRIMARY KEY (id);


--
-- Name: workflow_state_transitioners workflow_state_transitioners_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_transitioners
    ADD CONSTRAINT workflow_state_transitioners_pkey PRIMARY KEY (id);


--
-- Name: workflow_state_transitions workflow_state_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_state_transitions
    ADD CONSTRAINT workflow_state_transitions_pkey PRIMARY KEY (id);


--
-- Name: workflow_states workflow_states_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workflow_states
    ADD CONSTRAINT workflow_states_pkey PRIMARY KEY (workflow_state_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: ghii
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: ghii
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: ghii
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: ghii
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_assets_on_requisition_id; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX index_assets_on_requisition_id ON public.assets USING btree (requisition_id);


--
-- Name: index_logs_on_loggable; Type: INDEX; Schema: public; Owner: ghii
--

CREATE INDEX index_logs_on_loggable ON public.logs USING btree (loggable_type, loggable_id);


--
-- Name: index_logs_on_transition; Type: INDEX; Schema: public; Owner: ghii
--

CREATE INDEX index_logs_on_transition ON public.logs USING btree (transition);


--
-- Name: index_logs_on_transition_by; Type: INDEX; Schema: public; Owner: ghii
--

CREATE INDEX index_logs_on_transition_by ON public.logs USING btree (transition_by);


--
-- Name: index_purchase_request_attachments_on_stakeholder_id; Type: INDEX; Schema: public; Owner: ghii
--

CREATE INDEX index_purchase_request_attachments_on_stakeholder_id ON public.purchase_request_attachments USING btree (stakeholder_id);


--
-- Name: index_travel_requests_on_asset_id; Type: INDEX; Schema: public; Owner: ghii
--

CREATE INDEX index_travel_requests_on_asset_id ON public.travel_requests USING btree (asset_id);


--
-- Name: requisitions fk_rails_3367949685; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT fk_rails_3367949685 FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: employees fk_rails_5c35da0673; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_rails_5c35da0673 FOREIGN KEY (person_id) REFERENCES public.people(person_id);


--
-- Name: purchase_request_attachments fk_rails_69c4ae9821; Type: FK CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.purchase_request_attachments
    ADD CONSTRAINT fk_rails_69c4ae9821 FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- Name: assets fk_rails_79cb940331; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_79cb940331 FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- Name: travel_requests fk_rails_8fdab0c84d; Type: FK CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.travel_requests
    ADD CONSTRAINT fk_rails_8fdab0c84d FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: petty_cash_comments fk_rails_9c017cba1c; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.petty_cash_comments
    ADD CONSTRAINT fk_rails_9c017cba1c FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- Name: travel_requests fk_rails_b39d8a199f; Type: FK CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.travel_requests
    ADD CONSTRAINT fk_rails_b39d8a199f FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id);


--
-- Name: purchase_request_attachments fk_rails_bedb79b2a7; Type: FK CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.purchase_request_attachments
    ADD CONSTRAINT fk_rails_bedb79b2a7 FOREIGN KEY (stakeholder_id) REFERENCES public.stakeholders(stakeholder_id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: ghii
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: departments fk_rails_dd358b3f48; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_rails_dd358b3f48 FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- PostgreSQL database dump complete
--

