// Structured error body for paths this service does not serve. Same shape
// as service2's Error schema (code, message, description, moreInfo), even
// though this service's own openapi.yaml does not document it — it is
// required behavior for unmatched paths, not part of the /average contract.
public type Error record {|
    int code;
    string message;
    string description?;
    string moreInfo?;
|};
