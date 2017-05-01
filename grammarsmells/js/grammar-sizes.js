const grammarStats = require('../output/grammar-stats');
const referenceInfo = require('../output/reference-info');

const pairs = grammarStats.map(x => [x.nonterminals, x.location]);
const _ = require('lodash');
const {groupByF} = require('./base.js');

const within = (low, high) => x => low <= x && x <= high;

const nonterminalSizePreds = {
    '0': within(0,0),
    '1-10': within(1,10),
    '11-25': within(11,25),
    '26-50': within(26,50),
    '51-100': within(51,100),
    '101-200': within(101, 200),
    '201-500': within(201, 500),
    '501+': (x => x > 500),
};

const allGroups = Object.keys(nonterminalSizePreds);

const keyedPreds = function(predMap, v) {
    return Object.keys(predMap).filter(x => predMap[x](v))[0];
}

const nonterminalSizeGroup = x => keyedPreds(nonterminalSizePreds, x);
const groups = groupByF(pairs, x => nonterminalSizeGroup(x[0]));
const groupSizes = _.mapValues(groups, x => x.length);

const locGroupDict = {};
Object.keys(groups).forEach(groupKey => groups[groupKey].forEach(value => locGroupDict[value[1]] = groupKey))

console.log("Group Sizes:");
console.log(groupSizes);
console.log("");

console.log("Reference direction:");
console.log(" > all: ", _.mapValues(_.groupBy(referenceInfo, 'dir'), x => x.length));
console.log(" > mean:", _.mean(_.map(referenceInfo, 'ratio')));
console.log(" > min: ", _.min(_.map(referenceInfo, 'ratio')));
console.log(" > max: ", _.max(_.map(referenceInfo, 'ratio')));
console.log("");

allGroups.forEach(group => {
    console.log ("> Reference direction for group", group);
    const filtered = referenceInfo.filter(x => locGroupDict[x.location] == group);
    const grouped =  _.groupBy(filtered, 'dir');
    console.log(_.mapValues(grouped, x => x.length));
});

console.log("> Reference group percentage");
allGroups.forEach(group => {
    const filtered = referenceInfo.filter(x => locGroupDict[x.location] == group);
    const grouped =  _.groupBy(filtered, 'dir');
    const total = _.sum(_.values(_.mapValues(grouped, 'length')));
    const percentages = _.mapValues(_.mapValues(grouped, x => x.length / total), x => x.toFixed(2))

    console.log(percentages.UP ,"|", percentages.EVEN || 0.00,"|", percentages.DOWN);
});
