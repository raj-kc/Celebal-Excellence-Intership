import pandas as pd

from clean_data import (
    clean_orders,
    clean_order_items
)

from load_data import (
    validate_order_items
)


def test_invalid_order_reference():

    print("\nTest 1: Invalid Order Reference")

    orders = pd.DataFrame({
        "order_id": ["O001"]
    })

    order_items = pd.DataFrame({
        "item_id": ["I001"],
        "order_id": ["O999"],
        "product_id": ["P001"],
        "quantity": [2],
        "unit_price": [500],
        "discount_percent": [10]
    })

    valid_items, invalid_items = validate_order_items(
        order_items,
        orders
    )

    if len(valid_items) == 0 and len(invalid_items) == 1:
        print("PASS")
    else:
        print("FAIL")

def test_invalid_discount():

    print("\nTest 2: Discount Greater Than 100")

    orders = pd.DataFrame({
        "order_id": ["O001"]
    })

    order_items = pd.DataFrame({
        "item_id": ["I001"],
        "order_id": ["O001"],
        "product_id": ["P001"],
        "quantity": [2],
        "unit_price": [500],
        "discount_percent": [120]
    })

    valid_items, invalid_items = validate_order_items(
        order_items,
        orders
    )

    if len(valid_items) == 0 and len(invalid_items) == 1:
        print("PASS")
    else:
        print("FAIL")

def test_zero_quantity():

    print("\nTest 3: Zero Quantity")

    orders = pd.DataFrame({
        "order_id": ["O001"]
    })

    order_items = pd.DataFrame({
        "item_id": ["I001"],
        "order_id": ["O001"],
        "product_id": ["P001"],
        "quantity": [0],
        "unit_price": [500],
        "discount_percent": [10]
    })

    valid_items, invalid_items = validate_order_items(
        order_items,
        orders
    )

    if len(valid_items) == 1 and len(invalid_items) == 0:
        print("PASS")
    else:
        print("FAIL")

def test_future_order_date():

    print("\nTest 4: Future Order Date")

    orders = pd.DataFrame({

        "order_id": ["O001"],

        "customer_id": ["C001"],

        "order_date": ["2099-12-31"],

        "status": ["DELIVERED"],

        "region_code": ["NORTH"]

    })

    cleaned_orders = clean_orders(orders)

    if pd.to_datetime(
        cleaned_orders.loc[0, "order_date"]
    ) > pd.Timestamp.today():

        print("PASS")

    else:

        print("FAIL")

def main():

    print("=" * 50)
    print("Running Edge Case Tests")
    print("=" * 50)

    test_invalid_order_reference()
    test_invalid_discount()
    test_zero_quantity()
    test_future_order_date()


if __name__ == "__main__":
    main()