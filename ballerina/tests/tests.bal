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

configurable boolean isLiveServer = false;
configurable string originalId = "me";
configurable string userId = isLiveServer ? originalId : "test";
configurable string serviceUrl = isLiveServer ? "https://api.zoom.us/v2" : "http://localhost:9090";
configurable string refreshToken = "mockRefreshToken";
configurable string clientId = "mockClientId";
configurable string clientSecret = "mockClientSecret";
configurable string refreshUrl = "mockUrl";

ConnectionConfig config = isLiveServer
    ? {
        auth: {
            refreshToken,
            clientId,
            clientSecret,
            refreshUrl
        }
    }
    :
    {
        auth: {
            token: "mock-token"
        }
    };

final Client zoomClient = check new Client(config, serviceUrl);

int meetingId = 85793105951;

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testListMeetings() returns error? {
    InlineResponse20028 response = check zoomClient->/users/[userId]/meetings();
    test:assertEquals(response.pageNumber,1, msg = "Page number should be 1");
    test:assertEquals(response.pageSize, 30, msg = "Page size should be 30");
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
    test:assertTrue(response.topic !is (), msg = "Response topic should not be empty");
    test:assertEquals(response.duration, 50, msg = "Meeting duration should be 50 minutes");
    test:assertEquals(response.timezone, "UTC", msg = "Timezone should be UTC");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMeeting() returns error? {
    InlineResponse20013 response = check zoomClient->/meetings/[meetingId]();
    test:assertEquals(response.preSchedule, false, msg = "Both must be the same");
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
    InlineResponse20013 updatedMeeting = check zoomClient->/meetings/[meetingId]();
    test:assertEquals(updatedMeeting.topic, "Updated New Meeting", msg = "Meeting topic was not updated as expected");
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting, testUpdateMeeting, testGetMeeting, testGetMeetingInvitation]
}
function testDeleteMeeting() returns error? {
    error? response = zoomClient->/meetings/[meetingId].delete();
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting, testUpdateMeeting, testGetMeeting]
}
function testGetMeetingInvitation() returns error? {
    MeetingInvitation response = check zoomClient->/meetings/[meetingId]/invitation();
}

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreateMeeting]
}
function testListUpcomingMeetings() returns error? {
    InlineResponse20029 response = check zoomClient->/users/[userId]/upcoming_meetings();
    test:assertTrue(response.totalRecords >= 0, msg = "Total records should be non-negative");
}

