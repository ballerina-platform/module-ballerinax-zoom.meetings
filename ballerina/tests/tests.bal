// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

configurable boolean isLiveServer = ?;
configurable string originalId = ?;
configurable string userId = isLiveServer ? originalId : "test";
configurable string serviceUrl = isLiveServer ? "https://api.zoom.us/v2" : "http://localhost:9090";
configurable string token = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = ?;

ConnectionConfig config = {
    auth: {
        refreshToken: token,
        clientId,
        clientSecret,
        refreshUrl
    }
};

final Client zoomClient = check new Client(config, serviceUrl);
int meetingId = 85479942797;

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testListMeetings() returns error? {
    InlineResponse20028 response = check zoomClient->/users/[userId]/meetings();
    test:assertTrue(response is InlineResponse20028, msg = "Response should be InlineResponse20028");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateMeeting() returns error? {
    InlineResponse2018 response = check zoomClient->/users/[userId]/meetings.post(
        payload = {
            timezone: "UTC",
            'type: 2,
            duration: 50,
            preSchedule: false,
            startTime: "2025-06-21T10:00:00Z",
            topic: "The Internship Meeting"
        }
    );
    test:assertTrue(response?.topic !is (), msg = "Response topic should not be empty");
    test:assertEquals(response?.duration, 50, msg = "Meeting duration should be 50 minutes");
    test:assertEquals(response?.timezone, "UTC", msg = "Timezone should be UTC");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMeeting() returns error? {
    InlineResponse20013 response = check zoomClient->/meetings/[meetingId]();
    test:assertTrue(response is InlineResponse20013, msg = "Response should be InlineResponse20013");
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting]
}
function testUpdateMeeting() returns error? {
    error? response = zoomClient->/meetings/[meetingId].patch(
        payload = {
            topic: "Updated New Meeting",
            startTime: "2025-09-01T15:05:00Z"
        }
    );
    test:assertTrue(response is (), msg = "Update should succeed with no error (HTTP 204 or 200)");
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting, testUpdateMeeting, testGetMeeting, testGetMeetingInvitation]
}
function testDeleteMeeting() returns error? {
    error? response = zoomClient->/meetings/[meetingId].delete();
    test:assertTrue(response is (), msg = "Delete should succeed with no error (HTTP 204 or 200)");
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting, testUpdateMeeting, testGetMeeting]
}
function testGetMeetingInvitation() returns error? {
    MeetingInvitation response = check zoomClient->/meetings/[meetingId]/invitation();
    test:assertTrue(response is MeetingInvitation, msg = "Response should be MeetingInvitation");
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting]
}
function testListUpcomingMeetings() returns error? {
    InlineResponse20029 response = check zoomClient->/users/[userId]/upcoming_meetings();
    test:assertTrue(response is InlineResponse20029, msg = "Response should be InlineResponse20029");
}
