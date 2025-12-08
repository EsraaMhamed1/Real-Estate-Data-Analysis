CREATE TABLE Dim_Agents (
    Agent_sk INT IDENTITY(1,1) PRIMARY KEY,
    Agent_id INT,
    Agent_Name NVARCHAR(50),
    Email NVARCHAR(50),
    Phone NVARCHAR(50),
    Office_name nvarchar(50),
    Hire_Date DATE,
    Status NVARCHAR(50),
    Source_System_Code   TINYINT NOT NULL,
    Start_Date        DATETIME, 
    End_Date          DATETIME,
    Is_Current       TINYINT NOT NULL
);

CREATE TABLE Dim_lead (
    lead_sk INT IDENTITY(1,1) PRIMARY KEY,
    Lead_id INT,
    Name nvarchar(50),
    Email nvarchar(50),
    Phone nvarchar(50),
    source_name nvarchar(50),
    source_type  nvarchar(50),
    stage_name nvarchar(50),
    Source_System_Code   TINYINT NOT NULL,
    Start_Date        DATETIME, 
    End_Date          DATETIME,
    Is_Current       TINYINT NOT NULL
);


CREATE TABLE Dim_Property (
    Property_sk INT IDENTITY(1,1) PRIMARY KEY,
    Property_id INT,
    Property_Name NVARCHAR(50),
    Property_Type NVARCHAR(50),
    Source_Type NVARCHAR(50),
    Source_Name NVARCHAR(50),
    Size_Sqft float,
    Size_Sqm float,
    Bedrooms tinyint,
    maid_rooms int ,
    Bathrooms INT,
    Down_Payment float,
    Payment_Method NVARCHAR(50),
    Price int,
    Listed_Date DATE,
    Available_From DATE,
    Status NVARCHAR(50),
    Country NVARCHAR(50),
    Region NVARCHAR(50),
    City NVARCHAR(50),
	latitude float,
	longitude float,
    Sold_date date ,
    Source_System_Code   TINYINT NOT NULL,
    Start_Date        DATETIME, 
    End_Date          DATETIME,
    Is_Current       TINYINT NOT NULL
);

CREATE TABLE Dim_Campaigns (
    Campaign_sk INT IDENTITY(1,1) PRIMARY KEY,
    Campaign_id INT,
    Campaign_Name nvarchar(50),
    Start_Date DATE,
    End_Date DATE,
    Budget int ,
    Cost float,
    Impressions INT,
    Clicks smallINT,
    ROI float,
    Deals_Closed tinyINT,
    Leads_Generated smallint,
    Channel_name NVARCHAR(50),
    Status NVARCHAR(50),
    Source_System_Code   TINYINT NOT NULL,
    Start_Date_load        DATETIME, 
    End_Date_load          DATETIME,
    Is_Current       TINYINT NOT NULL
);

-- Fact 


CREATE TABLE Fact_Sales (
    Sale_ID INT IDENTITY(1,1) PRIMARY KEY,      -- مفتاح بديل (Surrogate Key) لكل عملية بيع
    Property_SK INT NOT NULL,                   -- مفتاح الربط مع Dim_Property
    Customer_SK INT NOT NULL,                   -- مفتاح الربط مع Dim_Customers
    Agent_SK INT NOT NULL,                      -- مفتاح الربط مع Dim_Agents
    Campaign_SK INT NULL,                       -- مفتاح الربط مع Dim_Campaign (لو في حملات تسويقية)
    Sale_Date_SK INT NOT NULL,                  -- مفتاح الربط مع Dim_Date (اليوم اللي حصلت فيه العملية)
    
    Sale_Price int NOT NULL,          -- سعر البيع
    Commission_Rate float NULL,          -- نسبة العمولة (%)
    Commission_Amount float NULL,       -- قيمة العمولة بالفلوس
    Revenue float NULL,                 -- الإيراد بعد خصم العمولة
    Days_to_Sell INT NULL,                      -- عدد الأيام اللي استغرقتها عملية البيع
    Sale_Count INT DEFAULT 1                    -- كل صف يمثل عملية بيع واحدة (تسهل التجميع)
);


CREATE TABLE Fact_Leads (
    Lead_ID INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key لكل صف في الفاكت
    Property_SK INT NULL,                     -- FK لربط العقار من Dim_Property
    Agent_SK INT NOT NULL,                    -- FK لربط الوكيل من Dim_Agents
    Campaign_SK INT NULL,                     -- FK لربط الحملة من Dim_Campaigns
    Lead_sk INT not NULL,                         -- Business Key من المصدر (Lead_ID الأصلي)
    Created_Date_SK INT NOT NULL,             -- FK لتاريخ الإنشاء من Dim_Date
    Lead_Count INT DEFAULT 1,                 -- كل صف = lead واحد
    Converted_Flag BIT,                       -- 1 لو lead اتحول sale، 0 لو لا
   
);                                              -- وحسبى الله ونعم الوكيل












