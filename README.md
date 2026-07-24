# IDP-Project | Intelligent Document Processing | Data Bricks

## Overview
This project is an **Intelligent Document Processing (IDP)** solution built in **Databricks SQL**. It automatically reads, classifies, and extracts key information from PDF documents (Invoices, Purchase Orders, and Receipts) using Databricks AI functions.

## What This Project Does

The pipeline performs the following steps:

1. **Reads PDF files** from a Volume in Databricks (`/Volumes/finalidp/default/final_idp`)
2. **Parses documents** using `ai_parse_document()`
3. **Cleans and prepares** the extracted text
4. **Classifies** each document into one of these categories:
   - Invoice
   - Purchase Order  
   - Receipt
   - Other
5. **Extracts important fields** from each document type using AI
6. **Stores** the structured data into clean Delta tables in the `finalidp.finance` schema

## Extracted Data

### Invoices
- Vendor Name
- Invoice Number
- Invoice Date
- Due Date
- Payment Method
- Total Amount

### Purchase Orders
- Merchant Name
- PO Number
- Purchase Order Date
- Total

### Receipts
- Merchant Name
- Receipt Number
- Transaction Date
- Items
- Amount
- Total

## Project Structure
``` 
IDP-Project/
├── README.md
├── Final project.sql          ← Main SQL notebook
├── documents/                 ← Store sample PDFs here
```

## How to Use

1. Upload your PDF documents to the Volume:  
   `/Volumes/finalidp/default/final_idp`

2. Run the SQL notebook in **Databricks SQL Warehouse**

3. All processed data will be available in:
   - `finalidp.finance.invoices`
   - `finalidp.finance.purchase_orders`
   - `finalidp.finance.receipts`

## Technologies Used

- Databricks SQL
- Delta Lake
- AI Functions (`ai_parse_document`, `ai_classify`, `ai_extract`)
- Volumes for document storage



