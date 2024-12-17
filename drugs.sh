#!/bin/bash
# Read JSON file and parse it to insert into MySQL drugs table
cat drugs.json | jq -c '.[]' | while read drug; do
    id=$(echo $drug | jq -r '.id')
    name=$(echo $drug | jq -r '.name' | sed "s/'/''/g")
    generic_name=$(echo $drug | jq -r '.generic_name' | sed "s/'/''/g")
    brand_name=$(echo $drug | jq -r '.brand_name' | sed "s/'/''/g")
    dosage_form=$(echo $drug | jq -r '.dosage_form' | sed "s/'/''/g")
    route_admin=$(echo $drug | jq -r '.route_admin' | sed "s/'/''/g")
    prescription_required=$(echo $drug | jq -r '.prescription_required')

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT IGNORE INTO drugs (id, name, generic_name, brand_name, dosage_form, route_admin, prescription_required)
    VALUES ($id, '$name', '$generic_name', '$brand_name', '$dosage_form', '$route_admin', $prescription_required);"
done
