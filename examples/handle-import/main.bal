import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.'import as crmImport;

// OAuth 2.0 Credentials
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

crmImport:OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

// Initialize the client
final crmImport:Client baseClient = check new ({auth});

public function main() returns error? {
    // Create an import request body
    json readJson = check io:fileReadJson("resources/contact_import_request.json");
    string importRequestString = readJson.toString();

    // Loading the data file
    string filePath = "resources/contact_import_file.csv";
    byte[] bytes = check io:fileReadBytes(filePath);

    // Request body
    crmImport:body requestBody = {
        files: {
            fileContent: bytes,
            fileName: "contact_import_file.csv"
        },
        importRequest: importRequestString
    };

    // Create an import
    io:println("Creating an import...");
    crmImport:PublicImportResponse response = check baseClient->/.post(payload = requestBody);
    io:println("The import is in the state : " + response.state);

    // Check if the import is successful
    if (response.id == null) {
        return error("The import is not successful");
    }

    int responseId = check int:fromString(response.id ?: "");
    io:println("The import id is : " + responseId.toString());

    // Fetching the status of this import
    io:println("\nFetching the status of the import " + responseId.toString() + "...");
    crmImport:PublicImportResponse|error statusResponse = baseClient->/[responseId].get({});
    if (statusResponse is error) {
        io:println("Failed to fetch the status of the import");
    } else {
        io:println("The import is in the state : " + statusResponse.state);
        io:println("The import was created at : " + statusResponse.createdAt.toString());
    }

    // Cancel the import
    io:println("\nCanceling the import " + responseId.toString() + "...");
    crmImport:ActionResponse|error cancelResponse = baseClient->/[responseId]/cancel.post();
    if (cancelResponse is error) {
        io:println("Failed to cancel the import");
    } else {
        if (cancelResponse.status == "COMPLETE") {
            io:println("The import was cancelled successfully");
        }
        else {
            io:println("The import cancellation is in the state : " + cancelResponse.status);
        }
    }
}
