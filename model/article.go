package model

import (
	"database/sql"
	"log"
)

type Article struct {
	Id          int64
	Name        string
	Description string
	Price       float64
	ImageName   string
	Category    Category
	Subcategory Subcategory
	InStock     uint64
}

func NewArticle(name, description string, price float64, imageName string, categoryName string, subcategoryName string, inStock uint64) Article {
	return Article{
		Name:        name,
		Description: description,
		Price:       price,
		ImageName:   imageName,
		Category:    NewCategory(categoryName),
		Subcategory: NewSubcategory(subcategoryName),
		InStock:     inStock,
	}
}

func scanArticle(row *sql.Row) (article Article, err error) {
	var categoryName, subcategoryName string
	row.Scan(&article.Id, &article.Name, &article.Description, &article.Price, &article.ImageName, &categoryName, &subcategoryName, &article.InStock)

	article.Category = NewCategory(categoryName)
	article.Subcategory = NewSubcategory(subcategoryName)

	return
}

func scanArticles(rows *sql.Rows) (articles []Article, err error) {
	var article Article
	var categoryName, subcategoryName string
	for rows.Next() {
		article = Article{}

		err = rows.Scan(
			&article.Id, &article.Name, &article.Description, &article.Price, &article.ImageName, &categoryName, &subcategoryName, &article.InStock)
		if err != nil {
			log.Panicln(err)
		}

		article.Category = NewCategory(categoryName)
		article.Subcategory = NewSubcategory(subcategoryName)
		articles = append(articles, article)
	}

	err = rows.Err()
	return
}

func SearchForArticles(query string) (articles []Article, err error) {
	rows, err := database.Query(`
		SELECT id, name, description, price, image_name, category, subcategory, in_stock
		FROM article WHERE name LIKE ?`, "%"+query+"%")
	if err != nil {
		return
	}

	defer rows.Close()

	articles, err = scanArticles(rows)

	return
}

func PutArticle(article Article) (Article, error) {
	ensureSubcategoryWithCategory(article.Category, article.Subcategory)

	result, err := database.Exec(`
		INSERT INTO article
		(name, description, price, image_name, category, subcategory, in_stock)
		VALUES
		(?, ?, ?, ?, ?, ?, ?)
	`, &article.Name, &article.Description, &article.Price, &article.ImageName, &article.Category.Name, &article.Subcategory.Name, &article.InStock)
	if err != nil {
		return Article{}, err
	}

	article.Id, err = result.LastInsertId()

	_, err = database.Exec(`
		INSERT INTO subcategory_has_articles
		(subcategory, article)
		VALUES
		(?, ?)
	`, &article.Subcategory.Name, &article.Id)

	return article, err
}

func GetArticlesFromSubcategory(subcategory Subcategory) (articles []Article, err error) {
	rows, err := database.Query(`
		SELECT a.id, a.name, a.description, a.price, a.image_name, a.category, a.subcategory, a.in_stock
		FROM subcategory s
		WHERE s.id=?

		INNER JOIN subcategory_has_articles h
		ON s.articles = h.id

		INNER JOIN article a
		ON h.article = a.id
	`, subcategory.Name)
	if err != nil {
		return
	}

	defer rows.Close()

	articles, err = scanArticles(rows)

	return
}

func GetArticleHighlights(n uint) (articles []Article, err error) {
	rows, err := database.Query(`
		SELECT id, name, description, price, image_name, category, subcategory, in_stock
		FROM article
		WHERE rand() <= 0.3
		LIMIT ?
	`, n)
	if err != nil {
		return
	}

	defer rows.Close()

	articles, err = scanArticles(rows)

	return
}

func GetArticleById(id int64) (article Article, err error) {
	article, err = scanArticle(database.QueryRow(`
		SELECT id, name, description, price, image_name, category, subcategory, in_stock
		FROM article
		WHERE id=?
	`, id))

	return
}

func GetArticlesByCategory(category string) (articles []Article, err error) {
	rows, err := database.Query(`
		SELECT a.id, a.name, a.description, a.price, a.image_name, a.category, a.subcategory, a.in_stock
		FROM category_has_subcategories c
		INNER JOIN subcategory_has_articles s
		ON c.subcategory=s.subcategory
		INNER JOIN article a
		ON s.article=a.id
		WHERE a.category=?
		ORDER BY a.name
	`, category)
	if err != nil {
		return
	}

	defer rows.Close()

	articles, err = scanArticles(rows)

	return
}

func GetArticlesBySubcategory(subcategory string) (articles []Article, err error) {
	rows, err := database.Query(`
		SELECT a.id, a.name, a.description, a.price, a.image_name, a.category, a.subcategory, a.in_stock
		FROM subcategory_has_articles s
		INNER JOIN article a
		ON s.article=a.id
		WHERE s.subcategory=?
		ORDER BY a.name
	`, subcategory)
	if err != nil {
		return
	}

	defer rows.Close()

	articles, err = scanArticles(rows)

	return
}
