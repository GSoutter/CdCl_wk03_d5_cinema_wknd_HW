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
    sql = "SELECT * FROM films ORDER BY price"
    films = SqlRunner.run(sql, [])
    return films.map {|film| Film.new(film)}
  end

  def customers
    screenings_array = screenings()
    customers_array = []

    for screening in screenings_array
      customers_array += screening.customers
    end

    return customers_array
  end

  def screenings()
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return screenings.map{|screen| Screening.new(screen)}
  end

  def tickets_num()
    screenings_array = screenings()

    return screenings_array.reduce(0){|sum, screen| sum + screen.tickets_num}
  end

  def most_popular()
    screenings_array = screenings()
    most_popular_times = []
    most_tickets = 0
    for screen in screenings_array
      if screen.tickets_num > most_tickets
        most_popular_times = []
        most_popular_times.push(screen.showtime)
        most_tickets = screen.tickets_num
      elsif screen.tickets_num = most_tickets
        most_popular_times.push(screen.showtime)
      else
        nil
      end
    end

    return most_popular_times
  end



end #class end
