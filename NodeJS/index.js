var express = require('express');
var watson = require('./watsonaudio.js');
var bodyParser = require('body-parser');
var request = require('request');

var app = express();
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({
        extended: false
}));
// parse application/json
app.use(bodyParser.json())

app.use(express.static(__dirname + '/public')); // Hit root, look in public
app.use("/audio", express.static(__dirname + "/audio")); // Hit uploads, look in uploads.

app.post("/ios", function(req, res) {
        var data = JSON.parse(req.body.json);
        //console.log(data.location.substring(data.location.indexOf("<") + 2, data.location.indexOf(">")));
        var place = data.Place.replace(/ /g, ''); // restaurant, trim whitespace
        var location = data.location.substring(data.location.indexOf("<") + 2, data.location.indexOf(">")); // Lat, Long
        var locarray = location.split(",");
        console.log(locarray);
        console.log(place);

        getnearby(place, locarray, "500", function(body) {
                if (body.status === "ZERO_RESULTS") {
                        getnearby(place, locarray, "1500", function(body) {
                                if (body.status === "ZERO_RESULTS") {
                                        getnearby(place, locarray, "2500", function(body) {
                                                if (body.status === "ZERO_RESULTS") {
                                                        watson("Sorry, I couldn't find any " + place + "s around you.", function(filelocation) {
                                                                res.send("https://0fa50fcc.ngrok.io/" + filelocation);
                                                        });
                                                } else { // 2500
                                                	console.log("Inside 2500");
                                                        var watsontext = ("I've found some " + place + "s, buy they are quite far away from you. they are.");
                                                        body.results.forEach(function(place) {
                                                                watsontext += (" " + place.name + " has a rating of " + place.rating + " and is located at " + place.vicinity);
                                                        });
                                                        console.log(watsontext);
                                                        watson(watsontext, function(filelocation) {
                                                        	console.log("ABOUT TO SEND 2500");
                                                                res.send("https://0fa50fcc.ngrok.io/" + filelocation);
                                                        });

                                                }
                                        });
                                } else { // 1500
                                	console.log("Inside 1500");
                                        var watsontext = ("I've found some " + place + "s a little far, they are.");
                                        body.results.forEach(function(place) {
                                                watsontext.concat(" " + place.name + " has a rating of " + place.rating + " and is located at " + place.vicinity);
                                        });
                                        watson(watsontext, function(filelocation) {
                                                res.send("https://0fa50fcc.ngrok.io/" + filelocation);
                                        });

                                }
                        });
                } else { // 500
                	console.log("Inside 500");
                        var watsontext = ("I've found some " + place + "s nearby, they are.");
                        body.results.forEach(function(place) {
                                watsontext.concat(" " + place.name + " has a rating of " + place.rating + " and is located at " + place.vicinity);
                        });
                        watson(watsontext, function(filelocation) {
                                res.send("https://0fa50fcc.ngrok.io/" + filelocation);
                        });
                }
        });
});

function getnearby(place, locarray, distance, callback) { // Passed in type of place
        console.log("Got to steptwo");
        request({
                url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=ThisISNotMyKeyyCOQFjtNOTAKEYvu4zLOLVUBgLMAO_m_HnE1QP9ag2WA&location=" + locarray[0] + "," + locarray[1] + "&radius=" + distance + "&type=" + place + "&opennow",
                json: true
        }, function(error, response, body) {
                if (!error && response.statusCode === 200) {
                        callback(body);
                } else {
                        console.log("Error");
                }
        })
}
app.listen(3000);