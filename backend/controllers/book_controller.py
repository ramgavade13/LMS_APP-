from flask import request, jsonify
from db_config import db

cursor = db.cursor()


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


def add_book():
    data = request.get_json(force=True)

    role = data.get("role")

    
    if role != "admin":
        return jsonify({"message": "Unauthorized"}), 403

    # 📥 Safe values
    title = data.get("title")
    author = data.get("author")
    category = data.get("category", "")
    isbn = data.get("isbn", "")
    published_year = data.get("published_year", None)
    description = data.get("description", "")
    cover_url = data.get("cover_url", "")
    total_copies = data.get("total_copies", 1)
    shelf_location = data.get("shelf_location", "")

    
    if not title or not author:
        return jsonify({"message": "Title & Author required"}), 400

    try:
        cursor.execute("""
INSERT INTO books 
(title, author, category, isbn, available_copies, total_copies)
VALUES (%s,%s,%s,%s,%s,%s)
""", (
    data.get("title"),
    data.get("author"),
    data.get("category", "General"),
    data.get("isbn", "000"),
    data.get("total_copies", 1),
    data.get("total_copies", 1)
))

        db.commit()

        return jsonify({"message": "Book added successfully"}), 201

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

        # ✅ CHECK AVAILABLE COPIES FIRST
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