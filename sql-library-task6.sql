-- Use the database
USE LibraryDB;

-- 1️⃣ Subquery in WHERE: Members who borrowed more than 1 book
SELECT Name
FROM Members
WHERE MemberID IN (
    SELECT MemberID
    FROM Borrow
    GROUP BY MemberID
    HAVING COUNT(*) > 1
);

-- 2️⃣ Scalar subquery in SELECT: Total borrow count for each member
SELECT 
    Name,
    (SELECT COUNT(*) FROM Borrow WHERE Borrow.MemberID = Members.MemberID) AS TotalBorrows
FROM Members;

-- 3️⃣ Subquery in FROM: Average borrowings per member
SELECT AVG(BorrowCount) AS AvgBorrows
FROM (
    SELECT MemberID, COUNT(*) AS BorrowCount
    FROM Borrow
    GROUP BY MemberID
) AS Sub;

-- 4️⃣ EXISTS: Show members who have borrowed at least one book
SELECT Name
FROM Members m
WHERE EXISTS (
    SELECT 1 FROM Borrow b WHERE b.MemberID = m.MemberID
);

-- 5️⃣ NOT EXISTS: Show members who never borrowed a book
SELECT Name
FROM Members m
WHERE NOT EXISTS (
    SELECT 1 FROM Borrow b WHERE b.MemberID = m.MemberID
);

-- 6️⃣ Correlated Subquery: Latest borrow date for each member
SELECT Name, (
    SELECT MAX(BorrowDate)
    FROM Borrow b
    WHERE b.MemberID = m.MemberID
) AS LastBorrowed
FROM Members m;

-- 7️⃣ Nested Subquery: Books borrowed by members who borrowed more than 1 book
SELECT Title
FROM Books
WHERE BookID IN (
    SELECT BookID
    FROM Borrow
    WHERE MemberID IN (
        SELECT MemberID
        FROM Borrow
        GROUP BY MemberID
        HAVING COUNT(*) > 1
    )
);