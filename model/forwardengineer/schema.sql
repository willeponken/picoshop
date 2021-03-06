SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

/* Create address table */
CREATE TABLE IF NOT EXISTS address (
	PRIMARY KEY (id),
	FOREIGN KEY (customer)
		REFERENCES customer(id)
		ON DELETE CASCADE,

	id INT AUTO_INCREMENT,
	customer INT NOT NULL,
	street VARCHAR(255) NOT NULL,
	care_of VARCHAR(255) NULL,
	zip_code VARCHAR(255) NOT NULL,
	country VARCHAR(255) NOT NULL);

/* Create user_has_addresses table */
CREATE TABLE IF NOT EXISTS user_has_addresses (
	PRIMARY KEY (`user`, address),

	`user` INT NOT NULL,
	address INT NOT NULL);

/* Create user table */
CREATE TABLE IF NOT EXISTS `user` (
	PRIMARY KEY (id),

	UNIQUE INDEX uc_email (email ASC),

	id INT AUTO_INCREMENT,
	email VARCHAR(255) NOT NULL,
	hash BINARY(60) NOT NULL,
	name VARCHAR(255) NOT NULL,
	phone_number VARCHAR(50),
	create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP);

/* Create comments table */
CREATE TABLE IF NOT EXISTS `comment` (
	PRIMARY KEY (id),
	FOREIGN KEY (customer)
		REFERENCES customer(id),
	FOREIGN KEY (article)
		REFERENCES article(id)
		ON DELETE CASCADE,

	id INT AUTO_INCREMENT,
	article INT NOT NULL,
	text VARCHAR(255) NOT NULL,
	create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	customer INT NOT NULL);

/* Create article table */
CREATE TABLE IF NOT EXISTS article (
	PRIMARY KEY (id),
	FOREIGN KEY (category)
		REFERENCES category(name),
	FOREIGN KEY (subcategory)
		REFERENCES subcategory(name),

	id INT AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	description VARCHAR(255) NOT NULL,
	price DECIMAL(11, 4) UNSIGNED NOT NULL, -- decimal with 11 bits and 4 decimals
	image_name VARCHAR(255) NOT NULL,
	category VARCHAR(255) NOT NULL,
	subcategory VARCHAR(255) NOT NULL,
	in_stock INT UNSIGNED DEFAULT 0 NOT NULL,
	nr_up INT UNSIGNED DEFAULT 0 NOT NULL,
	nr_down INT UNSIGNED DEFAULT 0 NOT NULL);


/* Create customer_has_rated type table */
CREATE TABLE IF NOT EXISTS customer_has_rated (
	PRIMARY KEY (id),
	FOREIGN KEY (customer)
		REFERENCES customer(id),
	FOREIGN KEY (article)
		REFERENCES article(id),

	id INT AUTO_INCREMENT,
	customer INT NOT NULL,
	article INT NOT NULL,
	rated TINYINT NOT NULL); -- (0 none), (-1 down), (1 up)

/* Create subcategory table */
CREATE TABLE IF NOT EXISTS subcategory (
	PRIMARY KEY (name),
	FOREIGN KEY (category)
		REFERENCES category(name)
		ON DELETE CASCADE,

	name VARCHAR(255) NOT NULL,
	category VARCHAR(255) NOT NULL);

/* Create subcategory_has_articles table */
CREATE TABLE IF NOT EXISTS subcategory_has_articles (
	PRIMARY KEY (subcategory, article),

	/* articles can never have more than one subcategory */
	UNIQUE INDEX uc_article (article ASC),

	subcategory VARCHAR(255) NOT NULL,
	article INT NOT NULL);

/* Create category table */
CREATE TABLE IF NOT EXISTS category (
	PRIMARY KEY (name),

	name VARCHAR(255) NOT NULL);

/* Create category_has_subcategories table */
CREATE TABLE IF NOT EXISTS category_has_subcategories (
	PRIMARY KEY (category, subcategory),

	/* subcategories can never have more than one category */
	UNIQUE INDEX uc_subcategory (subcategory ASC),

	category VARCHAR(255) NOT NULL,
	subcategory VARCHAR(255) NOT NULL);

/* Create order_has_articles table */
CREATE TABLE IF NOT EXISTS order_has_articles (
	PRIMARY KEY(`order`, article),

	`order` INT NOT NULL,
	article INT NOT NULL,
	price DECIMAL(11, 4) UNSIGNED NOT NULL, -- decimal with 11 bits and 4 decimals
	quantity INT UNSIGNED NOT NULL);

/* Create order table */
CREATE TABLE IF NOT EXISTS `order` (
	PRIMARY KEY (id),
	FOREIGN KEY (customer)
		REFERENCES customer(id),
	FOREIGN KEY (address)
		REFERENCES address(id),

	id INT AUTO_INCREMENT,
	customer INT NOT NULL,
	address INT NOT NULL,
	status INT UNSIGNED NOT NULL DEFAULT 0,
	create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP);

/* Create cart table */
CREATE TABLE IF NOT EXISTS cart (
	PRIMARY KEY (customer, article),

	customer INT NOT NULL,
	article INT NOT NULL,
	quantity INT UNSIGNED NOT NULL);

/* Create user_has_orders table */
CREATE TABLE IF NOT EXISTS customer_has_orders (
	PRIMARY KEY (`user`, `order`),

	`user` INT NOT NULL,
	`order` INT NOT NULL);

/* Create customer table */
CREATE TABLE IF NOT EXISTS customer (
	PRIMARY KEY (id),
	FOREIGN KEY (`user`)
		REFERENCES user(id)
		ON DELETE CASCADE,

	id INT AUTO_INCREMENT,
	`user` INT NOT NULL);

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
