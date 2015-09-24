# Native Apps iOS Proof of Concept

This project is a demonstration of `SFSafariViewController` for OAuth 2.0
native app flows. The sample domain www.oauth2.pw shows two OAuth flows, one
using a Custom URI, and the other with a Universal Link.

Read the Internet Draft [OAuth 2.0 for Native Apps](https://tools.ietf.org/html/draft-wdenniss-oauth-native-apps-00) 
for more about best practices for native app auth.

The Custom URI variant should work out of the box, but the Universal Link
relies on a specific team id to be referenced on the domain.

# Targets

This project includes two targets, 'OAuth2 Test' and 'Link Test'.  
'OAuth2 Test' is configured as an OAuth2 test with the choice of 
a claimed HTTPS or Custom URI Scheme redirect. 
'Link Test' is a copy without the registered redirect URIs, it is intended 
for testing native app-to-app calls.

# Setting up a Universal Link test

## Host configuration

Spin up a domain with HTTPS, and add a file at the root level `apple-app-site-association`

With the content:

	{
	    "applinks": {
	        "apps": [],
	        "details": {
	            "D4BTUY74LQ.com.wdenniss.SigninVC": {
	                "paths": [
	                    "/oauth2callback",
	                    "/o"
	                ]
	            }
	        }
	    }
	}

Replace `D4BTUY74LQ` with your own team ID.  Your server MUST serve this file with
a `application/pkcs7-mime` content-type.

Create an App Id, and enable App Associations. 
In the build settings of the 'OAuth2 Test' target, ensure that the provisioning
profile is set explicitly to the App Id, and the signing certificate is the correct
team ID.

The most common reasons for the app association failing are incorrect signing, 
a Content-type that isn't `application/pkcs7-mime`, or an invalid format.

## Testing your apple-app-site-association

Retrieve your test file, and verify the Content-Type.

    curl -v "https://www.oauth2.pw/apple-app-site-association"`

Look for `< Content-Type: application/pkcs7-mime`, if it isn't correct, address it.

Also, verify the JSON is valid using http://jsonlint.com

	# copy contents into clipboard
	curl "https://www.oauth2.pw/apple-app-site-association" | pbcopy

	# paste into jsonlint.com and verify 

When you first install the app (or delete & reinstall), monitor the logs on the server. 
You should see a request for the association file.
