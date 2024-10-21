import streamlit as st
import mysql.connector

# Function to connect to the MySQL database
def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Sachchidanand@173",
        database="lib_mgmt"
    )

# Function to fetch data from the specified table
def fetch_data(table_name):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        query = f"SELECT * FROM {table_name}"
        cursor.execute(query)
        data = cursor.fetchall()
        connection.close()
        return data
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")
        return []

# Function to add a book
def add_book(isbn, title, author, availability):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        query = "INSERT INTO Books (ISBN, Title, Author, Availability) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (isbn, title, author, availability))
        connection.commit()
        connection.close()
        st.success("Book added successfully!")
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")

# Function to delete a book
def delete_book(isbn):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        query = "DELETE FROM Books WHERE ISBN = %s"
        cursor.execute(query, (isbn,))
        connection.commit()
        connection.close()
        st.success("Book deleted successfully!")
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")

# Function to rent a book
def rent_book(customer_id, isbn):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        cursor.callproc('CheckOutBook', (customer_id, isbn))
        for result in cursor.stored_results():
            st.success(result.fetchone()[0])  # Display the result message
        connection.close()
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")

# Function to return a book
def return_book(customer_id, isbn):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        cursor.callproc('ReturnBook', (customer_id, isbn))
        for result in cursor.stored_results():
            st.success(result.fetchone()[0])  # Display the result message
        connection.close()
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")

# Function for member login
def member_login(username, password):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        query = "SELECT * FROM Members WHERE Username = %s AND Password = %s"
        cursor.execute(query, (username, password))
        member = cursor.fetchone()
        connection.close()
        return member
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")
        return None

# Function for admin login
def admin_login(username, password):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        query = "SELECT * FROM Administrators WHERE Username = %s AND Password = %s"
        cursor.execute(query, (username, password))
        admin = cursor.fetchone()
        connection.close()
        return admin
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")
        return None

# Function for member signup
def member_signup(username, password, first_name, last_name):
    try:
        connection = connect_db()
        cursor = connection.cursor()
        query = "INSERT INTO Members (Username, Password, First_Name, Last_Name) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (username, password, first_name, last_name))
        connection.commit()
        connection.close()
        st.success("Signup successful! You can now log in.")
    except mysql.connector.Error as error:
        st.error(f"Error: {error}")

# Main app logic
st.title("Welcome to the Library Management System")

# Show welcome message and continue button
if st.button("Continue"):
    st.session_state.page = "login"

# Login and Signup functionality
if 'page' in st.session_state and st.session_state.page == "login":
    st.subheader("Login")
    login_type = st.radio("Login as:", ("Member", "Admin"))

    if login_type == "Member":
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        if st.button("Login"):
            member = member_login(username, password)
            if member:
                st.success("Login successful!")
                st.session_state.page = "member_dashboard"
            else:
                st.error("Invalid username or password.")

        st.subheader("Sign Up")
        signup_username = st.text_input("Signup Username")
        signup_password = st.text_input("Signup Password", type="password")
        first_name = st.text_input("First Name")
        last_name = st.text_input("Last Name")
        if st.button("Sign Up"):
            member_signup(signup_username, signup_password, first_name, last_name)

    else:  # Admin login
        admin_username = st.text_input("Admin Username")
        admin_password = st.text_input("Admin Password", type="password")
        if st.button("Login"):
            admin = admin_login(admin_username, admin_password)
            if admin:
                st.success("Login successful!")
                st.session_state.page = "admin_dashboard"
            else:
                st.error("Invalid username or password.")

# Member Dashboard
if 'page' in st.session_state and st.session_state.page == "member_dashboard":
    st.title("Member Dashboard")
    
    if st.button("Show All Books"):
        books = fetch_data("Books")
        st.table(books)

    book_isbn = st.text_input("Enter Book ISBN to Rent")
    if st.button("Rent Book"):
        customer_id = st.number_input("Enter Your Customer ID", min_value=1)
        rent_book(customer_id, book_isbn)

    return_isbn = st.text_input("Enter Book ISBN to Return")
    if st.button("Return Book"):
        customer_id = st.number_input("Enter Your Customer ID", min_value=1)
        return_book(customer_id, return_isbn)

    if st.button("Logout"):
        st.session_state.page = "login"

# Admin Dashboard
if 'page' in st.session_state and st.session_state.page == "admin_dashboard":
    st.title("Admin Dashboard")

    if st.button("Show All Books"):
        books = fetch_data("Books")
        st.table(books)

    if st.button("Show All Users"):
        users = fetch_data("Members")
        st.table(users)

    isbn = st.text_input("Enter ISBN to Add Book")
    title = st.text_input("Enter Title to Add Book")
    author = st.text_input("Enter Author to Add Book")
    if st.button("Add Book"):
        add_book(isbn, title, author, "In stock")

    delete_isbn = st.text_input("Enter ISBN to Delete Book")
    if st.button("Delete Book"):
        delete_book(delete_isbn)

    if st.button("Logout"):
        st.session_state.page = "login"
