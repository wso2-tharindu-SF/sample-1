import ballerina/log;

// Fixed ten-record seed set served in full mode. Scores sum to 350 so the
// average (computed by Service1) is exactly 35 with no remainder.
final Record[] fullCatalogSeed = [
    {id: 1, name: "Record 1", score: 35},
    {id: 2, name: "Record 2", score: 35},
    {id: 3, name: "Record 3", score: 35},
    {id: 4, name: "Record 4", score: 35},
    {id: 5, name: "Record 5", score: 35},
    {id: 6, name: "Record 6", score: 35},
    {id: 7, name: "Record 7", score: 35},
    {id: 8, name: "Record 8", score: 35},
    {id: 9, name: "Record 9", score: 35},
    {id: 10, name: "Record 10", score: 35}
];

// In-memory mode state. Starts in full mode per the PRD's Starting mode
// decision. No external persistence — this is a single-process module-level
// variable, not a database.
"full"|"empty" currentMode = "full";

function recordsForMode(("full"|"empty") mode) returns Record[] {
    if mode == "full" {
        return fullCatalogSeed;
    }
    return [];
}

function currentCatalog() returns Catalog {
    Record[] data = recordsForMode(currentMode);
    log:printInfo("handled catalog request", recordCount = data.length());
    return {mode: currentMode, data: data};
}

function switchMode(string requestedMode) returns Catalog|Error {
    if requestedMode != "full" && requestedMode != "empty" {
        Record[] unchangedData = recordsForMode(currentMode);
        log:printInfo("handled mode switch request", recordCount = unchangedData.length(), requestedMode = requestedMode);
        return {
            code: 400,
            message: "Invalid mode value",
            description: string `mode must be "full" or "empty", got "${requestedMode}"`
        };
    }
    currentMode = <"full"|"empty">requestedMode;
    Record[] data = recordsForMode(currentMode);
    log:printInfo("handled mode switch request", recordCount = data.length(), requestedMode = requestedMode);
    return {mode: currentMode, data: data};
}
