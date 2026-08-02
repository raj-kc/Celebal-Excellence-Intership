from datetime import datetime, timedelta
import sqlite3


# Database Path
DB_PATH = "database/ecommerce.db"

# Connect Database
def connect_database():

    try:

        conn = sqlite3.connect(DB_PATH)

        print("\nConnected to SQLite database successfully.")

        return conn

    except sqlite3.Error as error:

        print(f"\nDatabase Connection Error: {error}")

        return None

# Get Report Details
def get_user_input():

    print("=" * 40)
    print("E-Commerce Analytics Report")
    print("=" * 40)

    print("\nChoose Report Type")
    print("1. Daily")
    print("2. Weekly")
    print("3. Monthly")

    report_choice = input(
        "\nEnter your choice (1-3): "
    )

    report_types = {
        "1": "Daily",
        "2": "Weekly",
        "3": "Monthly"
    }

    while report_choice not in report_types:

        report_choice = input(
            "Invalid choice. Enter again (1-3): "
        )

    start_date = input(
        "\nEnter Start Date (YYYY-MM-DD): "
    )

    end_date = input(
        "Enter End Date (YYYY-MM-DD): "
    )

    return (
        report_types[report_choice],
        start_date,
        end_date
    )

# Generate Summary Report
def generate_summary(
    conn,
    start_date,
    end_date
):

    cursor = conn.cursor()

    query = """
    SELECT

        COUNT(DISTINCT o.order_id),

        ROUND(
            SUM(
                oi.quantity *
                oi.unit_price *
                (
                    1 - oi.discount_percent / 100.0
                )
            ),
            2
        ),

        COUNT(
            DISTINCT o.customer_id
        )

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    WHERE
        o.order_date
        BETWEEN ? AND ?;
    """

    cursor.execute(
        query,
        (start_date, end_date)
    )

    total_orders, revenue, customers = cursor.fetchone()

    return (
        total_orders,
        revenue or 0,
        customers
    )

# Top 3 Products
def top_products(
    conn,
    start_date,
    end_date
):

    cursor = conn.cursor()

    query = """
    SELECT

        p.product_name,

        SUM(oi.quantity) AS total_quantity

    FROM products p

    JOIN order_items oi
    ON p.product_id = oi.product_id

    JOIN orders o
    ON oi.order_id = o.order_id

    WHERE
        o.order_date
        BETWEEN ? AND ?

    GROUP BY

        p.product_id,
        p.product_name

    ORDER BY

        total_quantity DESC

    LIMIT 3;
    """

    cursor.execute(
        query,
        (start_date, end_date)
    )

    return cursor.fetchall()


# Previous Date Range
def get_previous_period(
    start_date,
    end_date
):

    start = datetime.strptime(
        start_date,
        "%Y-%m-%d"
    )

    end = datetime.strptime(
        end_date,
        "%Y-%m-%d"
    )

    days = (end - start).days + 1

    previous_end = start - timedelta(days=1)

    previous_start = previous_end - timedelta(days=days - 1)

    return (

        previous_start.strftime("%Y-%m-%d"),

        previous_end.strftime("%Y-%m-%d")

    )


# Percentage Change
def percentage_change(
    current,
    previous
):

    if previous == 0:

        return "N/A"

    change = (

        (current - previous)

        / previous

    ) * 100

    return f"{change:.2f}%"

# Main
def main():

    report_type, start_date, end_date = get_user_input()

    print("\nSelected Report")
    print("-" * 30)

    print("Type :", report_type)
    print("From :", start_date)
    print("To   :", end_date)

    conn = connect_database()

    summary = generate_summary(
    conn,
    start_date,
    end_date
    )

    total_orders, revenue, customers = summary

    print("\nSummary Report")
    print("-" * 40)

    print(f"Total Orders      : {total_orders}")
    print(f"Revenue           : ₹{revenue:,.2f}")
    print(f"Unique Customers  : {customers}")

    products = top_products(
    conn,
    start_date,
    end_date
    )

    print("\nTop 3 Products")
    print("-" * 40)

    for index, product in enumerate(products, start=1):

        print(
            f"{index}. {product[0]} ({product[1]} units)"
        )

    previous_start, previous_end = get_previous_period(
    start_date,
    end_date
)

    current_summary = generate_summary(
        conn,
        start_date,
        end_date
    )

    previous_summary = generate_summary(
        conn,
        previous_start,
        previous_end
    )

    print("\nComparison with Previous Period")
    print("-" * 40)

    print(
        f"Previous Period : {previous_start} to {previous_end}"
    )

    print(
        f"Orders Change      : {percentage_change(current_summary[0], previous_summary[0])}"
    )

    print(
        f"Revenue Change     : {percentage_change(current_summary[1], previous_summary[1])}"
    )

    print(
        f"Customer Change    : {percentage_change(current_summary[2], previous_summary[2])}"
    )

    if conn is None:
        return

    conn.close()

    print("\nDatabase connection closed.")


if __name__ == "__main__":

    main()