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

  def update()
    sql = "UPDATE films SET (title, price)=($1,$2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def Film.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql, [])
    return films.map {|film| Film.new(film)}
  end

  def customers
    sql = "
    SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE tickets.film_id = $1
    "
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map {|cust| Customer.new(cust)}
  end

  def tickets_num()
    sql = "SELECT * FROM tickets WHERE film_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    tickets_array = tickets.map{|tick| Ticket.new(tick)}
    return tickets_array.length

  end


end #class end
