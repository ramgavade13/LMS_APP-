from flask import request, jsonify
from db_config import db

def add_book():
    data = request.get_json()
    print("DATA RECEIVED:", data)

    if data.get("role") != "admin":
        return jsonify({"message": "Unauthorized"}), 403

    title = data.get("title")
    author = data.get("author")
    isbn = data.get("isbn")

    if not title or not author or not isbn:
        return jsonify({"message": "Title, author, isbn required"}), 400

    try:
        cursor = db.cursor()

        cursor.execute("""
            INSERT INTO books
            (title, author, category, isbn, available_copies, total_copies)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            title,
            author,
            data.get("category", "General"),
            isbn,
            data.get("total_copies", 1),
            data.get("total_copies", 1)
        ))

        db.commit()

        return jsonify({"message": "Book added successfully"}), 201

    except Exception as e:
        print("ERROR:", e)
        return jsonify({"message": str(e)}), 500


def get_books():
    try:
        cursor = db.cursor()
        cursor.execute("SELECT * FROM books")
        rows = cursor.fetchall()

        books = []
        for r in rows:
            books.append({
                "id": r[0],
                "title": r[1],
                "author": r[2],
                "category": r[3],
                "isbn": r[4],
                "published_year": r[5],
                "description": r[6],
                "cover_url": r[7],
                "available_copies": r[8],
                "total_copies": r[9],
                "shelf_location": r[10],
                "status": "available" if r[8] > 0 else "unavailable"
            })

        return jsonify(books), 200

    except Exception as e:
        return jsonify({"message": str(e)}), 500



def issue_book():
    data = request.get_json()
    print("ISSUE DATA:", data)

    if data.get("role") not in ["student", "teacher"]:
        return jsonify({"message": "Only students & teachers can issue books"}), 403

    user_id = data.get("user_id")
    book_id = data.get("book_id")

    if not user_id or not book_id:
        return jsonify({"message": "user_id and book_id required"}), 400

    try:
        cursor = db.cursor()

        cursor.execute("SELECT available_copies FROM books WHERE id=%s", (book_id,))
        book = cursor.fetchone()

        if not book:
            return jsonify({"message": "Book not found"}), 404

        if book[0] <= 0:
            return jsonify({"message": "Book not available"}), 400

        cursor.execute("""
            UPDATE books
            SET available_copies = available_copies - 1
            WHERE id=%s AND available_copies > 0
        """, (book_id,))

        cursor.execute("""
            INSERT INTO issued_books (user_id, book_id)
            VALUES (%s, %s)
        """, (user_id, book_id))

        db.commit()

        return jsonify({"message": "Book issued successfully"}), 200

    except Exception as e:
        print("ERROR:", e)
        return jsonify({"message": str(e)}), 500


def return_book():
    data = request.get_json()
    user_id = data.get("user_id")
    book_id = data.get("book_id")

    try:
        cursor = db.cursor()

        cursor.execute("""
            DELETE FROM issued_books
            WHERE user_id=%s AND book_id=%s
        """, (user_id, book_id))

        cursor.execute("""
            UPDATE books
            SET available_copies = available_copies + 1
            WHERE id=%s
        """, (book_id,))

        db.commit()

        return jsonify({"message": "Book returned successfully"}), 200

    except Exception as e:
        return jsonify({"message": str(e)}), 500