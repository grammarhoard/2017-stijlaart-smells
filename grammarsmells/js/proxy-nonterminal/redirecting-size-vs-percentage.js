const gsutil = require('../grammar-stats-util.js');
const redirectInfo = require('../../output/redirecting-nonterminals-by-file');
const dataFile = require('../dataFile');
const _ = require('lodash');


const result = Object.keys(redirectInfo).map(function(key) {
    return [gsutil.statForFile(key).nonterminals,
        redirectInfo[key] / gsutil.statForFile(key).nonterminals
    ];
});

const grouped = _.groupBy(result, i => i);
const resultWithCount = Object.keys(grouped).map(k => {
    return (grouped[k][0].concat([grouped[k].length]));
});


dataFile.build(
    ["ns", "vs", "count"],
    resultWithCount
)
