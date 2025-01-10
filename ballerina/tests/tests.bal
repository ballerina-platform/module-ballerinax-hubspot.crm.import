// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is auto-generated by the Ballerina OpenAPI tool.

// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/oauth2;
import ballerina/test;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

configurable boolean isLiveServer = ?;
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/imports" : "http://localhost:9090";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final Client baseClient = check new ({auth});

json readJson = check io:fileReadJson("tests/resources/dummy_import_request.json");
string importRequestString = readJson.toString();

function createImport() returns int|error {
    string csvFilePath = "tests/resources/dummy_file.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);

    body requestBody = {
        files: {
            fileContent: bytes,
            fileName: "dummy_file.csv"
        },
        importRequest: importRequestString
    };

    PublicImportResponse buildupResponse = check baseClient->/.post(payload = requestBody);
    int buildUpImportId = check int:fromString(buildupResponse.id ?: "0");

    return buildUpImportId;
};

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPost_() returns error? {
    string csvFilePath = "tests/resources/dummy_file.csv";
    byte[] bytes = check io:fileReadBytes(csvFilePath);

    body requestBody = {
        files: {
            fileContent: bytes,
            fileName: "dummy_file.csv"
        },
        importRequest: importRequestString
    };

    PublicImportResponse response = check baseClient->/.post(payload = requestBody);

    test:assertNotEquals(response.id, (), "No id in response");
    test:assertEquals(response.state, "STARTED", "State should be in STARTED state");
};

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPost_importId_cancel() returns error? {
    int buildUpImportId = check createImport();

    ActionResponse response = check baseClient->/[buildUpImportId]/cancel.post();

    test:assertNotEquals(response.startedAt, (), msg = "No startedAt timestamp in response");
    test:assertNotEquals(response.status, (), msg = "No status in response");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGet_importId() returns error? {
    int buildUpImportId = check createImport();

    PublicImportResponse response = check baseClient->/[buildUpImportId].get({});

    test:assertNotEquals(response.createdAt, (), "No createdAt timestamp in response");
    test:assertNotEquals(response.id, (), "No id in response");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGet_() returns error? {
    CollectionResponsePublicImportResponse response = check baseClient->/.get({});

    test:assertNotEquals(response.results, null, msg = "Value should not be null");

    PublicImportResponse[] results = response.results ?: [];
    if (results.length() > 0) {
        foreach var item in results {
            test:assertNotEquals(item.id, (), "No id in response");
        }
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGet_importId_error() returns error? {
    int buildUpImportId = check createImport();

    CollectionResponsePublicImportErrorForwardPaging response = check baseClient->/[buildUpImportId]/errors.get({});

    test:assertNotEquals(response.results, (), msg = "Results should not be null");
}
