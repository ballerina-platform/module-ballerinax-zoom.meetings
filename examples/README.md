# Examples

The `ballerinax/zoom.meetings` connector provides practical examples illustrating usage in various scenarios. Explore these examples to learn how to interact with Zoom APIs for creating a meeting and listing meetings.

1. Create a Zoom meeting – Creates a new Zoom meeting using the API. 

2. List scheduled meetings – Displays the list of meetings scheduled under a specified Zoom user account. 

## Prerequisites

1. Create a Zoom account by clicking the Sign Up link here: https://marketplace.zoom.us/. Once you activate your account, you’ll be ready to join as a developer.

2. Generate credentials to authenticate the connector as described in the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/README.md).

3. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:
    ```bash 
    refreshToken = "<refresh Token>"
    refreshUrl = "<refresh URL>"
    userId="<user_id>"
    clientId = "<client_id>"
    clientSecret = "<client_secret>"
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
