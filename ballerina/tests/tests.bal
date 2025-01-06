import ballerina/io;
import ballerina/oauth2;
import ballerina/test;
import ballerina/lang.runtime;

// OAuth 2.0 Credentials
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string serviceUrl = "https://api.hubapi.com";

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
string importRequestString = string `{
        "name": "First Contact Data",
        "importOperations": {
        "0-1": "CREATE"
        },
        "dateFormat": "DAY_MONTH_YEAR",
        "files": [
        {
            "fileName": "dummy_contact_data.csv",
            "fileFormat": "CSV",
            "fileImportPage": {
            "hasHeader": true,
            "columnMappings": [
                {
                "columnObjectTypeId": "0-1",
                "columnName": "First Name",
                "propertyName": "firstname"
                },
                {
                "columnObjectTypeId": "0-1",
                "columnName": "Last Name",
                "propertyName": "lastname"
                },
                {
                "columnObjectTypeId": "0-1",
                "columnName": "Email",
                "propertyName": "email",
                "columnType": "HUBSPOT_ALTERNATE_ID"
                }
            ]
            }
        }
        ]
    }`;

// Support functions
function createImport() returns int|error {
    // Load a dummy data file
    string csvFilePath = "tests/resources/dummy_contact_data.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);

    // Request body
    v3_imports_body body = {
        files: {
            fileContent: bytes,
            fileName: "dummy_contact_data.csv"
        },
        importRequest: importRequestString
    };

    // Test buildup API call
    PublicImportResponse buildupResponse = check baseClient->/crm/v3/imports.post(payload = body);
    int buildUpImportId = check int:fromString(buildupResponse.id ?:"0");

    // Return a valid dummy import ID
    return buildUpImportId;
};

@test:Config
function testPost_crm_v3_imports() returns error? {
    // Loading a dummy data file
    string csvFilePath = "tests/resources/dummy_contact_data.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);

    // Request body
    v3_imports_body body = {
        files: {
            fileContent: bytes,
            fileName: "dummy_contact_data.csv"
        },
        importRequest: importRequestString
    };

    // Test API call
    PublicImportResponse response = check baseClient->/crm/v3/imports.post(payload = body);

    // Assertions
    test:assertNotEquals(response.createdAt,(), "No createdAt timestamp in response");
    test:assertNotEquals(response.metadata,(), "No metadata in response");
    test:assertNotEquals(response?.importRequestJson,(), "No importRequestJson in response");
    test:assertNotEquals(response.id, (), "No id in response");
    test:assertEquals(response.state, "STARTED", "State should be STARTED");
};

@test:Config
function  testPost_crm_v3_imports_importId_cancel() returns error?{
    // Create a dummy import
    int buildUpImportId = check createImport();

    // Test API call
    ActionResponse response = check baseClient->/crm/v3/imports/[buildUpImportId]/cancel.post();

    // Assertions
    test:assertNotEquals(response.completedAt, (), msg = "No completedAt timestamp in response");
    test:assertNotEquals(response.startedAt, (), msg = "No startedAt timestamp in response");
    test:assertNotEquals(response.status, (), msg = "No status in response");
}

@test:Config
function  testGet_crm_v3_imports_importId() returns error? {
    // Create a dummy import
    int buildUpImportId = check createImport();

    runtime:sleep(2);

    // Test API call
    PublicImportResponse response = check baseClient->/crm/v3/imports/[buildUpImportId].get({});

    // Assertions
    test:assertNotEquals(response.createdAt,(), "No createdAt timestamp in response");
    test:assertNotEquals(response.metadata,(), "No metadata in response");
    test:assertNotEquals(response?.importRequestJson,(), "No importRequestJson in response");
    test:assertNotEquals(response.id, (), "No id in response");
    test:assertNotEquals(response.state, (), msg = "No state in response");
}

@test:Config
function testGet_crm_v3_imports() returns error? {
    // Test API call
    CollectionResponsePublicImportResponse response = check baseClient->/crm/v3/imports.get({});
    
    // Assertions
    test:assertNotEquals(response.results, null, msg = "Value should not be null");

    PublicImportResponse[] results = response.results ?: [];
    if (results.length() > 0) {
        test:assertNotEquals(results[0].createdAt, (), "No createdAt timestamp in response");
        test:assertNotEquals(results[0].metadata, (), "No metadata in response");
        test:assertNotEquals(results[0]?.importRequestJson, (), "No importRequestJson in response");
        test:assertNotEquals(results[0].id, (), "No id in response");
        test:assertNotEquals(results[0].state, (), "No state in response");
    }
}

@test:Config
function  testGet_crm_v3_imports_importId_error() returns error? {
    // Create a dummy import
    int buildUpImportId = check createImport();

    // Test API call
    CollectionResponsePublicImportErrorForwardPaging response = check baseClient->/crm/v3/imports/[buildUpImportId]/errors.get({});

    // Assertions
    test:assertNotEquals(response.results,(), msg = "Results should not be null");
}

