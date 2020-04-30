class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end
              # the SELECT acts similar to if statement
  def self.all #in SQL you SELECT * if you want the statement to return everything in the table that matches the condition
    sql = <<-SQL
    SELECT * 
    FROM students 
    SQL

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.all_students_in_grade_9 #in SQL you SELECT * if you want the statement to return everything in the table that matches the condition
   # insert a WHERE below (the condition it needs to meet) 
    sql = <<-SQL 
    SELECT *
    FROM students
    WHERE grade = 9 
    SQL

    # => [[001, "James", 9], [004, "Fred", 9], [008, "Mike", 9]] <== this is returned from DB:[:conn].execute(sql)
    # row_1 = [001, "James", 9]
    # a_new_student = student.new
    # a_new_student.id = row_1[0]
    # a_new_student.name = row_1[1]
    # a_new_student.grade = row_1[2]

#DB[:conn].execute(sql) will execute your sql statement and return the data
  #what do you want to do with the data you just got back from running the sql statement  
  # it's actually possible to not use ennumerable in the below b/c the 9thgrade method justs wants the array of students and nothing else
    # the line self.new_from_db(student) is giving us back the object. The array is being changed to an object 
  
    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end 

  def self.students_below_12th_grade
    sql = <<-SQL
     SELECT *
     FROM students 
     WHERE grade < 12
     SQL

      #whatever you have between || below is what the argument will be for the newfromdb method
     DB[:conn].execute(sql).map do |student|
        self.new_from_db(student)
     end
    
  end 

  # * selects all the attributes
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
      SQL

      DB[:conn].execute(sql, x).map do |student|
        self.new_from_db(student)
      end 
  end

  def self.first_student_in_grade_10
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE grade = 10
      LIMIT 1
      SQL

      DB[:conn].execute(sql).map do |student|
        self.new_from_db(student)
      end.first
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x).map do |student|
      self.new_from_db(student)
    end 
  end 

  def self.find_by_name(name)
    sql = <<-SQL
    Select * 
    from students
    Where name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |student|
      self.new_from_db(student)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
