const indexedStats = {}
require('../output/grammar-stats.json').forEach(item => indexedStats[item.location] = item);

module.exports = {
    statForFile : function(x) {
        return indexedStats[x];
    }
};
