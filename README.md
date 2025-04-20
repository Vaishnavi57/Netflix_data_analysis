# Netflix_data_analysis
This project is focused on cleaning and analyzing the Netflix dataset using SQL Server and Python. The dataset contains details about various shows and movies available on Netflix, such as their titles, directors, genres, duration, cast, countries, and more.

## Tools & Technologies Used
SQL Server: For data cleaning, transformation, and writing queries.

Jupyter Notebook (Python): For initial data exploration, SQL Server connection, and schema adjustments.

GitHub: For version control and showcasing the project.

## Project Workflow
## 1.Data Cleaning

### Performed using SQL Server and Python.

### Schema Optimization:

Converted title column from varchar to nvarchar to support Unicode characters.

Adjusted column sizes as all were initially set to MAX, which was unnecessary.

Dropped the existing netflix_raw table and reloaded a new one with optimized schema using Python.

### Null Handling:

Populated missing country values by finding other records from the same director and inferring the likely country.

Handled duration nulls: for some rows, duration values were wrongly placed in the rating column. Interchanged values appropriately.

### Duplicate Removal:

Removed duplicate records based on a combination of title and type, keeping only the first occurrence using ROW_NUMBER().

### Created Final Clean Table:

All cleaned and standardized data was saved into a new table named netflix

## Data Normalization
Normalized multi-valued columns using SQL Server's STRING_SPLIT() function:

netflix_directors: Extracted multiple directors into individual rows.

netflix_genre: Split the listed_in genre column into separate genres.

netflix_cast: Separated multiple cast members into individual rows.

netflix_country: Handled multiple countries listed for a show.

## Data Analysis Queries
🎬 Which directors have created both movies and TV shows?

🌍 Which country has the highest number of comedies?

🏆 Top director by number of movies released each year.

⏱️ Average duration of movies by genre.

😱😂 Directors who have made both horror and comedy movies.
