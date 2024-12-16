#!/bin/bash
# Read JSON file and parse it to insert into MySQL drugs table
cat drug_contraindications.json | jq -c '.[]' | while read drug_contraindication; do
    id=$(echo $drug_contraindication | jq -r '.id')
    drug_id=$(echo $drug_contraindication | jq -r '.drug_id' | sed "s/'/''/g")
    contraindication_id=$(echo $drug_contraindication | jq -r '.contraindication_id' | sed "s/'/''/g")
    severity=$(echo $drug_contraindication | jq -r '.severity' | sed "s/'/''/g")
    specific_notes=$(echo $drug_contraindication | jq -r '.specific_notes' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p 'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO drug_contraindications (id, drug_id, contraindication_id, severity, specific_notes)
    VALUES ($id, '$drug_id', '$contraindication_id', '$severity', $specific_notes);"
done
