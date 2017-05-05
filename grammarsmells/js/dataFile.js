module.exports = {
    build : function(cols, values) {
        const header = cols.join(" ");
        const rows = values.map(x => x.join(" ")).join("\n");

        const total = header + "\n" + rows;
        console.log(total);
    }
}
