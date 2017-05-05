const buildOpening = function(hs) {

    const colDef = " |" + hs.map(_ => "l").join(" | ") + " |";
    return "\\begin{table}[ht!]\n\\centering\n\\begin{tabular}{" + colDef + "}"
}
const buildRow = function(row) {
    return row.join(" & ") + " \\\\";
}
const buildTableHeader = function(headers) {
    return headers.map(x => "\\hline\n\\textbf{" + x + "}" ).join(" & ") + "\\\\";
}
module.exports = function(headers, values) {
    const rows = values.map(buildRow).map(i => "\\hline\n" + i);
    const tableHeader = buildTableHeader(headers);

    return [buildOpening(headers)]
                .concat(tableHeader)
                .concat(rows)
                .concat(["\\hline\n\\end{tabular}\n\\end{table}"]).join("\n");
}
