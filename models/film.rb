require_relative('../db/sql_runner.rb')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i if options['id']
  end

  def save() #create
    sql = "
      INSERT INTO films
      (
        title,
        price
      )
      VALUES
      (
        $1,
        $2
      )
      RETURNING id
      "
      values = [@title, @price]
      @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def Film.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql, [])
  end

end #class end
