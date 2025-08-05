-- Tạo database
CREATE DATABASE IF NOT EXISTS app_food;
USE app_food;

-- Tạo bảng user
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100)
);

-- Tạo bảng restaurant
CREATE TABLE restaurant (
    res_id INT AUTO_INCREMENT PRIMARY KEY,
    res_name VARCHAR(100),
    image VARCHAR(255),
    `desc` VARCHAR(255)
);

-- Tạo bảng food_type
CREATE TABLE food_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100)
);

-- Tạo bảng food
CREATE TABLE food (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(100),
    image VARCHAR(255),
    price FLOAT,
    `desc` VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

-- Tạo bảng sub_food
CREATE TABLE sub_food (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    sub_name VARCHAR(100),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Tạo bảng order
CREATE TABLE `order` (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(100),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Tạo bảng like_res
CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng rate_res
CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);



SELECT u.user_id, u.full_name, COUNT(*) AS like_count
FROM like_res lr
JOIN user u ON u.user_id = lr.user_id
GROUP BY lr.user_id
ORDER BY like_count DESC
LIMIT 5;

-- 2. Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT r.res_id, r.res_name, COUNT(*) AS like_count
FROM like_res lr
JOIN restaurant r ON r.res_id = lr.res_id
GROUP BY lr.res_id
ORDER BY like_count DESC
LIMIT 2;

-- 3. Tìm người đã đặt hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(*) AS order_count
FROM `order` o
JOIN user u ON u.user_id = o.user_id
GROUP BY o.user_id
ORDER BY order_count DESC
LIMIT 1;

-- 4. Tìm người dùng không hoạt động
SELECT u.user_id, u.full_name
FROM user u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res lr ON u.user_id = lr.user_id
LEFT JOIN rate_res rr ON u.user_id = rr.user_id
WHERE o.user_id IS NULL
  AND lr.user_id IS NULL
  AND rr.user_id IS NULL;
