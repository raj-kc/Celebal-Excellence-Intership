# Data Cleaning Report

## Dataset Summary

| Dataset | Rows |
|----------|-----:|
| Customers | 601 |
| Products | 550 |
| Orders | 6075 |
| Order Items | 17920 |

## Orders

- Duplicate Orders Removed : 0
- NULL Customer IDs Fixed : 302
- Invalid Dates Fixed : 0
- Future Dates Found : 62

## Products

- Dirty Product Names Cleaned : 184
- Missing Cost Prices Fixed : 3
- Duplicate Products Removed : 0

## Customers

- Missing Customer Names Fixed : 7
- Dirty Customer Names Cleaned : 30
- Invalid Registration Dates : 0
- Duplicate Customers Removed : 0
- Duplicate Emails Found : 3
- Invalid Emails Found : 14

## Order Items

- Duplicate Items Removed : 0
- Negative Quantity Rows Removed : 548
- Zero Quantity Found : 200
- Discount > 100 Found : 181
- Invalid Order References : 194

## Validation Summary

| Validation | Status |
|------------|--------|
| Email Validation | ⚠️ 14 Invalid Emails |
| Referential Integrity | ⚠️ 194 Invalid References |

---
Report generated automatically by clean_data.py
