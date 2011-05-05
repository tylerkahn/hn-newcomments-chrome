(function( $ ){
    $.storage = {
        get: function(key, defaultVal, callback) {
                chrome.extension.sendRequest({method: "get", key:key, defaultValue:defaultVal}, function(response) {
                    if (typeof callback === "function") {
                        callback(response.value);
                    }
             })},
        
        set: function(key, value, callback) {
            chrome.extension.sendRequest({method: "set", key:key, value:value}, function(response){
                if (typeof callback === "function") {
                    callback(response);
                }
            });
        },
        
        dump: function(callback) {
            chrome.extension.sendRequest({method: "dump"}, function(response){
                if (typeof callback === "function") {
                    callback(response);
                }
            });
        }
    };
})(jQuery)
