import ballerina/http;

service on new http:Listener(9090) {
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

    resource isolated function post [int importId]/cancel() returns ActionResponse|http:Response {
        return {
            "completedAt": "completedTime",
            "startedAt": "startedTime",
            "status": "COMPLETE"
        };
    }
};
