USE publications;

# CHALLENGE 1 #

SELECT authors.au_id "AUTHOR ID", authors.au_lname "LAST NAME", authors.au_fname "FIRST NAME", titles.title "TITLE", publishers.pub_name "PUBLISHER"
FROM authors
LEFT JOIN titleauthor
ON authors.au_id = titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
LEFT JOIN publishers
ON titles.pub_id = publishers.pub_id;

# CHALLENGE 2 #

SELECT authors.au_id "AUTHOR ID", authors.au_lname "LAST NAME", authors.au_fname "FIRST NAME", publishers.pub_name "PUBLISHER", COUNT(titles.title) as "TITLE COUNT"
FROM authors
LEFT JOIN titleauthor
ON authors.au_id = titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
LEFT JOIN publishers
ON titles.pub_id = publishers.pub_id
GROUP BY authors.au_id
ORDER BY COUNT(titles.title) DESC;

SELECT SUM(checktable.titlecount)
FROM(
SELECT authors.au_id "AUTHOR ID", authors.au_lname "LAST NAME", authors.au_fname "FIRST NAME", publishers.pub_name "PUBLISHER", COUNT(titles.title) as titlecount
FROM authors
LEFT JOIN titleauthor
ON authors.au_id = titleauthor.au_id
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
LEFT JOIN publishers
ON titles.pub_id = publishers.pub_id
GROUP BY authors.au_id) AS checktable; -- THERE ARE 25 ROWS ON TABLE titleauthor

# CHALLENGE 3 #

SELECT authors.au_id "AUTHOR ID", authors.au_lname "LAST NAME", authors.au_fname "FIRST NAME", s.qty "TOTAL"
FROM authors
LEFT JOIN titleauthor ta
ON authors.au_id = ta.au_id
LEFT JOIN titles ti
ON ta.title_id = ti.title_id
LEFT JOIN sales s
ON ti.title_id = s.title_id
GROUP BY authors.au_id
ORDER BY qty DESC
LIMIT 3;

# CHALLENGE 4 #

SELECT au_id "AUTHOR ID", au_lname "LAST NAME", au_fname "FIRST NAME", IFNULL(qty, 0) "TOTAL", RANK() OVER (ORDER BY qty DESC) "RANKING"
FROM(
SELECT authors.au_id, authors.au_lname, authors.au_fname, s.qty
FROM authors
LEFT JOIN titleauthor ta
ON authors.au_id = ta.au_id
LEFT JOIN titles ti
ON ta.title_id = ti.title_id
LEFT JOIN sales s
ON ti.title_id = s.title_id
GROUP BY authors.au_id
ORDER BY qty DESC) AS derivada;

# BONUS CHALLENGE #

