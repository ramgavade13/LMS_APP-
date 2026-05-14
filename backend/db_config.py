import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Anita@1994",  
    database="vit_library"
)


__all__ = ['db']