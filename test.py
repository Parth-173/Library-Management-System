import streamlit as st
import mysql.connector

# Function to connect to the MySQL database and fetch data for a specified table
def fetch_data(table_name):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Sachchidanand@173",
            database="lib_mgmt"
        )
        cursor = connection.cursor()

        # Replace 'your_table' with the actual table name
        query = f"SELECT * FROM {table_name}"
        cursor.execute(query)
        data = cursor.fetchall()

        connection.close()

        # Display the fetched data in a Streamlit table
        st.table(data)

    except mysql.connector.Error as error:
        st.error(f"Error: {error}")
    
# Function to call the Cust_Membership function in MySQL
def call_cust_membership_function(customer_id):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Sachchidanand@173",
            database="lib_mgmt"
        )
        cursor = connection.cursor()

        # Replace the query with a call to the Cust_Membership function
        query = f"SELECT GetCustomerMembershipType({customer_id})"
        cursor.execute(query)
        data = cursor.fetchall()

        connection.close()

        return data[0][0] if data else "No data found"

    except mysql.connector.Error as error:
        return f"Error: {error}"

def fetch_admin_data():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Sachchidanand@173",
            database="lib_mgmt"
        )
        cursor = connection.cursor()

        # SQL query to fetch full name and emails of Admins
        query = "SELECT CONCAT(First_Name, ' ', Last_Name) AS Full_Name, Email FROM Administrators"
        cursor.execute(query)
        data = cursor.fetchall()

        connection.close()

        # Display the fetched data in a Streamlit table
        st.table(data)

    except mysql.connector.Error as error:
        st.error(f"Error: {error}")


def update_book_availability(isbn, action):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Sachchidanand@173",
            database="lib_mgmt"
        )
        cursor = connection.cursor()

        if action == "checkout":
            # Check if the book is available
            cursor.execute("SELECT * FROM Books WHERE ISBN = %s AND Availability = 'In stock'", (isbn,))
            book = cursor.fetchone()

            if book:
                # If the book is available, update its availability
                cursor.execute("UPDATE Books SET Availability = 'Checked out' WHERE ISBN = %s", (isbn,))
                connection.commit()
                st.success(f"Book with ISBN {isbn} has been checked out.")
            else:
                st.error(f"Book with ISBN {isbn} is not available for check-out.")

        elif action == "return":
            # Check if the book is checked out
            cursor.execute("SELECT * FROM Books WHERE ISBN = %s AND Availability = 'Checked out'", (isbn,))
            book = cursor.fetchone()

            if book:
                # If the book is checked out, update its availability
                cursor.execute("UPDATE Books SET Availability = 'In stock' WHERE ISBN = %s", (isbn,))
                connection.commit()
                st.success(f"Book with ISBN {isbn} has been returned.")
            else:
                st.error(f"Book with ISBN {isbn} is not currently checked out.")

        connection.close()

    except mysql.connector.Error as error:
        st.error(f"Error: {error}")


def check_out_book(customer_id, isbn):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Sachchidanand@173",
            database="lib_mgmt"
        )
        cursor = connection.cursor()

        # Call the stored procedure to check out a book
        cursor.callproc('CheckOutBook', (customer_id, isbn))
        
        for result in cursor.stored_results():
            st.success(result.fetchone()[0])  # Display the result message

        connection.close()

    except mysql.connector.Error as error:
        st.error(f"Error: {error}")


def return_book(customer_id, isbn):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Sachchidanand@173",
            database="lib_mgmt"
        )
        cursor = connection.cursor()

        # Call the stored procedure to return a book
        cursor.callproc('ReturnBook', (customer_id, isbn))

        for result in cursor.stored_results():
            st.success(result.fetchone()[0])  # Display the result message

        connection.close()

    except mysql.connector.Error as error:
        st.error(f"Error: {error}")

# Streamlit UI for functionalities
st.title("Library Management System")

# Fetch data
if st.button("Show Authors"):
    fetch_data("Authors")

if st.button("Show Books"):
    fetch_data("Books")

if st.button("Show Customers"):
    fetch_data("Customers")

if st.button("Show Memberships"):
    fetch_data("Memberships")

if st.button("Show Transactions"):
    fetch_data("Transactions")

if st.button("Show Admins"):
    fetch_admin_data()

# Check out book
st.subheader("Check Out Book")
customer_id = st.number_input("Customer ID", min_value=1)
book_isbn = st.number_input("Book ISBN", min_value=1)
if st.button("Check Out"):
    check_out_book(customer_id, book_isbn)

# Return book
st.subheader("Return Book")
if st.button("Return"):
    return_book(customer_id, book_isbn)

# Fetch customer membership type
st.subheader("Get Customer Membership Type")
customer_id_for_membership = st.number_input("Enter Customer ID", min_value=1)
if st.button("Get Membership Type"):
    membership_type = call_cust_membership_function(customer_id_for_membership)
    st.write(f"Membership Type: {membership_type}")
