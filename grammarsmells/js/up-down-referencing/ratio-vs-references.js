const gsutil = require('../grammar-stats-util.js');
const referenceInfo = require('../../output/reference-info');
const dataFile = require('../dataFile');
const _ = require('lodash');


const result = referenceInfo.map(function(item) {
    return [item.up + item.down,
        item.ratio
    ];
});

const grouped = _.groupBy(result, i => i);
const resultWithCount = Object.keys(grouped).map(k => {
    return (grouped[k][0].concat([grouped[k].length]));
});


dataFile.build(
    ["refs", "ratio", "count"],
    resultWithCount
)
