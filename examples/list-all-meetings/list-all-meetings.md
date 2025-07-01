# Zoom Meetings - List all meetings

This example demonstrates how to **retrieve and list all Zoom meetings** for a given user using the Zoom Meetings API. This is useful for displaying scheduled meetings, integrating with dashboards, or building internal tools for scheduling visibility.

## Prerequisites

**1. Setup Zoom developer account**

Refer to the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/README.md) to obtain necessary credentials (client Id, client secret, tokens).

**2. Configuration**

Create a `Config.toml` file in the example's root directory and, provide your Zoom account related configurations as follows:

```bash 
refreshToken = "<refresh Token>"
refreshUrl = "<refresh URL>"
userId = "<user_id>"
clientId = "<client_id>"
clientSecret = "<client_secret>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```

