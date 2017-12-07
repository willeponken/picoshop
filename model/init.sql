SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

/* Create address table */
CREATE TABLE IF NOT EXISTS address (
	PRIMARY KEY (id),

	id INT AUTO_INCREMENT,
	street VARCHAR(255) NOT NULL,
	care_of VARCHAR(255) NULL,
	zip_code INT(11) NOT NULL,
	country VARCHAR(255) NOT NULL);

/* Create user_has_address table */
CREATE TABLE IF NOT EXISTS user_has_address (
	PRIMARY KEY (id),
	FOREIGN KEY (address) REFERENCES address(id),

	id INT AUTO_INCREMENT,
	address INT NOT NULL);

/* Create user table */
CREATE TABLE IF NOT EXISTS `user` (
	PRIMARY KEY (id),
	FOREIGN KEY (addresses)
		REFERENCES user_has_address(id)
		ON DELETE CASCADE,

	UNIQUE INDEX uc_email (email ASC),

	id INT AUTO_INCREMENT,
	email VARCHAR(255) NOT NULL,
	hash BINARY(60) NOT NULL,
	name VARCHAR(255) NOT NULL,
	phone_number VARCHAR(50),
	create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	addresses INT NULL);

/* Create comments table */
CREATE TABLE IF NOT EXISTS comments (
	PRIMARY KEY (id),
	FOREIGN KEY (customer)
		REFERENCES customer(id),

	id INT NOT NULL,
	rating DECIMAL(10, 0) NOT NULL, -- rating between 0-10 stars
	text VARCHAR(255),
	create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	customer INT NOT NULL);

/* Create article table */
CREATE TABLE IF NOT EXISTS article (
	PRIMARY KEY (id),
	FOREIGN KEY (comments)
		REFERENCES comments(id),

	id INT AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	description VARCHAR(255) NOT NULL,
	price DECIMAL(11, 4) NOT NULL, -- decimal with 11 bits and 4 decimals
	image_name VARCHAR(255) NOT NULL,
	comments INT NULL);

/* Create order_has_articles table */
CREATE TABLE IF NOT EXISTS order_has_articles (
	PRIMARY KEY(id),
	FOREIGN KEY(article)
		REFERENCES article(id),

	id INT NOT NULL,
	article INT NOT NULL
	);

/* Create order table */
CREATE TABLE IF NOT EXISTS `order` (
	PRIMARY KEY (id),
	FOREIGN KEY (customer)
		REFERENCES customer(id),
	FOREIGN KEY (address)
		REFERENCES address(id),
	FOREIGN KEY (articles)
		REFERENCES order_has_articles(id),

	id INT AUTO_INCREMENT,
	customer INT NOT NULL,
	address INT NOT NULL,
	status INT(3) NOT NULL, -- status, future proof with 3 long int
	articles INT NOT NULL,
	create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP);

/* Create user_has_orders table */
CREATE TABLE IF NOT EXISTS customer_has_orders (
	PRIMARY KEY (id),
	FOREIGN KEY (`order`)
		REFERENCES `order`(id),

	id INT AUTO_INCREMENT,
	`order` INT NULL);

/* Create customer table */
CREATE TABLE IF NOT EXISTS customer (
	PRIMARY KEY (id),
	FOREIGN KEY (user)
		REFERENCES user(id)
		ON DELETE CASCADE,
	FOREIGN KEY (orders)
		REFERENCES customer_has_orders(id),

	id INT AUTO_INCREMENT,
	user INT NOT NULL,
	orders INT NULL);

/* Create admin table */
CREATE TABLE IF NOT EXISTS admin (
	PRIMARY KEY (id),
	FOREIGN KEY (user)
		REFERENCES user(id)
		ON DELETE CASCADE,

	id INT AUTO_INCREMENT NOT NULL,
	user INT NOT NULL);

/* Create warehouse table */
CREATE TABLE IF NOT EXISTS warehouse (
	PRIMARY KEY (id),
	FOREIGN KEY (user)
		REFERENCES user(id)
		ON DELETE CASCADE,

	id INT AUTO_INCREMENT NOT NULL,
	user INT NOT NULL);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
