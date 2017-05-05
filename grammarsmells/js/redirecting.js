const grammarStatsUtil = require('./grammar-stats-util');
const redirectingData = require('../output/redirecting-nonterminals-by-file.json');
const _ = require('lodash');

const data = Object.keys(redirectingData).map(k => {
    const stat = grammarStatsUtil.statForFile(k);
    return {
        ns: stat.nonterminals,
        violations: redirectingData[k],
        perc: redirectingData[k] / stat.nonterminals
    };
});
console.log(data);
console.log("Mean:",_.mean(_.map(data, 'perc')));

const violatingFiles = _.filter(data, i => { return i.perc != 0});
console.log("Violating files:", violatingFiles.length / data.length);
