import ballerina/io;
import ballerina/lang.runtime;
import ballerina/oauth2;
import ballerina/test;

// OAuth 2.0 Credentials
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string serviceUrl = "https://api.hubapi.com/crm/v3/imports";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

// Initialize the client
ConnectionConfig config = {auth: auth};
final Client baseClient = check new Client(config, serviceUrl);

// Local variables
json readJson = check io:fileReadJson("tests/resources/dummy_importRequest.json");
string importRequestString = readJson.toString();

// Support functions
function createImport() returns int|error {
    // Load a dummy data file
    string csvFilePath = "tests/resources/dummy_file.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);

    // Request body
    body requestBody = {
        files: {
            fileContent: bytes,
            fileName: "dummy_file.csv"
        },
        importRequest: importRequestString
    };

    // Test buildup API call
    PublicImportResponse buildupResponse = check baseClient->/.post(payload = requestBody);
    int buildUpImportId = check int:fromString(buildupResponse.id ?: "0");

    // Return a valid dummy import ID
    return buildUpImportId;
};

// Tests
@test:Config
function testPost_() returns error? {
    // Loading a dummy data file
    string csvFilePath = "tests/resources/dummy_file.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);

    // Request body
    body requestBody = {
        files: {
            fileContent: bytes,
            fileName: "dummy_file.csv"
        },
        importRequest: importRequestString
    };

    // Test API call
    PublicImportResponse response = check baseClient->/.post(payload = requestBody);

    // Assertions
    test:assertNotEquals(response.id, (), "No id in response");
    test:assertEquals(response.state, "STARTED", "State should be in STARTED state");
};

@test:Config
function testPost_importId_cancel() returns error? {
    // Create a dummy import
    int buildUpImportId = check createImport();

    // Test API call
    ActionResponse response = check baseClient->/[buildUpImportId]/cancel.post();

    // Assertions
    test:assertNotEquals(response.startedAt, (), msg = "No startedAt timestamp in response");
    test:assertNotEquals(response.status, (), msg = "No status in response");
}

@test:Config
function testGet_importId() returns error? {
    // Create a dummy import
    int buildUpImportId = check createImport();

    runtime:sleep(2);

    // Test API call
    PublicImportResponse response = check baseClient->/[buildUpImportId].get({});

    // Assertions
    test:assertNotEquals(response.createdAt, (), "No createdAt timestamp in response");
    test:assertNotEquals(response.id, (), "No id in response");
}

@test:Config
function testGet_() returns error? {
    // Test API call
    CollectionResponsePublicImportResponse response = check baseClient->/.get({});

    // Assertions
    test:assertNotEquals(response.results, null, msg = "Value should not be null");

    PublicImportResponse[] results = response.results ?: [];
    if (results.length() > 0) {
        foreach var item in results {
            test:assertNotEquals(item.createdAt, (), "No createdAt timestamp in response");
            test:assertNotEquals(item.id, (), "No id in response");
        }
    }
}

@test:Config
function testGet_importId_error() returns error? {
    // Create a dummy import
    int buildUpImportId = check createImport();

    // Test API call
    CollectionResponsePublicImportErrorForwardPaging response = check baseClient->/[buildUpImportId]/errors.get({});

    // Assertions
    test:assertNotEquals(response.results, (), msg = "Results should not be null");
}

