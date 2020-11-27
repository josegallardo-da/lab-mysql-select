USE publications;

# CHALLENGE 1 - Who Have Published What At Where?

SELECT authors.au_id `AUTHOR ID`, authors.au_lname `LAST NAME`, authors.au_fname `FIRST NAME`, titles.title `TITLE`, publishers.pub_name `PUBLISHER`
FROM authors
LEFT JOIN titleauthor
ON authors.au_id = titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
LEFT JOIN publishers
ON titles.pub_id = publishers.pub_id;

# CHALLENGE 2 - Who Have Published How Many At Where?

SELECT authors.au_id `AUTHOR ID`, authors.au_lname `LAST NAME`, authors.au_fname `FIRST NAME`, publishers.pub_name `PUBLISHER`, COUNT(titles.title) as `TITLE COUNT`
FROM authors
LEFT JOIN titleauthor
ON authors.au_id = titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
LEFT JOIN publishers
ON titles.pub_id = publishers.pub_id
GROUP BY authors.au_id, publishers.pub_name
ORDER BY COUNT(titles.title) DESC;

SELECT SUM(checktable.titlecount)
FROM(
SELECT authors.au_id `AUTHOR ID`, authors.au_lname `LAST NAME`, authors.au_fname `FIRST NAME`, publishers.pub_name `PUBLISHER`, COUNT(titles.title) as titlecount
FROM authors
LEFT JOIN titleauthor
ON authors.au_id = titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
LEFT JOIN publishers
ON titles.pub_id = publishers.pub_id
GROUP BY authors.au_id) AS checktable; -- THERE ARE 25 ROWS ON TABLE titleauthor

# CHALLENGE 3 - Best Selling Authors

SELECT authors.au_id `AUTHOR ID`, authors.au_lname `LAST NAME`, authors.au_fname `FIRST NAME`, sum(s.qty) `TOTAL`
FROM authors
LEFT JOIN titleauthor ta
ON authors.au_id = ta.au_id
LEFT JOIN titles ti
ON ta.title_id = ti.title_id
LEFT JOIN sales s
ON ti.title_id = s.title_id
GROUP BY authors.au_id
ORDER BY TOTAL DESC
LIMIT 3;

# CHALLENGE 4 - Best Selling Authors Ranking

SELECT a.au_id `AUTHOR ID`, a.au_lname `LAST NAME`, a.au_fname `FIRST NAME`, SUM(IFNULL(s.qty, 0)) TOTAL,
RANK () OVER (ORDER BY SUM(IFNULL(s.qty, 0)) DESC) Ranking 
FROM authors a
LEFT JOIN titleauthor ta
ON a.au_id = ta.au_id
LEFT JOIN titles ti
ON ta.title_id = ti.title_id
LEFT JOIN sales s
ON ti.title_id = s.title_id
GROUP BY a.au_id
ORDER BY SUM(s.qty) DESC

# BONUS CHALLENGE - Most Profiting Authors

SELECT IFNULL(temporal2.au_id, "Anonymous") `AUTHOR ID`, a.au_lname `LAST NAME`, a.au_fname `FIRST NAME`, SUM(profit) as `Profits` 
FROM (
SELECT au_id, title_id, ((((qty * royalty) + advance) * royaltyper) / 100) profit
FROM (
SELECT ta.au_id, ti.title_id, IFNULL(s.qty,0) qty, IFNULL(ti.royalty,0) royalty, IFNULL(ti.advance,0) advance, IFNULL(ta.royaltyper,0) royaltyper
FROM titles ti
LEFT JOIN sales s
ON ti.title_id = s.title_id
LEFT JOIN titleauthor ta
ON ti.title_id = ta.title_id
ORDER BY s.qty DESC
) AS temporal ) AS temporal2
LEFT JOIN authors a
ON temporal2.au_id = a.au_id
GROUP BY `AUTHOR ID` 
ORDER BY Profits DESC
LIMIT 3; 
