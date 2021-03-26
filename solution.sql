----PRACTICE JOINS----

--1 (needed help)
SELECT * FROM invoice
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
WHERE invoice_line.unit_price > 0.99;

--2 (needed help)
SELECT invoice.invoice_date, customer.first_name, customer.last_name, invoice.total
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id;

--3
SELECT customer.first_name, customer.last_name, employee.first_name, employee.last_name
FROM customer
JOIN employee ON customer.support_rep_id = employee.employee_id;

--4
SELECT customer.first_name, customer.last_name, employee.first_name, employee.last_name
FROM customer
JOIN employee ON customer.support_rep_id = employee.employee_id;

--5
SELECT playlist_track.track_id
FROM playlist_track
JOIN playlist ON playlist_track.playlist_id = playlist.playlist_id
WHERE playlist.name = 'Music';

--6
SELECT track.name
FROM track
JOIN playlist_track ON track.track_id = playlist_track.track_id
WHERE playlist_track.playlist_id = 5;

--7
SELECT track.name, playlist.name
FROM track
JOIN playlist_track ON track.track_id = playlist_track.track_id
JOIN playlist ON playlist_track.playlist_id = playlist.playlist_id;

--8
SELECT track.name, album.title
FROM track
JOIN genre ON track.genre_id = genre.genre_id
JOIN album ON  track.album_id = album.album_id
WHERE genre.name = 'Alternative & Punk';


----PRACTICE NESTED QUERIES----

--1 (needed help)
SELECT *
FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);

--2 (needed help)
SELECT * 
FROM playlist_track
WHERE playlist_id IN
	(SELECT playlist_id FROM playlist WHERE name = 'Music');

--3
SELECT name 
FROM track
WHERE track_id IN
	(SELECT track_id FROM playlist_track WHERE playlist_id = 5);

--4
SELECT *
FROM track
WHERE genre_id IN
	(SELECT genre_id FROM genre WHERE name = 'Comedy');

--5
SELECT *
FROM track
WHERE album_id IN 
	(SELECT album_id FROM album WHERE title = 'Fireball');

--6
SELECT *
FROM track
WHERE album_id IN
	(SELECT album_id FROM album WHERE artist_id IN
   (SELECT artist_id FROM artist WHERE name = 'Queen'));


----PRACTICE UPDATING ROWS----

--1 (needed help)
UPDATE customer
SET fax = null
WHERE fax IS NOT null;

--2
UPDATE customer
SET company = 'Self'
WHERE company = null;

--3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

--4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

--5
UPDATE track
SET composer = 'The darkness around us'
WHERE composer IS null AND genre_id IN
	(SELECT genre_id FROM genre WHERE name = 'Metal');



----GROUP BY----

--1 (needed help)
SELECT COUNT(*), genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY genre.name;

--2
SELECT COUNT(*), genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Pop' OR genre.name = 'Rock'
GROUP BY genre.name;

--3
SELECT artist.name, COUNT(*)
FROM album
JOIN artist ON album.artist_id = artist.artist_id
GROUP BY artist.name;


----USE DISTINCT----

--1
SELECT DISTINCT composer
FROM track;

--2
SELECT DISTINCT billing_postal_code
FROM invoice;

--3
SELECT DISTINCT company
FROM customer;


----DELETE ROWS----

--1
--nothing to do here

--2
DELETE FROM practice_delete WHERE type = 'bronze';

--3
DELETE FROM practice_delete WHERE type = 'silver';

--4
DELETE FROM practice_delete WHERE value = 150;


----ECOMMERCE SIMULATION----
CREATE TABLE users (
    name VARCHAR(255), 
    email VARCHAR(255), 
    user_id SERIAL PRIMARY KEY
);

INSERT INTO users (name, email)
VALUES ('Rachel Green', 'rachgreen@email.com');
INSERT INTO users (name, email)
VALUES ('Monica Geller', 'harmonica@email.com');
INSERT INTO users (name, email)
VALUES ('Phoebe Buffay', 'phoebs@email.com');

CREATE TABLE products (
    name VARCHAR(255), 
    price INTEGER, 
    product_id SERIAL PRIMARY KEY
);

INSERT INTO products (name, price)
VALUES ('coffee', 4);
INSERT INTO products (name, price)
VALUES ('magazine', 10);
INSERT INTO products (name, price)
VALUES ('couch', 800);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY, 
    user_id INTEGER references users(user_id), 
    product_id INTEGER references products(product_id)
);

INSERT INTO orders (user_id, product_id)
VALUES (1, 1);
INSERT INTO orders (user_id, product_id)
VALUES (2, 3);
INSERT INTO orders (user_id, product_id)
VALUES (3, 2);
INSERT INTO orders (user_id, product_id)
VALUES (2, 3);
INSERT INTO orders (user_id, product_id)
VALUES (3, 1);
INSERT INTO orders (user_id, product_id)
VALUES (1, 2);

--Get all products for the first order.
SELECT products.name
FROM products
JOIN orders ON products.product_id = orders.product_id
WHERE orders.order_id = 1;

--Get all orders.
SELECT * FROM orders;

--Get the total cost of an order (sum the price of all products on an order).
SELECT SUM(price)
FROM products
JOIN orders ON products.product_id = orders.product_id
WHERE orders.order_id = 2;

--Get all orders for a user.
SELECT *
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 2;

--Get how many orders each user has.
SELECT COUNT(order_id)
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 1;

SELECT COUNT(order_id)
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 2;

SELECT COUNT(order_id)
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 3;
