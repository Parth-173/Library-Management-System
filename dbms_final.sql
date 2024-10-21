-- Create the database
CREATE DATABASE IF NOT EXISTS lib_mgmt;
USE lib_mgmt;

-- Create the Authors table
CREATE TABLE IF NOT EXISTS Authors (
    Author_ID INT PRIMARY KEY AUTO_INCREMENT,
    Author_Name VARCHAR(100) NOT NULL
);

-- Create the Books table
CREATE TABLE IF NOT EXISTS Books (
    ISBN INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author_ID INT,
    Category VARCHAR(50),
    Availability ENUM('In stock', 'Checked out') NOT NULL,
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID)
);

-- Create the Memberships table
CREATE TABLE IF NOT EXISTS Memberships (
    Membership_ID INT PRIMARY KEY AUTO_INCREMENT,
    Membership_Type ENUM('Standard', 'Premium') NOT NULL,
    Expiry_Date DATE
);

-- Create the Customers table
CREATE TABLE IF NOT EXISTS Customers (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Membership_ID INT,
    FOREIGN KEY (Membership_ID) REFERENCES Memberships(Membership_ID)
);

-- Create the Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT,
    ISBN INT,
    Transaction_Date DATE NOT NULL,
    Transaction_Type ENUM('Check out', 'Return') NOT NULL,
    Due_Date DATE,
    Late_Fee DECIMAL(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

-- Create the Administrators table
CREATE TABLE IF NOT EXISTS Administrators (
    Admin_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100)
);

-- Create the Members table for member login
CREATE TABLE IF NOT EXISTS Members (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(50) NOT NULL,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100)
);

-- Insert sample data into the "Memberships" table
INSERT INTO Memberships (Membership_Type, Expiry_Date) VALUES
    ('Standard', '2023-12-31'),
    ('Premium', '2024-12-31');

-- Insert sample data into the "Customers" table
INSERT INTO Customers (First_Name, Last_Name, Email, Membership_ID) VALUES
    ('John', 'Smith', 'john.smith@email.com', 1),
    ('Mary', 'Johnson', 'mary.johnson@email.com', 2),
    ('David', 'Williams', 'david.williams@email.com', 1),
    ('Sarah', 'Davis', 'sarah.davis@email.com', 1),
    ('Michael', 'Brown', 'michael.brown@email.com', 2),
    ('Emily', 'Jones', 'emily.jones@email.com', 1),
    ('Robert', 'Miller', 'robert.miller@email.com', 1),
    ('Laura', 'Anderson', 'laura.anderson@email.com', 2),
    ('William', 'White', 'william.white@email.com', 1),
    ('Jennifer', 'Hall', 'jennifer.hall@email.com', 2);

-- Insert sample data into the "Administrators" table
INSERT INTO Administrators (Username, Password, First_Name, Last_Name, Email) VALUES
    ('admin1', 'password1', 'John', 'Smith', 'admin1@example.com'),
    ('admin2', 'password2', 'Mary', 'Johnson', 'admin2@example.com'),
    ('admin3', 'password3', 'David', 'Williams', 'admin3@example.com'),
    ('admin4', 'password4', 'Sarah', 'Davis', 'admin4@example.com'),
    ('admin5', 'password5', 'Michael', 'Brown', 'admin5@example.com');

-- Insert sample data into the "Authors" table
INSERT INTO Authors (Author_Name) VALUES
    ('Author One'),
    ('Author Two'),
    ('Author Three');

-- Insert sample data into the "Books" table
INSERT INTO Books (ISBN, Title, Author_ID, Category, Availability) VALUES
    (1, 'Book Title 1', 1, 'Fiction', 'In stock'),
    (2, 'Book Title 2', 2, 'Non-Fiction', 'In stock'),
    (3, 'Book Title 3', 1, 'Fiction', 'In stock'),
    (4, 'Book Title 4', 3, 'Science', 'In stock'),
    (5, 'Book Title 5', 1, 'History', 'In stock');

-- Insert sample data into the "Transactions" table
INSERT INTO Transactions (Customer_ID, ISBN, Transaction_Date, Transaction_Type, Due_Date, Late_Fee) VALUES
    (1, 1, '2023-01-10', 'Check out', '2023-02-10', 0),
    (2, 2, '2023-01-15', 'Check out', '2023-02-15', 0),
    (3, 3, '2023-02-01', 'Check out', '2023-03-01', 0),
    (4, 4, '2023-02-10', 'Check out', '2023-03-10', 0),
    (5, 5, '2023-03-05', 'Check out', '2023-04-05', 0),
    (1, 1, '2023-02-10', 'Return', NULL, 5),
    (2, 2, '2023-02-15', 'Return', NULL, 5),
    (3, 3, '2023-03-01', 'Return', NULL, 5),
    (4, 4, '2023-03-10', 'Return', NULL, 5),
    (5, 5, '2023-04-05', 'Return', NULL, 5);

-- Trigger to prevent deletion of certain administrators
DELIMITER //
CREATE TRIGGER prevent_admin_deletion
BEFORE DELETE ON Administrators
FOR EACH ROW
BEGIN
  IF OLD.Admin_ID IN (1, 2, 3) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete admin with this ID';
  END IF;
END;
//
DELIMITER ;

-- Trigger to calculate late fee on returns
DELIMITER //
CREATE TRIGGER prevent_overdue_returns
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
  IF NEW.Transaction_Type = 'Return' AND NEW.Transaction_Date > NEW.Due_Date THEN
    SET NEW.Late_Fee = DATEDIFF(NEW.Transaction_Date, NEW.Due_Date) * 2;
  END IF;
END;
//
DELIMITER ;

-- Procedure to check out a book
DELIMITER //
CREATE PROCEDURE CheckOutBook(IN p_customer_id INT, IN p_book_ISBN INT)
BEGIN
  DECLARE v_due_date DATE;

  -- Check if the book is available
  IF (SELECT Availability FROM Books WHERE ISBN = p_book_ISBN) = 'In stock' THEN
    -- Calculate the due date (e.g., 14 days from today)
    SET v_due_date = DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY);

    -- Insert the transaction record
    INSERT INTO Transactions (Customer_ID, ISBN, Transaction_Date, Transaction_Type, Due_Date, Late_Fee)
    VALUES (p_customer_id, p_book_ISBN, CURRENT_DATE, 'Check out', v_due_date, 0);

    -- Update book availability
    UPDATE Books SET Availability = 'Checked out' WHERE ISBN = p_book_ISBN;

    SELECT 'Book checked out successfully' AS result;
  ELSE
    SELECT 'Book is not available for checkout' AS result;
  END IF;
END;
//
DELIMITER ;

-- Procedure to return a book
DELIMITER //
CREATE PROCEDURE ReturnBook(IN p_customer_id INT, IN p_book_ISBN INT)
BEGIN
  DECLARE v_late_fee INT;

  -- Check if the customer checked out the book
  IF (SELECT COUNT(*) FROM Transactions WHERE Customer_ID = p_customer_id AND ISBN = p_book_ISBN AND Transaction_Type = 'Check out') > 0 THEN
    -- Calculate late fee if the book is returned late
    SET v_late_fee = DATEDIFF(CURRENT_DATE, (SELECT Due_Date FROM Transactions WHERE Customer_ID = p_customer_id AND ISBN = p_book_ISBN AND Transaction_Type = 'Check out'));

    IF v_late_fee < 0 THEN
      SET v_late_fee = 0; -- No late fee if returned early
    END IF;

    -- Insert the return transaction record
    INSERT INTO Transactions (Customer_ID, ISBN, Transaction_Date, Transaction_Type, Due_Date, Late_Fee)
    VALUES (p_customer_id, p_book_ISBN, CURRENT_DATE, 'Return', NULL, v_late_fee);

    -- Update book availability
    UPDATE Books SET Availability = 'In stock' WHERE ISBN = p_book_ISBN;

    SELECT 'Book returned successfully' AS result;
  ELSE
    SELECT 'This book was not checked out by the customer' AS result;
  END IF;
END;
//
DELIMITER ;

-- Procedure to add a new book
DELIMITER //
CREATE PROCEDURE add_book(
    IN p_ISBN INT,
    IN p_Title VARCHAR(100),
    IN p_Author_ID INT,
    IN p_Category VARCHAR(50),
    IN p_Availability ENUM('In stock', 'Checked out')
)
BEGIN
    INSERT INTO Books (ISBN, Title, Author_ID, Category, Availability)
    VALUES (p_ISBN, p_Title, p_Author_ID, p_Category, p_Availability);
END;
//
DELIMITER ;

-- Procedure for member login
DELIMITER //
CREATE PROCEDURE MemberLogin(IN p_username VARCHAR(50), IN p_password VARCHAR(50))
BEGIN
    DECLARE v_member_id INT;

    SELECT Member_ID INTO v_member_id
    FROM Members
    WHERE Username = p_username AND Password = p_password;

    IF v_member_id IS NOT NULL THEN
        SELECT 'Login successful' AS result;
    ELSE
        SELECT 'Invalid username or password' AS result;
    END IF;
END;
//
DELIMITER ;


SELECT * FROM Members;
