#!/bin/bash
# Read JSON file and parse it to insert into MySQL contraindications table
cat drug_adverse_effects.json | jq -c '.[]' | while read adverse_effect; do
    id=$(echo $adverse_effect | jq -r '.id')
    drug_id=$(echo $adverse_effect | jq -r '.drug_id' | sed "s/'/''/g")
    adverse_effect_id=$(echo $adverse_effect | jq -r '.adverse_effect_id' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p 'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO drug_adverse_effects (id, drug_id, adverse_effect_id)
    VALUES ($id, '$drug_id', $adverse_effect_id);"
done
