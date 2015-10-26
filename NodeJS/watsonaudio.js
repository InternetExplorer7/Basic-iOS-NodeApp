var watson = require('watson-developer-cloud');
var fs = require('fs');
var convert = require('./convert.js');
var uuid = require('node-uuid');

module.exports = function (text, callback) {
	var text_to_speech = watson.text_to_speech({
		username: "WATSON_USERNAME",
		password: "WATSON_PASS",
		version: "v1"
	});

	var params = {
		text: text,
		voice: 'en-US_MichaelVoice',
		accept: 'audio/wav'
	}
	var uid = uuid.v4();


	text_to_speech.synthesize(params).pipe(fs.createWriteStream("audio/" + uid + '.wav'));
	setTimeout(convert("audio/" + uid + ".wav"), 4000);
	callback("audio/" + uid + ".wav.mp4");
}