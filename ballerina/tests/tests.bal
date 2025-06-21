//  * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//  *
//  * WSO2 LLC. licenses this file to you under the Apache License,
//  * Version 2.0 (the "License"); you may not use this file except
//  * in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *    http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing,
//  * software distributed under the License is distributed on an
//  * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  * KIND, either express or implied. See the License for the
//  * specific language governing permissions and limitations
//  * under the License.
 
import ballerina/test;
import ballerina/io;
//import ballerina/http;

// Configs for live vs mock
configurable boolean isLiveServer = ?;
configurable string originalId = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string accountId= ?; 
configurable string userId =  isLiveServer? originalId:  "test";
configurable string serviceUrl = isLiveServer ? "https://api.zoom.us/v2" : "http://localhost:9090";
configurable string tokenFilePath =  ?;



string token = "mock_token";



// Create an HTTP client
ConnectionConfig config = {auth: {token}};
final Client zoomClient = check loadAccessToken();
int meetingId =  89292999022;


function loadAccessToken() returns Client|error {
    string token_use = token;
    if isLiveServer {
        string|error tokenResult = io:fileReadString(tokenFilePath);
        if tokenResult is string {
            token_use = tokenResult.trim();
        } else {
            return error("Unable to read token file: " + tokenResult.toString());
        }
    }

    return check new Client({auth:{token:token_use}}, serviceUrl);
}

//List the Meetings
@test:Config {
    groups: ["live_tests","mock_tests"]
    }

function testListMeetings() returns error? {
    InlineResponse20028 response = check zoomClient->/users/[userId]/meetings();
    io:println("Response : ",response);
    test:assertTrue(response is InlineResponse20028, msg = "Response should be InlineResponse20028");
    


}

//Create a meeting
@test:Config {
    groups: ["live_tests","mock_tests"]
    }

function testCreateMeeting() returns error? {
    
    InlineResponse2018 response = check zoomClient->/users/[userId]/meetings.post(
        payload = {
            timezone : "UTC",
            'type : 2,
            duration : 50,
            preSchedule: false,
            startTime : "2025-06-21T10:00:00Z",
            topic : "The Internship Meeting"
        }
    );
    io:println("Response : ", response);
    test:assertTrue(response is InlineResponse2018, msg = "Response should be InlineResponse2018");
}

//Get a meeting
@test:Config {
    groups: ["live_tests","mock_tests"]
    }
function testGetMeeting() returns error? {
    InlineResponse20013 response = check zoomClient->/meetings/[meetingId]();
    io:println("REsponse : ",response);
    test:assertTrue(response is InlineResponse20013, msg = "Response should be InlineResponse20013");

}





//Update a meeting
@test:Config {
    groups: ["live_tests","mock_tests"],
    dependsOn: [testCreateMeeting]
    }
function testUpdateMeeting() returns error? {
    error? response = zoomClient->/meetings/[meetingId].patch(
        payload = {
            topic : "Updated New Meeting",
            startTime : "2025-09-01T15:05:00Z"
        }
    );
    io:println("Response: ",response);
    test:assertTrue(response is (), msg = "Update should succeed with no error (HTTP 204 or 200)");
}




//Delete a meeting
@test:Config {
    groups: ["live_tests","mock_tests"],
    dependsOn: [testCreateMeeting, testUpdateMeeting, testGetMeeting, testGetMeetingInvitation]
    }

function testDeleteMeeting() returns error? {
    
    error? response = zoomClient->/meetings/[meetingId].delete();
    test:assertTrue(response is (), msg = "Delete should succeed with no error (HTTP 204 or 200)");
} 

//Get a meeting Invitation
@test:Config {
    groups: ["live_tests","mock_tests"],
    dependsOn: [testCreateMeeting, testUpdateMeeting, testGetMeeting]
    }

function testGetMeetingInvitation() returns error? {
    MeetingInvitation response = check zoomClient->/meetings/[meetingId]/invitation();
    io:println("Response : ", response);
    test:assertTrue(response is MeetingInvitation, msg = "Response should be MeetingInvitation");

}

//List Upcoming Meetings
@test:Config {
    groups: ["live_tests","mock_tests"],
    dependsOn: [testCreateMeeting]
    }

function testListUpcomingMeetings() returns error? {
    InlineResponse20029 response = check zoomClient->/users/[userId]/upcoming_meetings();
    io:println("Response : ", response);
    test:assertTrue(response is InlineResponse20029, msg = "Response should be InlineResponse20029");
}



