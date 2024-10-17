const fs = require('fs');

fs.readFile('input.csv', 'utf8', (err, csvData) => {
    if (err) {
        console.error('Error reading the CSV file:', err);
        return;
    }
    processCSVData(csvData);
});

function processCSVData(csvData) {
    // Split the CSV data into lines
    const lines = csvData.trim().split('\n');

    // Remove the header line
    const headerLine = lines.shift();
    const headers = parseCSVLine(headerLine);

    // Indexes of the columns
    const clusterOwnerIndex = headers.indexOf('cluster_owner');
    const operatorIdsIndex = headers.indexOf('operator_ids_str');
    const validatorKeyIndex = headers.indexOf('validator_key');

    if (clusterOwnerIndex === -1 || operatorIdsIndex === -1 || validatorKeyIndex === -1) {
        console.error('CSV headers are missing required fields.');
        return;
    }

    // Initialize an object to group data by operator_ids
    const groupedData = {};

    lines.forEach(line => {
        // Parse the CSV line correctly handling quoted fields
        const fields = parseCSVLine(line);

        if (fields.length < 3) {
            console.error('Malformed line:', line);
            return;
        }

        const cluster_owner = fields[clusterOwnerIndex];
        const operator_ids_str = fields[operatorIdsIndex];
        const validator_key = fields[validatorKeyIndex];

        // Parse operator_ids into an array of integers
        const operator_ids = operator_ids_str.split(',').map(Number);

        // Create a unique key for the operator_ids to group them
        const operatorKey = operator_ids.join(',');

        if (!groupedData[operatorKey]) {
            groupedData[operatorKey] = {
                owner: cluster_owner,
                operator_ids: operator_ids,
                pubkeys: []
            };
        }

        // Add the validator_key to the pubkeys array
        groupedData[operatorKey].pubkeys.push(validator_key);
    });

    // Convert the grouped data into an array
    const result = {
        arr: Object.values(groupedData)
    };

    // Output the result as a JSON string
    console.log(JSON.stringify(result, null, 2));
}

// Function to parse a CSV line handling quoted fields and commas
function parseCSVLine(line) {
    const result = [];
    let currentField = '';
    let insideQuotes = false;

    for (let i = 0; i < line.length; i++) {
        const char = line[i];
        const nextChar = line[i + 1];

        if (char === '"' && insideQuotes && nextChar === '"') {
            // Handle escaped quote
            currentField += '"';
            i++; // Skip the next quote
        } else if (char === '"' && insideQuotes) {
            // Closing quote
            insideQuotes = false;
        } else if (char === '"' && !insideQuotes) {
            // Opening quote
            insideQuotes = true;
        } else if (char === ',' && !insideQuotes) {
            // Field separator outside quotes
            result.push(currentField);
            currentField = '';
        } else {
            // Regular character
            currentField += char;
        }
    }

    // Add the last field
    result.push(currentField);

    return result;
}
