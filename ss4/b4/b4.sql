CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    status BIT NOT NULL DEFAULT 1
);

CREATE TABLE Film (
    film_id INT PRIMARY KEY AUTO_INCREMENT,
    film_name VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    duration TIME NOT NULL,
    director VARCHAR(50),
    release_date DATE NOT NULL
);

CREATE TABLE Category_Film (
    category_id INT NOT NULL,
    film_id INT NOT NULL,
    PRIMARY KEY (category_id, film_id)
);


ALTER TABLE Category_Film
ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE;

ALTER TABLE Category_Film 
ADD CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES Film(film_id) ON DELETE CASCADE;

ALTER TABLE Film
ADD COLUMN status TINYINT DEFAULT 1;

ALTER TABLE Category
DROP COLUMN status;

ALTER TABLE Category_Film DROP FOREIGN KEY fk_category;
ALTER TABLE Category_Film DROP FOREIGN KEY fk_film;
