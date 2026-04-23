INSERT INTO users (uname, uemail, upassword, unumber)
VALUES 
('user', 'user@example.com', '1234', 1234567890),
('sara', 'sara@example.com', 'pass123', 9876543210),
('alex', 'alex@example.com', 'letmein', 5551239876);

INSERT INTO product_table (
  pname, pprice, pdescription,
  default_serving_size, initial_stock,
  calories_per_serving, protein_grams, carbohydrate_grams, fat_grams
)
VALUES (
  'Chicken Biryani', 410, 'Chicken biryani',
  1, 0,
  0, 0, 0, 0
);