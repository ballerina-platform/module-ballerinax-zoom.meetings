# Running Tests

## Prerequisites
You need a Access token from Zoom developer account.

To do this, refer to [Ballerina Zoom Connector](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/README.md).

And You need Find Your User ID to run some of the tests by running this curl command.
```curl
curl -X GET "https://api.zoom.us/v2/users/me" \
-H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

# Running Tests

There are two test environments for running the Zoom connector tests. The default test environment is the mock server for Zoom API. The other test environment is the actual Zoom API. 

You can run the tests in either of these environments and each has its own compatible set of tests.

 Test Groups | Environment                                       
-------------|---------------------------------------------------
 mock_tests  | Mock server for Zoom API (Defualt Environment) 
 live_tests  | Zoom API                                       

## Running Tests in the Mock Server

To execute the tests on the mock server, ensure that the `IS_LIVE_SERVER` environment variable is either set to `false` or unset before initiating the tests. 

This environment variable can be configured within the `Config.toml` file located in the tests directory or specified as an environmental variable.

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and the following content:

```toml
isLiveServer = false
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=false
```
If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER false
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test
```

## Running Tests Against Zoom Live API

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and add your authentication credentials a

```toml
   isLiveServer = true
   clientId = "your_client_id"
   clientSecret = "your_client_secret"
   refreshToken = "user_refresh_token_from_step4"
   refreshUrl = "https://zoom.us/oauth/token"
   userId = "user_id_from_step5"
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER="true"
   export ZOOM_CLIENT_ID="your_client_id"
   export ZOOM_CLIENT_SECRET="your_client_secret"  
   export ZOOM_REFRESH_TOKEN="user_refresh_token_from_step4"
   export ZOOM_USER_ID="user_id_from_step5"
```

If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER true
   setx ZOOM_CLIENT_ID "your_client_id"
   setx ZOOM_CLIENT_SECRET "your_client_secret"
   setx ZOOM_REFRESH_TOKEN "user_refresh_token_from_step4"
   setx ZOOM_USER_ID "user_id_from_step5"
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test 
```
