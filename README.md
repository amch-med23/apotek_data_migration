## This includes the main SQL script and the initial JSON files data, with theire insertion bash scripts
### any update to the JSON files will require to start from the latest used record id, since the supplied insertion bash scripts use IF NOT EXISTS statement which knows for it's performance, but doesn't update column data.
### So it's important to take that in mind when updating the json files for each table (adding new recrds).
### this README.md file must be updated after each json file update (to update the latest record id, etc...).

## Very important note: the insertion order is very important in this case (tables referances could cause errors if not handeled properly), this is the correct order of insertion (in this case):
    1-drugs.sh
    2-adverse_effects.sh
    3-clinical_conditions.sh
    4-clinical_drug_recommendations.sh
    5-contraindications.sh
    6-drug_adverse_effects.sh
    7-drug_contraindications.sh
    8-interactions_types.sh
    9-drug_interactions.sh
    10-therapeutic_categories.sh
## the available json files for each table are:
### drugs.json
    latest record id: 1003 (newely added records must start from this id)
### clinical_conditions.json
    latest record id: 2337 (newely added records must start from this id)
### contraindications.json
    latest record id: 2586 (newely added records must start from this id)
### adverse_effects.json
    latest record id: 1351 (newely added records must start from this id)
### drug_adverse_effects.json
    latest record id: 1071 (newely added records must start from this id)
### drug_contraindications.json
    latest record id: 1419 (newely added records must start from this id)
### drug_interactions.json
    latest record id: 8849 (newely added records must start from this id)
### clinical_drug_recommendations.json
    latest record id: 1405 (newely added records must start from this id)
### interaction_types.json
    latest record id: 35 (newely added records must start from this id)
### therapeutic_categories.json
    latest record id: 338 (newely added records must start from this id)

### I have included a bulk JSON file that contains all the records and the script i used to separate it in this repository as well, to provide the possibility of updating the entire json file at once and generate individual json tables data (json file are named based on table names in the bulk json file)
### Note: I have noticed that the specific tables in the database has more columns than the elements in the json files, This will render the other columns Emtpy. 
