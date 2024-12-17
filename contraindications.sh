#!/bin/bash
# Read JSON file and parse it to insert into MySQL contraindications table
cat contraindications.json | jq -c '.[]' | while read contraindiction; do
    id=$(echo $contraindiction | jq -r '.id')
    name=$(echo $contraindiction | jq -r '.name' | sed "s/'/''/g")
    type=$(echo $contraindiction | jq -r '.type' | sed "s/'/''/g")
    description=$(echo $contraindiction | jq -r '.description' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO contraindications (id, name, type, description)
    VALUES ($id, '$name', '$type', '$description');"
done
