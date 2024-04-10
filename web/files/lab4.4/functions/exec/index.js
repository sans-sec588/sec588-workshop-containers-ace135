var child_process = require('child_process')

exports.handle = function(e, ctx, cb) {
  child_process.exec(e.command, {
    maxBuffer: 1024*1024*512
  }, (err, stdout, stderr) => {
    cb(err, stdout)
  })
}

