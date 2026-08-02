import os
import re
import pandas as pd

# Paths
RAW_FOLDER = "data/raw"
CLEAN_FOLDER = "data/cleaned"
REPORT_FOLDER = "output/reports"

os.makedirs(CLEAN_FOLDER, exist_ok=True)
os.makedirs(REPORT_FOLDER, exist_ok=True)

# Issue Report
issue_report = {
    "orders": {
        "invalid_dates": 0,
        "null_customer_ids": 0,
        "future_dates": 0,
        "duplicate_orders": 0
    },

    "products": {
        "dirty_names": 0,
        "missing_cost_price": 0,
        "duplicate_products": 0
    },

    "customers": {
        "missing_customer_names": 0,
        "invalid_emails": 0,
        "duplicate_emails": 0,
        "invalid_registration_dates": 0,
        "dirty_names": 0
    },

    "order_items": {
        "negative_quantity": 0,
        "zero_quantity": 0,
        "discount_gt_100": 0,
        "duplicate_items": 0,
        "invalid_order_reference": 0
    }
}

def load_data():

    customers = pd.read_csv(f"{RAW_FOLDER}/customers.csv")
    products = pd.read_csv(f"{RAW_FOLDER}/products.csv")
    orders = pd.read_csv(f"{RAW_FOLDER}/orders.csv")
    order_items = pd.read_csv(f"{RAW_FOLDER}/order_items.csv")

    return customers, products, orders, order_items

def save_data(customers, products, orders, order_items):

    customers.to_csv(
        f"{CLEAN_FOLDER}/customers_clean.csv",
        index=False
    )

    products.to_csv(
        f"{CLEAN_FOLDER}/products_clean.csv",
        index=False
    )

    orders.to_csv(
        f"{CLEAN_FOLDER}/orders_clean.csv",
        index=False
    )

    order_items.to_csv(
        f"{CLEAN_FOLDER}/order_items_clean.csv",
        index=False
    )

# Clean Orders
def clean_orders(orders):

    # Remove duplicate order_id
    duplicate_count = orders.duplicated(subset="order_id").sum()
    issue_report["orders"]["duplicate_orders"] = duplicate_count
    orders = orders.drop_duplicates(subset="order_id")

    # Handle NULL customer_id
    null_mask = (
        orders["customer_id"].isna()
        | (orders["customer_id"].astype(str).str.strip() == "")
        | (orders["customer_id"].astype(str).str.upper() == "NULL")
    )

    issue_report["orders"]["null_customer_ids"] = null_mask.sum()
    orders.loc[null_mask, "customer_id"] = "UNKNOWN"

    # Standardize Status
    orders["status"] = (
        orders["status"]
        .astype(str)
        .str.strip()
        .str.upper()
    )

    valid_status = {
        "PLACED",
        "SHIPPED",
        "DELIVERED",
        "RETURNED",
        "CANCELLED"
    }

    orders.loc[null_mask, "customer_id"] = "C00000"

    # Standardize Region
    orders["region_code"] = (
        orders["region_code"]
        .astype(str)
        .str.strip()
        .str.upper()
    )

    region_map = {
        "NOR": "NORTH",
        "SOU": "SOUTH",
        "EAS": "EAST",
        "WES": "WEST",
        "CEN": "CENTRAL"
    }

    orders["region_code"] = (
        orders["region_code"]
        .replace(region_map)
    )

    valid_regions = {
        "NORTH",
        "SOUTH",
        "EAST",
        "WEST",
        "CENTRAL"
    }

    orders.loc[
        ~orders["region_code"].isin(valid_regions),
        "region_code"
    ] = "UNKNOWN"

    # Fix Date Format
    invalid_dates = 0
    future_dates = 0
    cleaned_dates = []

    for value in orders["order_date"]:

        parsed_date = None
        for fmt in (
            "%Y-%m-%d %H:%M:%S",
            "%d-%m-%Y %H:%M:%S"
        ):
            try:
                parsed_date = pd.to_datetime(value, format=fmt)
                break
            except:
                continue

        if parsed_date is None:
            invalid_dates += 1
            cleaned_dates.append(pd.NaT)
            continue

        if parsed_date > pd.Timestamp.now():
            future_dates += 1

        cleaned_dates.append(parsed_date)

    orders["order_date"] = cleaned_dates

    issue_report["orders"]["invalid_dates"] = invalid_dates
    issue_report["orders"]["future_dates"] = future_dates

    return orders

# Clean Products
def clean_products(products):

    # Remove duplicate product_id
    duplicate_count = products.duplicated(subset="product_id").sum()

    issue_report["products"]["duplicate_products"] = duplicate_count

    products = products.drop_duplicates(subset="product_id")

    # Clean Product Names
    original_names = products["product_name"].copy()

    products["product_name"] = (
        products["product_name"]
        .astype(str)
        .str.strip()
        .str.replace(r"\s+", " ", regex=True)
        .str.title()
    )

    dirty_names = (
        original_names != products["product_name"]
    ).sum()

    issue_report["products"]["dirty_names"] = dirty_names

    # Cost Price

    products["cost_price"] = pd.to_numeric(
        products["cost_price"],
        errors="coerce"
    )

    missing_price = products["cost_price"].isna().sum()

    negative_price = (
        products["cost_price"] < 0
    ).sum()

    issue_report["products"]["missing_cost_price"] = (
        missing_price + negative_price
    )

    median_price = products.loc[
        products["cost_price"] > 0,
        "cost_price"
    ].median()

    products["cost_price"] = products["cost_price"].fillna(
        median_price
    )

    products.loc[
        products["cost_price"] <= 0,
        "cost_price"
    ] = median_price

    # Category
    products["category"] = (
        products["category"]
        .astype(str)
        .str.strip()
        .str.title()
    )

    # Subcategory
    products["subcategory"] = (
        products["subcategory"]
        .astype(str)
        .str.strip()
        .str.title()
    )

    return products

# Clean Customers
def clean_customers(customers):

    # Remove duplicate customer_id
    duplicate_count = customers.duplicated(
        subset="customer_id"
    ).sum()

    issue_report["customers"]["duplicate_customers"] = duplicate_count

    customers = customers.drop_duplicates(
        subset="customer_id"
    )

    # Handle missing customer names
    missing_names = customers["customer_name"].isna().sum()

    customers["customer_name"] = customers["customer_name"].fillna(
        "Unknown Customer"
    )

    issue_report["customers"]["missing_customer_names"] = missing_names

    # Clean Customer Name
    original_names = customers["customer_name"].copy()

    customers["customer_name"] = (
        customers["customer_name"]
        .astype(str)
        .str.strip()
        .str.replace(r"\s+", " ", regex=True)
        .str.title()
    )

    dirty_names = (
        original_names != customers["customer_name"]
    ).sum()

    issue_report["customers"]["dirty_names"] = dirty_names

    # Registration Date
    invalid_dates = 0
    cleaned_dates = []

    for value in customers["registration_date"]:

        parsed_date = None

        for fmt in ("%Y-%m-%d", "%d-%m-%Y"):

            try:
                parsed_date = pd.to_datetime(
                    value,
                    format=fmt
                )
                break

            except:
                continue

        if parsed_date is None:

            invalid_dates += 1
            cleaned_dates.append(pd.NaT)

        else:

            cleaned_dates.append(parsed_date)

    customers["registration_date"] = cleaned_dates

    issue_report["customers"]["invalid_registration_dates"] = invalid_dates

    # Duplicate Emails
    duplicate_email_count = customers.duplicated(
        subset="email"
    ).sum()

    issue_report["customers"]["duplicate_emails"] = duplicate_email_count

    # Add Unknown Customer
    if "C00000" not in customers["customer_id"].values:

        unknown_customer = pd.DataFrame([{
            "customer_id": "C00000",
            "customer_name": "Unknown Customer",
            "email": "unknown@system.local",
            "registration_date": pd.Timestamp("1900-01-01"),
            "customer_type": "UNKNOWN"
        }])

        customers = pd.concat(
            [customers, unknown_customer],
            ignore_index=True
        )

    return customers

# Validate Email Addresses
def validate_emails(customers):
    email_pattern = (
        r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
    )
    invalid_emails = customers[
        ~customers["email"]
        .astype(str)
        .str.match(email_pattern, na=False)
    ][["customer_id", "email"]]

    issue_report["customers"]["invalid_emails"] = len(
        invalid_emails
    )

    return invalid_emails

# Clean Order Items
def clean_order_items(order_items):

    # Remove duplicate item_id
    duplicate_count = order_items.duplicated(
        subset="item_id"
    ).sum()

    issue_report["order_items"]["duplicate_items"] = duplicate_count

    order_items = order_items.drop_duplicates(
        subset="item_id"
    )

    # Convert Numeric Columns
    numeric_columns = [
        "quantity",
        "unit_price",
        "discount_percent"
    ]

    for column in numeric_columns:
        order_items[column] = pd.to_numeric(
            order_items[column],
            errors="coerce"
        )

    # Remove Negative Quantity Rows
    negative_qty = (
        order_items["quantity"] < 0
    ).sum()

    issue_report["order_items"]["negative_quantity_removed"] = negative_qty

    order_items = order_items[
        order_items["quantity"] >= 0
    ]

    # Zero Quantity
    zero_qty = (
        order_items["quantity"] == 0
    ).sum()

    issue_report["order_items"]["zero_quantity"] = zero_qty

    # Discount Greater Than 100
    invalid_discount = (
        order_items["discount_percent"] > 100
    ).sum()

    issue_report["order_items"]["discount_gt_100"] = invalid_discount

    return order_items


# Check Referential Integrity
def check_referential_integrity(orders, order_items):

    invalid_order_items = order_items[
        ~order_items["order_id"].isin(orders["order_id"])
    ].copy()

    issue_report["order_items"]["invalid_order_reference"] = len(
        invalid_order_items
    )

    return invalid_order_items


# Generate Cleaning Report
def generate_report(customers, products, orders, order_items,
                    invalid_emails, invalid_order_items):

    report_path = os.path.join(
        REPORT_FOLDER,
        "cleaning_report.md"
    )

    with open(report_path, "w", encoding="utf-8") as report:

        report.write("# Data Cleaning Report\n\n")

        report.write("## Dataset Summary\n\n")
        report.write("| Dataset | Rows |\n")
        report.write("|----------|-----:|\n")
        report.write(f"| Customers | {len(customers)} |\n")
        report.write(f"| Products | {len(products)} |\n")
        report.write(f"| Orders | {len(orders)} |\n")
        report.write(f"| Order Items | {len(order_items)} |\n\n")

        report.write("## Orders\n\n")
        report.write(f"- Duplicate Orders Removed : {issue_report['orders']['duplicate_orders']}\n")
        report.write(f"- NULL Customer IDs Fixed : {issue_report['orders']['null_customer_ids']}\n")
        report.write(f"- Invalid Dates Fixed : {issue_report['orders']['invalid_dates']}\n")
        report.write(f"- Future Dates Found : {issue_report['orders']['future_dates']}\n\n")

        report.write("## Products\n\n")
        report.write(f"- Dirty Product Names Cleaned : {issue_report['products']['dirty_names']}\n")
        report.write(f"- Missing Cost Prices Fixed : {issue_report['products']['missing_cost_price']}\n")
        report.write(f"- Duplicate Products Removed : {issue_report['products']['duplicate_products']}\n\n")

        report.write("## Customers\n\n")
        report.write(f"- Missing Customer Names Fixed : {issue_report['customers']['missing_customer_names']}\n")
        report.write(f"- Dirty Customer Names Cleaned : {issue_report['customers']['dirty_names']}\n")
        report.write(f"- Invalid Registration Dates : {issue_report['customers']['invalid_registration_dates']}\n")
        report.write(f"- Duplicate Customers Removed : {issue_report['customers']['duplicate_customers']}\n")
        report.write(f"- Duplicate Emails Found : {issue_report['customers']['duplicate_emails']}\n")
        report.write(f"- Invalid Emails Found : {len(invalid_emails)}\n\n")

        report.write("## Order Items\n\n")
        report.write(f"- Duplicate Items Removed : {issue_report['order_items']['duplicate_items']}\n")
        report.write(f"- Negative Quantity Rows Removed : {issue_report['order_items']['negative_quantity_removed']}\n")
        report.write(f"- Zero Quantity Found : {issue_report['order_items']['zero_quantity']}\n")
        report.write(f"- Discount > 100 Found : {issue_report['order_items']['discount_gt_100']}\n")
        report.write(f"- Invalid Order References : {len(invalid_order_items)}\n\n")
        
        report.write("## Validation Summary\n\n")
        report.write("| Validation | Status |\n")
        report.write("|------------|--------|\n")

        if len(invalid_emails) == 0:
            report.write("| Email Validation | ✅ Passed |\n")
        else:
            report.write(f"| Email Validation | ⚠️ {len(invalid_emails)} Invalid Emails |\n")

        if len(invalid_order_items) == 0:
            report.write("| Referential Integrity | ✅ Passed |\n")
        else:
            report.write(f"| Referential Integrity | ⚠️ {len(invalid_order_items)} Invalid References |\n")

        report.write("\n---\n")
        report.write("Report generated automatically by clean_data.py\n")

def main():

    # Load raw datasets
    customers, products, orders, order_items = load_data()

    # Clean datasets
    customers = clean_customers(customers)
    products = clean_products(products)
    orders = clean_orders(orders)
    order_items = clean_order_items(order_items)

    # Validation
    invalid_emails = validate_emails(customers)
    invalid_order_items = check_referential_integrity(
        orders,
        order_items
    )

    # Save cleaned datasets
    save_data(
        customers,
        products,
        orders,
        order_items
    )

    # Generate report
    generate_report(
        customers,
        products,
        orders,
        order_items,
        invalid_emails,
        invalid_order_items
    )

    print("Data cleaning completed successfully.")

if __name__ == "__main__":
    main()