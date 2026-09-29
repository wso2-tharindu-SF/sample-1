# sample-1 — PRD

## Problem Statement

Teams building multi-service systems need a small, well-understood reference
case for verifying that one service correctly aggregates data it fetches from
another: a consumer service computing a derived value from a fixed catalog
served by an upstream service, including the upstream service's behavior when
its data source is deliberately emptied. Without such a case, integration
behavior — request handling, per-request record counts, and the diagnostics
returned for bad requests — is hard to pin down and verify consistently.

## Solution

Two backend services. Service2 serves a fixed catalog of scored records and
exposes an internal operations endpoint that switches it between a full
catalog and an empty one. Service1 asks Service2 for the current catalog and
returns the average of the records' scores as a whole number. Both services
log how many records they handled per request, and Service1 returns a
structured 404 body for any path it does not serve.

## Actors

- **API Consumer** — any external caller that requests the average score from
Service1. No sign-in or API key is required to reach Service1.
- **Operator** — an internal administrator who calls Service2's operations
endpoint to switch it between full and empty catalog mode, e.g. for testing
or demonstration. This endpoint is internal only and is never reachable by
an API Consumer.

## User Stories

1. As an API Consumer, I want to request the current average score from
 Service1, so that I get a single computed summary of Service2's catalog
 without fetching and aggregating the records myself.
2. As an Operator, I want to switch Service2 between full and empty catalog
 mode through its internal operations endpoint, so that I can exercise
 Service2's behavior under both catalog conditions.
3. As an API Consumer, I want a request to a path Service1 does not serve to
 return a structured 404 body, so that I get clear, machine-readable
 feedback for invalid requests instead of an opaque failure.

## Product Decisions

- **Fixed catalog data**: in full mode, Service2 serves exactly this seed
data, reproduced verbatim in its OpenAPI contract and in its seed data:
- **Starting mode**: Service2 starts in full mode.
- **Mode switch**: Service2's operations endpoint toggles it between full mode
(the catalog above) and empty mode (no records). It is internal only —
never exposed to an API Consumer.
- **Average computation**: Service1 computes the average as the sum of every
record's score divided by the number of records, returned as a whole
number with any remainder discarded. Against the full catalog this average
is 35.
- **One computation path**: the same computation runs for whichever catalog
Service2 is currently serving — there is no separate path or separate
result per catalog.
- **Per-request logging**: both Service1 and Service2 log how many records
they handled for each request they process.
- **Unmatched paths**: a request to a path Service1 does not serve returns a
structured 404 body.
- **Access to Service1**: open to any caller — no sign-in and no API key are
required.
- **No web front-end**: this project delivers Service1 and Service2 as
backend APIs only; any consumer integrates directly with Service1's API.

## Out of Scope

- An empty-catalog variant, alternative response, or optional field on either
service's OpenAPI contract — empty mode is a fault condition for Service1,
not a documented alternative response shape.
- What Service1 returns when Service2's catalog is empty — no computed value,
default, or error response for that case is defined by this PRD.
- Any 4xx or 5xx response documented on Service1's average endpoint — that
endpoint's contract documents exactly one response, the successful average.
The structured 404 for unmatched paths applies only to paths Service1 does
not serve, not to this endpoint.
- Any catalog management beyond the fixed seed data and the full/empty mode
switch — no creating, updating, or deleting individual records.
- A web or other user-facing front-end.

## Open Questions

None at this time.