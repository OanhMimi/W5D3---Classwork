
class Follows

    attr_accessor :id, :usersX_id, :questions_id

    def self.all 
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Follows.new(datum) }
    end

    def initialize(options)
        @id = options["id"]
        @usersX_id = options["usersX_id"]
        @questions_id = options["questions_id"]
    end

    def self.followers_for_question_id(question_id)

        followers_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id:question_id) 
        SELECT
        *
        FROM
        users
        JOIN question_follows
        ON users.id = question_follows.usersX_id
        -- JOIN questions
        -- ON questions.id = question_follows.questions_id
        WHERE
        questions_id = :question_id
        SQL

        followers_hash.map do |hash|
            Users.new(hash)
        end
    end

    def self.followed_questions_for_user_id(usersXR_id)
        questions_hash = QuestionsDatabase.instance.execute(<<-SQL, usersXR_id:usersXR_id) 
        SELECT
        *
        FROM
        questions
        -- JOIN question_follows
        -- ON questions.id = question_follows.usersX_id
        JOIN question_follows
        ON questions.id = question_follows.userX_id
        WHERE
        users_id = :usersXR_id
        SQL

        questions_hash.map do |hash|
            Questions.new(hash)
        end
    end

end