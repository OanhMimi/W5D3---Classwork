
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE  users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NO NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    users_id INTEGER NOT NULL,

    FOREIGN KEY (users_id) REFERENCES users(id)

);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    usersX_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,

    FOREIGN KEY (usersX_id) REFERENCES users(id),
    FOREIGN KEY (questions_id) REFERENCES questions(id)

);

CREATE TABLE replies (

    id INTEGER PRIMARY KEY,
    parent_reply_id INTEGER, 
    subject_questions_id INTEGER NOT NULL,
    subject_user_id INTEGER NOT NULL, 
    body TEXT NOT NULL,

    FOREIGN KEY(parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY(subject_questions_id) REFERENCES questions(id),
    FOREIGN KEY(subject_user_id) REFERENCES users(id)

);

CREATE TABLE question_likes (

    id INTEGER PRIMARY KEY,
    likes_user_id INTEGER NOT NULL, 
    likes_question_id INTEGER NOT NULL,

    FOREIGN KEY (likes_user_id) REFERENCES users(id),
    FOREIGN KEY (likes_question_id) REFERENCES questions(id)
);

INSERT INTO
    users(fname, lname)
VALUES
    ('Mimi', 'Ly'),
    ('Cameron', 'Sands'),
    ('Sunny', 'Day'),
    ('John', 'Snow');

INSERT INTO
    questions(title, body, users_id)
VALUES
    ('I Don''t Understand', 'What are you doing with your life', (SELECT id FROM users WHERE fname = 'Cameron')),
    ('I need help!', 'How to attract old men, I need a sugar daddy', (SELECT id FROM users WHERE fname = 'Mimi'));


INSERT INTO
    question_follows(usersX_id, questions_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Sunny'), (SELECT id FROM questions WHERE title = 'I Don''t Understand')), 
    ((SELECT id FROM users WHERE fname = 'John'), (SELECT id FROM questions WHERE title = 'I need help!'));

INSERT INTO
    replies(parent_reply_id, subject_questions_id, subject_user_id, body)
VALUES
    ((NULL), (SELECT id FROM questions WHERE title = 'I Don''t Understand'), (SELECT id FROM users WHERE fname = 'Sunny'), 'I am chillin, you?'),
    ((1), (SELECT id FROM questions WHERE title = 'I Don''t Understand'), (SELECT id FROM users WHERE fname = 'Cameron'), 'Fuck OFF!');

INSERT INTO
    question_likes(likes_user_id, likes_question_id)
VALUES  
    ((SELECT id FROM users WHERE fname = 'Mimi'), (SELECT id FROM questions WHERE title = 'I need help!')),
    ((SELECT id FROM users WHERE fname = 'John'), (SELECT id FROM questions WHERE title = 'I need help!'));