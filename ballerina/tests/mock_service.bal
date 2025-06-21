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
 
import ballerina/http;
import ballerina/log;
import ballerina/io;

listener http:Listener httpListener = new (9090);


http:Service mockService = service object{
    
    //List the meetings
    resource function get users/[string userId]/meetings() returns InlineResponse20028|error {
        return {
            pageNumber : 1,
            pageSize : 30

        };
    }

    //Create a meeting
    resource function post users/[string userId]/meetings() returns InlineResponse2018|error {
        return {
            timezone: "UTC",
            'type:2,
            duration: 30,
            preSchedule: false,
            startTime: "2025-06-21T10:00:00Z",
            topic: "The Internship Meeting"
        };
    }

    //Get a meeting
    resource function get meetings/[int meetingId]() returns InlineResponse20013|error {
        return {
            'type : 2,
            preSchedule: false

        };

    }

    //Update a meeting
    resource function patch meetings/[int meetingId]() returns error? {
        io:println("Meeting with ID " + meetingId.toString() + " updated successfully.");
        return;
    }

    //Delete a meeting
    resource function delete meetings/[int meetingId]() returns error? {
        io:println("Meeting with ID " + meetingId.toString() + " deleted successfully.");
        return;
    }

    //Get a meeting Invitation
    resource function get meetings/[int meetingId]/invitation() returns MeetingInvitation|error {
        io:println("Meeting with ID " + meetingId.toString() + " invited successfully.");
        return {
            invitation: "Join Zoom Meeting\nhttps://zoom.us/j/1234567890?pwd=abc123\nMeeting ID: 123 4567 890\nPasscode: 123456"
        };
    }

    //List Upcoming Meetings
    resource function get users/[string userId]/upcoming_meetings() returns InlineResponse20029|error {
        return {
            totalRecords : 5,
            meetings : [
                {
                    duration : 50,
                    startTime: "2025-12-01T09:00:00Z",
                    joinUrl: "https://zoom.us/j/123456789?pwd=mock",
                    id: 123456789,
                    topic: "Mock Upcoming Meeting",
                    'type: 2,
                    passcode: "123456"
                }
            ]
        };
    }

   

    



















    
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
    

