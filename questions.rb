require_relative 'questionsdatabase.rb'
class Questions

    attr_accessor :id, :title, :body, :users_id

    def self.all 
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Questions.new(datum) }
    end

    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @users_id = options["users_id"]
    end

    def self.find_by_id(id)
        raise "#{self} does not exist" if id <= 0
        found_question = QuestionsDatabase.instance.execute(<<-SQL, id:id) 
            SELECT
            *
            FROM
            questions
            WHERE
            questions.id = :id 
        SQL

        Questions.new(found_question.first)

    end

    def self.find_by_author_id(author_id)
        raise "#{self} does not exist" if author_id <= 0
        found_question = QuestionsDatabase.instance.execute(<<-SQL, author_id:author_id) 
            SELECT
            *
            FROM
            questions
            WHERE
            questions.id = :author_id
        SQL

        Questions.new(found_question.first)
    end
    
    def author
        Users.find_by_id(self.users_id)
    end
end