import pandas as pd

# -----------------------------
# File Paths
# -----------------------------

# CUSTOMERS_FILE = "data/raw/customers.csv"
# PRODUCTS_FILE = "data/raw/products.csv"
# ORDERS_FILE = "data/raw/orders.csv"
# ORDER_ITEMS_FILE = "data/raw/order_items.csv"

CUSTOMERS_FILE = "data/cleaned/customers_clean.csv"
PRODUCTS_FILE = "data/raw/products.csv"
ORDERS_FILE = "data/raw/orders.csv"
ORDER_ITEMS_FILE = "data/raw/order_items.csv"


# -----------------------------
# Load Data
# -----------------------------

customers = pd.read_csv(CUSTOMERS_FILE)
products = pd.read_csv(PRODUCTS_FILE)
orders = pd.read_csv(ORDERS_FILE)
order_items = pd.read_csv(ORDER_ITEMS_FILE)


# -----------------------------
# Dataset Summary
# -----------------------------

def dataset_summary(df, name):

    print(f"\n{name}")
    print("-" * 50)
    print(f"Rows    : {len(df)}")
    print(f"Columns : {len(df.columns)}")
    print(df.dtypes)


# -----------------------------
# Null Values
# -----------------------------

def check_nulls(df, name):

    print(f"\n{name} - NULL Values")
    print("-" * 50)

    print(df.isnull().sum())


# -----------------------------
# Duplicate Primary Keys
# -----------------------------

def check_duplicates(df, column, name):

    duplicates = df.duplicated(subset=column).sum()

    print(f"\n{name}")
    print("-" * 50)
    print(f"Duplicate {column}: {duplicates}")


# -----------------------------
# Referential Integrity
# -----------------------------

def check_referential_integrity():

    invalid_orders = order_items[
        ~order_items["order_id"].isin(orders["order_id"])
    ]

    invalid_products = order_items[
        ~order_items["product_id"].isin(products["product_id"])
    ]

    invalid_customers = orders[
        ~orders["customer_id"].isin(customers["customer_id"])
    ]

    print("\nReferential Integrity")
    print("-" * 50)
    print(f"Invalid Order References    : {len(invalid_orders)}")
    print(f"Invalid Product References  : {len(invalid_products)}")
    print(f"Invalid Customer References : {len(invalid_customers)}")


# -----------------------------
# Numeric Validation
# -----------------------------

def numeric_checks():

    print("\nOrder Items Validation")
    print("-" * 50)

    print(f"Negative Quantity : {(order_items['quantity'] < 0).sum()}")

    print(f"Zero Quantity     : {(order_items['quantity'] == 0).sum()}")

    print(f"Discount >100     : {(order_items['discount_percent'] > 100).sum()}")


import re

# -----------------------------
# Invalid Email Check
# -----------------------------

def check_invalid_emails(customers):

    email_pattern = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"

    invalid_emails = customers[
        ~customers["email"]
        .fillna("")
        .astype(str)
        .str.match(email_pattern)
    ]

    print("\nInvalid Emails")
    print("-" * 50)
    print(f"Invalid Emails : {len(invalid_emails)}")

    if not invalid_emails.empty:
        print("\nSample Invalid Emails")
        print(
            invalid_emails[
                ["customer_id", "email"]
            ].head(10)
            .to_string(index=False)
        )

# -----------------------------
# Main
# -----------------------------

def main():
    check_invalid_emails(customers)
    dataset_summary(customers, "Customers")
    dataset_summary(products, "Products")
    dataset_summary(orders, "Orders")
    dataset_summary(order_items, "Order Items")

    check_nulls(customers, "Customers")
    check_nulls(products, "Products")
    check_nulls(orders, "Orders")
    check_nulls(order_items, "Order Items")

    check_duplicates(customers, "customer_id", "Customers")
    check_duplicates(products, "product_id", "Products")
    check_duplicates(orders, "order_id", "Orders")
    check_duplicates(order_items, "item_id", "Order Items")

    check_referential_integrity()

    numeric_checks()

    print("\nVerification completed successfully.")


if __name__ == "__main__":
    main()