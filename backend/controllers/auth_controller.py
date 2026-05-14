from flask import request, jsonify
from models.user_model import create_user, get_user, get_user_by_email

def signup():
    data = request.get_json(force=True)

    print("Signup data:", data)

    name = data.get("name")
    email = data.get("email")
    password = data.get("password")
    role = data.get("role") 

    if not name or not email or not password or not role:
        return jsonify({"message": "All fields required"}), 400

    
    existing_user = get_user_by_email(email)
    if existing_user:
        return jsonify({"message": "User already exists"}), 400

    # create user
    create_user(name, email, password, role)

    return jsonify({"message": "Signup successful"}), 201


# 🔹 LOGIN
def login():
    data = request.get_json(force=True)

    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"message": "Email and password required"}), 400

    user = get_user(email, password) 

    if user:
        return jsonify({
            "message": "Login success",
            "user_id": user[0],
            "name": user[1],
            "email": user[2],
            "role": user[3]  
        })
    else:
        return jsonify({"message": "Invalid credentials"}), 401