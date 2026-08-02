import csv
import random
import os
from datetime import datetime, timedelta
from faker import Faker

# Initial Setup

fake = Faker("en_IN")
Faker.seed(42)
random.seed(42)

# Output Folder

OUTPUT_FOLDER = "data/raw"
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Dataset Size

NUM_CUSTOMERS = 600
NUM_PRODUCTS = 550

MIN_ITEMS = 1
MAX_ITEMS = 5

# Dirty Data Percentage
DIRTY = {
    "null_customer": 0.05,
    "invalid_email": 0.02,
    "wrong_date": 0.03,
    "bad_product_name": 0.08,
    "negative_qty": 0.03,
    "zero_qty": 0.01,
    "future_date": 0.01,
    "discount_gt100": 0.01,
    "invalid_order": 0.01,
    "invalid_product": 0.005
}

# Date Range
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2026, 7, 31)

# Regions and weights (Skewed)
REGIONS = ["NORTH", "WEST", "SOUTH", "EAST", "CENTRAL"]
REGION_WEIGHTS = [38, 25, 18, 12, 7]

# Order Status and weights
STATUS = ["PLACED","SHIPPED","DELIVERED","RETURNED","CANCELLED"]
STATUS_WEIGHTS = [10, 15, 62, 8, 5]

# Customer Type amd Weights
CUSTOMER_TYPES = ["REGULAR", "PREMIUM", "VIP"]
CUSTOMER_WEIGHTS = [70, 20, 10]

CATEGORY_PRODUCTS = {

    "Electronics": [
        "Samsung Galaxy S24","iPhone 15","Dell Inspiron",
        "HP Pavilion","MacBook Air","Sony Headphones",
        "Boat Speaker","Canon Camera","OnePlus Nord",
        "Realme Pad","Smart Watch","Wireless Mouse",
        "Mechanical Keyboard","Monitor","Printer"
    ],

    "Clothing": [
        "Nike Shoes","Adidas Shoes","Levis Jeans",
        "Puma T-Shirt","Formal Shirt",
        "Casual Shirt","Hoodie","Jacket",
        "Track Pants","Kurta"
    ],

    "Books": [
        "Atomic Habits","Deep Work","Clean Code",
        "Python Crash Course","Rich Dad Poor Dad",
        "The Alchemist","The Psychology of Money",
        "Think and Grow Rich","Ikigai",
        "Data Engineering Handbook"
    ],

    "Home": [
        "Dining Table","Sofa","Pressure Cooker",
        "Mixer Grinder","Office Chair",
        "Water Bottle","Wall Clock",
        "LED Lamp","Curtains","Bed Sheet"
    ],

    "Sports": [
        "Cricket Bat","Football",
        "Gym Gloves","Skipping Rope",
        "Yoga Mat","Badminton Racket",
        "Helmet","Tennis Ball"
    ],

    "Beauty": [
        "Face Wash","Lipstick",
        "Moisturizer","Perfume",
        "Shampoo","Conditioner",
        "Hair Serum"
    ],

    "Grocery": [
        "Rice","Milk","Coffee","Tea","Sugar",
        "Cooking Oil","Chocolate",
        "Biscuits","Juice","Pasta"
    ]
}

SUBCATEGORIES = {

    "Electronics": [
        "Smartphones", "Laptops", "Tablets", "Audio",
        "Accessories", "Cameras", "Printers"
    ],

    "Clothing": [
        "Men", "Women", "Kids", "Footwear",
        "Winter Wear", "Sportswear"
    ],

    "Books": [
        "Programming", "Finance", "Fiction",
        "Self Help", "Education", "Biography"
    ],

    "Home": [
        "Furniture", "Kitchen", "Decor", "Lighting", "Storage"
    ],

    "Sports": [
        "Cricket", "Football", "Gym", "Cycling", "Outdoor"
    ],

    "Beauty": [
        "Skincare", "Haircare", "Makeup", "Fragrance"
    ],

    "Grocery": [
        "Beverages", "Snacks", "Staples", "Dairy", "Personal Care"
    ]
}

VARIANTS = [
    "64GB", "128GB","256GB","512GB", "Black","White","Blue",
    "Red", "Pro", "Plus", "Max","XL", "2025 Edition","2026 Edition"
]

CATEGORY_COUNT = {
    "Electronics": 160,
    "Clothing": 130,
    "Grocery": 80,
    "Home": 70,
    "Books": 45,
    "Sports": 40,
    "Beauty": 25
}

PRICE_RANGE = {
    "Electronics": (800, 120000),
    "Clothing": (200, 6000),
    "Books": (100, 1500),
    "Home": (300, 30000),
    "Sports": (250, 20000),
    "Beauty": (100, 5000),
    "Grocery": (20, 1200)
}


# helper functions
def random_date(start=START_DATE, end=END_DATE):
    delta = end - start
    return start + timedelta(
        seconds=random.randint(
            0,
            int(delta.total_seconds())
        )
    )

def dirty_name(name):

    return random.choice([
        lambda x: " " + x,
        lambda x: x + " ",
        lambda x: x.upper(),
        lambda x: x.lower(),
        lambda x: x.title()
    ])(name)

def invalid_email(email):

    return random.choice([
        lambda e: e.replace("@", ""),
        lambda e: e.split("@")[0] + "@",
        lambda e: e.replace(".com", ""),
        lambda e: e.replace("@", "#")
    ])(email)

def save_csv(filename, header, rows):
    path = os.path.join(OUTPUT_FOLDER, filename)

    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)

# Return expected number of orders based on customer profile
def get_order_count(profile):

    if profile == "POWER":
        return random.randint(40, 70)

    elif profile == "FREQUENT":
        return random.randint(15, 35)

    elif profile == "NORMAL":
        return random.randint(5, 12)

    else:
        return random.randint(1, 4)

# Festival season has more orders
def generate_order_date():

    # 35% chance of festival months
    if random.random() < 0.35:
        year = random.choice([2024, 2025])
        month = random.choice([10, 11, 12])
        day = random.randint(1, 28)

        dt = datetime(
            year,
            month,
            day,
            random.randint(0, 23),
            random.randint(0, 59),
            random.randint(0, 59)
        )

    else:
        dt = random_date()

    # Future date
    if random.random() < DIRTY["future_date"]:
        dt = END_DATE + timedelta(
            days=random.randint(30, 180)
        )

    return dt

def get_unit_price(cost_price):

    if cost_price == "":
        cost = random.randint(100, 5000)
    else:
        cost = float(cost_price)

    markup = random.uniform(1.15, 2.20)
    return round(cost * markup, 2)


# Generate Customers
def generate_customers():
    customers = []
    # Used to intentionally create duplicate emails
    email_pool = []
    # Hidden profile used while generating orders
    customer_profiles = {}

    for i in range(1, NUM_CUSTOMERS + 1):
        customer_id = f"C{i:05d}"
        name = fake.name()
        email = fake.email().lower()
        registration_date = random_date()

        customer_type = random.choices(
            CUSTOMER_TYPES,
            weights=CUSTOMER_WEIGHTS,
            k=1
        )[0]

        # Hidden buying behaviour (NOT saved in CSV)
        profile = random.choices(
            ["POWER", "FREQUENT", "NORMAL", "OCCASIONAL"],
            weights=[5, 15, 30, 50],
            k=1
        )[0]

        customer_profiles[customer_id] = profile

        # Dirty Customer Names
        chance = random.random()

        if chance < 0.02:
            name = name.upper()

        elif chance < 0.04:
            name = name.lower()

        elif chance < 0.06:
            name = "   " + name

        elif chance < 0.08:
            name = name + "   "

        elif chance < 0.09:
            name = ""

        # Invalid Emails (2%)
        if random.random() < DIRTY["invalid_email"]:
            email = invalid_email(email)

        # Duplicate Emails (1%)
        if email_pool and random.random() < 0.01:
            email = random.choice(email_pool)

        email_pool.append(email)

        # Mixed Registration Date Formats
        if random.random() < DIRTY["wrong_date"]:
            registration_date = registration_date.strftime(
                "%d-%m-%Y"
            )

        else:
            registration_date = registration_date.strftime(
                "%Y-%m-%d"
            )

        customers.append([
            customer_id,
            name,
            email,
            registration_date,
            customer_type
        ])

    return customers, customer_profiles

# Generate Products
def generate_products():
    products = []

    # Hidden product popularity
    # Used later while generating order_items
    product_popularity = {}

    product_id = 1

    for category, total_products in CATEGORY_COUNT.items():
        product_list = CATEGORY_PRODUCTS[category]

        for _ in range(total_products):
            pid = f"P{product_id:05d}"
            base_name = random.choice(product_list)

            # Around 70% of products get a variant
            if random.random() < 0.70:
                product_name = f"{base_name} {random.choice(VARIANTS)}"
            else:
                product_name = base_name

            # Dirty Product Names
            if random.random() < DIRTY["bad_product_name"]:
                product_name = dirty_name(product_name)

            # Subcategory
            subcategory = random.choice(SUBCATEGORIES[category])

            # Cost Price
            low, high = PRICE_RANGE[category]

            cost_price = round(
                random.uniform(low, high),
                2
            )

            # Missing Cost Price
            if random.random() < 0.01:
                cost_price = ""

            # Store numeric as string
            elif random.random() < 0.02:
                cost_price = str(cost_price)

            # Hidden Popularity

            popularity = random.choices(
                ["BEST", "MEDIUM", "LOW", "NEVER"],
                weights=[10, 25, 60, 5],
                k=1
            )[0]

            product_popularity[pid] = popularity
            products.append([pid, product_name, category, subcategory, cost_price])
            product_id += 1

    return products, product_popularity

# Generate Orders
def generate_orders(customer_profiles):
    orders = []
    order_id = 1
    customer_ids = list(customer_profiles.keys())

    for customer_id in customer_ids:
        profile = customer_profiles[customer_id]
        total_orders = get_order_count(profile)

        for _ in range(total_orders):

            dt = generate_order_date()
            # Wrong date format
            if random.random() < DIRTY["wrong_date"]:
                order_date = dt.strftime(
                    "%d-%m-%Y %H:%M:%S"
                )
            else:
                order_date = dt.strftime(
                    "%Y-%m-%d %H:%M:%S"
                )

            # Missing Customer IDs
            cust = customer_id
            chance = random.random()

            if chance < DIRTY["null_customer"] / 2:
                cust = ""

            elif chance < DIRTY["null_customer"]:
                cust = "NULL"

            status = random.choices(
                STATUS,
                weights=STATUS_WEIGHTS,
                k=1
            )[0]

            # Small percentage mixed case
            if random.random() < 0.02:
                status = random.choice([
                    status.lower(),
                    status.title()
                ])

            region = random.choices(
                REGIONS,
                weights=REGION_WEIGHTS,
                k=1
            )[0]

            # Dirty Region
            if random.random() < 0.02:
                region = random.choice([
                    region.lower(),
                    region.title(),
                    region[:3]
                ])

            orders.append([
                f"O{order_id:06d}",
                cust,
                order_date,
                status,
                region
            ])
            order_id += 1
    return orders
# Generate Order Items

def generate_order_items(orders,products,product_popularity):

    order_items=[]
    item_id=1

    product_lookup={}

    for product in products:
        product_lookup[product[0]]={
            "cost":product[4],
            "category":product[2]
        }

    best_products=[pid for pid,p in product_popularity.items() if p=="BEST"]
    medium_products=[pid for pid,p in product_popularity.items() if p=="MEDIUM"]
    low_products=[pid for pid,p in product_popularity.items() if p=="LOW"]
    never_products=[pid for pid,p in product_popularity.items() if p=="NEVER"]

    for order in orders:

        order_id=order[0]
        status=str(order[3]).upper()

        total_items=random.randint(MIN_ITEMS,MAX_ITEMS)

        for _ in range(total_items):

            group=random.choices(
                ["BEST","MEDIUM","LOW"],
                weights=[60,30,10],
                k=1
            )[0]

            if group=="BEST":
                product_id=random.choice(best_products)
            elif group=="MEDIUM":
                product_id=random.choice(medium_products)
            else:
                product_id=random.choice(low_products)

            quantity=random.randint(1,5)

            if random.random()<DIRTY["negative_qty"]:
                quantity*=-1

            if random.random()<DIRTY["zero_qty"]:
                quantity=0

            discount=random.choice([0,5,10,15,20,30,40,50,70])

            if random.random()<DIRTY["discount_gt100"]:
                discount=random.randint(101,150)

            unit_price=get_unit_price(
                product_lookup[product_id]["cost"]
            )

            fake_order_id=order_id

            if random.random()<DIRTY["invalid_order"]:
                fake_order_id=f"O{random.randint(900000,999999)}"

            order_items.append([
                f"I{item_id:07d}",
                fake_order_id,
                product_id,
                quantity,
                unit_price,
                discount
            ])

            item_id+=1

    return order_items

# main function
def main():

    # Generate datasets
    customers, customer_profiles = generate_customers()
    products, product_popularity = generate_products()
    orders = generate_orders(customer_profiles)
    order_items = generate_order_items(
        orders,
        products,
        product_popularity
    )

    # Save customers
    save_csv(
        "customers.csv",
        ["customer_id", "customer_name", "email", "registration_date", "customer_type"],
        customers
    )

    # Save products
    save_csv(
        "products.csv",
        ["product_id", "product_name", "category", "subcategory", "cost_price"],
        products
    )

    # Save orders
    save_csv(
        "orders.csv",
        ["order_id", "customer_id", "order_date", "status", "region_code"],
        orders
    )

    # Save order items
    save_csv(
        "order_items.csv",
        ["item_id", "order_id", "product_id", "quantity", "unit_price", "discount_percent"],
        order_items
    )

    # Summary
    print("\nData Generation Completed Successfully!")
    print("-" * 40)
    print(f"Customers   : {len(customers)}")
    print(f"Products    : {len(products)}")
    print(f"Orders      : {len(orders)}")
    print(f"Order Items : {len(order_items)}")

if __name__ == "__main__":
    main()
    