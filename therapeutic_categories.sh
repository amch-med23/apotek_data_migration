#!/bin/bash
# Read JSON file and parse it to insert into MySQL therapeutic_categories table
cat therapeutic_categories.json | jq -c '.[]' | while read therapeutic_category; do
    id=$(echo $therapeutic_category | jq -r '.id')
    name=$(echo $therapeutic_category | jq -r '.name' | sed "s/'/''/g")
    description=$(echo $therapeutic_category | jq -r '.description' | sed "s/'/''/g")
    parent_category_id=$(echo $therapeutic_category | jq -r '.parent_category_id')
    
    if [[ "$parent_category_id" == "null" ]]; then
        parent_category_id="NULL" 
    fi

    # Check if the record with the same id exists and insert it if it doesn't
    mysql -u root -p'rootP@ssw0rd' -e "
    USE apotek_db;
    SET NAMES 'utf8mb4';
    INSERT INTO therapeutic_categories (id, name, description, parent_category_id)
    VALUES ($id, '$name', '$description', $parent_category_id);"
done

