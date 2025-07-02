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

import ballerina/io;
import ballerinax/zoom.meetings;

configurable string userId = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = ?;
configurable string refreshToken = ?;

final meetings:Client zoomClient = check new ({
    auth: {
        clientId,
        clientSecret,
        refreshUrl,
        refreshToken
    }
});

public function main() returns error? {
    meetings:InlineResponse20028 response = check zoomClient->/users/[userId]/meetings();
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
    meetings:InlineResponse20028Meetings firstMeeting = meetings[0];
    int meetingId = <int>firstMeeting.id;
    check zoomClient->/meetings/[meetingId].patch({
            topic: "Updated Internship Topic via Test Ballerina",
            startTime: "2025-09-01T15:05:00Z"
        }
    );
    io:println("Meeting ", meetingId, " successfully updated.");
    meetings:InlineResponse20013 updatedMeeting = check zoomClient->/meetings/[meetingId]();
    io:println("Updated Topic: ", updatedMeeting.topic);
}


