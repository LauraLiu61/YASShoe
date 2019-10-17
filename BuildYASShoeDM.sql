/*
YASShoe Datamart developed by Yao Liu
Date Created: Feb 2 2018
Fact Table concerning Sales with following dimensions:
Date, Employee, Product, and Store
*/
-- Create Data Mart YASShoeDM
--
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'YASShoeDM')
	CREATE DATABASE YASShoeDM
GO
USE YASShoeDM

-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactSales'
       )
	DROP TABLE FactSales;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimEmployee'
       )
	DROP TABLE DimEmployee;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProduct'
       )
	DROP TABLE DimProduct;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimStore'
       )
	DROP TABLE DimStore;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;

--
-- Create tables
--Automatically populate Employee_SK beginning with 1001 and incrementing by one?
CREATE TABLE DimEmployee
	(Employee_SK   INT IDENTITY (1,1) CONSTRAINT pk_employee PRIMARY KEY,
    Employee_AK    INT          NOT NULL CONSTRAINT ak_employee UNIQUE,
	FirstName      NVARCHAR(50) NOT NULL,
	LastName       NVARCHAR(50) NOT NULL,
	Gender         NVARCHAR(1)  NOT NULL,
	HireDate       DATE         NOT NULL,
	StartDate      DATETIME     NOT NULL,
	EndDate        DATETIME     NULL      
	);
--
--Automatically populate Product_SK beginning with 1 and incrementing by one.
CREATE TABLE DimProduct
	(Product_SK INT IDENTITY (1,1) CONSTRAINT pk_product_sk PRIMARY KEY,
	Product_AK  INT           NOT NULL CONSTRAINT ak_Product UNIQUE,
	Name        NVARCHAR(50)  NOT NULL,
	Brand	    NVARCHAR(20)  NOT NULL,
	Category	NVARCHAR(20)  NOT NULL,
	Size        DECIMAL(3,1)  NOT NULL
       );
--
--Automatically populate Store_SK beginning with 101 and incrementing by one.
CREATE TABLE DimStore
	(Store_SK INT IDENTITY (1,1) CONSTRAINT pk_store_sk PRIMARY KEY,
	Store_AK    INT           NOT NULL CONSTRAINT ak_Store UNIQUE,
	City        NVARCHAR(50)  NOT NULL,
	State	    NVARCHAR(50)  NOT NULL,
	Zipcode  	NVARCHAR(10)  NOT NULL,
	Region      VARCHAR(12)   NOT NULL
       );
--
CREATE TABLE DimDate
	(	
	Date_SK INT PRIMARY KEY, 
	Date DATE,
	FullDate CHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth INT, -- Field will hold day number of Month
	DayName VARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear INT,
	DayOfQuarter INT,
	DayOfYear INT,
	WeekOfMonth INT,-- Week Number of Month 
	WeekOfQuarter INT, -- Week Number of the Quarter
	WeekOfYear INT,-- Week Number of the Year
	Month INT, -- Number of the Month 1 to 12{}
	MonthName VARCHAR(9),-- January, February etc
	MonthOfQuarter INT,-- Month Number belongs to Quarter
	Quarter CHAR(2),
	QuarterName VARCHAR(9),-- First,Second..
	Year INT,-- Year value of Date stored in Row
	YearName CHAR(7), -- CY 2015,CY 2016
	MonthYear CHAR(10), -- Jan-2016,Feb-2016
	MMYYYY INT,
	FirstDayOfMonth DATE,
	LastDayOfMonth DATE,
	FirstDayOfQuarter DATE,
	LastDayOfQuarter DATE,
	FirstDayOfYear DATE,
	LastDayOfYear DATE,
	IsHoliday BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday BIT,-- 0=Week End ,1=Week Day
	Holiday VARCHAR(50),--Name of Holiday in US
	Season VARCHAR(10)--Name of Season
	);
--
CREATE TABLE FactSales
	(Employee_SK INT CONSTRAINT fk_dimemployee_employee FOREIGN KEY REFERENCES DimEmployee(Employee_SK),
	Product_SK  INT CONSTRAINT fk_dimproduct_product   FOREIGN KEY REFERENCES DimProduct(Product_SK),
	Store_SK INT CONSTRAINT fk_dimstore_store FOREIGN KEY REFERENCES DimStore(Store_SK),
	Date_SK INT CONSTRAINT fk_dimconsumer_consumer FOREIGN KEY REFERENCES DimDate(Date_SK),
--SaleID_DD   Degenerated Dimension   Not for Measuring 
	SaleID_DD       INT          NOT NULL,
	Quantity_Sold   DECIMAL(5,2) NOT NULL,
	UnitPrice       NUMERIC(6,2) NOT NULL,
	Discount        NUMERIC(4,4),
	CONSTRAINT pk_factsales PRIMARY KEY CLUSTERED (Employee_SK, Product_SK, Store_SK, Date_SK, SaleID_DD)
	);
