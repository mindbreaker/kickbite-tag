___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery/tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Kickbite",
  "brand": {
    "id": "kickbite",
    "displayName": "Kickbite",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAEKADAAQAAAABAAAAEAAAAAA0VXHyAAABy0lEQVQ4EbWRP2sUURTFz31v/uwSBVHxDxaOYTPssgiBFCndmMJC0SDGRvwCgrCiIMaY0i9g0m2wENGvYKGCjTYRbKIObmdMXEWbuGvezLzrPOTBvHULC33Nufe+c35zHwP8r/Pk4OWxv2GLUablQwsXX4qZS6Puhmd/AK4fWDrVDU+uIjq2d9g8qncAs7tv7UtQv9eafr3rzol2OiowPHMAiYr2nJl+sf9s7SGw4eaft1oeN5sBA7IM8crN02sPOPK3NT4y9KffN4NG46jIseJt9g5n4K4Xx1eQJF9tztlgYmxA1NMSRZg/c8ZRVJGa7wdSngZjHDmvUilsIM4G2NxRvIUtfIHSA/bSsNLxIWe01t8U5fPVD++f2S9bJVsYLd5HmJqq4jt85f/oBJAXdDFNWV+tJO+Wy15bO08oaExra30l+zdM2CCNQYJmuVYLbaisDoAxL9O4vuQJWky1fqUYd43ZI5pTIlgoB23tADC+foRBbUHFLgKPw2T9dsr8CEXvEW7uxI05G7TqAgT5zAghhFm+Ykx+rtqpzt8IIUJJ6KiJ5qQNG3X/Qra9wUH1HDgLNPy3xkDdbu9nfPw88qwuhZCZzPtm/s/OL0ETnHQ4wfJkAAAAAElFTkSuQmCC"
  },
  "description": "Unofficial Kickbite Tag. Loads the Kickbite tracking scripts (u.js, script.js) and initialises window.kbd with your Account ID (aid). In Conversion mode it also sets conv_id (order number) and conv_rev (order total, excl. VAT) before calling kb().",
  "categories": ["ANALYTICS", "ATTRIBUTION", "ADVERTISING"],
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "trackingType",
    "displayName": "Tracking Type",
    "radioItems": [
      {
        "value": "pageview",
        "displayValue": "Page View (all pages)"
      },
      {
        "value": "conversion",
        "displayValue": "Conversion (Thank-You page)"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "pageview"
  },
  {
    "type": "TEXT",
    "name": "aid",
    "displayName": "Account ID (aid)",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Your Kickbite account identifier, e.g. \"your_account_id\". Required for every hit."
  },
  {
    "type": "TEXT",
    "name": "conv_id",
    "displayName": "Conversion ID (conv_id)",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "trackingType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "enablingConditions": [
          {
            "paramName": "trackingType",
            "paramValue": "conversion",
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Order number from your ecommerce system, e.g. {{DLV - ecommerce.purchase.actionField.id}}."
  },
  {
    "type": "TEXT",
    "name": "conv_rev",
    "displayName": "Conversion Revenue (conv_rev, optional)",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "trackingType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ],
    "help": "Optional. Order total amount excluding VAT, e.g. 11.95."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const callInWindow = require('callInWindow');
const copyFromWindow = require('copyFromWindow');
const log = require('logToConsole');

const U_JS = 'https://tr.kickbite.io/u.js';
const SCRIPT_JS = 'https://tr.kickbite.io/script.js';

const onFailure = () => {
  log('Kickbite: a tracking script failed to load.');
  data.gtmOnFailure();
};

const fire = () => {
  const kbd = copyFromWindow('kbd') || {};
  kbd.aid = data.aid;
  if (data.trackingType === 'conversion') {
    kbd.conv_id = data.conv_id;
    if (data.conv_rev) {
      kbd.conv_rev = data.conv_rev;
    }
  }
  setInWindow('kbd', kbd, true);
  callInWindow('kb');
  data.gtmOnSuccess();
};

let loaded = 0;
const onOne = () => {
  loaded++;
  if (loaded === 2) fire();
};

injectScript(U_JS, onOne, onFailure, 'kickbite_u');
injectScript(SCRIPT_JS, onOne, onFailure, 'kickbite_script');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://tr.kickbite.io/u.js"
              },
              {
                "type": 1,
                "string": "https://tr.kickbite.io/script.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "kbd"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "kb"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created for the unofficial Kickbite GTM template.
