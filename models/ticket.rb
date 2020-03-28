require_relative('../db/sql_runner.rb')

class Ticket

  attr_accessor :customer_id, :screening_id
  attr_reader :id

  def initialize(options)
    @customer_id = options['customer_id']
    @screening_id = options['screening_id']
    @id = options['id'].to_i if options['id']
  end

  def save() #create
    sql = "
      INSERT INTO tickets
      (
        customer_id,
        screening_id
      )
      VALUES
      (
        $1,
        $2
      )
      RETURNING id
      "
      values = [@customer_id, @screening_id]
      @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def Ticket.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql, [])
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, screening_id)=($1,$2) WHERE id = $3"
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def Ticket.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql, [])
    return tickets.map {|tick| Ticket.new(tick)}
  end



end #class end
