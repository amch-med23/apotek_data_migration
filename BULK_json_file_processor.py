#!/usr/bin/env python
""" this is a script to read and inspect specific elements of
    the provided apotek_json_file"""

import os
import json

def main_inspector_func(file_path:str):
    """this handles the main functionality"""

    with open(file_path, "r", encoding='utf-8') as json_file :
        json_data = json.load(json_file)
        available_tables_num = len(json_data)
        print("json len is: {}".format(available_tables_num))
        tables_list = json_data.keys()

        print(tables_list)
    # here we will create separate json file that contain each table records.
    print(available_tables_num)
    for key in tables_list:
        print("key: {}".format(key))
        # writing tables records to their correspondant json file names.
        filename = key + ".json"
        print(filename)
        with open(filename, 'w', encoding='utf-8') as new_file:
            table_record = json_data[key]
            table_record_json = json.dumps(table_record)
            new_file.write(table_record_json)


if __name__ == "__main__":
    main_inspector_func("BULK_apotek_json_file.json")