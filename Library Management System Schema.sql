-- DROP TABLES IF EXISTS
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE loans';
    EXECUTE IMMEDIATE 'DROP TABLE books';
    EXECUTE IMMEDIATE 'DROP TABLE members';
    EXECUTE IMMEDIATE 'DROP TABLE authors';
    EXECUTE IMMEDIATE 'DROP TABLE categories';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- CREATING TABLES

-- CATEGORIES
CREATE TABLE categories (
    category_id NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);

-- AUTHORS
CREATE TABLE authors (
    author_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    nationality VARCHAR2(50)
);

-- MEMBERS
CREATE TABLE members (
    member_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    join_date DATE
);

-- BOOKS
CREATE TABLE books (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(200),
    author_id NUMBER,
    category_id NUMBER,
    available_copies NUMBER,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- LOANS
CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    member_id NUMBER,
    book_id NUMBER,
    loan_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- INSERTING VALUES INTO TABLES

-- INSERT CATEGORIES
INSERT INTO categories VALUES (1, 'Fiction');
INSERT INTO categories VALUES (2, 'Non-Fiction');
INSERT INTO categories VALUES (3, 'Science');
INSERT INTO categories VALUES (4, 'History');
INSERT INTO categories VALUES (5, 'Biography');

-- INSERT AUTHORS
INSERT INTO authors VALUES (1, 'George Orwell', 'British');
INSERT INTO authors VALUES (2, 'J.K. Rowling', 'British');
INSERT INTO authors VALUES (3, 'Stephen Hawking', 'British');
INSERT INTO authors VALUES (4, 'Yuval Noah Harari', 'Israeli');
INSERT INTO authors VALUES (5, 'Michelle Obama', 'American');
INSERT INTO authors VALUES (6, 'Kiran Desai', 'Indian');
INSERT INTO authors VALUES (7, 'Rohinton Mistry', 'Canadian');
INSERT INTO authors VALUES (8, 'Chetan Bhagat', 'Indian');
INSERT INTO authors VALUES (9, 'APJ Abdul Kalam', 'Indian');
INSERT INTO authors VALUES (10, 'Agatha Christie', 'British');

-- INSERT MEMBERS
INSERT INTO members VALUES (1, 'Raj Malhotra', 'raj@example.com', TO_DATE('2023-01-10','YYYY-MM-DD'));
INSERT INTO members VALUES (2, 'Simran Kaur', 'simran@example.com', TO_DATE('2023-02-12','YYYY-MM-DD'));
INSERT INTO members VALUES (3, 'Ankit Singh', 'ankit@example.com', TO_DATE('2023-03-05','YYYY-MM-DD'));
INSERT INTO members VALUES (4, 'Neha Jain', 'neha@example.com', TO_DATE('2023-04-18','YYYY-MM-DD'));
INSERT INTO members VALUES (5, 'Tanya Roy', 'tanya@example.com', TO_DATE('2023-05-01','YYYY-MM-DD'));
INSERT INTO members VALUES (6, 'Amit Patel', 'amit@example.com', TO_DATE('2023-05-15','YYYY-MM-DD'));
INSERT INTO members VALUES (7, 'Sneha Agarwal', 'sneha@example.com', TO_DATE('2023-06-02','YYYY-MM-DD'));
INSERT INTO members VALUES (8, 'Ravi Sharma', 'ravi@example.com', TO_DATE('2023-06-18','YYYY-MM-DD'));
INSERT INTO members VALUES (9, 'Priya Mehta', 'priya@example.com', TO_DATE('2023-07-04','YYYY-MM-DD'));
INSERT INTO members VALUES (10, 'Kunal Verma', 'kunal@example.com', TO_DATE('2023-07-21','YYYY-MM-DD'));

-- INSERT BOOKS
INSERT INTO books VALUES (1, '1984', 1, 1, 5);
INSERT INTO books VALUES (2, 'Harry Potter and the Sorcerer''s Stone', 2, 1, 4);
INSERT INTO books VALUES (3, 'A Brief History of Time', 3, 3, 3);
INSERT INTO books VALUES (4, 'Sapiens', 4, 2, 2);
INSERT INTO books VALUES (5, 'Becoming', 5, 5, 6);
INSERT INTO books VALUES (6, 'The Inheritance of Loss', 6, 1, 3);
INSERT INTO books VALUES (7, 'A Fine Balance', 7, 1, 2);
INSERT INTO books VALUES (8, 'Five Point Someone', 8, 1, 5);
INSERT INTO books VALUES (9, 'Wings of Fire', 9, 5, 4);
INSERT INTO books VALUES (10, 'Murder on the Orient Express', 10, 1, 1);

-- INSERT LOANS
INSERT INTO loans VALUES (101, 1, 1, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-10','YYYY-MM-DD'));
INSERT INTO loans VALUES (102, 2, 2, TO_DATE('2024-04-03','YYYY-MM-DD'), TO_DATE('2024-04-13','YYYY-MM-DD'));
INSERT INTO loans VALUES (103, 3, 3, TO_DATE('2024-04-04','YYYY-MM-DD'), NULL);
INSERT INTO loans VALUES (104, 4, 4, TO_DATE('2024-04-05','YYYY-MM-DD'), TO_DATE('2024-04-15','YYYY-MM-DD'));
INSERT INTO loans VALUES (105, 5, 5, TO_DATE('2024-04-06','YYYY-MM-DD'), NULL);
INSERT INTO loans VALUES (106, 6, 6, TO_DATE('2024-04-07','YYYY-MM-DD'), NULL);
INSERT INTO loans VALUES (107, 7, 7, TO_DATE('2024-04-08','YYYY-MM-DD'), NULL);
INSERT INTO loans VALUES (108, 8, 8, TO_DATE('2024-04-09','YYYY-MM-DD'), NULL);
INSERT INTO loans VALUES (109, 9, 9, TO_DATE('2024-04-10','YYYY-MM-DD'), NULL);
INSERT INTO loans VALUES (110, 10, 10, TO_DATE('2024-04-11','YYYY-MM-DD'), NULL);

COMMIT;

SELECT * FROM books;

SELECT * FROM authors;

SELECT * FROM members;

SELECT * FROM loans;

SELECT * FROM categories;

-- 1. List all books with their author names and categories
SELECT b.title, a.name AS author, c.name AS category
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id;

-- 2. Show members who have not returned books
SELECT m.name, b.title, l.loan_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;

-- 3. Count how many books are in each category
SELECT c.name AS category, COUNT(*) AS book_count
FROM books b
JOIN categories c ON b.category_id = c.category_id
GROUP BY c.name;

-- 4. List overdue loans assuming today is '2024-04-20'
SELECT m.name, b.title, l.loan_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL AND l.loan_date < TO_DATE('2024-04-10','YYYY-MM-DD');

-- 5. Find which authors have more than 1 book in the library
SELECT a.name, COUNT(*) AS total_books
FROM books b
JOIN authors a ON b.author_id = a.author_id
GROUP BY a.name
HAVING COUNT(*) > 1;

--6. Books borrowed by each member
SELECT m.name AS member, b.title AS book, l.loan_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
ORDER BY m.name;

--7. Book count per author
SELECT a.name AS author, COUNT(b.book_id) AS book_count
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.name;

--8. Members who borrowed books from the "Science" category
SELECT DISTINCT m.name
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
JOIN categories c ON b.category_id = c.category_id
WHERE c.name = 'Science';

--9. List members who have borrowed more than 1 book
SELECT name
FROM members
WHERE member_id IN (
    SELECT member_id
    FROM loans
    GROUP BY member_id
    HAVING COUNT(*) > 1
);

--10. Find the book(s) with the least number of available copies
SELECT title, available_copies
FROM books
WHERE available_copies = (
    SELECT MIN(available_copies) FROM books
);

COMMIT;

-- 11. Authors whose books have never been borrowed
SELECT name
FROM authors
WHERE author_id NOT IN (
    SELECT DISTINCT author_id
    FROM books
    WHERE book_id IN (SELECT book_id FROM loans)
);

-- CASE Statements Practice

-- 12. Show loan status for each book (Returned / Not Returned)

SELECT l.loan_id, b.title, 
       CASE 
           WHEN l.return_date IS NULL THEN 'Not Returned'
           ELSE 'Returned'
       END AS loan_status
FROM loans l
JOIN books b ON l.book_id = b.book_id;

-- 13. Categorize members based on number of books borrowed
SELECT m.name,
       COUNT(l.loan_id) AS total_loans,
       CASE 
           WHEN COUNT(l.loan_id) = 0 THEN 'Inactive'
           WHEN COUNT(l.loan_id) BETWEEN 1 AND 2 THEN 'Occasional Reader'
           WHEN COUNT(l.loan_id) > 2 THEN 'Active Reader'
       END AS reader_type
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.name;

-- 14. Flag books with low stock
SELECT title, available_copies,
       CASE 
           WHEN available_copies <= 2 THEN 'Low Stock'
           WHEN available_copies BETWEEN 3 AND 5 THEN 'Medium Stock'
           ELSE 'High Stock'
       END AS stock_status
FROM books;

--VIEW Statements Practice

-- 15. View: Books with Author and Category Info
CREATE OR REPLACE VIEW view_books_info AS
SELECT 
    b.book_id,
    b.title,
    a.name AS author,
    c.name AS category,
    b.available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id;

SELECT * FROM view_books_info WHERE category = 'Fiction';

-- 16. View: Active Loans (Not Yet Returned)
CREATE OR REPLACE VIEW view_active_loans AS
SELECT 
    l.loan_id,
    m.name AS member,
    b.title AS book,
    l.loan_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;

SELECT * FROM view_active_loans ORDER BY loan_date;

-- 17. View: Loan History Summary
CREATE OR REPLACE VIEW view_loan_history AS
SELECT 
    l.loan_id,
    m.name AS member_name,
    b.title AS book_title,
    l.loan_date,
    NVL(TO_CHAR(l.return_date, 'YYYY-MM-DD'), 'Not Returned') AS return_status
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id;

SELECT * FROM view_loan_history WHERE return_status = 'Not Returned';

-- 18. View: Book Loan Counts
CREATE OR REPLACE VIEW view_book_loan_count AS
SELECT 
    b.title,
    COUNT(l.loan_id) AS times_borrowed
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.title;

SELECT * FROM view_book_loan_count ORDER BY times_borrowed DESC;

-- 19. View: Member Borrowing Activity
CREATE OR REPLACE VIEW view_member_activity AS
SELECT 
    m.member_id,
    m.name,
    COUNT(l.loan_id) AS total_books_borrowed
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.name;

SELECT * FROM view_member_activity WHERE total_books_borrowed > 2;

COMMIT;