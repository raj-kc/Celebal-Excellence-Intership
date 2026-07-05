# Azure Cloud Fundamentals and Data Pipeline Implementation using Azure Data Factory

## Student Information

- **Name:** Raj Chaudhary
- **Assignment:** Azure Cloud Fundamentals and Data Pipeline Implementation using ADF
- **Technology:** Microsoft Azure
- **Services Used:**
  - Azure Resource Group
  - Azure Storage Account
  - Azure Blob Storage
  - Azure Data Factory (ADF)
  - Azure IAM (Access Control)

---

# Objective

To understand Azure cloud concepts and build a complete data pipeline using Azure Storage Account and Azure Data Factory (ADF). The pipeline reads a CSV file from Blob Storage, validates its metadata, and copies it to another Blob Storage location.

---

# Project Architecture

```
Azure Resource Group
        │
        ▼
Azure Storage Account
        │
 ┌───────────────┐
 │               │
 ▼               ▼
Input         Output
Container      Container
 │
 ▼
Superstore.csv
 │
 ▼
Azure Data Factory
 │
 ├── Linked Service
 ├── Source Dataset
 ├── Destination Dataset
 ├── Get Metadata Activity
 └── Copy Data Activity
 │
 ▼
Superstore_Copy.csv
```

---

# Tasks Completed

## Task 1 – Resource Group

- Created an Azure Resource Group.

**Screenshot**
- 01_RG.png

---

## Task 2 – Storage Setup

- Created an Azure Storage Account.
- Created Blob Containers.
- Uploaded the source CSV file.

**Screenshot**
- 02_Blob.png

---

## Task 3 – Azure Data Factory Basics

- Created Azure Data Factory.
- Configured Azure Blob Storage Linked Service.
- Created Source Dataset.
- Created Destination Dataset.
- Configured Get Metadata Activity.

**Screenshots**
- 03_LinkedService.png
- 04_SourceDataset.png
- 05_DestDataset.png
- 06_GetMetadata.png

---

## Task 4 – Pipeline Development

Created a pipeline consisting of:

- Get Metadata Activity
- Copy Data Activity

**Screenshot**
- 07_Pipeline.png

---

## Task 5 – Pipeline Execution

- Executed the pipeline successfully.
- Verified successful data copy.

**Screenshots**
- 08_PipelineRun.png
- 10_Output.png

---

## Task 6 – IAM Role Assignment

Assigned the required Azure roles:

- Reader
- Contributor
- Storage Blob Data Contributor

**Screenshot**
- 09_IAM.png

---

# Mini Project

## Problem Statement

Build a complete Azure Data Factory pipeline that reads a CSV file from Azure Blob Storage, validates the file metadata, and copies it to a new Blob Storage location.

## Source

- Azure Blob Storage
- File: Superstore.csv

## Process

- Get Metadata
- Copy Data

## Destination

- Azure Blob Storage
- File: Superstore_Copy.csv

---

# Expected Output

- Source CSV file successfully read from Blob Storage.
- Metadata validated using Get Metadata.
- CSV copied successfully to the Output container.
- Pipeline executed successfully.
- Output file generated in Blob Storage.

---

# Technologies Used

- Microsoft Azure Portal
- Azure Resource Group
- Azure Storage Account
- Azure Blob Storage
- Azure Data Factory
- Azure IAM

---

# Project Status

**Completed Successfully**

``Pipeline Execution Status: Succeeded``

---

# Folder Structure

# Folder Structure

```
Azure_ADF_Assignment/
│
├── README.md
│── Superstore.csv
│── Superstore_Copy.csv
│
└── screenshots/
    ├── 01_RG.png
    ├── 02_StorageAccount.png
    ├── 03_Blob.png
    ├── 04_LinkedService.png
    ├── 05_SourceDataset.png
    ├── 06_DestDataset.png
    ├── 07_GetMetadata.png
    ├── 08_Pipeline.png
    ├── 09_PipelineRun.png
    ├── 10_IAM.png
    └── 11_Output.png
```
---

# Conclusion

This project demonstrates the implementation of a complete Azure Data Factory pipeline using Azure Blob Storage. The solution successfully validates file metadata, copies data between Blob containers, and applies appropriate IAM role assignments, providing a practical understanding of Azure cloud services and data integration workflows.