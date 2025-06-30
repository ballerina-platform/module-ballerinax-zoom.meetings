_Author_: @Laavanja19 \
_Created_: 2025/06/24 \
_Updated_: 2025/06/24 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Zoom Meetings.
The OpenAPI specification is obtained from (https://developers.zoom.us/docs/api/meetings/).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

## Sanitation Details

**Note** : In case of redeclared fields across multiple schemas under `allOf`, follow this rule:

* If one of the schema defines the field as a subtype (e.g., an `enum`) and another defines it as a base type (e.g., `string`), then choose the schema with the subtype and add the redeclared field in the mentioned way below.

1. **Redeclared Symbol** : `nextPageToken` in types.bal

   **Issue** : The symbol `nextPageToken` was declared in multiple schemas referenced by `allOf`, leading to a redeclaration error during compilation.

   **Before**:

   ```json
    "InlineResponse20047": {
      "allOf":[
        {
          "$ref": "#/components/schemas/InlineResponse20047AllOf1"
        },
        {
          "$ref": "#/components/schemas/InlineResponse20047InlineResponse20047AllOf12"
        }
      ]
    }
   ```

   **After**:

   ```json
    "InlineResponse20047": {
      "allOf": [
        {
          "$ref": "#/components/schemas/InlineResponse20047AllOf1"
        },
        {
          "$ref": "#/components/schemas/InlineResponse20047InlineResponse20047AllOf12"
        },
        {
          "type": "object",
          "properties": {
            "next_page_token": {
              "type": "string",
              "description": "The next page token is used to paginate through large result sets. A next page token will be returned whenever the set of available results exceeds the current page size. The expiration period for this token is 15 minutes",
              "example": "w7587w4eiyfsudgk",
              "x-ballerina-name": "nextPageToken"
            }
          }
        }
      ]
    }
   ```

2. **Redeclared Symbol** : `recordingPlayPasscode` in types.bal

   **Issue** : The symbol `recordingPlayPasscode` was declared in multiple schemas referenced by `allOf`, leading to a redeclaration error during compilation.

   **Before**:

   ```json
    "InlineResponse2003": {
      "allOf": [
        {
          "$ref": "#/components/schemas/InlineResponse2003AllOf1"
        },
        {
          "$ref": "#/components/schemas/InlineResponse2003InlineResponse2003AllOf12"
        },
        {
          "$ref": "#/components/schemas/InlineResponse2003InlineResponse2003InlineResponse2003AllOf123"
        }
      ]
    }
   ```

   **After**:

   ```json
    "InlineResponse2003": {
      "allOf": [
        {
          "$ref": "#/components/schemas/InlineResponse2003AllOf1"
        },
        {
          "$ref": "#/components/schemas/InlineResponse2003InlineResponse2003AllOf12"
        },
        {
          "$ref": "#/components/schemas/InlineResponse2003InlineResponse2003InlineResponse2003AllOf123"
        },
        {
          "type": "object",
          "properties": {
            "recording_play_passcode": {
            "type": "string",
            "description": "The cloud recording's passcode to be used in the URL. Directly splice this recording's passcode in `play_url` or `share_url` with `?pwd=` to access and play. Example: 'https://zoom.us/rec/share/**************?pwd=yNYIS408EJygs7rE5vVsJwXIz4-VW7MH'",
            "example": "yNYIS408EJygs7rE5vVsJwXIz4-VW7MH",
            "x-ballerina-name": "recordingPlayPasscode"
            }
          }
        }
      ]
    }
   ```

3. **Redeclared Symbol** : `status` in types.bal

   **Issue** : The symbol `status` was declared in multiple schemas referenced by `allOf`, leading to a redeclaration error during compilation.

   **Before**:

   ```json
    "RegistrationListRegistrants": {
      "allOf": [
        {
          "$ref": "#/components/schemas/RegistrantsAllOf1"
        },
        {
          "$ref": "#/components/schemas/RegistrantsRegistrantsAllOf12"
        },
        {
          "$ref": "#/components/schemas/RegistrantsRegistrantsRegistrantsAllOf123"
        }
      ]
    }
   ```

   **After**:

   ```json
    "RegistrationListRegistrants": {
      "allOf": [
        {
          "$ref": "#/components/schemas/RegistrantsAllOf1"
        },
        {
          "$ref": "#/components/schemas/RegistrantsRegistrantsAllOf12"
        },
        {
          "$ref": "#/components/schemas/RegistrantsRegistrantsRegistrantsAllOf123"
        },
        {
          "type": "object",
          "properties": {
            "status": {
              "type": "string",
              "description": "The registrant's status. \n* `approved` - Registrant is approved. \n* `denied` - Registrant is denied. \n* `pending` - Registrant is waiting for approval",
              "example": "approved",
              "enum": [
                  "approved",
                  "denied",
                  "pending"
              ]
            }
          }
        }
      ]
    }
   ```

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```

Note: The license year is hardcoded to 2025, change if necessary.
