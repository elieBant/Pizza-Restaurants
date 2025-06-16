# Pizza Restaurant API Challenge

## Overview
This project is a RESTful API for a Pizza Restaurant built using Flask. It implements models, validations, and routes following the MVC pattern. No frontend is included. The API can be tested using Postman or curl.

## Project Structure
```
.
├── server/
│   ├── __init__.py
│   ├── app.py                # App setup
│   ├── config.py             # DB config, etc.
│   ├── models/               # Models (SQLAlchemy)
│   │   ├── __init__.py
│   │   ├── restaurant.py
│   │   ├── pizza.py
│   │   └── restaurant_pizza.py
│   ├── controllers/          # Route handlers (Controllers)
│   │   ├── __init__.py
│   │   ├── restaurant_controller.py
│   │   ├── pizza_controller.py
│   │   └── restaurant_pizza_controller.py
│   ├── seed.py               # Seed data script
├── migrations/               # Database migrations
├── README.md                 # This file
```

## Setup Instructions

1. Create a virtual environment and install packages:
```bash
pipenv install flask flask_sqlalchemy flask_migrate
pipenv shell
```

2. Run database setup commands:
```bash
export FLASK_APP=server.app
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

3. Seed the database with initial data:
```bash
python server/seed.py
```

## Models

### Restaurant
- `id`: primary key
- `name`: string, required
- `address`: string, required
- Relationships: has many `RestaurantPizzas` (cascade delete)

### Pizza
- `id`: primary key
- `name`: string, required
- `ingredients`: string, required
- Relationships: has many `RestaurantPizzas` (cascade delete)

### RestaurantPizza (Join table)
- `id`: primary key
- `price`: integer, required, must be between 1 and 30
- `restaurant_id`: foreign key to `Restaurant`
- `pizza_id`: foreign key to `Pizza`
- Relationships: belongs to `Restaurant` and `Pizza`

## Routes

### Restaurants
- `GET /restaurants`  
  Returns a list of all restaurants.

- `GET /restaurants/<int:id>`  
  Returns details of a single restaurant and its pizzas.  
  If not found → `{ "error": "Restaurant not found" }` with 404 status.

- `DELETE /restaurants/<int:id>`  
  Deletes a restaurant and all related `RestaurantPizzas`.  
  If successful → 204 No Content  
  If not found → `{ "error": "Restaurant not found" }` with 404 status.

### Pizzas
- `GET /pizzas`  
  Returns a list of all pizzas.

### RestaurantPizzas
- `POST /restaurant_pizzas`  
  Creates a new `RestaurantPizza`.  
  Request JSON example:  
  ```json
  { "price": 5, "pizza_id": 1, "restaurant_id": 3 }
  ```  
  Success response example:  
  ```json
  {
    "id": 4,
    "price": 5,
    "pizza_id": 1,
    "restaurant_id": 3,
    "pizza": { "id": 1, "name": "Emma", "ingredients": "Dough, Tomato Sauce, Cheese" },
    "restaurant": { "id": 3, "name": "Kiki's Pizza", "address": "address3" }
  }
  ```  
  Error response example:  
  ```json
  { "errors": ["Price must be between 1 and 30"] }
  ```  
  With 400 Bad Request status.

## Validation Rules
- `RestaurantPizza.price` must be between 1 and 30.
- `pizza_id` and `restaurant_id` must reference existing records.

## Testing
You can test the API using Postman or curl. A Postman collection file (`challenge-1-pizzas.postman_collection.json`) can be imported for convenience.

## Notes
- This is a development server. For production, use a production WSGI server.
- The database used is SQLite (`pizza.db`).
