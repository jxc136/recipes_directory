# {{Recipes} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

see /reicpes_directory_recipe

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE recipes RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.


  INSERT INTO recipes (name, cooking_time, rating) VALUES ('Simple Scrambled Eggs', 10, 3);
  INSERT INTO recipes (name, cooking_time, rating) VALUES ('Slow Cooker White Chicken Chilli', 240, 5 );
  INSERT INTO recipes (name, cooking_time, rating) VALUES ('Quick Chicken Korma', 30, 3 );
  INSERT INTO recipes (name, cooking_time, rating) VALUES ('roast chicken', 60, 5 );
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: recipes 

# Model class
# (in lib/recipe.rb)
class Recipe
end

# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: Recipes

# Model class
# (in lib/recipe.rb)

class Recipe 
  attr_accessor :id, :name, :cooking_time, :rating
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: recipes

# Repository class
# (in lib/recipe_repository.rb)

class RecipeRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipes;

    # Returns an array of Recipe objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipes; WHERE id = $1;

    # Returns a single Recipe object.
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1 Get all recipes 

repo = RecipeRepository.new

recipes = repo.all

recipes.length # =>  4

recipes[0].id # =>  1
recipes[0].name # =>  'Simple Scrambled Eggs'
recipes[0].cooking_time # =>  '10'
recipes[0].rating # =>  '3'

recipes[1].id # =>  2
recipes[1].name # =>  'Slow Cooker White Chicken Chilli'
recipes[1].cooking_time # =>  '240'
recipes[1].rating # =>  '5'

recipes[3].id # =>  4
recipes[3].name # => 'roast chicken'
recipes[3].cooking_time # =>  '60'
recipes[3].rating # =>  '5'

# 2
# Get a single recipe

repo = RecipeRepository.new

recipe = repo.find(1)

recipe.id # =>  1
recipe.name # =>  'Simple Scrambled Eggs'
recipe.cooking_time # =>  '10'
recipe.rating # =>  '3'

recipe2 = repo.find(2)

recipe2.id # =>  2
recipe2.name # =>  'Slow Cooker White Chicken Chilli'
recipe2.cooking_time # =>  '240'
recipe2.rating # =>  '5'



# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby

# file: spec/recipe_repository_spec.rb

def reset_recipe_table
  seed_sql = File.read('spec/seeds_recipes.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'recipe_test' })
  connection.exec(seed_sql)
end

describe RecipeRepository do
  before(:each) do 
    reset_recipe_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
