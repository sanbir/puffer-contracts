const fs = require('fs');
const path = require('path');

// File paths
const inputJsonPath = path.join(__dirname, 'output_from_csv.json');
const publicKeysPath = path.join(__dirname, 'inactive_public_keys.json');
const outputJsonPath = path.join(__dirname, 'filtered_output.json');

// Read the publicKeys array from inactive_public_keys.json
const publicKeys = JSON.parse(fs.readFileSync(publicKeysPath, 'utf8'));

// Convert the array to a Set for efficient lookup
const publicKeysSet = new Set(publicKeys.map(key => '0x' + key.toLowerCase())); // Use lowercase for case-insensitive comparison

console.log('publicKeysSet size:', publicKeysSet.size)

// Read the JSON output from the first script
const inputData = JSON.parse(fs.readFileSync(inputJsonPath, 'utf8'));

// Filter the pubkeys in inputData.arr
inputData.arr.forEach(item => {
    console.log('item.pubkeys before:', item.pubkeys.length)

    item.pubkeys = item.pubkeys.filter(pubkey => publicKeysSet.has(pubkey.toLowerCase()));

    console.log('item.pubkeys after:', item.pubkeys.length)
});

// Optionally, remove items with empty pubkeys arrays
inputData.arr = inputData.arr.filter(item => item.pubkeys.length > 0);

// Write the filtered data to a new JSON file
fs.writeFileSync(outputJsonPath, JSON.stringify(inputData, null, 2), 'utf8');

console.log(`Filtered data has been saved to ${outputJsonPath}`);
