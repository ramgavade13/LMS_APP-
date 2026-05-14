from flask import Flask
from flask_cors import CORS

from routes.auth_routes import signup, login
from controllers.book_controller import add_book, get_books, issue_book
from models.book_model import return_book

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return {"message": "VIT Library API running"}

app.add_url_rule('/signup', 'signup', signup, methods=['POST'])
app.add_url_rule('/login', 'login', login, methods=['POST'])
app.add_url_rule('/add-book', 'add_book', add_book, methods=['POST'])
app.add_url_rule('/books', 'get_books', get_books, methods=['GET'])
app.add_url_rule('/issue_book', 'issue_book', issue_book, methods=['POST'])
app.add_url_rule('/return_book', 'return_book', return_book, methods=['POST'])

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)