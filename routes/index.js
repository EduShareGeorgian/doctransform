var express = require('express');
var router = express.Router();
var xslt4node = require('xslt4node');
var path = require('path');


//transform route
router.post('/', function(req, res) {
    var config = {
        xsltPath: 'bwcktrans.xslt',
        source: req.body.doc,
        result: 'result.html'
    };

    xslt4node.transform(config, function (err) {
        if (err) {
            console.log(err);
            res.send('error');
        } else {
            res.header('Access-Control-Allow-Origin', '*');
			res.header('Access-Control-Allow-Headers', 'X-Requested-With');
            res.sendFile(path.dirname(module.parent.filename) + '/result.html');
        }
    });
});

module.exports = router;
