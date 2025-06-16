#!/bin/bash

# Run the Flask server in the background
pipenv run python -m server.main &

# Save the server PID to kill later
SERVER_PID=$!

# Wait for the server to start
echo "Waiting for the server to start..."
sleep 5

# Test GET /restaurants
echo "Testing GET /restaurants"
curl -i http://127.0.0.1:5000/restaurants
echo -e "\n"

# Test GET /restaurants/1 (valid and invalid)
echo "Testing GET /restaurants/1"
curl -i http://127.0.0.1:5000/restaurants/1
echo -e "\n"
echo "Testing GET /restaurants/9999 (non-existent)"
curl -i http://127.0.0.1:5000/restaurants/9999
echo -e "\n"

# Test DELETE /restaurants/1 (valid and invalid)
echo "Testing DELETE /restaurants/1"
curl -i -X DELETE http://127.0.0.1:5000/restaurants/1
echo -e "\n"
echo "Testing DELETE /restaurants/9999 (non-existent)"
curl -i -X DELETE http://127.0.0.1:5000/restaurants/9999
echo -e "\n"

# Test GET /pizzas
echo "Testing GET /pizzas"
curl -i http://127.0.0.1:5000/pizzas
echo -e "\n"

# Test POST /restaurant_pizzas with valid data
echo "Testing POST /restaurant_pizzas with valid data"
curl -i -X POST http://127.0.0.1:5000/restaurant_pizzas -H "Content-Type: application/json" -d '{"restaurant_id":2,"pizza_id":1,"price":15}'
echo -e "\n"

# Test POST /restaurant_pizzas with missing price
echo "Testing POST /restaurant_pizzas with missing price"
curl -i -X POST http://127.0.0.1:5000/restaurant_pizzas -H "Content-Type: application/json" -d '{"restaurant_id":2,"pizza_id":1}'
echo -e "\n"

# Test POST /restaurant_pizzas with invalid price
echo "Testing POST /restaurant_pizzas with invalid price"
curl -i -X POST http://127.0.0.1:5000/restaurant_pizzas -H "Content-Type: application/json" -d '{"restaurant_id":2,"pizza_id":1,"price":50}'
echo -e "\n"

# Kill the Flask server
kill $SERVER_PID
echo "Server stopped."
