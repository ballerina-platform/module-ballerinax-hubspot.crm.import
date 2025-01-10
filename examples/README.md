# Examples

The `hubspot.crm.import` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.import/tree/main/examples), covering use cases like creating an import, fetching the status and cancelling an import.

1. [Creating a contact import](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.import/tree/main/examples/handle-import) - Integrate hubspot.crm.import API to create and manage a contact data import


## Prerequisites

1. Generate Credentials to authenticate the connector as described in the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.import/tree/main/README.md).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    clientId = "<Client ID>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Refresh Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```
