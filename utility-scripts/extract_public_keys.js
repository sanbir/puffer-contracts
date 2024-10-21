const fs = require('fs');
const path = require('path');

const publicKeys = [];

// Read the current directory
fs.readdir(__dirname, (err, files) => {
    if (err) {
        console.error('Error reading directory:', err.message);
        return;
    }

    // Filter files matching the pattern 'response_*.json'
    const jsonFiles = files.filter(file => {
        return file.startsWith('response_') && file.endsWith('.json');
    });

    if (jsonFiles.length === 0) {
        console.log('No matching files found.');
        return;
    }

    let filesProcessed = 0;

    jsonFiles.forEach(file => {
        const filePath = path.join(__dirname, file);

        // Read the JSON file
        fs.readFile(filePath, 'utf8', (err, data) => {
            filesProcessed++;
            if (err) {
                console.error(`Error reading file ${file}:`, err.message);
            } else {
                try {
                    const jsonData = JSON.parse(data);

                    // Check if 'validators' array exists
                    if (jsonData.validators && Array.isArray(jsonData.validators)) {
                        jsonData.validators.forEach(validator => {
                            // Check if 'status' is 'Inactive' and 'public_key' exists
                            if (validator.status === 'Inactive' && validator.public_key) {
                                publicKeys.push(validator.public_key);
                            }
                        });
                    } else {
                        console.warn(`No 'validators' array found in ${file}`);
                    }
                } catch (err) {
                    console.error(`Error parsing JSON in file ${file}:`, err.message);
                }
            }

            // After processing all files, output the result
            if (filesProcessed === jsonFiles.length) {
                // Output the array of public_keys
                console.log(publicKeys);
                fs.writeFileSync('inactive_public_keys.json', JSON.stringify(publicKeys, null, 2), 'utf8');
            }
        });
    });
});
