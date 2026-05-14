from flask import request, jsonify
from models.user_model import create_user, get_user, get_user_by_email

def signup():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")
    role = data.get("role")

    if not email or not password or not role:
        return jsonify({"message": "All fields required"}), 400

    if get_user_by_email(email):
        return jsonify({"message": "User already exists"}), 400

    create_user(email, password, role)

    return jsonify({"message": "Signup successful"})


def login():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    user = get_user(email, password)

    if user:
        return jsonify({
            "message": "Login success",
            "user_id": user[0],
            "email": user[1],
            "role": user[3] 
        })
    else:
        return jsonify({"message": "Invalid credentials"}), 401