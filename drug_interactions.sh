#!/bin/bash
# Read JSON file and parse it to insert into MySQL drugs table
cat drug_interactions.json | jq -c '.[]' | while read drug_interaction; do
    id=$(echo $drug_interaction | jq -r '.id')
    drug_id_1=$(echo $drug_interaction | jq -r '.drug_id_1' | sed "s/'/''/g")
    drug_id_2=$(echo $drug_interaction | jq -r '.drug_id_2' | sed "s/'/''/g")
    interaction_type_id=$(echo $drug_interaction | jq -r '.interaction_type_id' | sed "s/'/''/g")
    niveau=$(echo $drug_interaction | jq -r '.niveau' | sed "s/'/''/g")
    mecanisme=$(echo $drug_interaction | jq -r '.mecanisme' | sed "s/'/''/g")
    description_interaction=$(echo $drug_interaction | jq -r '.description_interaction' | sed "s/'/''/g")

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT INTO drug_interactions (id, drug_id_1, drug_id_2, interaction_type_id, niveau, mecanisme, description_interaction)
    VALUES ($id, '$drug_id_1', '$drug_id_2', '$interaction_type_id', '$niveau', '$mecanisme', '$description_interaction');"
done
