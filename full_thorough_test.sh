#!/bin/bash

# Seed the database before starting the server
pipenv run python -m server.seed

# Run the Flask server in the background
pipenv run python -m server.main &

# Save the server PID to kill later
SERVER_PID=$!

# Wait for the server to start
echo "Waiting for the server to start..."
sleep 5

# Define a helper function to print test titles
print_title() {
  echo -e "\n=============================="
  echo "$1"
  echo "=============================="
}

# Test GET /restaurants
print_title "Testing GET /restaurants"
curl -i http://127.0.0.1:5000/restaurants

# Test GET /restaurants/<id> with valid and invalid IDs
print_title "Testing GET /restaurants/1 (valid)"
curl -i http://127.0.0.1:5000/restaurants/1
print_title "Testing GET /restaurants/9999 (invalid)"
curl -i http://127.0.0.1:5000/restaurants/9999

# Test DELETE /restaurants/<id> with valid and invalid IDs
print_title "Testing DELETE /restaurants/1 (valid)"
curl -i -X DELETE http://127.0.0.1:5000/restaurants/1
print_title "Testing DELETE /restaurants/9999 (invalid)"
curl -i -X DELETE http://127.0.0.1:5000/restaurants/9999

# Test GET /pizzas
print_title "Testing GET /pizzas"
curl -i http://127.0.0.1:5000/pizzas

# Test POST /restaurant_pizzas with valid data
print_title "Testing POST /restaurant_pizzas with valid data"
curl -i -X POST http://127.0.0.1:5000/restaurant_pizzas -H "Content-Type: application/json" -d '{"restaurant_id":2,"pizza_id":1,"price":10}'

# Test POST /restaurant_pizzas with missing price
print_title "Testing POST /restaurant_pizzas with missing price"
curl -i -X POST http://127.0.0.1:5000/restaurant_pizzas -H "Content-Type: application/json" -d '{"restaurant_id":2,"pizza_id":1}'

# Test POST /restaurant_pizzas with invalid price
print_title "Testing POST /restaurant_pizzas with invalid price"
curl -i -X POST http://127.0.0.1:5000/restaurant_pizzas -H "Content-Type: application/json" -d '{"restaurant_id":2,"pizza_id":1,"price":50}'

# Additional edge case tests can be added here

# Kill the Flask server
kill $SERVER_PID
echo "Server stopped."
