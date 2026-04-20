-- Migration: Add order_index to Exercises table
-- Run this against your SQL Server DB

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Exercises' AND COLUMN_NAME = 'order_index'
)
BEGIN
    ALTER TABLE Exercises ADD order_index INT NOT NULL DEFAULT 0;
    PRINT 'Column order_index added to Exercises.';
END
ELSE
BEGIN
    PRINT 'Column order_index already exists in Exercises. Nothing to do.';
END
