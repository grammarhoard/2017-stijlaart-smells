

const groupByF = function(coll, f) {
    const result = {};
    coll.forEach(i => {
        const k = f(i);
        if (result[k]) {
            result[k].push(i);
        } else {
            result[k] = [i];
        }
    });
    return result;
};

module.exports = {
    groupByF : groupByF
};
