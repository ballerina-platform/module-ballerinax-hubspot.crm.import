## Customer Support tweets and Feedback Management

This use case demonstrates how the HubSpot CRM Imports connector can be utilized to efficiently import CRM records and activities into HubSpot. The example involves a sequence of actions that leverage the HubSpot CRM Imports API to streamline the data import process, including creating an import, monitoring its progress by checking the status, and canceling the import if needed.

## Prerequisites

### 1. Setup Hubspot developer account

Refer to the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.import/tree/main/README.md) to obtain necessary credentials (client Id, client secret, tokens).

### 2. Configuration

Create a `Config.toml` file in the example's root directory and, provide your Twitter account related configurations as follows:

```toml
clientId = "<Client ID>"
clientSecret = "<Client Secret>"
refreshToken = "<Refresh Token>"
```

## Run the example

Execute the following command to run the example:

```
bal run
```
