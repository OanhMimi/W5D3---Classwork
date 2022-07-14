 
require_relative 'questionsdatabase.rb'
class Users

    attr_accessor :id, :fname, :lname

    def self.all 
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Users.new(datum) }
    end

    def initialize(options)
        @id = options["id"]
        @fname = options["fname"]
        @lname = options["lname"]

    end

    def self.find_by_id(id)
        
        found_user = QuestionsDatabase.instance.execute(<<-SQL, id:id)
        SELECT
        *
        FROM
        users
        WHERE
        users.id = :id  
        SQL

        Users.new(found_user.first)

    end

    def self.find_by_name(fname,lname)
        raise "#{self} does not exist" if fname.length <= 0 || lname.length <= 0
        found_user = QuestionsDatabase.instance.execute(<<-SQL, fname:fname, lname:lname) 
            SELECT
            *
            FROM
            users
            WHERE
            users.fname = :fname AND users.lname = :lname 
        SQL

        Users.new(found_user.first)

    end

    def authored_questions
        id = self.id
        question_hash = QuestionsDatabase.instance.execute(<<-SQL,  id:id) 
        SELECT
        *
        FROM
        questions
        WHERE
        questions.users_id = :id
        SQL

        question_hash.map do |hash|
            Questions.new(hash)
        end
        
    end

    def authored_replies
        id = self.id
        replies_hash = QuestionsDatabase.instance.execute(<<-SQL, id:id) 
        SELECT
        *
        FROM
        replies
        WHERE
        replies.subject_user_id = :id
        SQL

        replies_hash.map do |hash|
            Replies.new(hash)
        end
    end
    
end