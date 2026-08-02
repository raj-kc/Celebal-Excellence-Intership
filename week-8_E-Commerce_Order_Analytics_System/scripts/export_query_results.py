import os
import sqlite3
import pandas as pd


# ---------------------------------------
# Paths
# ---------------------------------------

DATABASE_PATH = "database/ecommerce.db"

SQL_FOLDER = "sql"

OUTPUT_FOLDER = "output/sample_reports"


os.makedirs(
    OUTPUT_FOLDER,
    exist_ok=True
)


# ---------------------------------------
# SQL Files
# ---------------------------------------

SQL_FILES = [

    "aggregations.sql",

    "window_functions.sql",

    "cohort_analysis.sql"

]


# ---------------------------------------
# Connect Database
# ---------------------------------------

connection = sqlite3.connect(
    DATABASE_PATH
)


# ---------------------------------------
# Execute SQL Files
# ---------------------------------------

for sql_file in SQL_FILES:

    print("\n" + "=" * 70)
    print(f"Executing : {sql_file}")
    print("=" * 70)

    sql_path = os.path.join(
        SQL_FOLDER,
        sql_file
    )

    if not os.path.exists(sql_path):

        print(f"{sql_file} not found.\n")

        continue


    with open(
        sql_path,
        "r",
        encoding="utf-8"
    ) as file:

        sql_script = file.read()


    queries = [

        query.strip()

        for query in sql_script.split(";")

        if query.strip()

    ]


    query_number = 1


    for query in queries:

        try:

            result = pd.read_sql_query(
                query,
                connection
            )

        except Exception:

            continue


        print("\n" + "-" * 60)
        print(f"Query {query_number}")
        print("-" * 60)

        print(result.head())


        output_file = (

            f"{os.path.splitext(sql_file)[0]}"

            f"_query_{query_number}.csv"

        )


        result.to_csv(

            os.path.join(
                OUTPUT_FOLDER,
                output_file
            ),

            index=False

        )


        print(
            f"\nSaved -> {output_file}"
        )


        query_number += 1


# ---------------------------------------
# Close Database
# ---------------------------------------

connection.close()


print("\n" + "=" * 70)
print("All query results exported successfully.")
print("=" * 70)