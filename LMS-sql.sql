-- Create the database
CREATE DATABASE lib_mgmt;
USE lib_mgmt;

-- Create the Authors table
CREATE TABLE Authors (
    Author_ID INT PRIMARY KEY AUTO_INCREMENT,
    Author_Name VARCHAR(100) NOT NULL
);

-- Create the Books table
CREATE TABLE Books (
    ISBN INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Author_ID INT,
    Category VARCHAR(50),
    Availability ENUM('In stock', 'Checked out') NOT NULL,
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID)
);

-- Create the Transactions table
CREATE TABLE Transactions (
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

-- Create the Customers table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Membership_ID INT,
    FOREIGN KEY (Membership_ID) REFERENCES Memberships(Membership_ID)
);

-- Create the Memberships table
CREATE TABLE Memberships (
    Membership_ID INT PRIMARY KEY AUTO_INCREMENT,
    Membership_Type ENUM('Standard', 'Premium') NOT NULL,
    Expiry_Date DATE
);

-- Create the Administrators table
CREATE TABLE Administrators (
    Admin_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100)
);

-- Insert sample data into the "Customers" table
INSERT INTO Customers (Customer_ID, First_Name, Last_Name, Email, Membership_ID, Contact)
VALUES
    (1, 'John', 'Smith', 'john.smith@email.com', 1, '123-456-7890'),
    (2, 'Mary', 'Johnson', 'mary.johnson@email.com', 2, '987-654-3210'),
    (3, 'David', 'Williams', 'david.williams@email.com', 1, '555-555-5555'),
    (4, 'Sarah', 'Davis', 'sarah.davis@email.com', 1, '111-222-3333'),
    (5, 'Michael', 'Brown', 'michael.brown@email.com', 2, '999-888-7777'),
    (6, 'Emily', 'Jones', 'emily.jones@email.com', 1, '444-777-8888'),
    (7, 'Robert', 'Miller', 'robert.miller@email.com', 1, '222-333-4444'),
    (8, 'Laura', 'Anderson', 'laura.anderson@email.com', 2, '666-555-4444'),
    (9, 'William', 'White', 'william.white@email.com', 1, '777-888-9999'),
    (10, 'Jennifer', 'Hall', 'jennifer.hall@email.com', 2, '333-111-5555');

-- Insert sample data into the "Admin" table
INSERT INTO Admin (Admin_ID, Username, Password, First_Name, Last_Name, Email, Roles)
VALUES
    (1, 'admin1', 'password1', 'John', 'Smith', 'admin1@example.com', 'Role 1, Role 2'),
    (2, 'admin2', 'password2', 'Mary', 'Johnson', 'admin2@example.com', 'Role 3, Role 4'),
    (3, 'admin3', 'password3', 'David', 'Williams', 'admin3@example.com', 'Role 1, Role 5'),
    (4, 'admin4', 'password4', 'Sarah', 'Davis', 'admin4@example.com', 'Role 2, Role 4'),
    (5, 'admin5', 'password5', 'Michael', 'Brown', 'admin5@example.com', 'Role 3, Role 5');

-- Update the Books table to set Author_ID based on matching Author_Name
UPDATE Books
JOIN Authors ON Books.Author = Authors.Author_Name
SET Books.Author_ID = Authors.Author_ID;


-- Insert sample data into the "Memberships" table with Membership_ID
INSERT INTO Memberships (Membership_ID, Membership_Type, Expiry_Date)
VALUES
    (1, 'Standard', '2023-12-31'),
    (2, 'Premium', '2024-12-31');

-- Insert sample data into the "Admin" table
INSERT INTO Admin (Admin_ID, Username, Password, First_Name, Last_Name, Email, Roles)
VALUES
    (1, 'admin1', 'password1', 'John', 'Smith', 'admin1@example.com', 'Role 1, Role 2'),
    (2, 'admin2', 'password2', 'Mary', 'Johnson', 'admin2@example.com', 'Role 3, Role 4'),
    (3, 'admin3', 'password3', 'David', 'Williams', 'admin3@example.com', 'Role 1, Role 5'),
    (4, 'admin4', 'password4', 'Sarah', 'Davis', 'admin4@example.com', 'Role 2, Role 4'),
    (5, 'admin5', 'password5', 'Michael', 'Brown', 'admin5@example.com', 'Role 3, Role 5');

-- Insert sample data into the "Transactions" table with integer ISBN and modified Transaction_ID
INSERT INTO Transactions (Transaction_ID, Customer_ID, ISBN, Transaction_Date, Transaction_Type, Due_Date, Late_Fee)
VALUES
    (123456, 1, 1, '2023-01-10', 'Check out', '2023-02-10', 0),
    (789012, 2, 2, '2023-01-15', 'Check out', '2023-02-15', 0),
    (345678, 3, 3, '2023-02-01', 'Check out', '2023-03-01', 0),
    (901234, 4, 4, '2023-02-10', 'Check out', '2023-03-10', 0),
    (567890, 5, 5, '2023-03-05', 'Check out', '2023-04-05', 0),
    (654321, 1, 6, '2023-03-15', 'Return', '2023-02-10', 5),
    (210987, 2, 7, '2023-03-20', 'Return', '2023-02-15', 5),
    (876543, 3, 8, '2023-04-05', 'Return', '2023-03-01', 5),
    (432109, 4, 9, '2023-04-10', 'Return', '2023-03-10', 5),
    (987654, 5, 10, '2023-05-01', 'Return', '2023-04-05', 5),
    (112233, 1, 11, '2023-05-10', 'Check out', '2023-06-10', 0),
    (445566, 2, 12, '2023-05-15', 'Check out', '2023-06-15', 0),
    (778899, 3, 13, '2023-06-01', 'Check out', '2023-07-01', 0),
    (990011, 4, 14, '2023-06-10', 'Check out', '2023-07-10', 0),
    (223344, 5, 15, '2023-07-05', 'Check out', '2023-08-05', 0),
    (556677, 1, 16, '2023-07-15', 'Return', '2023-06-10', 5),
    (889900, 2, 17, '2023-07-20', 'Return', '2023-06-15', 5),
    (112233, 3, 18, '2023-08-05', 'Return', '2023-07-01', 5),
    (445566, 4, 19, '2023-08-10', 'Return', '2023-07-10', 5),
    (778899, 5, 20, '2023-09-01', 'Return', '2023-08-05', 5);

DELIMITER //
CREATE TRIGGER prevent_admin_deletion
BEFORE DELETE ON admins
FOR EACH ROW
BEGIN
  IF OLD.admin_id IN (1, 2, 3) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete admin with this ID';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER prevent_overdue_returns
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
  IF NEW.transaction_type = 'Return' AND NEW.transaction_date > NEW.due_date THEN
    SET NEW.late_fee = DATEDIFF(NEW.transaction_date, NEW.due_date) * 2;
  END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE CheckOutBook (IN p_customer_id INT, IN p_book_ISBN INT)
BEGIN
  DECLARE v_due_date DATE;
  
  -- Check if the book is available
  IF (SELECT availability FROM books WHERE ISBN = p_book_ISBN) = 'In stock' THEN
    -- Calculate the due date (e.g., 14 days from today)
    SET v_due_date = DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY);

    -- Insert the transaction record
    INSERT INTO transactions (customer_id, ISBN, transaction_date, transaction_type, due_date, late_fee)
    VALUES (p_customer_id, p_book_ISBN, CURRENT_DATE, 'Check out', v_due_date, 0);

    -- Update book availability
    UPDATE books SET availability = 'Checked out' WHERE ISBN = p_book_ISBN;
    
    SELECT 'Book checked out successfully' AS result;
  ELSE
    SELECT 'Book is not available for checkout' AS result;
  END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ReturnBook (IN p_customer_id INT, IN p_book_ISBN INT)
BEGIN
  DECLARE v_late_fee INT;
  
  -- Check if the customer checked out the book
  IF (SELECT COUNT(*) FROM transactions WHERE customer_id = p_customer_id AND ISBN = p_book_ISBN AND transaction_type = 'Check out') > 0 THEN
    -- Calculate late fee if the book is returned late
    SET v_late_fee = DATEDIFF(CURRENT_DATE, (SELECT due_date FROM transactions WHERE customer_id = p_customer_id AND ISBN = p_book_ISBN AND transaction_type = 'Check out')) * 2;

    -- Insert the return transaction record
    INSERT INTO transactions (customer_id, ISBN, transaction_date, transaction_type, due_date, late_fee)
    VALUES (p_customer_id, p_book_ISBN, CURRENT_DATE, 'Return', NULL, v_late_fee);

    -- Update book availability
    UPDATE books SET availability = 'In stock' WHERE ISBN = p_book_ISBN;

    SELECT 'Book returned successfully' AS result;
  ELSE
    SELECT 'Customer did not check out this book' AS result;
  END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE FUNCTION GetCustomerMembershipType(p_customer_id INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE v_membership_type VARCHAR(50);
  
  -- Get the customer's membership type
  SELECT membership_type INTO v_membership_type
  FROM customers c
  JOIN memberships m ON c.membership_id = m.membership_id
  WHERE c.customer_id = p_customer_id;
  
  RETURN v_membership_type;
END;
//
DELIMITER ;
