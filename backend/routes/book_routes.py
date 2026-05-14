from flask import Blueprint
from controllers.book_controller import add_book, get_books, issue_book

book_routes = Blueprint('book_routes', __name__)

book_routes.route('/books', methods=['GET'])(get_books)
book_routes.route('/add-book', methods=['POST'])(add_book)   
book_routes.route('/issue', methods=['POST'])(issue_book)