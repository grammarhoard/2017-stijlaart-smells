const gsutil = require('../grammar-stats-util.js');
const referenceInfo = require('../../output/reference-info');
const _ = require('lodash');
const dataFile = require('../dataFile');

const result = referenceInfo.map(function(item) {
    return [gsutil.statForFile(item.location).nonterminals,
        item.ratio
    ];
});

const grouped = _.groupBy(result, i => i);
const resultWithCount = Object.keys(grouped).map(k => {
    return (grouped[k][0].concat([grouped[k].length]));
});


dataFile.build(
    ["ns", "ratio", "count"],
    resultWithCount
)
// console.log(JSON.stringify(result));
