## Overview
[Zoom](https://www.zoom.com/) is a widely-used video conferencing service provided by Zoom Video Communications, enabling users to host and attend virtual meetings, webinars, and collaborate online.

The `ballerinax/zoom.meetings` package offers APIs to connect and interact with Zoom API endpoints, specifically based on Zoom API v2 (https://developers.zoom.us/docs/api/meetings/).

## Setup guide

To use the Zoom meetings connector, you must have access to the Zoom API through  [Zoom Marketplace](https://marketplace.zoom.us/) and a project under it. If you do not have a Zoom account, you can sign up for one [here](https://zoom.us/signup#/signup).

### Step 1: Create a new app
   1. Open the [Zoom Marketplace](https://marketplace.zoom.us/).

   2. Click "Develop" → "Build App"

      [Zoom Marketplace](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/build-app.png)

   3. Choose **"General App"** app type (for user authorization with refresh tokens)

      [App Type](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/general-app.png)
   

   4. Fill in Basic Information, choose Admin-managed option.

### Step 2: Configure OAuth settings

   1. **Note down your credentials**:
      * Client ID
      * Client Secret

      [App Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/app-credentials.png)
      
   2. **Set Redirect URI**: Add your application's redirect URI

   3. **Add Scopes**: Make sure your Zoom app has the necessary scopes for the Scheduler API:
      * Add `scheduler:read`, `scheduler:write` and `user:read` in the scope

      [App Scopes](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/app-scopes.png)

### Step 3: Activate the App
 
   1. Complete all necessary information fields.

   2. Once, the necessary fields are correctly filled, app will be activated.

### Step 4: Get User Authorization

   1. **Direct users to authorization URL** (replace `YOUR_CLIENT_ID` and `YOUR_REDIRECT_URI`):
      ```
      https://zoom.us/oauth/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&scope=scheduler:read scheduler:write user:read
      ```

   2. **User authorizes the app** and gets redirected to your callback URL with an authorization code

   3. **Exchange authorization code for tokens**:
      ```curl
      curl -X POST https://zoom.us/oauth/token \
      -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
      -d "grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=YOUR_REDIRECT_URI"
      ```

      This returns both `access_token` and `refresh_token`.

      Replace:
         * `CLIENT_ID` with your app's Client ID
         * `CLIENT_SECRET` with your app's Client Secret
         * `AUTHORIZATION_CODE` with the code received from the callback
         * `YOUR_REDIRECT_URI` with your configured redirect URI

### Step 5: Verify Your Setup
      ```curl
      curl -X GET "https://api.zoom.us/v2/users/me" \
      -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
      ```
      
   This will give you the user ID needed for API calls.

## Quickstart

To use the `Zoom` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

   Import the `zoom.meetings` module.

   ```ballerina
   import ballerinax/zoom.meetings;
   ```

### Step 2: Instantiate a new connector

   1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

      ```bash
      refreshToken = "<refresh Token>"
      refreshUrl = "<refresh URL>"
      userId="<user_id>"
      clientId = "<client_id>"
      clientSecret = "<client_secret>"
      ```

   2. Create a `zoom.meeting:ConnectionConfig` with the obtained access token and initialize the connector with it.

      ```ballerina
      configurable string refreshToken = ?;
      ConnectionConfig config = {
         auth: {
            refreshToken,
            clientId,
            clientSecret,
            refreshUrl
         }
      };

      final Client zoomClient = check new Client(config, serviceUrl);
      ```

### Step 3: Invoke the connector operation

   Now, utilize the available connector operations.

      ```ballerina
      meetings:InlineResponse20028 response = check zoomClient->/users/[originalId]/meetings();
         meetings:InlineResponse20028Meetings[]? meetings = response.meetings;
         if meetings is () {
            io:println("No upcoming meetings found.");
            return;
         }
         foreach var meeting in meetings {
            if meeting.id is int && meeting.topic is string {
                  io:println("Meeting ID: ", meeting.id);
                  io:println("Topic    : ", meeting.topic);
                  io:println("-------------------------------");
            }
         }
      ```

### Step 4: Run the Ballerina application

      ```bash
      bal run
      ```

## Examples

The `Zoom Meetings` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/examples/), covering the following use cases:

1. [**Create a Zoom meeting**](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/examples/create-new-meeting) – Creates a new Zoom meeting using the API. 

2. [**List scheduled meetings**](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/examples/list-all-meetings) – Displays the list of meetings scheduled under a specified Zoom user account. 
