CREATE DATABASE Ecommerce_App;
USE Ecommerce_App;

-- 1. User Roles Table
CREATE TABLE User_roles (
    ID INT PRIMARY KEY IDENTITY(1,1), 
    Role_name VARCHAR(50) NOT NULL UNIQUE,
    Created_at DATETIME2 DEFAULT GETDATE(),
    Updated_at DATETIME2 NULL
);

-- 2. Users Table
CREATE TABLE Users (
    ID INT PRIMARY KEY IDENTITY(1,1),
    First_name VARCHAR(50) NOT NULL,
    Last_name VARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password_hash VARCHAR(255) NOT NULL,
    Phone_number VARCHAR(20) NULL UNIQUE,
    Status VARCHAR(20) DEFAULT 'Active' NOT NULL,
    User_role_ID INT,
    Created_at DATETIME2 DEFAULT GETDATE(),
    Updated_at DATETIME2 NULL,
    FOREIGN KEY (User_role_ID) REFERENCES User_roles(ID)
);

-- 3. Categories Table
CREATE TABLE Categories(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Category_name VARCHAR(50) NOT NULL UNIQUE,
    Parent_cat_id INT NULL,
    Status VARCHAR(20) DEFAULT 'Active' NOT NULL,
    Created_at DATETIME2 DEFAULT GETDATE(),
    Updated_at DATETIME2 NULL,
    FOREIGN KEY (Parent_cat_id) REFERENCES Categories(ID)
);

-- 4. Products Table
CREATE TABLE Products(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Product_name VARCHAR(255) NOT NULL UNIQUE,
    Cat_ID INT NOT NULL,
    Description VARCHAR(255) NULL, 
    Status VARCHAR(20) DEFAULT 'Active' NOT NULL,
    Created_at DATETIME2 DEFAULT GETDATE(),
    Updated_at DATETIME2 NULL,
    FOREIGN KEY (Cat_ID) REFERENCES Categories(ID)
);

-- 5. Product Variants Table
CREATE TABLE Product_variants(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Product_ID INT NOT NULL,
    Color VARCHAR(50) NULL,
    Size VARCHAR(20) NULL,
    Original_Price DECIMAL(10, 2) NOT NULL,
    Sale_Price DECIMAL(10, 2) NULL,
    Stock_quantity INT NOT NULL DEFAULT 0,
    Created_at DATETIME2 DEFAULT GETDATE(),
    Updated_at DATETIME2 NULL,
    FOREIGN KEY (Product_ID) REFERENCES Products(ID),
    UNIQUE (Product_ID, Color, Size)
);

-- 6. Addresses Table
CREATE TABLE Addresses(
    ID INT PRIMARY KEY IDENTITY(1,1),
    User_Id INT NOT NULL,
    Address_Line_1 VARCHAR(255) NOT NULL, 
    Address_Line_2 VARCHAR(255) NULL,  
    City VARCHAR(100) NOT NULL,
    Postal_Code VARCHAR(20) NOT NULL, 
    Country VARCHAR(100) NOT NULL,
    Address_Label VARCHAR(50) NULL,
    FOREIGN KEY (User_Id) REFERENCES Users(ID)
);

-- 7. Cart Items Table
CREATE TABLE Cart_items(
    ID INT PRIMARY KEY IDENTITY(1,1),
    User_Id INT NOT NULL,
    Product_variant_Id INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    Created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (User_Id) REFERENCES Users(ID),
    FOREIGN KEY (Product_variant_Id) REFERENCES Product_variants(ID),
    UNIQUE (User_Id, Product_variant_Id)
);

-- 8. Orders Table
CREATE TABLE Orders(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Order_Number VARCHAR(50) UNIQUE NOT NULL,
    User_Id INT NOT NULL,
    Shipping_Amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    Shipping_Address_Id INT NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Placed',
    Payment_Method VARCHAR(50) NULL,
    Payment_Status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    Created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    Updated_at DATETIME2 NULL,
    Shipped_at DATETIME2 NULL,
    Delivered_at DATETIME2 NULL,
    FOREIGN KEY (User_Id) REFERENCES Users(ID),
    FOREIGN KEY (Shipping_Address_Id) REFERENCES Addresses(ID)
);

-- 9. Order Items Table
CREATE TABLE Order_Items(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Order_Id INT NOT NULL,
    Product_variant_Id INT NOT NULL,
    Quantity INT NOT NULL,
    Original_Price_Per_Unit DECIMAL(10, 2) NOT NULL,
    Discount_Per_Unit DECIMAL(10, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (Order_Id) REFERENCES Orders(ID),
    FOREIGN KEY (Product_variant_Id) REFERENCES Product_variants(ID),
    UNIQUE (Order_ID, Product_variant_ID) --composite unique key
);

Insert Queries:
-- 1. User Roles Table
Code:
INSERT INTO User_roles(Role_name)
VALUES
    ('Admin'),
    ('Customer'),
    ('Seller'),
    ('Guest');
-- 2. Users Table
Code:

INSERT INTO Users (First_name, Last_name, Email, Password_hash, Phone_number, Status, User_role_ID)
VALUES
    -- User 1: An Administrator (Role ID = 1)
    ('Ali', 'Khan', 'ali.khan@example.com', 'hashed_password_admin_123', '03001234567', 'Active', 1),
    
    -- User 2: A regular Customer (Role ID = 2)
    ('Sana', 'Butt', 'sana.b@example.com', 'hashed_password_customer_456', '03217654321', 'Active', 2),
    
    -- User 3: Another Customer with no phone number (Role ID = 2)
    ('Bilal', 'Ahmed', 'bilal.ahmed@example.com', 'hashed_password_customer_789', NULL, 'Active', 2),
    
    -- User 4: An Inactive/Suspended Customer (Role ID = 2)
    ('Fatima', 'Raza', 'fatima.r@example.com', 'hashed_password_customer_101', '03338889990', 'Inactive', 2),

    -- User 5: A Seller (Role ID = 3)
    ('Usman', 'Malik', 'usman.seller@example.com', 'hashed_password_seller_112', '03451122334', 'Active', 3);
-- 3. Categories Table
Code:
INSERT INTO Categories (Category_name, Parent_cat_id, Status)
VALUES
    -- Top-Level Categories (Parent_cat_id is NULL)
    ('Electronics', NULL, 'Active'),          -- Will get ID: 1
    ('Fashion', NULL, 'Active'),                  -- Will get ID: 2
    ('Home & Kitchen', NULL, 'Active'),      -- Will get ID: 3
    ('Books', NULL, 'Inactive'),                    -- Will get ID: 4 (Example of an inactive category)

    -- Sub-categories of Electronics (Parent_cat_id = 1)
    ('Mobile Phones', 1, 'Active'),         -- Will get ID: 5
    ('Laptops', 1, 'Active'),                     -- Will get ID: 6
    
    -- Sub-categories of Fashion (Parent_cat_id = 2)
    ('Men''s Fashion', 2, 'Active'),          -- Will get ID: 7 
    ('Women''s Fashion', 2, 'Active'),      -- Will get ID: 8

    -- A sub-sub-category: T-Shirts under Men's Fashion (Parent ID = 7)
    ('T-Shirts', 7, 'Active');                  -- Will get ID: 9


-- 4. Products Table
Code:
INSERT INTO Products (Product_name, Cat_ID, Description, Status)
VALUES
    -- Products in 'Mobile Phones' Category (Cat_ID = 5)
    ('iPhone 15 Pro', 5, 'The latest flagship phone with the A17 Bionic chip.', 'Active'),
    ('Samsung Galaxy S24 Ultra', 5, 'A powerful Android phone with a built-in S Pen and advanced camera.', 'Active'),

    -- Product in 'Laptops' Category (Cat_ID = 6)
    ('MacBook Pro 14-inch M3', 6, 'A professional laptop for creators and developers.', 'Active'),
    ('Dell XPS 15', 6, 'A high-performance Windows laptop with an OLED display.', 'Active'),

    -- Product in 'T-Shirts' Category (Cat_ID = 9)
    ('Classic Crew Neck T-Shirt', 9, 'A comfortable and stylish 100% cotton crew neck t-shirt.', 'Active'),

    -- An 'Inactive' or 'Discontinued' Product
    ('Google Pixel 6', 5, 'The 2021 flagship phone from Google.', 'Inactive');

-- 5. Product Variants Table
Code:
INSERT INTO Product_variants (Product_ID, Color, Size, Original_Price, Sale_Price, Stock_quantity)
VALUES
    -- Variants for iPhone 15 Pro (Product_ID = 1)
    (1, 'Natural Titanium', '256GB', 350000.00, 345000.00, 50), -- Item is on sale
    (1, 'Blue Titanium', '256GB', 350000.00, NULL, 75),       -- Item is not on sale
    (1, 'Natural Titanium', '512GB', 400000.00, NULL, 20),

    -- Variants for Samsung Galaxy S24 Ultra (Product_ID = 2)
    (2, 'Titanium Gray', '256GB', 330000.00, NULL, 60),
    (2, 'Titanium Black', '512GB', 380000.00, NULL, 15),

    -- 'Default' variant for MacBook Pro (Product_ID = 3) - No color/size specified
    (3, NULL, '16GB RAM, 512GB SSD', 550000.00, 540000.00, 10), -- Item is on sale

    -- 'Default' variant for Dell XPS 15 (Product_ID = 4)
    (4, 'Silver', '16GB RAM, 1TB SSD', 480000.00, NULL, 12),

    -- Variants for Classic Crew Neck T-Shirt (Product_ID = 5)
    (5, 'Black', 'M', 1500.00, NULL, 200),
    (5, 'White', 'M', 1500.00, NULL, 250),
    (5, 'Black', 'L', 1500.00, NULL, 150),
    (5, 'White', 'L', 1500.00, 1200.00, 80),  -- This specific variant is on sale

    -- Variant for the inactive Google Pixel 6 (Product_ID = 6)
    (6, 'Sorta Seafoam', '128GB', 150000.00, 95000.00, 0); -- On sale but out of stock

-- 6. Addresses Table
Code:
INSERT INTO Addresses (User_Id, Address_Line_1, Address_Line_2, City, Postal_Code, Country, Address_Label)
VALUES
    -- Addresses for Ali Khan (User_Id = 1)
    (1, 'House No. 123, Street 5', 'Near Park', 'Lahore', '54000', 'Pakistan', 'Home'),
    (1, 'Office # 404, Business Center', 'Main Boulevard', 'Lahore', '54000', 'Pakistan', 'Work'),

    -- Address for Sana Butt (User_Id = 2)
    (2, 'Flat 7B, Sky Tower', 'Gulshan-e-Iqbal', 'Karachi', '75300', 'Pakistan', 'Home'),

    -- Address for Bilal Ahmed (User_Id = 3) - No Address_Line_2
    (3, 'Shop No. 10, Anarkali Bazaar', NULL, 'Lahore', '54000', 'Pakistan', 'Shop Address'),
    
    -- Another address for a customer (User_Id = 2)
    (2, 'Apt 22, Defence View', 'Phase 8', 'Karachi', '75500', 'Pakistan', 'Secondary Home');

--Cart_items table:
Code:
INSERT INTO Cart_items (User_Id, Product_variant_Id, Quantity)
VALUES
    -- Items in Sana Butt's cart (User_Id = 2)
    (2, 11, 2), -- Sana wants 2 White, Large T-Shirts (which are on sale)
    (2, 7, 1),  -- Sana also wants 1 Dell XPS 15 Laptop
    (2, 1, 1),  -- Sana is also considering 1 iPhone (Natural, 256GB)

    -- Items in Bilal Ahmed's cart (User_Id = 3)
    (3, 8, 5),  -- Bilal wants 5 Black, Medium T-Shirts for his team
    (3, 9, 5),  -- And also 5 White, Medium T-Shirts
    (3, 6, 1)  -- Bilal is buying a MacBook Pro

--Orders Table:
Code:
INSERT INTO Orders (Order_Number, User_Id, Shipping_Amount, Shipping_Address_Id, Status, Payment_Method, Payment_Status, Created_at, Shipped_at, Delivered_at)
VALUES
    -- Order 1: A recent, completed order for Sana
    ('ORD-2025-1201', 2, 250.00, 3, 'Delivered', 'Credit Card', 'Paid', '2025-12-01 10:30:00', '2025-12-02 17:00:00', '2025-12-04 11:30:00'),

    -- Order 2: A new COD order for Bilal
    ('ORD-2025-1202', 3, 500.00, 4, 'Processing', 'Cash on Delivery', 'Pending', GETDATE(), NULL, NULL),

    -- Order 3: An older, cancelled order for Sana
    ('ORD-2025-1101', 2, 150.00, 5, 'Cancelled', 'Credit Card', 'Refunded', '2025-11-15 14:00:00', NULL, NULL),

    -- Order 4: A recent, shipped (but not delivered) order for Bilal
    ('ORD-2025-1203', 3, 300.00, 4, 'Shipped', 'JazzCash', 'Paid', '2025-12-03 09:00:00', '2025-12-05 11:00:00', NULL),

    -- Order 5: A very old but successful order for Sana
    ('ORD-2024-0815', 2, 200.00, 3, 'Delivered', 'Cash on Delivery', 'Paid', '2024-08-15 20:00:00', '2024-08-16 12:00:00', '2024-08-18 16:00:00');

--Order_items:
Code:
INSERT INTO Order_items (Order_Id, Product_variant_Id, Quantity, Original_Price_Per_Unit, Discount_Per_Unit)
VALUES
    -- Items for Order 1 (Sana's recent completed order)
    (1, 11, 2, 1500.00, 300.00), -- 2 White, L T-Shirts that were on sale
    (1, 7, 1, 480000.00, 0),      -- 1 Dell XPS 15 Laptop

    -- Items for Order 2 (Bilal's new COD order)
    (2, 8, 5, 1500.00, 0),        -- 5 Black, M T-Shirts
    (2, 9, 5, 1500.00, 0),        -- 5 White, M T-Shirts
    (2, 6, 1, 550000.00, 10000.00), -- 1 MacBook Pro that was on sale

    -- Items for Order 3 (Sana's older, cancelled order)
    (3, 2, 1, 350000.00, 0),      -- 1 iPhone (Blue) that she had ordered

    -- Items for Order 4 (Bilal's shipped order)
    (4, 10, 4, 1600.00, 0),       -- 4 Black, L T-Shirts (Price was 1600 at the time)

    -- Items for Order 5 (Sana's very old order)
    (5, 8, 1, 1400.00, 100.00),   -- 1 Black, M T-Shirt (Price was 1400 and on sale)
    (5, 1, 1, 300000.00, 0);      -- 1 iPhone (Price was 300k back then)
