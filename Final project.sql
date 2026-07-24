-- Databricks notebook source
Select * From read_files('/Volumes/finalidp/default/final_idp')

-- COMMAND ----------

create or replace table Parsed_data As 
select path,
ai_parse_document(content) as parsed_content
From read_files('/Volumes/finalidp/default/final_idp')

-- COMMAND ----------

select * from Parsed_data

-- COMMAND ----------

create or replace table pretty_data as
select path,
   concat_ws('\n',
      transform(try_cast(parsed_content:document:elements as array<variant>),
      e -> coalesce(try_cast(e:content as string), ''))
    ) as doc_text
from parsed_data

-- COMMAND ----------

create or  replace table classsified_data as
select  *, 
ai_classify(doc_text, array('Invoice','Purchase Order','Receipt','other')) as doc_classification
from pretty_data

-- COMMAND ----------

Create or replace table invoice_data as
select  *,
ai_extract(doc_text, 
    Array('Vendor_Name', 'Invoice_Number', 'Invoice_Date', 'Due_date','Payment_method','Total')) as extracted

from classsified_data
where doc_classification = 'Invoice'

-- COMMAND ----------

create schema if not exists finalidp.finacne


-- COMMAND ----------

create or replace table finalidp.finacne.invoices as
select path,
extracted.Vendor_Name as Vendor,    
extracted.Invoice_Number as invoice ,
extracted.Invoice_Date as invoice_date,
extracted.Due_date as  Due_date,
extracted.Payment_method as Payment_method,
extracted.Total as Total 
from invoice_data

-- COMMAND ----------

select * from  finalidp.finacne.invoices

-- COMMAND ----------

Create or replace table Purchase_order_data as
select  *,
ai_extract(doc_text, 
    Array('Merchant_Name','PO_number', 'Purchase_Order_date','Total')) as extracted

from classsified_data
where doc_classification = 'Purchase Order'

-- COMMAND ----------

Create or replace table finalidp.finacne.Purchase_orders as
select path,
extracted.Merchant_Name as Merchant,
extracted.PO_number as PO_number,
extracted.Purchase_Order_date as Purchase_Order_date,
extracted.Total as Total 
from Purchase_order_data

-- COMMAND ----------

create or replace table receipt_data as
select *,
ai_extract(doc_text, 
    Array('Merchant_Name','receipt_number','transaction_date','Item', 'Amount','total')) as extracted
 from classsified_data
 where doc_classification = 'Receipt'

-- COMMAND ----------

create or replace table finalidp.finacne.receipts as
select path,
extracted.Merchant_Name as Merchant,
extracted.receipt_number as receipt_number,
extracted.transaction_date as transaction_date,
extracted.Item as Item,
extracted.Amount as Amount,
extracted.total as total

from receipt_data