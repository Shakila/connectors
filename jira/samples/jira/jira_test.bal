import org.wso2.ballerina.connectors.jira;

import ballerina.lang.jsons;
import ballerina.lang.system;
import ballerina.lang.messages;
import ballerina.net.http;
import ballerina.test;

message jiraResponse;
json jiraJSONResponse;
string issueId = "ABC-1234";

function init () (jira:ClientConnector){

    string apiInstance = system:getEnv("JIRA_URL");
    string username = system:getEnv("USERNAME");
    string password = system:getEnv("PASSWORD");
    jira:ClientConnector jiraConnector = create jira:ClientConnector(apiInstance, username, password);
    return jiraConnector;

}


function testGetIssueInfo () {

    jira:ClientConnector jiraConnector = init();
    jiraResponse = jira:ClientConnector.getIssueInfo (jiraConnector, issueId, "", "summary");
    jiraJSONResponse = messages:getJsonPayload(jiraResponse);
    system:println((string)(jiraJSONResponse));
    int status = http:getStatusCode(jiraResponse);
    test:assertEquals(status, 200);
    system:println("===testGetIssueInfo completed===\n");

}

function testSearchJira () {

    json payload = {
                   "jql":"project = ABC",
                   "startAt":0,
                   "maxResults":3,
                   "validateQuery":true,
                   "fields":[
                            "summary",
                            "status",
                            "assignee"
                            ]
                   };
    jira:ClientConnector jiraConnector = init();
    jiraResponse = jira:ClientConnector.searchJira (jiraConnector, payload);
    jiraJSONResponse = messages:getJsonPayload(jiraResponse);
    system:println(jsons:toString(jiraJSONResponse));
    int status = http:getStatusCode(jiraResponse);
    test:assertEquals(status, 200);
    system:println("===testSearchJira completed===\n");

}

function testPostComment () {

    json payload = {
                   "body":"This is a test comment triggered by a Ballerina program",
                   "visibility":{
                                "type":"role",
                                "value":"Users"
                                }
                   };
    jira:ClientConnector jiraConnector = init();
    jiraResponse = jira:ClientConnector.postComment (jiraConnector, issueId, "", payload);
    jiraJSONResponse = messages:getJsonPayload(jiraResponse);
    system:println(jsons:toString(jiraJSONResponse));
    int status = http:getStatusCode(jiraResponse);
    test:assertEquals(status, 201);
    system:println("===testPostComment completed===\n");

}

function testAssignIssueToUser () {

    json payload = {
                   "name":"user@example.com"
                   };
    jira:ClientConnector jiraConnector = init();
    jiraResponse = jira:ClientConnector.assignIssueToUser (jiraConnector, issueId, payload);
    int status = http:getStatusCode(jiraResponse);
    test:assertEquals(status, 204);
    system:println("===testAssignIssueToUser completed===\n");

}

function testCreateBulkIssue () {

    json payload = {
                   "issueUpdates":[
                                  {
                                  "update":{
                                           },
                                  "fields":{
                                           "project":{
                                                     "id":"10000"
                                                     },
                                           "summary":"This is a test issue created by a Ballerina program",
                                           "issuetype":{
                                                       "id":"1"
                                                       },
                                           "assignee":{
                                                      "name":"user@example.com"
                                                      },
                                           "priority":{
                                                      "id":"1"
                                                      },
                                           "labels":[
                                                    "bugfix",
                                                    "blitz_test"
                                                    ],
                                           "versions":[
                                                      {
                                                      "id":"10000"
                                                      }
                                                      ],
                                           "environment":"environment",
                                           "description":"description",
                                           "duedate":"2017-06-11",
                                           "fixVersions":[
                                                         {
                                                         "id":"10001"
                                                         }
                                                         ],
                                           "components":[
                                                        {
                                                        "id":"10000"
                                                        }
                                                        ]
                                           }
                                  },
                                  {
                                  "update":{
                                           },
                                  "fields":{
                                           "project":{
                                                     "id":"10000"
                                                     },
                                           "summary":"This is the test issue 2 created by a Ballerina program",
                                           "issuetype":{
                                                       "id":"1"
                                                       },
                                           "assignee":{
                                                      "name":"user@example.com"
                                                      },
                                           "priority":{
                                                      "id":"1"
                                                      },
                                           "labels":[
                                                    "bugfix",
                                                    "blitz_test"
                                                    ],
                                           "versions":[
                                                      {
                                                      "id":"10000"
                                                      }
                                                      ],
                                           "environment":"environment",
                                           "description":"description",
                                           "duedate":"2017-06-11",
                                           "fixVersions":[
                                                         {
                                                         "id":"10001"
                                                         }
                                                         ],
                                           "components":[
                                                        {
                                                        "id":"10000"
                                                        }
                                                        ]
                                           }
                                  }
                                  ]
                   };
    jira:ClientConnector jiraConnector = init();
    jiraResponse = jira:ClientConnector.createBulkIssue (jiraConnector, payload);
    jiraJSONResponse = messages:getJsonPayload(jiraResponse);
    system:println(jsons:toString(jiraJSONResponse));
    int status = http:getStatusCode(jiraResponse);
    test:assertEquals(status, 201);
    system:println("===testCreateBulkIssue completed===\n");

}
