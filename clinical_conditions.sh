#!/bin/bash
# Read JSON file and parse it to insert into MySQL clinical_conditions table
cat clinical_conditions.json | jq -c '.[]' | while read condition; do
    id=$(echo $condition | jq -r '.id')
    name=$(echo $condition | jq -r '.name' | sed "s/'/''/g")
    severity=$(echo $condition | jq -r '.severity' | sed "s/'/''/g")
    description=$(echo $condition | jq -r '.description' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO clinical_conditions (id, name, severity, description)
    VALUES ($id, '$name', '$severity', '$description');"
done
