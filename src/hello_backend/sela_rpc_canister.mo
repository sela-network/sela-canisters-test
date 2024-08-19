import Debug "mo:base/Debug";
import Http "mo:base/Http";
import Principal "mo:base/Principal";

actor SelaRpcCanister {

    // Define the Sela Node API endpoint
    let selaNodeEndpoint: Text = "https://api.selanetwork.io/status";

    // Function to check the status of Sela Node
    public shared func checkSelaNodeStatus() : async Text {
        let request = Http.Request {
            url = selaNodeEndpoint;
            method = #get;
            body = null;
            headers = [];
        };

        // Send the request
        let response = await Http.fetch(request);

        // Check response
        switch (response.status_code) {
            case (200): {
                // Read response body and return status
                return #ok : (switch response.body {
                    case (?bodyBytes) return Text.decodeUtf8(bodyBytes);
                    case null return "Empty response body";
                });
            };
            case (_): {
                // Return error message in case of failure
                let errorMessage = "Failed to fetch status, HTTP status code: " # Text.fromNat(response.status_code);
                return #err : [(errorMessage)];
            }
        }
    };

    // Function to call Scrape API on Sela Node
    public shared func scrapeApi(query: Text) : async Text {
        let request = Http.Request {
            url = "https://api.selanetwork.io/scrape?query=" # query;
            method = #get;
            body = null;
            headers = [];
        };

        // Send the request
        let response = await Http.fetch(request);

        // Check response
        switch (response.status_code) {
            case (200): {
                // Read response body and return the result
                return #ok : (switch response.body {
                    case (?bodyBytes) return Text.decodeUtf8(bodyBytes);
                    case null return "Empty response body";
                });
            };
            case (_): {
                // Return error message in case of failure
                let errorMessage = "Failed to scrape data, HTTP status code: " # Text.fromNat(response.status_code);
                return #err : [(errorMessage)];
            }
        }
    };
};