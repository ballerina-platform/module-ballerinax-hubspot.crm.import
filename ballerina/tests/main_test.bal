// import ballerina/config;
configurable string client_id = ?;
configurable string client_secret = ?;
configurable string access_token = ?; 

// public function main() {
//     OAuth2RefreshTokenGrantConfig auth = {
//        clientId: "",
//        clientSecret: "",
//        refreshToken: ""
//    };
// }

// import ballerina/http;
// import ballerina/test;

// configurable http:BearerTokenConfig & readonly authConfig = ?;
// ConnectionConfig config = {auth : authConfig};
// Client baseClient = check new Client(config, serviceUrl = "https://api.hubapi.com");

// @test:Config {}
// isolated function  testPost-/crm/v3/imports/{importId}/cancel_cancel() {
// }

// @test:Config {}
// isolated function  testGet-/crm/v3/imports/{importId}_getById() {
// }

// @test:Config {}
// isolated function  testGet-/crm/v3/imports/{importId}/errors_getErrors() {
// }

// @test:Config {}
// isolated function  testGet-/crm/v3/imports/_getPage() {
// }

// @test:Config {}
// isolated function  testPost-/crm/v3/imports/_create() {
// }