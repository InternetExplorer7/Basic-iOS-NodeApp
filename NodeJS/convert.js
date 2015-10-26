var ffmpeg = require('fluent-ffmpeg');
module.exports = function (filename) {
	    // Create a command to convert source.avi to MP4
	    setTimeout(function(){
        var command = ffmpeg(filename)
          .audioCodec('libfaac')
          .videoCodec('libx264')
          .format('mp4');

        // Save a converted version with the original size
        command.save(filename + '.mp4');
        	    }, 15500); // Give some time for Watson to initialize file

} 