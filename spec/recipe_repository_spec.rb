require 'recipe_repository'

RSpec.describe RecipeRepository do 

  def reset_recipe_table
    seed_sql = File.read('spec/seeds_recipes.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test ' })
    connection.exec(seed_sql)
  end


  before(:each) do 
    reset_recipe_table
  end

  it 'Gets all recipes' do 

    repo = RecipeRepository.new
    recipes = repo.all

    expect(recipes.length).to eq 4
    expect(recipes[0].id).to eq  '1'
    expect(recipes[1].name).to eq  'Slow Cooker White Chicken Chilli'
    expect(recipes[2].cooking_time).to eq  '30'
    expect(recipes[3].rating).to eq  '5'
    
  end 

  it 'gets the first recipe in the databse' do 

    repo = RecipeRepository.new
    recipe = repo.find(1)
    expect(recipe.id).to eq '1'
    expect(recipe.name).to eq 'Simple Scrambled Eggs'
    expect(recipe.cooking_time).to eq '10'
    expect(recipe.rating).to eq '3'
    
  end

  it 'finds the second recipe in the databse' do 

    repo2 = RecipeRepository.new
    recipe2 = repo2.find(2)
    expect(recipe2.id).to eq '2'
    expect(recipe2.name).to eq 'Slow Cooker White Chicken Chilli'
    expect(recipe2.cooking_time).to eq '240'
    expect(recipe2.rating).to eq '5'
    
  end

  it 'finds the last recipe in the databse' do 

    repo3 = RecipeRepository.new
    recipe3 = repo3.find(4)
    expect(recipe3.id).to eq '4'
    expect(recipe3.name).to eq 'roast chicken'
    expect(recipe3.cooking_time).to eq '60'
    expect(recipe3.rating).to eq '5'
    
  end

end