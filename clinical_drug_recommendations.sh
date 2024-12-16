#!/bin/bash
# Read JSON file and parse it to insert into MySQL clinical_drug_recommendations table
cat clinical_drug_recommendations.json | jq -c '.[]' | while read clinical_rec; do
    id=$(echo $clinical_rec | jq -r '.id')
    clinical_condition_id=$(echo $clinical_rec | jq -r '.clinical_condition_id' | sed "s/'/''/g")
    drug_id=$(echo $clinical_rec | jq -r '.drug_id' | sed "s/'/''/g")
    dosing_details=$(echo $iclinical_rec | jq -r '.dosing_details' | sed "s/'/''/g")
    usage_notes=$(echo $clinical_rec | jq -r '.usage_notes' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p 'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO clinical_drug_recommendations (id, clinical_condition_id, drug_id, dosing_details, usage_notes)
    VALUES ($id, '$clinical_condition_id', '$drug_id', '$dosing_details', $usage_notes);"
done
