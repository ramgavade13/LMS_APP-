from db_config import db

cursor = db.cursor()

def create_user(email, password, role):
    cursor.execute(
        "INSERT INTO user (email, password, role) VALUES (%s, %s, %s)",
        (email, password, role)
    )
    db.commit()

def get_user_by_email(email):
    cursor.execute("SELECT * FROM user WHERE email=%s", (email,))
    return cursor.fetchone()

def get_user(email, password):
    cursor.execute(
        "SELECT * FROM user WHERE email=%s AND password=%s",
        (email, password)
    )
    return cursor.fetchone()