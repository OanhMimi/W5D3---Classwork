
require_relative 'questionsdatabase.rb'
require_relative 'questions.rb'

class Replies

    attr_accessor :id, :parent_reply_id, :subject_questions_id, :subject_user_id, :body

    def self.all 
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Replies.new(datum) }
    end

    def initialize(options)
        @id = options["id"]
        @parent_reply_id = options["parent_reply_id"]
        @subject_questions_id = options["subject_questions_id"]
        @subject_user_id = options["subject_user_id"]
        @body = options["body"]
    end

    def self.find_by_user_id(subject_user_id)
        raise "#{self} does not exist" if subject_user_id.nil? || subject_user_id <= 0
        found_question = QuestionsDatabase.instance.execute(<<-SQL, subject_user_id:subject_user_id) 
            SELECT
            *
            FROM
            replies
            WHERE
            replies.subject_user_id = :subject_user_id 
        SQL

        Replies.new(found_question.first)

    end

    def self.find_by_question_id(subject_questions_id)
        raise "#{self} does not exist" if subject_questions_id <= 0
        found_question = QuestionsDatabase.instance.execute(<<-SQL, subject_questions_id:subject_questions_id) 
            SELECT
            *
            FROM
            replies
            WHERE
            replies.subject_questions_id = :subject_questions_id
        SQL

        Replies.new(found_question.first)
    end

    def question
        Questions.find_by_id(self.subject_questions_id)
    end

    def parent_reply
        parent_reply_id = self.parent_reply_id
        find_replies = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id:parent_reply_id) 
        SELECT
        *
        FROM
        replies
        WHERE
        replies.id = :parent_reply_id
        SQL

        Replies.new(find_replies.first)
    end

    def child_replies
        id = self.id
        replies_hash = QuestionsDatabase.instance.execute(<<-SQL, id:id) 
        SELECT
        *
        FROM
        replies
        WHERE
        replies.id >= :id
        SQL

        replies_hash.map do |hash|
            Replies.new(hash)
        end
    end
end