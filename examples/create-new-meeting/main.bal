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
    meetings:InlineResponse2018 meetingDetails = check zoomClient->/users/[userId]/meetings.post(
        payload = {
            topic: "Ballerina New Internship Meeting",
            'type: 2, 
            preSchedule: false,
            startTime: "2025-07-10T10:00:00Z",
            duration: 30,
            timezone: "UTC"
        }
    );
    io:println("Meeting created successfully!");
    io:println("Meeting ID   : ", meetingDetails.id);
    io:println("Topic        : ", meetingDetails.topic);
    io:println("Join URL     : ", meetingDetails.joinUrl);
}
