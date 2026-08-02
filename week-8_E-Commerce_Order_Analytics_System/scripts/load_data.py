import sqlite3
import pandas as pd
import os


# -----------------------------
# Paths
# -----------------------------

DB_PATH = "database/ecommerce.db"

SCHEMA_PATH = "sql/schema.sql"

CLEAN_FOLDER = "data/cleaned"

OUTPUT_FOLDER = "output"


# -----------------------------
# CSV Files
# -----------------------------

CUSTOMERS_FILE = "customers_clean.csv"
PRODUCTS_FILE = "products_clean.csv"
ORDERS_FILE = "orders_clean.csv"
ORDER_ITEMS_FILE = "order_items_clean.csv"



# Create Database

def create_database():

    os.makedirs("database", exist_ok=True)

    # Remove old database
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)

    with open(SCHEMA_PATH, "r") as file:
        schema = file.read()

    conn.executescript(schema)

    return conn



# Load CSV Files
def load_csv_files():

    customers = pd.read_csv(
        os.path.join(CLEAN_FOLDER, CUSTOMERS_FILE)
    )

    products = pd.read_csv(
        os.path.join(CLEAN_FOLDER, PRODUCTS_FILE)
    )

    orders = pd.read_csv(
        os.path.join(CLEAN_FOLDER, ORDERS_FILE)
    )

    order_items = pd.read_csv(
        os.path.join(CLEAN_FOLDER, ORDER_ITEMS_FILE)
    )

    return customers, products, orders, order_items



# Handle Referential Integrity
def validate_order_items(order_items, orders):

    # Invalid order references
    invalid_order_ref = order_items[
        ~order_items["order_id"].isin(
            orders["order_id"]
        )
    ]


    # Invalid discount values
    invalid_discount = order_items[
        (order_items["discount_percent"] < 0) |
        (order_items["discount_percent"] > 100)
    ]

    # Negative quantity (Safety Check)
    invalid_quantity = order_items[
        order_items["quantity"] < 0
    ] 

    # Combine all rejected rows
    rejected_items = pd.concat(
        [
            invalid_order_ref,
            invalid_discount,
            invalid_quantity
        ]
    ).drop_duplicates()


    # Valid rows
    valid_items = order_items[
        ~order_items["item_id"].isin(
            rejected_items["item_id"]
        )
    ]


    os.makedirs(
        OUTPUT_FOLDER,
        exist_ok=True
    )


    rejected_items.to_csv(
        os.path.join(
            OUTPUT_FOLDER,
            "rejected_order_items.csv"
        ),
        index=False
    )


    return valid_items, rejected_items

# Insert Data
def insert_data(
    conn,
    customers,
    products,
    orders,
    order_items
):

    customers.to_sql(
        "customers",
        conn,
        if_exists="append",
        index=False
    )


    products.to_sql(
        "products",
        conn,
        if_exists="append",
        index=False
    )


    orders.to_sql(
        "orders",
        conn,
        if_exists="append",
        index=False
    )


    order_items.to_sql(
        "order_items",
        conn,
        if_exists="append",
        index=False
    )



# Verify Load
def verify_database(conn):

    tables = [
        "customers",
        "products",
        "orders",
        "order_items"
    ]


    print("\nDatabase Load Summary")
    print("=" * 40)


    for table in tables:

        count = pd.read_sql(
            f"SELECT COUNT(*) AS count FROM {table}",
            conn
        )["count"][0]


        print(
            f"{table:<15}: {count}"
        )



# Main
def main():

    print("Loading cleaned datasets...")


    conn = create_database()


    customers, products, orders, order_items = load_csv_files()


    valid_items, invalid_items = validate_order_items(
        order_items,
        orders
    )


    insert_data(
        conn,
        customers,
        products,
        orders,
        valid_items
    )


    verify_database(conn)


    print("\nRejected order items:",
          len(invalid_items))


    print("\nDatabase created successfully.")


    conn.close()



if __name__ == "__main__":

    main()