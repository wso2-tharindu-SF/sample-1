import ballerina/os;

// SERVICE2_URL is injected by the platform from the service2 dependency
// wiring (design.json). A sensible localhost default keeps the service
// startable when the env var is unset, per the component contract.
configurable string service2Url = os:getEnv("SERVICE2_URL");

// The injected address may end in "/" — trim it once here so every call site
// can join a leading-slash path onto service2BaseUrl without a double slash.
final string service2BaseUrl = trimTrailingSlash(service2Url == "" ? "http://localhost:9090" : service2Url);

function trimTrailingSlash(string url) returns string {
    if url.endsWith("/") {
        return url.substring(0, url.length() - 1);
    }
    return url;
}
