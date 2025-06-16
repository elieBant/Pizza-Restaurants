from server.app import app, db
from server.models.restaurant import Restaurant
from server.models.pizza import Pizza

def seed_data():
    with app.app_context():
        # Clear existing data
        db.drop_all()
        db.create_all()

        # Create sample restaurants
        r1 = Restaurant(name="Kiki's Pizza", address="123 Main St")
        r2 = Restaurant(name="Luigi's Pizzeria", address="456 Elm St")

        # Create sample pizzas
        p1 = Pizza(name="Emma", ingredients="Dough, Tomato Sauce, Cheese")
        p2 = Pizza(name="Pepperoni", ingredients="Dough, Tomato Sauce, Cheese, Pepperoni")

        # Add to session
        db.session.add_all([r1, r2, p1, p2])
        db.session.commit()

        print("Database seeded successfully.")

if __name__ == '__main__':
    seed_data()
