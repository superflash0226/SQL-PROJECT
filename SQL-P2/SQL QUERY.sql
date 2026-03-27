-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird',  
-- 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
SELECT * FROM books;

-- Task 2: Update an Existing Member's Address
UPDATE member
SET member_address = '125 Oak St'
WHERE member_id = 'C103'

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_id, issued_book_name FROM issued
WHERE issued_emp_id = 'E101'

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_emp_id, COUNT(*) FROM issued
GROUP BY 1
HAVING COUNT(*) > 1

-- CTAS (Create Table As Select)
-- Task 6: Create Summary Tables: 
-- Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE books_summary
AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) FROM books AS b
JOIN issued AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE Category = 'Classic'

-- Task 8: Find Total Rental Income by Category:
SELECT b.category, SUM(b.rental_price), COUNT(*) FROM books AS b
JOIN issued AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

-- Task 9. List Members Who Registered in the Last 180 Days:
SELECT * FROM member
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10. List Employees with Their Branch Manager's Name and their branch details:
SELECT e.emp_id, e.emp_name, e.position,
	   b.branch_id, b.manager_id
FROM employee AS e
JOIN branch AS b
ON b.branch_id = e.branch_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE rental_books
AS 
SELECT isbn, book_title, rental_price FROM books
WHERE rental_price > 7.0

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

SELECT i.issued_id, m.member_name,
	   b.book_title,
	   i.issued_date,
	   r.return_date
FROM issued AS i
JOIN books AS b
ON b.isbn = i.issued_book_isbn
JOIN member AS m
ON m.member_id = i.issued_member_id
JOIN return_status AS r
ON r.issued_id = i.issued_id

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to 
"Yes" when they are returned (based on entries in the return_status table).
*/

CREATE OR REPLACE PROCEDURE add_return_book(
    u_return_id VARCHAR(100),
    u_issued_id VARCHAR(100),
    u_return_book_name VARCHAR(100),
    u_book_quality VARCHAR(50)
)
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(100);

BEGIN
    INSERT INTO return_status(
        return_id,
        issued_id,
        return_book_name,
        book_quality,
        return_date
    )
    VALUES (
        u_return_id,
        u_issued_id,
        u_return_book_name,
        u_book_quality,
        CURRENT_DATE
    );

    SELECT issued_book_isbn
    INTO v_isbn
    FROM issued
    WHERE issued_id = u_issued_id;

    UPDATE books
    SET status = 'YES'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank You For returning the book';

END;
$$;

CALL  add_return_book();


CALL  add_return_book('RS106', 'IS106', 'The Diary of a Young Girl', 'Good');

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch,  
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

Drop TABLE IF EXISTS report;
CREATE TABLE report
AS
SELECT 
	b.branch_id,
	COUNT(i.issued_id) AS issued_books,
	COUNT(r.return_id) AS return_books
FROM issued AS i
JOIN employee as e
ON e.emp_id = i.issued_emp_id
JOIN branch AS b
ON b.branch_id = e.branch_id
JOIN return_status AS r
ON r.issued_id = i.issued_id
GROUP BY 1
	
/*
Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing 
members who have issued at least one book in the last 2 months.
*/

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;

/*
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues.
Display the employee name, number of books processed, and their branch.
*/

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2
 


