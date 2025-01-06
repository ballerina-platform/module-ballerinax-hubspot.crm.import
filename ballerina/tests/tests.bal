// import ballerina/http;
import ballerina/io;
import ballerina/test;
import ballerina/oauth2;

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

ConnectionConfig config = {auth: auth};
final Client baseClient = check new Client(config, serviceUrl);

int importId = 0;

@test:Config
function testPost_crm_v3_imports() returns error? {
    string csvFilePath = "tests/resources/dummy_contact_data.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);
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

    v3_imports_body temp = {
        files: {
            fileContent: bytes,
            fileName: "dummy_contact_data.csv"
        },
        importRequest: importRequestString
    };
    PublicImportResponse response = check baseClient->/crm/v3/imports.post(payload = temp);
    importId = check int:fromString(response.id ?:"0");
    io:println(importId);
};

@test:Config
function  testPost_crm_v3_imports_importId_cancel() returns error?{
    ActionResponse response = check baseClient->/crm/v3/imports/[importId]/cancel.post();
    io:println(response);
}

@test:Config
function  testGet_crm_v3_imports_importId() returns error? {
    string csvFilePath = "tests/resources/dummy_contact_data.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);
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

    v3_imports_body temp = {
        files: {
            fileContent: bytes,
            fileName: "dummy_contact_data.csv"
        },
        importRequest: importRequestString
    };
    PublicImportResponse response = check baseClient->/crm/v3/imports.post(payload = temp);
    int importId2 = check int:fromString(response.id ?:"0");
    PublicImportResponse response2 = check baseClient->/crm/v3/imports/[importId2];
    test:assertNotEquals(response2, null, msg = "Value should not be null");
}

@test:Config
function testGet_crm_v3_imports() returns error?{
    CollectionResponsePublicImportResponse response = check baseClient->/crm/v3/imports;
    test:assertNotEquals(response.results, null, msg = "Value should not be null");
}

@test:Config
function  testGet_crm_v3_imports_importId_error() returns error? {
    string csvFilePath = "tests/resources/dummy_contact_data.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);
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

    v3_imports_body temp = {
        files: {
            fileContent: bytes,
            fileName: "dummy_contact_data.csv"
        },
        importRequest: importRequestString
    };
    PublicImportResponse response = check baseClient->/crm/v3/imports.post(payload = temp);
    int importId3 = check int:fromString(response.id ?:"0");

    CollectionResponsePublicImportErrorForwardPaging response2 = check baseClient->/crm/v3/imports/[importId3]/errors;
    test:assertNotEquals(response2, null, msg = "Value should not be null");
}

