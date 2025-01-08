import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {
    # Get active imports
    #
    # + return - successful operation
    resource function get .() returns CollectionResponsePublicImportResponse|http:Response {
        return {
            results: [],
            paging: {
                next: {
                    after: "after",
                    link: "link"
                }
            }
        };
    }

    # Get the information on any import
    #
    # + importId - id of the import
    # + return - successful operation 
    resource function get [int importId]() returns PublicImportResponse|http:Response {
        return {
            "state": "DONE",
            "mappedObjectTypeIds": [
                "0-1"
            ],
            "createdAt": "createdTime",
            "updatedAt": "updatedTime",
            "metadata": {
                "objectLists": [],
                "counters": {
                    "TOTAL_ROWS": 10,
                    "PROPERTY_VALUES_EMITTED": 10,
                    "ERRORS": 10,
                    "MAPPED_COLUMNS": 3
                },
                "fileIds": [
                    "184448894240"
                ]
            },
            "importName": "First Contact Data",
            "optOutImport": false,
            "id": importId.toString()
        };
    }

    # Get active imports
    # 
    # + return - successful operation 
    resource isolated function get [int importId]/errors() returns CollectionResponsePublicImportErrorForwardPaging|http:Response {
        return {
            "results": [],
            "paging": {
                "next": {
                    "after": "after",
                    "link": "link"
                }
            }
        };
    }

    # Start a new import
    #
    # + return - successful operation 
    resource isolated function post .() returns PublicImportResponse|http:Response {
        return {
            "state": "STARTED",
            "importSource": "API",
            "mappedObjectTypeIds": [
                "0-1"
            ],
            "createdAt": "createdTime",
            "updatedAt": "UpdatedTime",
            "metadata": {
                "objectLists": [],
                "counters": {},
                "fileIds": [
                    "184642347637"
                ]
            },
            "importName": "First Contact Data",
            "optOutImport": false,
            "id": "55234002"
        };
    }

    # Cancel an active import
    #
    # + return - successful operation 
    resource isolated function post [int importId]/cancel() returns ActionResponse|http:Response {
        return {
            "completedAt": "completedTime", 
            "startedAt": "startedTime", 
            "status": "COMPLETE"
            };
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
