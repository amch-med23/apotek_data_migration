#!/bin/bash
# Read JSON file and parse it to insert into MySQL adverse_effects table
cat interaction_types.json | jq -c '.[]' | while read interaction_type; do
    id=$(echo $interaction_type | jq -r '.id')
    name=$(echo $interaction_type | jq -r '.name' | sed "s/'/''/g")
    category=$(echo $interaction_type | jq -r '.category' | sed "s/'/''/g")
    description=$(echo $interaction_type | jq -r '.description' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO interaction_types (id, name, category, description)
    VALUES ($id, '$name', '$category', '$description');"
done
