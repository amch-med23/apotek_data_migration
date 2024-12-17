#!/bin/bash
# Read JSON file and parse it to insert into MySQL adverse_effects table
cat adverse_effects.json | jq -c '.[]' | while read adverse_effect; do
    id=$(echo $adverse_effect | jq -r '.id')
    name=$(echo $adverse_effect | jq -r '.name' | sed "s/'/''/g")
    severity=$(echo $adverse_effect | jq -r '.severity' | sed "s/'/''/g")
    description=$(echo $adverse_effect | jq -r '.description' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO adverse_effects (id, name, severity, description)
    VALUES ($id, '$name', '$severity', '$description');"
done
