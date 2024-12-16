#!/bin/bash
# Read JSON file and parse it to insert into MySQL drugs table
cat drugs.json | jq -c '.[]' | while read drug; do
    id=$(echo $drug | jq -r '.id')
    name=$(echo $drug | jq -r '.name')
    generic_name=$(echo $drug | jq -r '.generic_name')
    brand_name=$(echo $drug | jq -r '.brand_name')
    dosage_form=$(echo $drug | jq -r '.dosage_form')
    route_admin=$(echo $drug | jq -r '.route_admin')
    prescription_required=$(echo $drug | jq -r '.prescription_required')

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p '' -e "
    USE apotek_db;
    IF NOT EXISTS (SELECT 1 FROM drugs WHERE id = $id) THEN
        INSERT INTO drugs (id, name, generic_name, brand_name, dosage_form, route_admin, prescription_required)
        VALUES ($id, '$name', '$generic_name', '$brand_name', '$dosage_form', '$route_admin', $prescription_required);
    END IF;"
done
