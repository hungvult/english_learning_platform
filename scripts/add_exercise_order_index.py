"""
One-shot migration: add order_index column to Exercises table.
Existing rows get order_index = 0 so they remain valid.

Run from project root:
    cd server && python ../scripts/add_exercise_order_index.py
"""
import sys
import os

# Allow imports from server/app
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "server"))

from sqlalchemy import text
from app.core.database import _get_engine


def main():
    engine = _get_engine()
    with engine.connect() as conn:
        # Check if column already exists
        result = conn.execute(text(
            "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS "
            "WHERE TABLE_NAME = 'Exercises' AND COLUMN_NAME = 'order_index'"
        )).scalar()

        if result and result > 0:
            print("Column 'order_index' already exists in Exercises table. Nothing to do.")
            return

        print("Adding 'order_index' column to Exercises table...")
        conn.execute(text(
            "ALTER TABLE Exercises ADD order_index INT NOT NULL DEFAULT 0"
        ))
        conn.commit()
        print("Done. All existing rows have order_index = 0.")


if __name__ == "__main__":
    main()
